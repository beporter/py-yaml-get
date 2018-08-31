#!/usr/bin/env bash
# Run tests on the yaml-get.py script from the command line.


#----------------------------------------------------------------------------
# Set up vars.
YAML=$(cat <<'EOYAML'
---
foo: bar
fizz: "buzz"
life: 42
nested:
  first: 1
  second: 2
  3:
    - bleet
    - wargle
    - garg
  fourth:
    truthy: true
    falsey: false
lines: |
  458 Walkman Dr.
  Suite #292
comments: >
  Late afternoon is best.
  Backup contact is Nancy
  Billsmer @ 338-4338.

EOYAML
)

YAML_FILE="tmp/sample.yaml"
ASSERT="tmp/assert.sh"
TARGET="./yaml-get.py"


#----------------------------------------------------------------------------
# Grab a copy of assert.sh if not already present and make it executable.
# Import the assertion functions. Create a temp yaml file to operate on.
function setup {
  local DESTINATION="$(dirname "$ASSERT")"

  if [[ ! -d "$DESTINATION" ]]; then
    mkdir -p "$DESTINATION"
  fi

  echo "$YAML" > "$YAML_FILE"

  if [[ ! -x "$ASSERT" ]]; then
    wget -qO "$ASSERT" https://raw.github.com/lehmannro/assert.sh/v1.1/assert.sh
    chmod a+x "$ASSERT"
  fi

  . "$ASSERT"
}


#----------------------------------------------------------------------------
# Wrapper to execute the target script uniformly in all tests. Always provides
# the same sample YAML document to the script.
# Usage: `execute dotted.path`
function execute {
  echo "cat '$YAML_FILE' | '$TARGET' $1"
}


#----------------------------------------------------------------------------
# main()

setup

assert "$(execute foo)" "bar"
assert "$(execute nested.first)" "1"
assert "$(execute nested.3.0)" "bleet"
assert "$(execute nested.fourth.truthy)" "True"
assert "$(execute nested.fourth.falsey)" "False"

assert_raises "$(execute foo)" "bar" 0
assert_raises "$(execute )" 1
assert_raises "$(execute bad.path)" 2

assert_end "yaml-get.py"
