## JQ

### Sort array contents by object key

```vim
%! jq '.relationships.categories|=sort_by(.id)'
```

### Add `new_key` to all objects in `array`

```vim
%! jq '.array[] + {"new_key": 0}'
%! jq '.array[].subArray |= map (. + {new_key: 0})'


### Filter an array of objects

```bash
jq '[.items[] | select(.name == "Bob")] | length]'
```

## Links

- https://github.com/reegnz/dotfiles/blob/master/jq/README.md
- https://gist.github.com/reegnz/5bceb53427008a4ff9367eb8eae97b85
