# SQL

## Commands

Get select results in a CSV format (postgresql)

```sql
COPY (select * from users) To stdout with CSV;
```
