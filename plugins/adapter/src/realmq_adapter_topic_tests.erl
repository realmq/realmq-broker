-module(realmq_adapter_topic_tests).

-include_lib("eunit/include/eunit.hrl").

to_external_plain_with_realm_test() ->
  ?assertEqual(
    [<<"topic">>],
    realmq_adapter_topic:to_external([<<"realm">>,<<"123">>,<<"topic">>])
  ).

to_external_plain_without_realm_test() ->
  ?assertEqual(
    [<<"some">>,<<"other">>,<<"topic">>],
    realmq_adapter_topic:to_external([<<"some">>,<<"other">>,<<"topic">>])
  ).

to_external_sys_sync_subscriptions_test() ->
  ?assertEqual(
    [<<"$RMQ">>,<<"sync">>,<<"my">>,<<"subscriptions">>],
    realmq_adapter_topic:to_external(
      [<<"$RMQ">>,<<"realm">>,<<"123">>,<<"sync">>,<<"user">>,<<"name">>,<<"subscriptions">>]
    )
  ).
