#!/bin/sh
set -x
set -e

# The binaries for packages installed with `pip install --user` are not available on PATH
# by default, so we fix up PATH to suppress warnings by pip. This also needs to be done by
# any script that needs to access poetry/pipenv.
#
# Using `::add-path::` from the actions toolkit is not enough, since that only affects
# subsequent actions in the current job, and not the current action.
export PATH="$HOME/.local/bin:$PATH"

python2 -m pip install --user --upgrade pip setuptools wheel
python3 -m pip install --user --upgrade pip setuptools wheel

# virtualenv is a bit nicer for setting up virtual environment, since it will provide up-to-date versions of
# pip/setuptools/wheel which basic `python3 -m venv venv` won't
python2 -m pip install --user virtualenv
python3 -m pip install --user virtualenv

# venv is required for installation of poetry or pipenv (I forgot which)
sudo apt-get install -y python3-venv

# We install poetry with pip instead of the recommended way, since the recommended way
# caused some problem since `poetry run` gives output like:
#
#     /root/.poetry/lib/poetry/_vendor/py2.7/subprocess32.py:149: RuntimeWarning: The _posixsubprocess module is not being used. Child process reliability may suffer if your program uses threads.
#       "program uses threads.", RuntimeWarning)
#     LGTM_PYTHON_SETUP_VERSION=The currently activated Python version 2.7.18 is not supported by the project (^3.5). Trying to find and use a compatible version. Using python3 (3.8.2) 3

# poetry 1.0.10 has error (https://github.com/python-poetry/poetry/issues/2711)
python3 -m pip install --user poetry!=1.0.10
python3 -m pip install --user pipenv
