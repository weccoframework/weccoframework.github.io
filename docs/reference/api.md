# API reference

This page provides a reference to the Javascript API for `wecco`.

## Apps

### `wecco.app`

Creates a new app. The arguments define the app's model, view and update handler
as well as the "mount point" inside the DOM.

* `modelInitializer` - initializer to create the initial model - either synchronously or asynchronously
* `updater` - applies update messages to the model - either synchronously or asynchronously
* `view` - renders the model - always synchronously
* `mountPoint` - the mount point to control using this app

The function returns an `AppContext` (see below) that can be used to control
the app by emitting messages.

```typescript
class Model {
    // ...
}

type Message = // ...

function update(ctx: wecco.AppContext<Message>, model: Model, message: Message): Model {
    // ...
}

function view (ctx: wecco.AppContext<Message>, model: Model) {
    // ...
}

document.addEventListener("DOMContentLoaded", () => {
    wecco.app(() => new Model(), update, view, "#app")
})

```

### `wecco.AppContext`
An instance of an `AppContext` is provided to the `view` function of an app.
The context provides an `emit` method that can be used to signal a model
update by sending a message.

```typescript
interface AppContext<M> {
    emit(message: M): void
}
```

### `wecco.NoModelChange`
A sentinel value representing the updater's decision _not_ to update the model
and skip the re-rendering cycle. May be returned from an `update` function to
indicate that side effects happend (such as updating the storage) but no
re-rendering is needed.

## Custom Elements

### `wecco.define`

`define` is used to define a new wecco component which is also a custom element.
The render callback provided to `define` will be called whenever the element`s
content needs to be updated.

* `name` - the name of the custom element. Must follow the custom element specs (i.e. the name must contain a dash)
* `renderCallback` the render callback
* `observedAttributes` list of attribute names to observe for changes and bind to data
 
Returns an instance of a `ComponentFactory` which can produce instances of the
defined component.

```typescript
const CountClicks = wecco.define("count-clicks", (data: CountClicks, context) => {
    data.count = data.count ?: 0

    return wecco.html`<p>
        <button class="btn btn-primary" @click=${() => { data.count++; context.requestUpdate(); }}>
            You clicked me ${data.count} times
        </button>
    </p>`
}, "count")
```

### `wecco.component`

Creates an instance of a `define`d element which will use the given `data` and
will be added to the given `host` element. This is an alternative approach to
using the `ComponentFactory` returned by `define` which does not require a
handle to the component factory but uses the browser's built-in registry for
custom web components.

The following two snippets as essentially the same:

```typescript
const SomeComponent = define("some-component", (data: SomeComponentData, requestUpdate) => {
     // ..
})

SomeComponent({}).mount("#body")
```

vs.

```typescript
define("some-component", (data: SomeComponentData, requestUpdate) => {
     // ..
})

component("some-component", SomeComponent({}).mount("#body")
```

* `componentName` - the component name
* `data` - the bound data
* `host` - the host to add the component to

## Rendering HTML

### `wecco.updateElement`

`updateElement` applies the given update request to the given target.

* `target` -  the target to update. This can be a DOM `Element` or a CSS selector string.
* `request` - the update "request". May be an update function or an `ElementUpdater`. Usually you will use the return of an `wecco.html` template string.
* `notifyUpdated` whether to send an update event after the element update 

### `wecco.html`

Used as a tag for a template string to create an `ElementUpdater` that updates
a DOM node.

### `wecco.shadow`

Used to create a HTML `ShadowDocument` to isolate an element from the surrounding
CSS and JavaScript.