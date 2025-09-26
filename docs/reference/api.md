# API reference

This page provides a reference to the Javascript API for `wecco`.

## Apps

`wecco` apps are a combination of view functions, data models and mutations on
those models in combination with a well-defined lifecycle that causes the
views to be invoked any time the data changes. Those apps follow the
_model-view-update_ architecture pattern which is often described as the
[elm architecture](https://guide.elm-lang.org/architecture/).

### Contexts

`wecco` apps use an idiom called _contexts_ which means, that all functions
that make up an app and which are called by the framework
receive a _context_ parameter which contains data and callbacks for each app
part. 

In `wecco`, by convention, a _context_ parameter is usually handled via object
deconstruction, cherry-picking only those properties needed.

The following sections describe the types of context and their usage.

### View

A view defines how the UI looks (i.e. which HTML elements to render) given some
_data_ (the model).

A view is just a function that conforms to the following type definition:

```typescript
type View<MODEL, MESSAGE> = (ctx: ViewContext<MODEL, MESSAGE>) => ElementUpdate

interface ViewContext<MODEL, MESSAGE> {
    emit: MessageEmitter<MESSAGE>
    get model(): MODEL
}
```

The view function produces an `ElementUpdate`, which is how `wecco` updates
element's content. This can either be a string, a value returned from the
`wecco.html` string tag, and `HTMLElement`, `null` or an array of those values.

The _context_ passed to the view contains the `model` to render as well as
a callback `emit` which is used to emit a message to be handled.

### Update

An update function mutates the data (the model) based on some input, which is
called a _message_. Think of a message as something like a _command pattern_
object which describes _what_ operation to perform and _which_ arguments to
use for this operation.

The result of such an update cycle is a (possibly new) version of the data to
render.

An update function must conform to the following type definition:

```typescript
type Updater<MODEL, MESSAGE> = (ctx: UpdaterContext<MODEL, MESSAGE>) => ModelResult<MODEL>

export interface UpdaterContext<MODEL, MESSAGE> extends ViewContext<MODEL, MESSAGE> {
    get message(): MESSAGE
}
```

Notice the return type `ModelResult<MODEL>`. This type union includes instances
of `MODEL`, `Promises` that resolve to a `MODEL` as well as the sentinel
`NoModelChange` value (which signals, that nothing needs to be updated).

### `wecco.createApp`

Creates a new app. The arguments define the app's model, view and update handler.

* `modelInitializer` - initializer to create the initial model - either synchronously or asynchronously
* `updater` - applies update messages to the model - either synchronously or asynchronously
* `view` - renders the model - always synchronously

The function returns an `App` (see below) that can be used to control
the app by emitting messages.

The following "sketch" shows the "wireframe" for each app:

```typescript
type Model = // ...

type Message = // ...

function update({model}: wecco.UpdaterContext<Model, Message>): Model {
    // ...
}

function view ({ emit, model }: wecco.ViewContext<Model, Message>): wecco.ElementUpdate {
    return wecco.html`
        ...
    `
}

document.addEventListener("DOMContentLoaded", () => {
    wecco.createApp(() => /* some model value */, update, view)
        .mount("#app")
})
```

### `wecco.App`

An `App` is returned from `wecco.createApp`. It provides two methods:

* `mount` - which "mounts" the app onto some HTML element
* `emit` - which can be used to send messages to the app used to control
    the app from the outside.

```typescript
interface App<M> {
    mount(mountPoint: ElementSelector): void
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

`define` is used to define a new web component which is also a custom web element.
The function accepts the following arguments:

* `name` - the name of the custom element. This name is used as the custom
    element's tag name, so it must follow the custom element specs (i.e. the
    name must contain a dash)
* `renderCallback` - the render callback will be called whenever the element`s
    content needs to be updated. The callback receives a `RenderContext` parameter
    (see below) which, by convention, is handled by object deconstruction.
* `options` - an optional options object. See below for additional information

The value returned from `define` is an instance of a `ComponentFactory` which
can produce instances of the defined component by passing in initial data.

```typescript
const CountClicks = wecco.define<number>("count-clicks", ...)

// ...

const countClicksElement = CountClicks(3)
someHTMLElement.appendChild(countClicksElement)
```

#### Render Callback

The context passed to each invocation of the render callback, follows the following
interface:

```typescript
interface RenderContext<T> {
    get data(): T

    requestUpdate: () => void

    emit: (event: string, payload?: any) => void

    addEventListener: (event: string, listener: (payload?: any) => void) => void

    once: (id: string, callback: OnceCallback) => void
}
```

* `data` - getter to get the data to be rendered. Almost all custom elements use this
* `requestUpdate` - a callback to be bound to some trigger from within the rendered HTML.
    Invoking this callback signals to the framework that `data` has been updated and
    rendering should be triggered again for the element's rendered content to reflect
    this change. As with `data`, almost all custom elements use this.
* `emit` - can be used to emit a `CustomEvent` from the element.
    Pass in the event's name and an (optional payload). This method is especially
    usefull when using custom events.
* `addEventListener` - used to subscribe for `CustomEvent`s.
* `once` - register some callback to be called _exactly once_ for each instance
    of the element. Use this to register a callback that, loads inital data (i.e.
    via `fetch`) or register timeouts, intervals, ...

### Options

You can pass an optional `options` parameter to `define` which supports a
two-way binding of `data` fields to either HTML element attributes or 
JavaScript properties of the element. The options type is defined as

```typescript
interface DefineOptions<T> {
    observedAttributes?: Array<keyof T>
    observedProperties?: Array<keyof T>
}
```

### Full Example

The following full example shows a simple click-counting button:

```typescript
import * as wecco from "@weccoframework/core"

interface CountClicks {
    count?: number
}

const CountClicks = wecco.define("count-clicks", ({ data, requestUpdate }: wecco.RenderContext<CountClicks>) => {
    data.count = data.count ?? 0

    return wecco.html`<p>
        <button 
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" 
            @click=${() => { data.count++; requestUpdate() }}>
            You clicked me ${data.count} times
        </button>
    </p>`
}, {
    observedAttributes: ["count"],
})
```

### `wecco.component`

Creates an instance of a `define`d element which will use the given `data` and
will be added to the given `host` element. This is an alternative approach to
using the `ComponentFactory` returned by `define` which does not require a
handle to the component factory but uses the browser's built-in registry for
custom web components.

The following two snippets as essentially the same:

```typescript
const SomeComponent = wecco.define("some-component" // ...

SomeComponent({}).mount("#body")
```

vs.

```typescript
wecco.define("some-component" // ...

const componentData = // ...

wecco.component("some-component", componentData).mount("#body")
```

The arguments passed to `component` are:

* `componentName` - the component's name
* `data` - the bound data
* `host` - the host to add the component to. This is optional; you can leave
    it out and add the element to the DOM by any other means.

## Rendering HTML

### `wecco.updateElement`

`updateElement` applies the given update request to the given target.

* `target` -  the target to update. This can be a DOM `Element` or a CSS selector string.
* `request` - the update "request". May be an update function or an `ElementUpdater`. The following things
    can be used: 
    * `null` to remove any content from the target
    * `string` which is used as inner text (note that this is _not_ `innerHTML`)
    * a DOM `Element` which gets appended as a child of target
    * a `wecco.ElementUpdateFunction` which is callback function that receives the target to update
    * a `wecco.ElementUpdater` an interface for types used internally by wecco (but may be used externally as well).
        See the documentation on `wecco.html` and `wecco.shadow` below for the most common uses of this type
    * an array of any of the above
* `notifyUpdated` whether to send an update event after the element update 

`updateElement` emits custom events to notify any subscribers that an update happens/happend. The following
events are emitted:

* `updatestart` - emitted for the `target` before update starts
* `updateend` - emitted for the `target` adter update ends
* `update` - emitted for _every_ child nested below `target` that was visited during the update

Subscribe to those event in case you need to handle custom processing such as managing animations.

### `wecco.html`

Used as a tag for a template string to create an `ElementUpdater` that updates
a DOM node. See [HTML tag template string reference](../html-template-tag/) for details.

### `wecco.shadow`

Used to create a HTML `ShadowDocument` to isolate an element from the surrounding
CSS and JavaScript.