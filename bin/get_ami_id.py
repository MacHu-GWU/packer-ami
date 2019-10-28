#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Echo the last build ami image from manifest.json generated from the latest
packer build.

Usage:

.. code-block:: python

    ./bin/get_ami_id.py ./tests_bin/get_ami_id/manifest.json
"""

import json


class Style(object):
    RESET = "\033[0m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    CYAN = "\033[36m"


def raise_error():
    print(Style.RESET)
    exit(1)


class AmiIdNotFoundError(Exception): pass


def main(manifest_file):
    with open(manifest_file, "rb") as f:
        data = json.loads(f.read().decode("utf-8"))

    last_built_ami_id = None

    last_run_uuid = data["last_run_uuid"]
    for dct in data["builds"]:
        if dct["packer_run_uuid"] == last_run_uuid:
            last_built_ami_id = dct["artifact_id"].split(":")[1]

    if last_built_ami_id is None:
        raise AmiIdNotFoundError

    return last_built_ami_id


if __name__ == "__main__":
    import sys

    manifest_file = sys.argv[1]

    try:
        last_built_ami_id = main(manifest_file)
        print(last_built_ami_id)
    except AmiIdNotFoundError as e:
        print(Style.RED + "can't locate last built ami id from {}!".format(manifest_file))
        raise_error()
    except Exception as e:
        print(Style.RED + "{} is not a valid manifest file!".format(manifest_file))
