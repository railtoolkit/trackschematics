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

#let pos-on-track(cetz, ctx, name, pos) = {
  let points = drawables-to-points(cetz, ctx, name)
  let c

  assert(
    pos >= 0,
    message: "There is no position \"" + str(pos) + "\" on track \"" + name + "\". \n" + "Select a positive position.",
  )

  let length-sum = 0
  for (index, start) in points.slice(0, -1).enumerate() {
    let end = points.at(index + 1)
    let diff = cetz.vector.sub(end, start)

    let length = {
      if diff.at(0) != 0 {
        calc.abs(diff.at(0))
      } else {
        calc.abs(diff.at(1))
      }
    }

    length-sum += length

    if pos > length-sum {
      continue
    }
    
    let start-pos = length-sum - length
    let rel-pos = cetz.vector.scale(diff, (pos - start-pos) / length)

    c = cetz.vector.add(start, rel-pos)
    break
  }

  assert(
    c != none,
    message: "There is no position \""
      + str(pos)
      + "\" on track \""
      + name
      + "\" with a length of "
      + str(length-sum)
      + ". \n"
      + "Select a position betwetween 0 and "
      + str(length-sum)
      + ".",
  )
  c
}
