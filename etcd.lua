local cjson = require('cjson')
local http = require('socket.http')
local ltn12 = require('ltn12')

local M = {}
local Etcd = {}

local function to_query(data)
  local entries = {}
  for k, v in pairs(data) do
    if v ~= nil then
      table.insert(entries, k .. '=' .. tostring(v))
    end
  end
  return table.concat(entries, '&')
end

function Etcd:request(opts)
  local http_opts = {
    url=self.addr .. opts.path,
    headers={}
  }

  if opts.method ~= nil then http_opts.method = opts.method end

  if opts.params ~= nil then
    if http_opts.method == 'GET' or http_opts.method == 'DELETE' then
      http_opts.url = http_opts.url .. '?' .. to_query(opts.params)
    else
      local data = to_query(opts.params)
      http_opts.source = ltn12.source.string(data)
      http_opts.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      http_opts.headers['Content-Length'] = #data
    end
  end

  local buffer = {}
  http_opts.sink = ltn12.sink.table(buffer)

  local res, status = http.request(http_opts)
  local response_text = table.concat(buffer)

  if res == nil then
    return nil, status
  elseif status ~= 200 then
    return cjson.decode(response_text), status
  else
    return cjson.decode(response_text), nil
  end
end

function Etcd:keys_get(key, params)
  return self:request{
    path    = '/v2/keys/' .. key,
    method  = 'GET',
    params  = params
  }
end

function Etcd:keys_put(key, params)
  return self:request{
    path    = '/v2/keys/' .. key,
    method  = 'PUT',
    params  = params
  }
end

function Etcd:keys_delete(key, params)
  return self:request{
    path    = '/v2/keys/' .. key,
    method  = 'DELETE',
    params  = params
  }
end

function Etcd:keys_post(key, params)
  return self:request{
    path    = '/v2/keys/' .. key,
    method  = 'POST',
    params  = params
  }
end

function Etcd:stats_leader()
  return self:request{
    path    = '/v2/stats/leader',
    method  = 'GET'
  }
end

function Etcd:stats_self()
  return self:request{
    path    = '/v2/stats/self',
    method  = 'GET'
  }
end

function M.new(addr)
  local self = {}
  self.addr = addr or 'http://127.0.0.1:2379'

  setmetatable(self, {__index = Etcd})
  return self
end

return M
