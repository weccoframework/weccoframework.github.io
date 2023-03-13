serve:
    mkdocs serve

build:
    mkdocs build

publish: build
    mkdir -p /tmp/publish-weccoframework.github.io
    git clone $(git remote get-url origin) /tmp/publish-weccoframework.github.io
    rm -rf /tmp/publish-weccoframework.github.io/*
    cp -r site/* /tmp/publish-weccoframework.github.io
    cd /tmp/publish-weccoframework.github.io && git commit -a
    cd /tmp/publish-weccoframework.github.io && git push
    rm -rf /tmp/publish-weccoframework.github.io
