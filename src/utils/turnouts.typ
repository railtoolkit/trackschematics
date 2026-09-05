#import "/src/utils/init.typ": cetz

#let link-track-to-turnouts(ctx, pts) = {
  let saved-turnouts = ctx.trackschematics.turnouts

  for (i, pt) in pts.enumerate() {
    let t-index = saved-turnouts.position(t => t.center == pt)
    if t-index == none {
      continue
    }

    let angle = {
      if i == 0 {
        cetz.vector.angle2(pts.at(0), pts.at(1))
      } else {
        cetz.vector.angle2(pts.at(i), pts.at(i-1))
      }
    }

    ctx.trackschematics.turnouts.at(t-index).ports.push(angle)
  }

  ctx
}

#let loop-index(index, items) = calc.rem-euclid(index, items.len())

#let drawing-angles-in-allowed-combination(angles, allowed-angles, max-drawing-angle: 45deg) = {
  let angles = angles.map(a => {
    while a < 0deg {
      a += 360deg
    }
    a
  })

  angles = angles.sorted()

  let drawing-angles = ()

  let angles-between = for (index, a1) in angles.enumerate() {
    let a2 = angles.at(loop-index(index + 1, angles))
    let diff = a1 - a2

    // Normalize diff angle
    while diff > 180deg { diff -= 360deg }
    while diff < -180deg { diff += 360deg }
    diff = calc.abs(diff)

    if diff <= max-drawing-angle {
      drawing-angles.push((a1, a2))
    }

    (diff,)
  }

  let angles-sorted = angles-between.dedup().sorted()
  let min-item = angles-sorted.first()

  // Reverse when needed
  if angles-sorted.len() > 1 {
    let last-min-index = angles-between.position(x => x == min-item)

    while angles-between.at(last-min-index) == min-item {
      last-min-index = loop-index(last-min-index + 1, angles-between)
    }

    if angles-between.at(last-min-index) != angles-sorted.at(1) {
      angles-between = angles-between.rev()
    }
  }

  // Get index of first min-item
  let first-min-index = angles-between.position(x => x == min-item)
  if angles-sorted.len() > 1 {
    while angles-between.at(loop-index(first-min-index - 1, angles-between)) == min-item {
      first-min-index = loop-index(first-min-index - 1, angles-between)
    }
  }

  // Move first min-item to the front
  if first-min-index != 0 {
    angles-between = for i in range(angles-between.len()) {
      (angles-between.at(loop-index(i + first-min-index, angles-between)),)
    }
  }

  // Should be in correct order right now!
  // If new angles are added this has to be checked

  if angles-between == allowed-angles {
    return drawing-angles
  }

  return none
}

#let draw-finished-turnouts(ctx) = {
  for t in ctx.trackschematics.turnouts {
    if t.ports.len() not in (3, 4) {
      continue
    }

    let drawing-angles

    // Try crossings
    if t.ports.len() == 4 {
      drawing-angles = drawing-angles-in-allowed-combination(t.ports, (45deg, 135deg, 45deg, 135deg))

      if drawing-angles == none {
        drawing-angles = drawing-angles-in-allowed-combination(t.ports, (45deg, 45deg, 135deg, 135deg))
      }
    }

    if t.ports.len() == 3 {
      // "Normal" tournouts
      drawing-angles = drawing-angles-in-allowed-combination(t.ports, (45deg, 135deg, 180deg))

      // Try split tournouts
      if drawing-angles == none {
        drawing-angles = drawing-angles-in-allowed-combination(
          t.ports,
          (90deg, 135deg, 135deg),
          max-drawing-angle: 90deg,
        )
      }
    }

    if drawing-angles == none {
      continue
    }

    for angles in drawing-angles {
      cetz.draw.scope({
        cetz.draw.set-origin(t.center)
        (t.draw)(..angles, ..t.styles)
      })
    }
  }
}
