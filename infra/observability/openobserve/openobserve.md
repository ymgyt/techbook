# Openobserve

## Memo

* OpenObserve does not rely on indexing of the data. It stores un-indexed data in compressed format in local disk or object store in parquet columnar format.

* In contrast to Elasticsearch, which is a general-purpose search engine that doubles as an observability tool, OpenObserve was built from the ground up as an observability tool, with high focus on delivering exceptional observability.

* OpenObserve _bulk API endpoint is elasticsearch compatible and can be used by log forwarders like fluentbit, fluentd and vector. Filebeat is supported through zPlane.


## Deploy

### HA

https://openobserve.ai/docs/ha_deployment/

## Data storage

> Support of S3, MinIO, GCS, Azure blob for data storage
