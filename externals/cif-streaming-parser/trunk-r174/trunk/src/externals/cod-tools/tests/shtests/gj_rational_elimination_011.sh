#!/bin/sh

#BEGIN DEPEND------------------------------------------------------------------
INPUT_TEST_SCRIPT=tests/scripts/gj_rational_elimination
INPUT_MATRIX=tests/inputs/matrices/wikipedia2.mat
#END DEPEND--------------------------------------------------------------------

"${INPUT_TEST_SCRIPT}" "${INPUT_MATRIX}"
