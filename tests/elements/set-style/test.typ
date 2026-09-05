#set page(width: auto, height: auto, margin: 1em)

#import "/src/lib.typ" as railtoolkit-trackschematics
#import "/tests/util.typ": cetz

#cetz.canvas({
  import cetz.draw: *
  import railtoolkit-trackschematics.draw: *

  set-style(stroke: purple)

  track((0, 0), (east: 4), name: "Tr1", kind: "secondary")
  turnout("Tr1.2", name: "T1")
  track("T1", (north-east: 2))
})

#pagebreak()

#cetz.canvas({
  import cetz.draw: *
  import railtoolkit-trackschematics.draw: *

  set-style(stroke: blue, fill: navy, turnout: (stroke: 1pt), track: (stroke: eastern, main: (stroke: purple + 4pt)))

  track((0, 0), (east: 4), name: "Tr1", kind: "secondary")
  turnout("Tr1.2", name: "T1")
  track("T1", (north-east: 2), type: "secondary", stroke: purple)
})
