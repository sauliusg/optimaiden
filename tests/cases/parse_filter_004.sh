#!/bin/sh

./bin/parse_filter '(a = b AND c != d OR str != "foo bar") OR (a != b OR (c != 12 AND string < "bar baz" AND q <= 1))'
