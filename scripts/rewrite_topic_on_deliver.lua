
function string_starts_with(subject, start)
  return string.sub(subject, 1, string.len(start)) == start;
end

function remove_topic_level(topic, prefix)
  local next_slash_pos = string.find(topic, "/", string.len(prefix) + 1);
  return string.sub(topic, next_slash_pos + 1, -1);
end

-- Rewrite topic from internal to external on deliver
-- patterns to handle:
-- realm/xxx/some-topic -> some-topic
-- $RMQ/realm/xxx/sync/user/yyy/topic -> $RMQ/sync/my/topic
function rewrite_topic_on_deliver(params)
  local topic = params.topic;
  log.debug("rewrite_topic_on_deliver: input: " .. topic);

  local is_sys_topic = false;
  if string_starts_with(topic, "$RMQ/") then
    is_sys_topic = true;
    topic = string.sub(topic, 6, -1);
  end
  if string_starts_with(topic, "realm/") then
    topic = remove_topic_level(topic, "realm/");
  end
  if is_sys_topic and string_starts_with(topic, "sync/user/") then
    topic = "sync/my/" .. remove_topic_level(topic, "sync/user/");
  end
  if is_sys_topic then
    topic = "$RMQ/" .. topic;
  end

  log.debug("rewrite_topic_on_deliver: output: " .. topic);
  return {topic = topic};
end

hooks = {
  on_deliver = rewrite_topic_on_deliver,
};
