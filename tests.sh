#!/usr/bin/env bash
# Run tests on the yaml-get.py script from the command line.


#----------------------------------------------------------------------------
# Set up vars.
ASSERT_LIB="tmp/assert.sh"
TARGET="./yaml-get.py"
YAML_FILE="test.yaml"


#----------------------------------------------------------------------------
# Grab a copy of assert.sh if not already present and make it executable.
# Import the assertion functions. Create a temp yaml file to operate on.
function setup {
  local DESTINATION="$(dirname "$ASSERT_LIB")"

  if [[ ! -d "$DESTINATION" ]]; then
    mkdir -p "$DESTINATION"
  fi

  if [[ ! -x "$ASSERT_LIB" ]]; then
    wget -qO "$ASSERT_LIB" https://raw.github.com/lehmannro/assert.sh/v1.1/assert.sh
    chmod a+x "$ASSERT_LIB"
  fi

  source "$ASSERT_LIB"
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

assert "$(execute name)" "Foo.app"
assert "$(execute directories.source)" "./src"
assert "$(execute debug.includes.0)" "./debug"
assert "$(execute debug.enabled)" "True"
assert "$(execute description)" "This is a great app. It can do many things. You should try it."

assert_raises "$(execute foo)" 0
assert_raises "$(execute )" 1
assert_raises "$(execute bad.path)" 2

assert_end "yaml-get.py"
