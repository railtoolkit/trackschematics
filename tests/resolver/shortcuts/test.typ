#import "/src/lib.typ" as railtoolkit-trackschematics
#import "/tests/util.typ": cetz

#set page(width: auto, height: auto)

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  track((), (ne: 1), (e: 2), (se: 1), (s: 1), (sw: 1), (w: 1), (nw: 1), (n: 1))
})

#pagebreak()

// Different directions of untersection
#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  track((), (e: 1), (ne: 1), (e: 3), name: "tr1")

  track((1, 1), (e: "tr1"), stroke: orange)
  track((2, 0), (ne: "tr1"), stroke: red)
  track((4, 0), (n: "tr1"), stroke: purple)
})

#pagebreak()

// Choose nearest intersection
#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  track((), (e: 1), (ne: 2), (e: 1), (se: 2), (e: 1), name: "tr1")
  track((7, 1), (w: "tr1"), stroke: red)
  track((0, 1), (e: "tr1"), stroke: purple)
})

