-- hooks:
--   session:
--   - auth_on_register - register client
--     - validate auth token
--   - on_register - client registered, init session
--   - on_client_wakeup - session initialized
--     - mark user online
--   - ...
--   - on_client_offline (clean_session=false)
--     - mark user offline
--   - on_client_gont (clean_session=true)
--     - mark user offline
--
--  subscription:
--  - auth_on_subscribe - auth subscription
--    - validate subscribe
--  - on_subscribe - client subscribed
--  - on_unsubscribe - client unsubscribed
--
--  publish:
--  - auth_on_publish - auth publish
--    - validate publish
--  - on_publish - client published
--  - on_offline_message - client got offline message
--  - on_deliver - message gets send out to client

clients = {}
-- adapter_host = os.getenv("GFCC_ADAPTER_HOST") or "adapter"
-- adapter_port = os.getenv("GFCC_ADAPTER_PORT") or "80"

function auth_on_register(reg)
  -- call adapter with client_id, username and password
  local adapter_host = os.getenv("GFCC_ADAPTER_HOST") or "adapter"
  local adapter_port = os.getenv("GFCC_ADAPTER_PORT") or "8080"
  local response = http.get(
    "gfcc",
    string.format(
      "http://%s:%s/auth?c=%s&u=%s&p=%s",
      adapter_host,
      adapter_port,
      url_encode(reg.client_id),
      url_encode(reg.username),
      url_encode(reg.password)
    )
  )

  -- check response
  if response == false or response.status ~= 200 then
    log.error("auth request failed")
    return false
  end

  -- check response data
  local data = json.decode(http.body(response.ref));
  if data == false then
    log.error("invalid auth response")
    return false
  end

  -- check adapter return val
  if data.auth ~= true then
    return false
  end

  -- store client data in global table
  clients[reg.client_id] = {
    uid = data.uid
  }
  return true
end

function on_client_offline(params)
  -- remove client from global table
  clients[params.client_id] = nil
end

function on_client_gone(params)
  -- remove client from global table
  clients[params.client_id] = nil
end

function url_encode(str)
  str = string.gsub (
    str,
    "([^%w %-%_%.%~])",
    function (c) return string.format ("%%%02X", string.byte(c)) end
  )
  return str
end

http.ensure_pool({pool_id = "gfcc"})
hooks = {
  auth_on_register = auth_on_register
}
