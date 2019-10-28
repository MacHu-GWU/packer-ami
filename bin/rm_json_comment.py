#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
remove comment

valid comments are

usage:

.. code-block:: bash

    ./bin/rm_json_comment.py ./tests_bin/rm_json_comment/input.json ./tests_bin/rm_json_comment/output.json
"""

import os
import re
import json


class Style(object):
    RESET = "\033[0m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    CYAN = "\033[36m"


def raise_error():
    print(Style.RESET)
    exit(1)


def strip_comment_line_with_symbol(line, start):
    """
    Strip comments from line string.
    """
    parts = line.split(start)
    counts = [len(re.findall(r'(?:^|[^"\\]|(?:\\\\|\\")+)(")', part))
              for part in parts]
    total = 0
    for nr, count in enumerate(counts):
        total += count
        if total % 2 == 0:
            return start.join(parts[:nr + 1]).rstrip()
    else:  # pragma: no cover
        return line.rstrip()


def strip_comments(string, comment_symbols=frozenset(('#', '//'))):
    """
    Strip comments from json string.
    :param string: A string containing json with comments started by comment_symbols.
    :param comment_symbols: Iterable of symbols that start a line comment (default # or //).
    :return: The string with the comments removed.
    """
    lines = string.splitlines()
    new_lines = list()
    for line in lines:
        for symbol in comment_symbols:
            line = strip_comment_line_with_symbol(line, start=symbol)
        if line.strip():
            new_lines.append(line)
    return "\n".join(new_lines).strip()


def read_text(abspath, encoding="utf-8"):
    """
    :type abspath: str
    :type encoding: str
    :rtype: str
    """
    with open(abspath, "rb") as f:
        return f.read().decode(encoding)


def write_text(text, abspath, encoding="utf-8"):
    """
    :type text: str
    :type abspath: str
    :type encoding: str
    :rtype: None
    """
    with open(abspath, "wb") as f:
        return f.write(text.encode(encoding))


if __name__ == "__main__":
    import sys

    src, dst = sys.argv[1], sys.argv[2]
    src = os.path.abspath(src)
    dst = os.path.abspath(dst)

    content = read_text(src)
    new_content = strip_comments(content)
    try:
        json.loads(new_content)
    except:
        print(Style.RED + "{} is not a valid json file".format(src))
        raise_error()

    allow_overwrite = False
    try:
        if sys.argv[3] == "-o":
            allow_overwrite = True
    except:
        pass

    if os.path.exists(dst):
        if allow_overwrite is False:
            print(Style.RED + "output file {} already exists".format(dst))
            raise_error()

    write_text(new_content, dst)
