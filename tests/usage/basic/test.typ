// Used in README
/// [ppi: 100]

#set page(width: auto, height: auto, margin: 1em)

#import "/src/lib.typ" as railtoolkit-trackschematics
#import "/tests/util.typ": cetz

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  track((), (e: 6), name: "tr-1")

  turnout((track: "tr-1", x: 1))
  track((), (ne: 1), (e: 2), (se: 1), name: "tr-2")
  turnout(())

  track((track: "tr-2", x: 4), (e: 1), end: "]")
})
