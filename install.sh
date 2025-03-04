#!/usr/bin/env bash

virtualenv -p python3 venv ;
source venv/bin/activate ;
pip install -r ./py/requirements.txt ;
pip install -e ./py ;

