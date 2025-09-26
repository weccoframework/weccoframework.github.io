# Installation

`wecco` is currently not available from a CDN, so you are required to bundle
it with your web application. If you are using `npm` (or any of the compatible
tools, such as `pnpm` or `yarn`) you can add `wecco` as a dependency. This is
the recommended way.

If you do not use `npm` you can manually add `wecco` as a `<script>` tag to
your HTML.

## NPM

`wecco` is available via npm as `@weccoframework/core`. Simply add it to the
`dependencies` section of your `package.json`.

## Directly embedding in a HTML page

You can include the a bundled version of `wecco` into your web application.
Simply go to the [releases](https://github.com/weccoframework/core/releases)
and download the latest version of either the `es6` or `es5` bundle. To test a
version, you can directly load the bundle from the github downloads, i.e.

```html
<script src="https://github.com/weccoframework/core/releases/download/v0.25.0/weccoframework-core.min.js"></script>
```

Please note, that this is _not_ recommended for any kind of production systems
and should only be used during development.
