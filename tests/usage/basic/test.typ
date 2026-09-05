// Used in README
/// [ppi: 100]

#set page(width: auto, height: auto, margin: 1em)

#import "/src/lib.typ" as railtoolkit-trackschematics
#import "/tests/util.typ": cetz

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  track((), (east: 6), name: "tr-1")

  turnout("tr-1.1")
  track((), (north-east: 1), (east: 2), (south-east: 1), name: "tr-2")
  turnout(())

  track("tr-2.3", (east: 1), end: "]")
})

