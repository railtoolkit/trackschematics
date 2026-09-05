#import "@preview/tidy:0.4.3"
#import "@preview/cetz:0.5.2"

#import "/src/lib.typ" as railtoolkit-trackschematic

#let docs = tidy.parse-module(
  read("/src/draw.typ"),
  name: "Elements",
  require-all-parameters: true,
  scope: (
    cetz: cetz,
    rts: railtoolkit-trackschematic,
  ),
)

#let wrap-code(code) = {
  let c = (">>> cetz.canvas({ import rts.draw: *; import cetz.draw: *\n", code, "\n>>> })")
  c.fold(raw(""), (acc, code) => if type(code) == str { raw(acc.text + code) } else { raw(acc.text + code.text) })
}

#let example(code) = tidy.show-example.show-example(
  wrap-code(code),
  scope: (
    cetz: cetz,
    rts: railtoolkit-trackschematic,
  ),
  mode: "code",
  code-block: block.with(radius: 3pt, stroke: .5pt + luma(200)),
  preview-block: block.with(radius: 3pt, fill: rgb("#e4e5ea")),
)

#let t(type) = {
  tidy.styles.default.show-type(type, style-args: (colors: tidy.styles.default.colors))
}

#let t-raw(content) = text(font: "DejaVu Sans Mono", size: 0.8em, content)

== Coordinates

This package adopts the CeTZ coordinate system. All of CeTZ's coordinate definitions also work within this package.
For further reading consult the #link("https://cetz-package.github.io/docs/basics/coordinate-systems/")[CeTZ documentation].

To simplify the process of drawing track infrastructure, several options for defining coordinates have been added.

=== Relative position in cardinal direction

#grid(
  columns: (1fr, 1fr),
  align: (left, center),
  [
    Support for drawing tracks in all eight directions. \
    For example #t-raw[(e: 2)] describes to go two units east and is internally translated to: #t-raw[(rel: (2, 0))]
  ],
  [
    #cetz.canvas({
      import cetz.draw: *
      import railtoolkit-trackschematic.draw: *

      hide(track((0, 0), (1, 0)))

      for dir in ("north", "north-east", "east", "south-east", "south", "south-west", "west", "north-west") {
        line((0, 0), ((dir): 1), mark: (end: ">", fill: black), name: dir)
        content((rel: ((dir): -.15)), [#dir], padding: 0em)
      }
    })
  ],
)

#t-raw[(#t("key"): #t("number"))]

#t("key"): one of the cardinal directions: #t-raw[north, north-east, east, south-east, south, south-west, west, north-west]. \

#example(```typc

track(
  (),
  (east: 7),
  (north-east: 1),
  (north: 1),
  (north-west: 1),
  (west: 1),
  (south-west: 3)
)
>>>
>>>set-style(mark: (end: ">"), fill: purple, stroke: (dash: "dashed", paint: purple), content: (padding: .25))
>>>
>>>line((0,-.25), (east: 7), name: "e")
>>>line((rel: (.25, .1)), (north-east: 1), name: "ne")
>>>line((rel: (0, .25)), (north: 1), name: "n")
>>>line((rel: (-.1, .1)), (north-west: 1), name: "nw")
>>>line((rel: (-.25, 0)), (west: 1), name: "w")
>>>line((rel: (-.25, -.1)), (south-west: 3), name: "sw")
>>>
>>>content("e", [(east: 7)], anchor: "north")
>>>content("ne", [(north-east: 1)], anchor: "north-west")
>>>content("n", [(north: 1)], anchor: "west")
>>>content("nw", [(north-west: 1)], anchor: "south-west")
>>>content("w", [(west: 1)], anchor: "south")
>>>content("sw", [(south-west: 1)], anchor: "south-east")
```)

=== Position on track

To position elements on a referenced track.

#t-raw[#t("str").#t("number")] or #t-raw[(name: #t("str"), anchor: #t("number"))]

The syntax is identical to the anchor syntax of CeTZ.
For tracks the default functionality of CeTZ is overwritten to match with the length calculations of track schematics.

The default anchors #t-raw[start] and #t-raw[end] are also supported.


#example(```typc
>>> set-style(circle: (radius: .15, stroke: none))
track(
  (), (east: 3), (north-east:2), (east:3),
  name: "tr-1"
)
circle("tr-1.start", fill: red)
circle("tr-1.1", fill: purple)
// long syntax:
circle(
  (name: "tr-1", anchor: 4),
  fill: orange
)
circle("tr-1.end", fill: green)
>>>
>>>set-style(mark: (start: "o", end: ">"), stroke: (dash: "dashed"), content: (padding: .5em))
>>>line((rel: (0,0) , to: "tr-1.start"), (rel: (0,0) , to: "tr-1.1"), mark: (fill: purple), stroke: purple, name: "purple")
>>>line((rel: (0,-.2) , to: "tr-1.start"), (east:3), (rel: (.2,-.1) , to: "tr-1.4"), mark: (fill: orange), stroke: orange, name: "orange")
>>>line((rel: (0,.2) , to: "tr-1.start"), (east:3), (north-east: 2), (rel: (0,.2) , to: "tr-1.end"), mark: (fill: green), stroke: green, name: "green")
>>>
>>>content("tr-1.start", [start], anchor: "south")
>>>content("purple.end", [1], anchor: "north")
>>>content("orange.end", [4], anchor: "north")
>>>content("green.end", [end], anchor: "south")
```)

=== Track intersection in cardinal direction

Draw the track until it intersects with the specified track.

#t-raw[(#t("key"): #t("str"))]

#t("key"): one of the cardinal directions: #t-raw[north, north-east, east, south-east, south, south-west, west, north-west]. \
#t("str"): track name.

#example(```typc
track((), (east: 7), name:  "tr-1")
track((0, 1), (east: 1), (south-east: "tr-1"))
>>>
>>>set-style(mark: (end: ("|", ">"), start: "|"), fill: purple, stroke: (dash: "dashed", paint: purple), content: (padding: .25))
>>>
>>>line((rel: (.1, .1), to: (1,1)), (south-east: 1))
>>>line((), (south-east: 1), stroke: gray, mark: none)
```)

#tidy.show-module(docs, style: tidy.styles.default)
