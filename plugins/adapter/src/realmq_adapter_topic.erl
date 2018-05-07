-module(realmq_adapter_topic).

-export([
  to_external/1
]).

to_external([<<"$RMQ">> | Rest]) ->
  WithoutRealm = strip_realm(Rest),
  WithAdjustedSync = adjust_sync_to_external(WithoutRealm),
  [<<"$RMQ">> | WithAdjustedSync];
to_external(Topic) -> strip_realm(Topic).

strip_realm([<<"realm">>, _RealmId | Rest]) -> Rest;
strip_realm(Topic) -> Topic.

adjust_sync_to_external([<<"sync">>, <<"user">>, _UserId | Rest]) -> [<<"sync">>, <<"my">> | Rest];
adjust_sync_to_external(Topic) -> Topic.
