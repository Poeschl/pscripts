#!/usr/bin/env bash

saveProgress() {
  sed -i "/^${FUNCNAME[ 1 ]}$/s/^#*/#/" "$(basename "$0")"
}

foo() {
	echo "foo"
	saveProgress
}

bar() {
	echo "bar"
	saveProgress
}

#foo
#bar
