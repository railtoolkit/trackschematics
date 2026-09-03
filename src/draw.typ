#import "/src/types.typ": cetz, set-style-to, track-type, turnout-type

/// Draws a track
///
///
/// ```examplec
/// >>> cetz.canvas({
/// >>> import rts.draw: *
/// track((), (e: 3), (ne: 2), (e: 4))
/// >>> })
/// ```
#let track(
  /// Positional two or more coordinates to draw tracks.
  /// -> coordinate
  ..points,

  /// Kind of track. Can be either `"main"` or `"secondary"`.
  ///
  /// ```examplec
  /// >>> cetz.canvas({
  /// >>> import rts.draw: *
  /// track((), (e: 7))
  /// >>> })
  /// ```
  ///
  /// ```examplec
  /// >>> cetz.canvas({
  /// >>> import rts.draw: *
  /// track((), (e: 7), kind: "secondary")
  /// >>> })
  /// ```
  ///
  /// -> str
  kind: "main",

  /// How to stroke the track. See #link("https://typst.app/docs/reference/visualize/line/#parameters-stroke")[Typst's line documentation] for more details.
  /// -> none | length | color | gradient | stroke | tiling | dictionary
  stroke: auto,

  /// Anchor name.
  /// -> none | str
  name: none,
) = {
  let type-def = (
    name: "track",
    default-styles: (stroke: 1pt, main: (stroke: 2pt)),
    draw: (pts, ..styles) => {
    if kind == "main" {
        styles = set-style-to(styles, "main")
    }

      cetz.draw.line(..pts, ..styles, name: name)
    },
  )

  track-type(type-def, points.pos(), stroke: stroke, name: name)
}


/// Draws a turnout
///
/// ```examplec
/// >>> cetz.canvas({
/// >>> import rts.draw: *
/// track((), (e: 8))
/// track((3,0), (ne: 1), (e: 4))
/// turnout((3,0))
/// >>> })
/// ```
#let turnout(
  /// Positional coordinate to draw the turnout.
  /// -> coordinate
  point,

  /// How to fill the turnout.
  /// -> auto | none | color | gradient | tiling
  fill: auto,

  /// How to stroke the turnout. See #link("https://typst.app/docs/reference/visualize/line/#parameters-stroke")[Typst's line documentation] for more details.
  /// -> auto | none | length | color | gradient | stroke | tiling | dictionary
  stroke: auto,

  /// Anchor name.
  /// -> none | str
  name: none,
) = {
  let type-def = (
    name: "turnout",
    default-styles: (fill: auto, stroke: none),
    draw: (ang1, ang2, ..style) => {
    let r = a => if calc.rem(a.deg(), 90) == 0 { 0.4 } else { calc.sqrt(2) * 0.4 }

      cetz.draw.line((0, 0), (ang1, r(ang1)), (ang2, r(ang2)), ..style, name: name)
    },
  )

  turnout-type(type-def, point, fill: fill, stroke: stroke, name: name)
}
