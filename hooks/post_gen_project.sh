#!/usr/bin/env bash

echo -e '\e[1mYour cookie is cut successfully, running post-cut operations now.\e[0m'

{% if cookiecutter.package_type == 'Library' %}
echo -e '\e[1mCleaning non-library files...\e[0m'
rm -rf ./deployment ./openapi ./Dockerfile ./dockerrun.bash ./build_openapi.py ./run.py
rm -rf ./{{ cookiecutter.package_name }}/{admin_endpoints,auth,some_endpoints,api.py}
rm ./tests/system_test.py
{% endif %}

echo -e '\e[1mCreating git repository...\e[0m'
git init
git add -A .
git commit -m 'Cut from gh:occ/template-repo'
git tag 0.1.0
git remote add origin git@github.com:uc-cdis/{{ cookiecutter.package_name }}.git

echo -e '\e[1mLocking dependencies...\e[0m'
pipenv lock --pre
pipenv --rm
git add Pipfile.lock
git commit --quiet --amend -m 'Cut from gh:uc-cdis/template-repo'
git tag -f 0.1.0

echo -e '\e[1mYour new {{ cookiecutter.package_type.lower() }} is ready under: \e[31m{{ cookiecutter.package_name }}\e[0m'

{% if cookiecutter.package_type == 'Library' %}
echo -e '\e[1m\e[31mPlease ask the team to add encrypted PyPI credentials for automatic releases!\e[0m'
{% endif %}
