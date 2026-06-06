# moka

## Example

```rust
pub struct CacheConfig {
    max_cache_size: u64,
    time_to_live: Duration,
}

impl Default for CacheConfig {
    fn default() -> Self {
        Self {
            // 10MiB
            max_cache_size: 10 * 1024 * 1024,
            time_to_live: Duration::from_secs(60 * 60),
        }
    }
}

impl CacheConfig {
    pub fn with_max_cache_size(self, max_cache_size: u64) -> Self {
        Self {
            max_cache_size,
            ..self
        }
    }

    pub fn with_time_to_live(self, time_to_live: Duration) -> Self {
        Self {
            time_to_live,
            ..self
        }
    }
}

#[derive(Clone)]
pub struct CacheLayer<S> {
    service: S,
    // Use Arc to avoid expensive clone
    // https://github.com/moka-rs/moka?tab=readme-ov-file#avoiding-to-clone-the-value-at-get
    cache: Cache<String, Arc<types::Feed>>,
}
impl<S> CacheLayer<S> {
    /// Construct CacheLayer with default config
    pub fn new(service: S) -> Self {
        Self::with(service, CacheConfig::default())
    }

    /// Construct CacheLayer with given config
    pub fn with(service: S, config: CacheConfig) -> Self {
        let CacheConfig {
            max_cache_size,
            time_to_live,
        } = config;

        let cache = Cache::builder()
            .weigher(|_key, value: &Arc<types::Feed>| -> u32 {
                value.approximate_size().try_into().unwrap_or(u32::MAX)
            })
            .max_capacity(max_cache_size)
            .time_to_live(time_to_live)
            .build();

        Self { service, cache }
    }
}

impl<S> FetchCachedFeed for CacheLayer<S>
where
    S: FetchFeed + Clone + 'static,
{
    async fn fetch_feed(&self, url: String) -> ParseResult<Arc<types::Feed>> {
        // lookup cache
        if let Some(feed) = self.cache.get(&url).await {
            tracing::debug!(url, "Feed cache hit");
            return Ok(feed);
        }

        let feed = self.service.fetch_feed(url.clone()).await?;
        let feed = Arc::new(feed);

        self.cache.insert(url, Arc::clone(&feed)).await;

        Ok(feed)
    }
}
```

* `Cache::builder()`
  * `weigher()`でcache entryごとのsizeを返せる
    * entryごとにsizeが違う際に使える
  * `max_capacity()` cacheの最大bytes
  * `time_to_live()` insertしてからcacheに滞在する時間
  * `time_to_idle()` 最後にgetされてからのcacheの滞在時間も指定できる

* `Cache::get()`
  * `&V`ではなく`V`をclone()して返す。
  * 重たいstructは`Arc`でwrapするとよいとREADMEにあった
