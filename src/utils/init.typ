#import "@preview/cetz:0.5.2"
#import "/src/utils/track.typ": drawables-to-points, one-x-or-y-coordinate-on-track

#let init() = {
  cetz.draw.get-ctx(ctx => {
    if "trackschematics" in ctx {
      return
    }

    // Add trackschematics dict to context
    cetz.draw.set-ctx(ctx => {
      ctx.insert("trackschematics", (
        turnouts: (),
        tracks: (),
      ))

      ctx
    })

    cetz.draw.register-coordinate-resolver((ctx, c) => {
      // Resolves coordinates referring to track
      // element((track: "track-1", x: 1))
      // element((track: "track-1", y: 1))
      if type(c) == dictionary and "track" in c {
        assert(c.track in ctx.nodes, message: "track was not found: " + c.track)
        c = one-x-or-y-coordinate-on-track(cetz, ctx, ..c)
      }

      // Shortcut for drawing in cardinal directions
      if (type(c) == dictionary and c.keys().len() == 1) {
        let key = c.keys().at(0)
        let v = c.values().at(0)

        if type(v) == int or type(v) == float {
          if key == "n" { c = (rel: (0, v)) }
          if key == "e" { c = (rel: (v, 0)) }
          if key == "s" { c = (rel: (0, -v)) }
          if key == "w" { c = (rel: (-v, 0)) }
          if key == "ne" { c = (rel: (v, v)) }
          if key == "se" { c = (rel: (v, -v)) }
          if key == "sw" { c = (rel: (-v, -v)) }
          if key == "nw" { c = (rel: (-v, v)) }
        }

        if type(v) == str {
          let resolved
          let prev = ctx.prev.pt
          let dir = {
            if key == "n" { (0, 1) }
            if key == "e" { (1, 0) }
            if key == "s" { (0, 1) }
            if key == "w" { (-1, 0) }
            if key == "ne" { (1, 1) }
            if key == "se" { (1, -1) }
            if key == "sw" { (-1, -1) }
            if key == "nw" { (-1, 1) }
          }

          let points = drawables-to-points(cetz, ctx, v)
          let intersection-len = float.inf
          for index in range(0, points.len() - 1) {
            let point1 = points.at(index)
            let point2 = points.at(index + 1)
            let point3 = prev
            let point4 = cetz.vector.add(prev, dir)

            let intersection = cetz.intersection.line-line(
              point1,
              point2,
              point3,
              point4,
              ray: true,
            )

            if intersection == none {
              continue
            }

            // Direction is respected
            if dir.at(0) != 0 {
              let diff = intersection.at(0) - point3.at(0)
              if diff == 0 {
                continue
              }
              if diff / calc.abs(diff) != dir.at(0) {
                continue
              }
            } else {
              let diff = intersection.at(1) - point3.at(1)
              if diff == 0 {
                continue
              }
              if diff / calc.abs(diff) != dir.at(1) {
                continue
              }
            }

            if (
              cetz.intersection.line-line(
                point1,
                point2,
                point3,
                intersection,
              )
                != none
            ) {
              let len = cetz.vector.dist(point3, intersection)
              if (len < intersection-len) {
                intersection-len = len
                resolved = intersection
              }
            }
          }

          assert(resolved != none, message: "Could not find intersction with " + v + " in direction " + key)

          c = resolved
        }
      }

      c
    })
  })
}
