## Docker

### Remove all dangling images

```bash
docker rmi $(docker images -f "dangling=true" -q)
```
