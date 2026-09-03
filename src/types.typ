#import "/src/utils/init.typ": cetz, init
#import "/src/utils/track.typ": drawables-to-points, point-is-on-line, x-or-y-coordinate-on-track
#import "/src/utils/turnouts.typ": draw-finished-turnouts, link-track-to-turnouts
// Change style to named element
// Important so user can change default styles
#let set-style-to(style, name) = {
  if type(style) == arguments {
    style = style.named()
  }

  cetz.styles.resolve(style, merge: style.at(name))
}

#let base-type(type-fn, type-name: none, default-style: (:), ..args) = (..pts-style) => {
  init()

  // Add default styles for type if not added yet
  cetz.draw.set-ctx(ctx => {
    if type-name not in ctx.style {
      let style = default-style

      // Respect previously set styles by the user
      if type-name in ctx.style {
        style = cetz.styles.resolve(style, merge: ctx.style.at(type-name))
      }

      // Add styles to ctx
      ctx.style = cetz.styles.merge(ctx.style, ((type-name): style))
    }

    ctx
  })

  // Get styles currently in effect for type
  cetz.draw.get-ctx(ctx => {
    let style = cetz.styles.resolve(ctx.style, merge: pts-style.named(), root: type-name)

    // If fill is not specified (none) default to stroke paint
    // This implicates that fill=none on global level is always ignored for trackschematics
    if "fill" in ctx.style.at(type-name) and ctx.style.at(type-name).fill == auto {
      if style.fill == none and "paint" in ctx.style.stroke {
        style.fill = ctx.style.stroke.paint
      }
    }

    type-fn(pts-style.pos(), ..style)
  })
}

#let track-type(draw, ..args) = base-type(
  (points, ..style, name: none) => {
    assert(points.len() > 1, message: "track expects at least two points, got" + str(points.len()))

    cetz.draw.get-ctx(ctx => {
      let (ctx, ..pts) = cetz.coordinate.resolve(ctx, ..points)

      cetz.draw.set-ctx(ctx => {
        // If coordinate is an anchor referencencing a turnout add the track to the ports of the turnout
        ctx = link-track-to-turnouts(ctx, pts)

        if name == none {
          ctx.trackschematics.tracks.push(pts)
        } else {
          ctx.trackschematics.tracks.push(name)
        }

        ctx
      })

      cetz.draw.get-ctx(ctx => draw-finished-turnouts(ctx))

      draw(pts, ..style, name: name)
    })
  },
  ..args,
)

#let turnout-type(draw, ..args) = base-type(
  (points, ..style, name: none, connect-track: none) => {
    assert(points.len() == 1, message: "turnout expects one point, got" + str(points.len()))

    cetz.draw.get-ctx(ctx => {
      let center-raw = points.at(0)
      let (ctx, center) = cetz.coordinate.resolve(ctx, center-raw)

      // Add anchor for turnout center
      if name != none {
        cetz.draw.anchor(name, center)
      } // Update previous position when having no anchor
      else {
        cetz.draw.set-ctx(ctx => {
          ctx.prev.insert("pt", center)
          ctx
        })
      }

      let ports = ()

      // Loop over all tracks to check if turnout is on existing track
      for track in ctx.trackschematics.tracks {
        let points = track

        if type(track) == str {
          points = drawables-to-points(cetz, ctx, track)
        }

        for index in range(0, points.len() - 1) {
          if point-is-on-line(center, points.at(index), points.at(index + 1)) {
            if center != points.at(index) {
              ports.push(cetz.vector.angle2(center, points.at(index)))
            }

            if center != points.at(index + 1) {
              ports.push(cetz.vector.angle2(center, points.at(index + 1)))
            }
          }
        }
      }

      // Save turnout so that it can be drawn when ports are filled
      cetz.draw.set-ctx(ctx => {
        ctx.trackschematics.turnouts.push(
          (
            center: center,
            style: style,
            ports: ports,
            draw: draw,
          ),
        )

        ctx
      })

      cetz.draw.get-ctx(ctx => draw-finished-turnouts(ctx))
    })
  },
  ..args,
)
