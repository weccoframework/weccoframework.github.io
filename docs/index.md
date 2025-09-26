# Introduction

This site documents the use of `@weccoframework/core`

`weccoframework/core` - called `wecco` - is a web application framework based 
on web standards such as [Web Components](https://www.webcomponents.org/), 
[HTML Templates](https://developer.mozilla.org/de/docs/Web/HTML/Element/template) 
and plain JavaScript that features

* simplicity
* performance
* small footprint (under 60k uncompressed)

`wecco` features a _functional programming style_ as opposed to a class based 
approach using inheritence that other common web frameworks endorse. Using 
functions to express a dynamic web UI allows a developer to focus on a 
descriptive approach, where as classes tend to obfuscate the concepts behind a
dynamic UI.

`wecco` provides both a _view_ engine, that renders views based on models as
well as a full application framework that is based on the _Model, View, Update_
architecture pattern.

`wecco` is written using [TypeScript](https://www.typescriptlang.org/) and can
be used from TypeScript projects as well as plain JavaScript ones.

Besides a couple of development tools (such as TypeScript, mocha, ...) `wecco`
uses _no dependencies_ (all dependencies are declared as `devDependencies` in
the `package.json`). This means, that adding `wecco` to your project does not
bloat your `node_modules`.

> :material-alert: wecco is stil under heavy development and the API is not 
> considered stable until release 1.0.0.

# Author

wecco is written by Alexander Metzner <alexander.metzner@gmail.com>.

# License

Copyright (c) 2019 - 2025 The wecco authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

