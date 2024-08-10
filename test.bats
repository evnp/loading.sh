#!/usr/bin/env bash

load './node_modules/bats-support/load'
load './node_modules/bats-assert/load'

function run_loading() {
	local cmd
	cmd="${BATS_TEST_DESCRIPTION}"
	cmd="${cmd/${BATS_TEST_NUMBER} /}"
	cmd="${cmd/README /}"
	cmd="${cmd/loading/${BATS_TEST_DIRNAME}/loading.sh}"
	if [[ "${cmd}" =~ ^([A-Z_]+=[^ ]*) ]]; then
		# handle env var declarations placed before test command
		export "${BASH_REMATCH[1]}"
		run ${cmd/${BASH_REMATCH[1]} /}
	else
		run ${cmd}
	fi
}

function run_loading_stop() {
	${BATS_TEST_DIRNAME}/loading.sh stop
}

@test "${BATS_TEST_NUMBER} loading 10" {
	run_loading &
	sleep 1
	run_loading_stop
	assert_success
}
