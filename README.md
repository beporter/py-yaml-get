# yaml-get.py

A small single-file, no-dependencies python command line script that consumes a YAML file and displays a single nested value named by a `dotted.path` argument.

Initially built to supplment automated command line usage of an [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html).

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

Given the following sample `config.yaml` file:

```yaml
---
debug: true
version: 42
name: Foo.app
directories:
    source: ./src
    temp: /tmp
    destination: /Applications
dependencies:
    - stdlib
    - bar
    - fizz
description: |
    This is a great app.
    It can do many things.
    You should try it.
```

```shell
$ cat config.yaml | ./yaml-get.py debug
True

$ cat config.yaml | ./yaml-get.py version
42

$ cat config.yaml | ./yaml-get.py directories.source
./src

$ cat config.yaml | ./yaml-get.py dependencies.0
stdlib

$ cat config.yaml | ./yaml-get.py description
This is a great app.
It can do many things.
You should try it.
```

### Error Handling

In the event that the provided YAML document can not be parsed, or the provided dotted.path can not be located in the file, the script will print an error message to STDERR and exit with a non-zero code. There will be no STDOUT output.

For automated workflows, you may wish to suppress the STDERR output:

```shell
$ cat config.yml | ./yaml-get.py bad.path.here
Error: 'str' object has no attribute 'get'

$ echo $?
2  # Also produces a non-zero exit code.

$ cat config.yml | ./yaml-get.py bad.path.here 2>/dev/null  # Error output suppressed.

$ echo $?
2  # Still produces a non-zero exit code.
```


## Contributing

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms. [Translations are available](https://www.contributor-covenant.org/translations).


### Reporting Issues

Please use [GitHub Isuses](https://github.com/beporter/py-yaml-get/issues) for listing any known defects or issues.


### Development

Please fork this repository, create a new topic branch, and submit a [pull request](https://github.com/beporter/py-yaml-get/issues) for your work.



## License

[MIT](LICENSE.md)


## Copyright

Copyright &copy; 2018 Brian Porter
