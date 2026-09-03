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

#let base-type(type-def) = {
  init()

  assert("name" in type-def.keys())
  assert("default-styles" in type-def.keys())

  let (default-styles, name) = type-def

  // Add default styles for type if not added yet
  cetz.draw.set-ctx(ctx => {
    if name not in ctx.style {
      let style = default-styles

      // Respect previously set styles by the user
      if name in ctx.style {
        style = cetz.styles.resolve(style, merge: ctx.style.at(name))
      }

      // Add styles to ctx
      ctx.style = cetz.styles.merge(ctx.style, ((name): style))
    }

    ctx
  })
}

#let resolve-styles(ctx, styles, root) = {
  styles = cetz.styles.resolve(ctx.style, merge: styles, root: root)

  // If fill is not specified (none) default to stroke paint
  // This implicates that fill=none on global level is always ignored for trackschematics
  if "fill" in ctx.style.at(root) and ctx.style.at(root).fill == auto {
    if styles.fill == none and "paint" in ctx.style.stroke {
      styles.fill = ctx.style.stroke.paint
    }
  }

  styles
}

#let track-type(type-def, points, name: none, ..args) = {
  base-type(type-def)

  assert("name" in type-def.keys())
  assert("draw" in type-def.keys())

  assert(points.len() > 1, message: "track expects at least two points, got" + str(points.len()))

  cetz.draw.get-ctx(ctx => {
    let (ctx, ..pts) = cetz.coordinate.resolve(ctx, ..points)
    let styles = resolve-styles(ctx, args.named(), type-def.name)

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

    (type-def.draw)(pts, ..styles)
  })
}

#let turnout-type(type-def, point, name: none, ..args) = {
  base-type(type-def)

  assert("draw" in type-def.keys())

  cetz.draw.get-ctx(ctx => {
    let center-raw = point
    let (ctx, center) = cetz.coordinate.resolve(ctx, center-raw)
    let styles = resolve-styles(ctx, args.named(), type-def.name)

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
          styles: styles,
          ports: ports,
          draw: type-def.draw,
        ),
      )

      ctx
    })
  })
  cetz.draw.get-ctx(ctx => draw-finished-turnouts(ctx))
}

#let end-of-track-type(type-def, point, ..args) = {
  base-type(type-def)

  assert("draw" in type-def.keys())

  cetz.draw.get-ctx(ctx => {
    let (ctx, point) = cetz.coordinate.resolve(ctx, point)
    let styles = resolve-styles(ctx, args.named(), type-def.name)

    let dir
    for track in ctx.trackschematics.tracks {
      if type(track) == str {
        track = drawables-to-points(cetz, ctx, track)
      }

      if track.at(0) == point {
        dir = cetz.vector.angle2(track.at(1), point)
        break
      }

      if track.at(-1) == point {
        dir = cetz.vector.angle2(track.at(-2), point)
        break
      }
    }

    assert(dir != none, message: "Could not find track end or start.")

    cetz.draw.scope({
      cetz.draw.set-origin(point)
      cetz.draw.rotate(dir)
      (type-def.draw)(..styles)
    })
  })
}
