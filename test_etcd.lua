local etcd = require('etcd').new(os.getenv('ETCD_ADDR'))

assert(etcd:keys_put('message', {value='Hello world'}) ~= nil)
assert(etcd:keys_get('message') ~= nil)
assert(etcd:keys_put('message', {value='Hello etcd'}) ~= nil)
assert(etcd:keys_delete('message') ~= nil)
assert(etcd:keys_put('foo', {value='bar', ttl=5}) ~= nil)
assert(etcd:keys_post('queue', {value='Job1'}) ~= nil)
assert(etcd:stats_self() ~= nil)
