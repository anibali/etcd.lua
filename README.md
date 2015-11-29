# etcd.lua

## Usage

Create a new etcd client like so:

```lua
local etcd = require('etcd').new('http://127.0.0.1:2379')
```

Now take a look at some equivalent examples to those found in the
[official etcd API documentation](https://coreos.com/etcd/docs/latest/api.html).

### Setting the value of a key

```lua
etcd:keys_put('message', {value='Hello world'})
```

Response:

```lua
{
  action = "set",
  node = {
    createdIndex = 4,
    key = "/message",
    modifiedIndex = 4,
    value = "Hello world"
  }
}
```

### Get the value of a key

```lua
etcd:keys_get('message')
```

Response:

```lua
{
  action = "get",
  node = {
    createdIndex = 4,
    key = "/message",
    modifiedIndex = 4,
    value = "Hello world"
  }
}
```

### Changing the value of a key

```lua
etcd:keys_put('message', {value='Hello etcd'})
```

Response:

```lua
{
  action = "set",
  node = {
    createdIndex = 5,
    key = "/message",
    modifiedIndex = 5,
    value = "Hello etcd"
  },
  prevNode = {
    createdIndex = 4,
    key = "/message",
    modifiedIndex = 4,
    value = "Hello world"
  }
}
```

### Deleting a key

```lua
etcd:keys_delete('message')
```

Response:

```lua
{
  action = "delete",
  node = {
    createdIndex = 5,
    key = "/message",
    modifiedIndex = 6
  },
  prevNode = {
    createdIndex = 5,
    key = "/message",
    modifiedIndex = 5,
    value = "Hello etcd"
  }
}
```

### Using key TTL

```lua
etcd:keys_put('foo', {value='bar', ttl=5})
```

Response:

```lua
{
  action = "set",
  node = {
    createdIndex = 7,
    expiration = "2015-11-29T09:28:06.425855523Z",
    key = "/foo",
    modifiedIndex = 7,
    ttl = 5,
    value = "bar"
  }
}
```

### Atomically Creating In-Order Keys

```lua
tcd:keys_post('queue', {value='Job1'})
```

Response:

```lua
{
  action = "create",
  node = {
    createdIndex = 8,
    key = "/queue/00000000000000000008",
    modifiedIndex = 8,
    value = "Job1"
  }
}
```

### Self statistics

```lua
etcd:stats_self()
```

Response:

```lua
{
  id = "ce2a822cea30bfca",
  leaderInfo = {
    leader = "ce2a822cea30bfca",
    startTime = "2015-11-29T09:32:31.347062716Z",
    uptime = "827.979895ms"
  },
  name = "default",
  recvAppendRequestCnt = 0,
  sendAppendRequestCnt = 0,
  startTime = "2015-11-29T09:32:30.946282648Z",
  state = "StateLeader"
}
```
