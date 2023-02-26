# HTML tag template string reference

`wecco` provides the `wecco.html` template tag that features easy to use
mechanics to render HTML from template strings. The HTML is rendered by the
browser using HTML `<template>` elements that are cached and reused for minimal
updates.

## Element text

You can use literal text as well as placeholders to generate literal element
text.

```javascript
wecco.html`<p>hello, world!</p>`

wecco.html`<p>${"hello, world!"}</p>`

wecco.html`<p>hello, ${"world"}!</p>`

const gretee = "world";   
wecco.html`<p>Hello</p>${gretee}`

wecco.html`<p>${"hello"}</p>${"world"}`

const message = "Hello,";
const gretee = "world";  
wecco.html`<p>${message} ${gretee}!</p>`
```

## Attributes

You can use placeholders to set the attributes of HTML elements. You can use
a single placeholder as the whole attribute's value as well as combine one or
more placeholders with literal text.

```javascript
const classes = "small hero"
wecco.html`<p class=${classes}>hello, world!</p>`

wecco.html`<p class="${classes} hero">hello, world!</p>`

wecco.html`<p class="${classes} hero ${"col"}">hello, world!</p>`
```

### Remove empty attributes
If you want to remove an attribute if the placeholder used for the value
resolves to `null`, add a `+omitempty` suffix to the attribute's name:

```javascript
wecco.html`<p id+omitempty="foo ${undefined}"></p>`
```

### Boolean Attributes
Boolean attributes are attributes with a value that doesn't matter. What matters
is whether the attribute is present or not. `wecco` uses a `?` prefix for the
attribute name. The value must be a single placeholder that will be used in a
boolean context.

```javascript
wecco.html`<a ?disabled=${false}>hello, world!</a>`
```

### Properties

`wecco.html` can also set Javascript properties of an `HTMLElement` created from
a template string. A good example for this is setting the `value` of an input
element or the `checked` attribute of a checkbox.

```javascript
wecco.html`<input type="text" .value=${"hello, world"}>`

wecco.html`<input type="checkbox" .checked=${true} ?disabled=${true}><input type="checkbox" .checked=${true}>
```

### Add Event Listeners

`wecco` allows you to add event listeners to `HTMLElements` created from a
template by using the event's name prefixed with `@` as an attribute. The
value must be single placeholder that resolves to a valid JavaScript event
handler (usually a function).

```javascript
const callback = () => { clicked = true }
    
wecco.html`<a @click=${callback}>Hello, world</a>`
```

The event attribute name can be suffixed with any of the following suffixes
which customize the event listener registration:

Suffix | Description
-- | --
`+capture` | Sets the `capture` property of the Options object passed to `addEventListener` to `true`
`+passive` | Sets the `passive` property of the Options object passed to `addEventListener` to `true`
`+once` | Sets the `once` property of the Options object passed to `addEventListener` to `true`
`+stoppropagation` | Creates a wrapper for the listener that calls `event.StopPropagation()`
`+stopimmediatepropagation` | Creates a wrapper for the listener that calls `event.StopImmediatePropagation()`
`+preventdefault` | Creates a wrapper for the listener that calls `event.PreventDefault()`

```javascript
wecco.html`<div @click=${callback.bind(null, "div")}><a @click+stopPropagation=${callback.bind(null, "a")}>Hello, world</a></div>`
```

### The `@update` listener

`wecco` adds a special `update` event that is invoked everytime this element or
parts of it are updated. You can subscribe for this event to apply custom logic
when the element updates.

```typescript
const callback = (e: CustomEvent) => { element = e.target as Element} 
wecco.html`<a @update=${callback}>Hello, world</a>`
```