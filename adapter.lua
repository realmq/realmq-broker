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
--   - on_client_gone (clean_session=true)
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

environment = os.getenv("envrionment") or "develop"
vmq_version = os.getenv("VMQ_VERSION") or "0.0.0"
adapter_host = os.getenv("GFCC_ADAPTER_HOST") or "adapter"
adapter_port = os.getenv("GFCC_ADAPTER_PORT") or "80"

function auth_on_register(reg)
  log_debug('auth_on_register');
  -- call adapter with client_id, username and password
  local response = http.get(
    "gfcc",
    string.format(
      "http://%s:%s/auth?c=%s&u=%s&p=%s&v=vmq-%s",
      adapter_host,
      adapter_port,
      url_encode(reg.client_id),
      url_encode(reg.username),
      url_encode(reg.password),
      url_encode(vmq_version)
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

  set_client_meta(reg.client_id, {uid = data.uid})
  log.info(string.format(
    "identified client \"%s\" as user \"%s\"",
    reg.client_id,
    data.uid
  ))
  return true
end

function on_client_wakeup(params)
  log_debug('on_client_wakeup')
  local meta = get_client_meta(params.client_id)
  if meta ~= nil then
    update_client_status(params.client_id, meta.uid, "online")
  end
end

function on_client_offline(params)
  log_debug('on_client_offline')
  local meta = get_client_meta(params.client_id)
  if meta ~= nil then
    update_client_status(params.client_id, meta.uid, "offline")
    unset_client_meta(params.client_id)
  end
end

function on_client_gone(params)
  log_debug('on_client_gone');
  local meta = get_client_meta(params.client_id)
  if meta ~= nil then
    update_client_status(params.client_id, meta.uid, "offline")
    unset_client_meta(params.client_id)
  end
end

function auth_on_subscribe(sub)
  log_debug('auth_on_subscribe')

  local meta = get_client_meta(sub.client_id)
  if meta == nil then
    -- unknown user, next plugin should decide
    return
  end

  local subscriptions = {}
  for idx, topic in pairs(sub.topics) do
    subscriptions[topic[1]] = topic[2]
  end

  local response = http.post(
    "gfcc",
    string.format(
      "http://%s:%s/sub?c=%s&u=%s",
      adapter_host,
      adapter_port,
      url_encode(sub.client_id),
      url_encode(meta.uid)
    ),
    json.encode({subscriptions = subscriptions}),
    {["Content-type"] = "application/json"}
  )

  -- check response
  if response == false or response.status ~= 200 then
    log.error("sub auth request failed")
    return false
  end

  -- check response data
  local data = json.decode(http.body(response.ref));
  if data == false then
    log.error("invalid sub auth response")
    return false
  end

  -- check adapter return val
  if data.auth ~= true then
    return false
  end
  if type(data.subscriptions) ~= "table" then
    return false
  end

  -- map return val
  local subscriptions = {}
  for pattern, qos in pairs(data.subscriptions) do
    if qos == 0 or qos == 1 or qos == 2 then
      table.insert(subscriptions, {pattern, qos})
    else
      table.insert(subscriptions, {pattern, 0x80})
    end
  end
  return subscriptions
end

function auth_on_publish(params)
  log_debug('auth_on_publish');

  local meta = get_client_meta(params.client_id)
  if meta == nil then
    -- unknown user, next plugin should decide
    return
  end

  local response = http.get(
    "gfcc",
    string.format(
      "http://%s:%s/pub?c=%s&u=%s&t=%s",
      adapter_host,
      adapter_port,
      url_encode(params.client_id),
      url_encode(meta.uid),
      url_encode(params.topic)
    )
  )

  -- check response
  if response == false or response.status ~= 200 then
    log.error("pub auth request failed")
    return false
  end

  -- check response data
  local data = json.decode(http.body(response.ref));
  if data == false then
    log.error("invalid pub auth response")
    return false
  end

  -- check adapter return val
  if data.auth ~= true then
    return false
  end

  return true
end

function set_client_meta(client_id, meta)
  kv.insert("gfcc_meta", {[client_id] = meta})
end

function get_client_meta(client_id)
  return kv.lookup("gfcc_meta", client_id)[1]
end

function unset_client_meta(client_id)
  kv.delete("gfcc_meta", client_id)
end

function update_client_status(client_id, user_id, status)
  local response = http.post(
    "gfcc",
    string.format(
      "http://%s:%s/status?c=%s&u=%s",
      adapter_host,
      adapter_port,
      url_encode(client_id),
      url_encode(user_id)
    ),
    string.format('{"status":"%s"}', status),
    {["Content-type"] = "application/json"}
  )

  -- check response
  if response == false or (response.status ~= 200 and response.status ~= 204) then
    log.error(string.format(
      "status update request failed (%s)",
      response.status
    ))
    return false
  end

  return true
end

function url_encode(str)
  str = string.gsub(
    str,
    "([^%w %-%_%.%~])",
    function (c) return string.format ("%%%02X", string.byte(c)) end
  )
  return str
end

function log_debug(str)
  if (environment == "develop") then
    log.debug(str)
  end
end

http.ensure_pool({pool_id = "gfcc"})
kv.ensure_table({name = "gfcc_meta"})
hooks = {
  auth_on_register  = auth_on_register,
  auth_on_publish   = auth_on_publish,
  auth_on_subscribe = auth_on_subscribe,
  on_client_wakeup  = on_client_wakeup,
  on_client_offline = on_client_offline,
  on_client_gone    = on_client_gone,
}
