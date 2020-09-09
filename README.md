# Service Template

This is template repository to create services.


## Quick Start

1. Install [Cookiecutter](https://github.com/audreyr/cookiecutter) and
   [Pipenv](https://github.com/pypa/pipenv):

    ```bash
    pip install cookiecutter pipenv
    ```

2. Use Cookiecutter to create your new generic repo or Python repo:

    ```bash
    cookiecutter gh:occ-data/template-repo --checkout generic-template
    ```
    
    ```bash
    cookiecutter gh:occ-data/template-repo --checkout python-template
    ```

3. Follow the interactive guide and you'll get your new service.


## About Cookiecutter, Pipenv

Though these two utilities are written in Python, they are recommended to be installed
as global software on a development computer. Therefore, system packages are preferred
over `pip install`, e.g. [Homebrew](https://brew.sh/) on macOS:

```bash
brew install cookiecutter pipenv
```

If `pip install` is your only option, you may choose to install in user base:

```bash
pip install --user cookiecutter pipenv
```

You may need to add the bin directory under "user base" to your PATH, for example:

```bash
echo "export PATH=\"`python -m site --user-base`/bin:\$PATH\"" >> ~/.bash_profile
```

(Or alternatively, you may use sudo pip install without `--user` and `PATH` trouble)


## About pyenv

It is convenient to manage multiple Python versions and multiple virtualenvs with
[pyenv](https://github.com/pyenv/pyenv). It is usually available as a system package.
For example on macOS:

```bash
brew install pyenv pyenv-virtualenv
pyenv init 2>> ~/.bash_profile
pyenv virtualenv-init 2>> ~/.bash_profile
```

Pipenv would make the most of pyenv if they are both installed.
