#let drawables-to-points(cetz, ctx, name) = {
  let drawables = ctx.nodes.at(name).drawables
  let points = drawables.fold((), (pts, d) => pts + cetz.path-util.bounds(d.segments))

  cetz.util.revert-transform(ctx.transform, ..points)
}

#let point-is-on-line(currPoint, point1, point2) = {
  // https://stackoverflow.com/questions/11907947/how-to-check-if-a-point-lies-on-a-line-between-2-other-points

  if currPoint == point1 or currPoint == point2 {
    return true
  }

  let dxc = currPoint.at(0) - point1.at(0)
  let dyc = currPoint.at(1) - point1.at(1)

  let dxl = point2.at(0) - point1.at(0)
  let dyl = point2.at(1) - point1.at(1)

  let cross = dxc * dyl - dyc * dxl
  if (cross != 0) {
    return false
  }

  if (calc.abs(dxl) >= calc.abs(dyl)) {
    if dxl > 0 {
      return point1.at(0) <= currPoint.at(0) and currPoint.at(0) <= point2.at(0)
    } else {
      return point2.at(0) <= currPoint.at(0) and currPoint.at(0) <= point1.at(0)
    }
  } else {
    if dyl > 0 {
      return point1.at(1) <= currPoint.at(1) and currPoint.at(1) <= point2.at(1)
    } else {
      return point2.at(1) <= currPoint.at(1) and currPoint.at(1) <= point1.at(1)
    }
  }
}

#let x-or-y-coordinate-on-track(cetz, ctx, track-name, x: none, y: none) = {
  assert((x != none and y == none) or (x == none and y != none))

  let points = drawables-to-points(cetz, ctx, track-name)

  let pos = { if x != none { x } else { y } }
  let pos-index = { if x != none { 0 } else { 1 } }

  // Find correct section to interpolate for x or y position
  let pts = for index in range(0, points.len() - 1) {
    let (start, end) = (points.at(index + 1), points.at(index)).sorted(key: it => it.at(pos-index))
    let (start-pos, end-pos) = (start, end).map(p => p.at(pos-index))

    if start-pos == end-pos {
      continue
    }

    if start-pos > pos or end-pos < pos {
      continue
    }

    let frac = (pos - start-pos) / (end-pos - start-pos)
    let pt = range(0, start.len()).map(i => start.at(i) + (end.at(i) - start.at(i)) * frac)

    (pt,)
  }

  if pts != none {
    pts = pts.dedup()
  }

  pts
}

#let one-x-or-y-coordinate-on-track(cetz, ctx, track: none, x: none, y: none) = {
  assert(
    x != none or y != none,
    message: "Track referencing coordinate expects x or y. None were found.",
  )

  assert(
    x == none or y == none,
    message: "Track referencing coordinate expects x or y. Both were found.",
  )

  let pts = x-or-y-coordinate-on-track(cetz, ctx, track, x: x, y: y)

  assert(pts.len() == 1, message: "Track referencing coordinate couldn't find correct coordinate.")

  return pts.at(0)
}
