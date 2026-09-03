#set page(width: auto, height: auto, margin: 1em)

#import "/src/lib.typ" as railtoolkit-trackschematics
#import "/tests/util.typ": cetz

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  for dir in ("n", "ne", "e", "se", "s", "sw", "w", "nw") {
    track((0, 0), ((dir): 1), name: "tr-" + dir)
  }

  for dir in ("n", "ne", "e", "se", "s", "sw", "w", "nw") {
    buffer-stop("tr-" + dir + ".end")
  }
})

#pagebreak()

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  for dir in ("n", "ne", "e", "se", "s", "sw", "w", "nw") {
    track((rel: ((dir): 1), to: (0, 0)), (0, 0), name: "tr-" + dir)
  }

  for dir in ("n", "ne", "e", "se", "s", "sw", "w", "nw") {
    buffer-stop("tr-" + dir + ".start")
  }
})

#pagebreak()

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  for dir in ("n", "ne", "e", "se", "s", "sw", "w", "nw") {
    track((0, 0), ((dir): 1), end: buffer-stop)
  }
})


#pagebreak()

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  for dir in ("n", "ne", "e", "se", "s", "sw", "w", "nw") {
    track((rel: ((dir): 1), to: (0, 0)), (0, 0), start: buffer-stop)
  }
})

#pagebreak()

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  for dir in ("n", "ne", "e", "se", "s", "sw", "w", "nw") {
    track((0, 0), ((dir): 1), end: "]")
  }
})


#pagebreak()

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  for dir in ("n", "ne", "e", "se", "s", "sw", "w", "nw") {
    track((rel: ((dir): 1), to: (0, 0)), (0, 0), start: "]")
  }
})
