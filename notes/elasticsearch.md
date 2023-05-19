## Elasticsearch

### Links

- https://www.elastic.co/blog/found-crash-elasticsearch#mapping-explosion (How to avoid a mapping explosion)

### Queries

Get recent documents (where `field` matches `value`)

```
GET documents/_search?sort=created_at:desc&q=field:value
```

Get specific document (only fetch `some_field` for document)

```
GET documents/_doc/some_doc?_source=some_field
```
