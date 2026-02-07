#!/bin/sh

./bin/parse_filter 'property HAS = 5'

./bin/parse_filter 'property HAS != 5'

./bin/parse_filter 'property HAS > 5'

./bin/parse_filter 'property HAS < 5'

./bin/parse_filter 'property HAS >= 5'

./bin/parse_filter 'property HAS <= 5'
