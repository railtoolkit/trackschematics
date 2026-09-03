#import "/src/lib.typ" as railtoolkit-trackschematics
#import "/tests/util.typ": cetz

#set page(width: auto, height: auto)
#set grid(align: center + horizon)

#let possible_points = ((1, 0), (-1, 0), (1, 1), (-1, -1), (-1, 1), (1, -1), (0, 1), (0, -1))

// Keep this so its possible to overwrite it when testing specific cases
#let diverging_points = possible_points
#let alternatives = range(0, 3)


// #let possible_points = ((1, 1),)
// #let diverging_points = ((-1, 0),)
// #let alternatives = (0,)

/*
  Helper function
*/
#let possible-directions(point) = {
  let center = (0, 0)

  let dir = (
    center.at(0) - point.at(0),
    center.at(1) - point.at(1),
  )

  if dir.at(0) == 0 {
    let y = center.at(1) + dir.at(1)
    return (
      (center.at(0), y),
      (center.at(0) - 1, y),
      (center.at(0) + 1, y),
    )
  }

  if dir.at(1) == 0 {
    let x = center.at(0) + dir.at(0)
    return (
      (x, center.at(1)),
      (x, center.at(1) - 1),
      (x, center.at(1) + 1),
    )
  }

  (
    (center.at(0) + dir.at(0), center.at(1) + dir.at(1)),
    (center.at(0), center.at(1) + dir.at(1)),
    (center.at(0) + dir.at(0), center.at(1)),
  )
}

#grid(
  columns: 3,
  gutter: 5em,
  ..for straight_start in possible_points {
    let possible-dirs = possible-directions(straight_start)
    for i in alternatives {
      let straight_end = possible-dirs.at(i)
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
  columns: 3,
  gutter: 5em,
  ..for straight_start in possible_points {
    let possible-dirs = possible-directions(straight_start)
    for i in alternatives {
      let straight_end = possible-dirs.at(i)
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

