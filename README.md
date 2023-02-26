# weccoframework.github.io

This branch contains the author's sources for build the website running on
[weccoframework.github.io](https://weccoframework.github.io).

The documentation site is built using `mkdocs` and the `mkdocs-material` theme.

# How to build locally

You should run these commands inside a python venv.

```shell
pip install -r requirements.txt
mkdocs serve
# Make changes and view them in the browser
mkdocs build
# Find the generated output in ./site
```