# yaml-get.py

A small single-file, no-dependencies python command line script that consumes a YAML file and displays a single nested value named by a `dotted.path` argument.

Initially built to supplement automated command line usage of an [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html).


## Requirements

* Python v2.7 or v3.0+


## Installation

* Download [`yaml-get.py`](yaml-get.py) to somewhere in your path.
    * `$ wget https://raw.github.com/beporter/py-yaml-get/master/yaml-get.py`
* Make it executable.
    * `$ chmod a+x yaml-get.py`


## Usage

* The script expects the YAML document to be provided on STDIN.
* The script accepts a single command line argument representing the "dotted path" to the nested value you wish to extract.


### Examples

Given the sample [`test.yaml` file](test.yaml) (included in this repo):


```shell
$ cat test.yaml | ./yaml-get.py debug.enabled
True

$ cat test.yaml | ./yaml-get.py version
42

$ cat test.yaml | ./yaml-get.py directories.source
./src

$ cat test.yaml | ./yaml-get.py dependencies.0
stdlib

$ cat test.yaml | ./yaml-get.py description
This is a great app. It can do many things. You should try it.
```


### Error Handling

In the event that the provided YAML document can not be parsed, or the provided dotted.path can not be located in the file, the script will print an error message to STDERR and exit with a non-zero code. There will be no STDOUT output.

For automated workflows, you may wish to suppress the STDERR output:

```shell
$ cat test.yaml | ./yaml-get.py bad.path.here
Error: 'str' object has no attribute 'get'

$ echo $?
2  # Also produces a non-zero exit code.

$ cat test.yaml | ./yaml-get.py bad.path.here 2>/dev/null  # Error output suppressed.

$ echo $?
2  # Still produces a non-zero exit code.
```


### Known Issues (aka "Please fix me")

Error handling is currently quite crude in the script, and there are many edge cases not specifically addressed.

For example, asking for a non-leaf node currently returns a json-ish string when it should probably error instead:

```shell
$ cat test.yaml | ./yaml-get.py debug
{'symbols': False, 'enabled': True, 'includes': ['./debug', './local-only']}
```


## Contributing

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms. [Translations are available](https://www.contributor-covenant.org/translations).


### Reporting Issues

Please use [GitHub Issues](https://github.com/beporter/py-yaml-get/issues) for listing any known defects or issues.


### Development

Please fork this repository, create a new topic branch, and submit a [pull request](https://github.com/beporter/py-yaml-get/compare) for your work.


### Testing

Tests for the script are maintained in `tests.sh` and make use of the [`assert.sh`](https://github.com/lehmannro/assert.sh) package from [@lehmannro](https://github.com/lehmannro), which itself includes a sample inline YAML document.

Tests take the form of:

```bash
assert "command to run" "expected output"
# or
assert_raises "command to run" N  # Where `N` is the integer exit code expected.
```


## License

[MIT](LICENSE.md)


## Copyright

Copyright &copy; 2020 Brian Porter
