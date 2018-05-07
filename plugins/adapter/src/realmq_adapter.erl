-module(realmq_adapter).

-behaviour(on_deliver_hook).

-export([on_deliver/4]).

on_deliver(_UserName, _SubscriberId, Topic, _Payload) ->
  error_logger:info_msg("on_deliver: Internal topic: ~p", [Topic]),
  ExternalTopic = realmq_adapter_topic:to_external(Topic),
  error_logger:info_msg("on_deliver: External topic: ~p", [ExternalTopic]),
  {ok, [{topic, ExternalTopic}]}.
