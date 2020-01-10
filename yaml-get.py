#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
usage:
$ ansible-vault view vault.yml | ./yaml-get.py var.name
Value printed here.
'''

import sys
import yaml


def get_by_path(root, path):
    """Access a nested object in root by path sequence."""

    for k in path if isinstance(path, list) else path.split("."):
        root = root[int(k)] if k.isdigit() else root.get(k, "")

    return root


def main():
    if len(sys.argv) < 2:
        sys.stderr.write('Provide a dotted.var.path as the first arg.')
        sys.exit(1)

    try:
        doc = yaml.safe_load(sys.stdin)
        print(get_by_path(doc, sys.argv[1]))
    except:
        sys.stderr.write("Error: {0}".format(sys.exc_info()[1]))
        sys.exit(2)


if __name__ == '__main__':
    main()
