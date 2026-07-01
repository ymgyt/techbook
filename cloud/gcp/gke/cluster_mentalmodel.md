# Clsuter Mental Mode

```rust
struct GkeCluster {
  mode: ClusterMode,
  release_channel: ReleaseChannel,
}

enum ClusterMode {
  Autopilot,
  Standard,
}

enum ReleaseChanel {
  Rapid,
  Regular,
  Stable,
  Extended,
}

```
