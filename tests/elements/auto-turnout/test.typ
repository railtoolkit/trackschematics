#import "/src/lib.typ" as railtoolkit-trackschematics
#import "/tests/util.typ": cetz

#set page(width: auto, height: auto)
#set grid(align: center + horizon)

#let possible_points = ((1, 0), (-1, 0), (1, 1), (-1, -1), (-1, 1), (1, -1), (0, 1), (0, -1))

// Keep this so its possible to overwrite it when testing specific cases
#let diverging_points = possible_points


// #let possible_points = ((0, -1),)
// #let diverging_points = ((0, -1), (0, 1))

#let possible-directions(index) = {
  let cp = diverging_points
  let points = cp.slice(index + 1)

  if type(points) == int {
    points = (points,)
  }

  points
}

#grid(
  columns: 4,
  gutter: 5em,
  ..for (index, straight_start) in possible_points.enumerate() {
    let possible-dirs = possible-directions(index)
    for straight_end in possible-dirs {
      (
        grid(
          columns: diverging_points.len(),
          gutter: 1em,
          ..for diverging_point in diverging_points {
            (
              cetz.canvas({
                import cetz.draw: *
                import railtoolkit-trackschematics.draw: *

                // For correct centering of the turnout
                rect((-1, -1), (1, 1), stroke: none)
                track(straight_start, (0, 0), straight_end, name: "T1")

                if straight_start.at(0) == 0 {
                  turnout((track: "T1", y: 0), name: "W1")
                } else {
                  turnout((track: "T1", x: 0), name: "W1")
                }

                track("W1", diverging_point, stroke: purple)
              }),
            )
          }
        ),
      )
    }
  }
)

#pagebreak()

#grid(
  columns: 4,
  gutter: 5em,
  ..for (index, straight_start) in possible_points.enumerate() {
    let possible-dirs = possible-directions(index)
    for straight_end in possible-dirs {
      (
        grid(
          columns: diverging_points.len(),
          gutter: 1em,
          ..for diverging_point in diverging_points {
            (
              cetz.canvas({
                import cetz.draw: *
                import railtoolkit-trackschematics.draw: *

                // For correct centering of the turnout
                rect((-1, -1), (1, 1), stroke: none)

                track(straight_start, (0, 0))
                turnout((), name: "W1")
                track((), straight_end)

                track("W1", diverging_point, stroke: purple)
              }),
            )
          }
        ),
      )
    }
  }
)

#pagebreak()

#grid(
  columns: 4,
  gutter: 5em,
  ..for (index, straight_start) in possible_points.enumerate() {
    let possible-dirs = possible-directions(index)
    for straight_end in possible-dirs {
      (
        grid(
          columns: diverging_points.len(),
          gutter: 1em,
          ..for (index, diverging_start) in diverging_points.enumerate() {
            let possible-dirs = possible-directions(index)
            for diverging_end in possible-dirs {
              (
                cetz.canvas({
                  import cetz.draw: *
                  import railtoolkit-trackschematics.draw: *

                  // For correct centering of the turnout
                  rect((-1, -1), (1, 1), stroke: none)
                  track(straight_start, (0, 0), straight_end, name: "T1")

                  if straight_start.at(0) == 0 {
                    turnout((track: "T1", y: 0), name: "W1")
                  } else {
                    turnout((track: "T1", x: 0), name: "W1")
                  }

                  track((0, 0), diverging_start, stroke: purple)
                  track((0, 0), diverging_end, stroke: purple)
                }),
              )
            }
          }
        ),
      )
    }
  }
)
