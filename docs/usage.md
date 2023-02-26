# Usage

This page gives you an overview of how `wecco` can be used. This is your page
to go especially of you are new to `wecco`. If you have specific questions
concerning the API the [JavaScript API](../reference/api/) has an in-depth reference.
For questions on how to write template strings see the 
[HTML template reference](../reference/html-template-tag/).

## A `wecco` application

The following code contains a full "app" for a button that counts the number of
times a user clicked it.

```typescript
import * as wecco from "@weccoframework/core"

class Model {
    constructor(public readonly count: number) {}

    inc() {
        return new Model(this.count + 1)
    }
}

type Message = "inc"

function update(model: Model, message: Message): Model {
    return model.inc()
}

function view (model: Model, context: wecco.AppContext<Message>) {
    return wecco.html`<p>
        <button class="btn btn-primary" @click=${() => context.emit("inc")}>
            You clicked me ${model.count} times
        </button>
    </p>`
}

document.addEventListener("DOMContentLoaded", () => {
    wecco.app(() => new Model(0), update, view, "#count-clicks-app")
})
```

`wecco` apps use the _Model-View-Update_ architecture pattern. This pattern
separates the logic into a _model_ that gets rendered via _view_ functions.
Updates to the model happen via a central _update_ function.

In the example above the `Model` class represents the model: a simple counter.
Note that `inc` method the provides the "business capabilities" of the model.

An instance of the model will be rendered by the `view` function. This 
function is called by `wecco` with the current model instance and a `context`
which can be used to emit update messages. The view function uses a tagged
template string to create the HTML. The template tag `wecco.html` is very
powerful. It compiles the template string into a hidden HTML `<template>`
element and reuses that everytime the view function is executed. While this
allows the developer to simple return a template string, under the hood a
lot of caching and reusing is happening to only update what is changed.

The `update` function is responsible for executing updates on the model. This
function is called by `wecco` everytime an update `Message` is emitted. The
function receives the current model instance and the message and provides a
new (or updated) model reference which will then get rendered again.

The call to `wecco.app` brings these functions together and starts the app.
The rendered content will go to the element identified by the CSS expression
`#count-clicks-app`. The first parameter is the "model initializer". This
function is called once at the very start of the app to produce the initial
model. Use this function to implement URL routing or restore a previous model
from the local or session storage.

## A custom element

`wecco` also provides a simple API for defining custom elements. These can be
used standalone or as part of an app.

Here is the same count clicks example with a custom element:

```typescript
import * as wecco from "@weccoframework/core"

interface CountClicks {
    count?: number
}

const CountClicks = wecco.define("count-clicks", (data: CountClicks, context) => {
    data.count = data.count ?: 0

    return wecco.html`<p>
        <button class="btn btn-primary" @click=${() => { data.count++; context.requestUpdate(); }}>
            You clicked me ${data.count} times
        </button>
    </p>`
}, "count")
```

`wecco.define` is used to define a custom element. It returns a factory
function that can be used to create instances of the web component. In addition
it registers the custom element's name so that HTML references to the element
will be resolved.

The first parameter to `wecco.define` defines the name of the component and
must follow the custom webcomponent's conventions (i.e. it must contain a dash).

The second parameter is the render callback. The render callback is called
everytime the component should update.

The first parameter passed to this callback is the component's data. Using
Typescript this parameter's type is defined using a generic type parameter.
You commonly use an interface to describe the type. 

The second parameter is the notify update callback. It can be used to notify
the component that something has changed and the component should update its
content. We use this callback to notify when the user has clicked the button
and we updated the `data`-attribute `count`.

The last line creates an instance of the component passing in an object that
implements `CountClicks` - the data interface - which initializes the 
component's data state. The result is an instance of `HTMLElement` which can be
added to the DOM using plain DOM manipulation functions. The object also
provides a convenience method `mount` which can be used to add the element to
dom: Simply pass in a `HTMLElement` or a string which is passed to
`document.querySelector` in order to obtain the element to add the new element
as a child.

Check out the [examples](https://github.com/weccoframework/core/tree/master/examples)
to see these two in action as well as the classical todo app.