#import "/src/lib.typ" as railtoolkit-trackschematics
#import "/tests/util.typ": cetz

#set page(width: auto, height: auto)

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  track(
    (),
    (north-east: 1),
    (east: 2),
    (south-east: 1),
    (south: 1),
    (south-west: 1),
    (west: 1),
    (north-west: 1),
    (north: 1),
  )
})

#pagebreak()

// Different directions of untersection
#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  track((), (east: 1), (north-east: 1), (east: 3), name: "tr1")

  track((1, 1), (east: "tr1"), stroke: orange)
  track((2, 0), (north-east: "tr1"), stroke: red)
  track((4, 0), (north: "tr1"), stroke: purple)
})

#pagebreak()

// Choose nearest intersection
#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  track((), (east: 1), (north-east: 2), (east: 1), (south-east: 2), (east: 1), name: "tr1")
  track((7, 1), (west: "tr1"), stroke: red)
  track((0, 1), (east: "tr1"), stroke: purple)
})

