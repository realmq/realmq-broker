-module(realmq_adapter).

-behaviour(on_deliver_hook).

-export([on_deliver/6]).

%% System users (username "adapter") will see internal topic structure instead of external.
%% That's important for retrieving the realm context.
on_deliver(<<"adapter">>, _SubscriberId, _QoS, _Topic, _Payload, _IsRetain) -> {ok};
on_deliver(_UserName, _SubscriberId, _QoS, Topic, _Payload, _IsRetain) ->
  error_logger:info_msg("realmq: on_deliver: Internal topic: ~p", [Topic]),
  ExternalTopic = realmq_adapter_topic:to_external(Topic),
  error_logger:info_msg("realmq: on_deliver: External topic: ~p", [ExternalTopic]),
  {ok, [{topic, ExternalTopic}]}.
