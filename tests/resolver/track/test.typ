#import "/src/lib.typ" as railtoolkit-trackschematics
#import "/tests/util.typ": cetz

#set page(width: auto, height: auto)

#cetz.canvas({
  import cetz.draw: *
  import railtoolkit-trackschematics.draw: *

  track((0, 0), (3, 0), name: "Tr1")

  for-each-anchor("Tr1", name => {
    content((), box(inset: 1pt, fill: white, text(8pt, [#name])), angle: -30deg)
  })

  circle("Tr1.2", radius: 0.1, fill: red, stroke: 0pt)
})

#pagebreak()

#cetz.canvas({
  import cetz.draw: *
  import railtoolkit-trackschematics.draw: *

  track((0, 0), (0, 3), name: "Tr1")

  for-each-anchor("Tr1", name => {
    content((), box(inset: 1pt, fill: white, text(8pt, [#name])), angle: -30deg)
  })

  circle("Tr1.1", radius: 0.1, fill: red, stroke: 0pt)
})

#pagebreak()

#cetz.canvas({
  import cetz.draw: *
  import railtoolkit-trackschematics.draw: *

  track((0, 0), (3, 3), name: "Tr1")

  for-each-anchor("Tr1", name => {
    content((), box(inset: 1pt, fill: white, text(8pt, [#name])), angle: -30deg)
  })

  circle("Tr1.1", radius: 0.1, fill: red, stroke: 0pt)
  circle("Tr1.2", radius: 0.1, fill: purple, stroke: 0pt)
})

#pagebreak()

#cetz.canvas({
  import cetz.draw: *
  import railtoolkit-trackschematics.draw: *

  track((0, 0), (1, 0), (2, 1), (3, 1), name: "Tr1")

  circle("Tr1.1", radius: 0.1, fill: red, stroke: 0pt)
  circle("Tr1.2", radius: 0.1, fill: purple, stroke: 0pt)
})



#pagebreak()

#cetz.canvas({
  import cetz.draw: *
  import railtoolkit-trackschematics.draw: *

  track((0, 0), (1, 0), (2, 1), (2, 2), name: "Tr1")

  circle((name: "Tr1", anchor: 1), radius: 0.1, fill: red, stroke: 0pt)
  circle((name: "Tr1", anchor: 3), radius: 0.1, fill: purple, stroke: 0pt)
})

