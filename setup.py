# -*- coding: utf-8 -*-
import re
from os import environ
from os.path import dirname, join, realpath
from setuptools import setup, find_packages

PWD = realpath(dirname(__file__))

package_name = 'resticmgr'
package_root = join(PWD, 'resticmgr')

def read(path):
    with open(join(dirname(__file__), path)) as f:
        return f.read()

def get_build_number():
    try:
        return environ['BLD_NUMBER']
    except KeyError:
        return "0"

def get_version():
    version_line = read("{0}/__init__.py".format(package_name))
    match = re.search(r"^__version__ = ['\"]([^'\"]*)['\"]$", version_line, re.M)
    version = "{}.{}".format(match.group(1), get_build_number())
    print(version)
    return version

def get_requirements():
    requirements = read('requirements.txt').strip().split('\n')
    return requirements

setup(
    name=package_name,
    packages=find_packages(exclude=['venv']),
    version=get_version(),
    description='A simple backup scheduler using restic.',
    author='Mark Callan',
    author_email='mark.l.callan@gmail.com',
    long_description='Enumerates backup jobs and schedules async restic backups.',
    install_requires=get_requirements(),
    zip_safe=False,
    entry_points={
        'console_scripts': [
            'resticmgr = resticmgr.main:main',
        ]
    },
    package_data={package_name: ['data/*']},
    classifiers=[
        'Development Status :: 3 - Alpha',
        'License :: Other/Proprietary :: All Rights Reserved',
        'Programming Language :: Python',
    ])
