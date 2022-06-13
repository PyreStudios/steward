# Tests

Several of the router and app tests actually start up a server and send local requests to that server. We may break these tests out in the future. For now, its strongly recommended to run tests via `dart test --concurrency=1` to help prevent issues where a port is being bound to one already in use. If tests fail without the flag, please try it again with the flag.