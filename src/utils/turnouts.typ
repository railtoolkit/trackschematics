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


#let drawing-angles-in-allowed-combination(angles, allowed-angles) = {
  let drawn-angles

  // Compare each combination of angles
  for (index, a1) in angles.slice(0, -1).enumerate() {
    for a2 in angles.slice(index + 1) {
      let diff = a1 - a2

      // Normalize diff angle
      while diff > 180deg { diff -= 360deg }
      while diff < -180deg { diff += 360deg }
      diff = calc.abs(diff)

      let pos = allowed-angles.position(a => a == diff)
      if pos == none {
        continue
      }

      let _ = allowed-angles.remove(pos)

      if diff <= 90deg {
        drawn-angles = (a1, a2)
      }

      if allowed-angles.len() == 0 {
        break
      }
    }
    if allowed-angles.len() == 0 {
      break
    }
  }

  if allowed-angles.len() == 0 {
    drawn-angles
  }
}

#let draw-finished-turnouts(ctx) = {
  for t in ctx.trackschematics.turnouts {
    if t.ports.len() != 3 {
      continue
    }

    // Try "normal" tournouts
    let drawing-angles = drawing-angles-in-allowed-combination(t.ports, (180deg, 45deg))

    // Try split tournouts
    if drawing-angles == none {
      drawing-angles = drawing-angles-in-allowed-combination(t.ports, (90deg, 135deg, 135deg))
    }

    if drawing-angles == none {
      continue
    }

    cetz.draw.scope({
      cetz.draw.set-origin(t.center)
      (t.draw)(..drawing-angles, ..t.styles)
    })
  }
}
