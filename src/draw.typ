#import "/src/types.typ": cetz, end-of-track-type, set-style-to, track-type, turnout-type

/// Draws a buffer stop
///
/// The direction is inferred from the track.
/// Buffer stops must be drawn at the start or the end of a track.
///
/// ```examplec
/// >>> cetz.canvas({
/// >>> import rts.draw: *
/// track((), (e: 4), (ne: 2), name: "tr-1")
/// buffer-stop(())
/// buffer-stop("tr-1.start")
/// >>> })
/// ```
///
/// Buffer stops can also be added directly to a track with the start and end parameter.
/// ```examplec
/// >>> cetz.canvas({
/// >>> import rts.draw: *
/// track(
///   (),  (e: 4), (ne: 2),
///   start: buffer-stop,
///   end: buffer-stop,
///   name: "tr-1"
/// )
/// >>> })
/// ```
#let buffer-stop(
  /// Positional coordinate to draw the buffer stop.
  /// -> coordinate
  point,

  /// How to stroke the buffer stop. See #link("https://typst.app/docs/reference/visualize/line/#parameters-stroke")[Typst's line documentation] for more details.
  /// -> auto | none | length | color | gradient | stroke | tiling | dictionary
  stroke: auto,
) = {
  let type-def = (
    name: "buffer-stop",
    default-styles: (stroke: 1.25pt),
    draw: (..styles) => {
      let h = .25
      let w = .1

      cetz.draw.translate(x: -styles.named().stroke.thickness / 2)
      cetz.draw.line(
        (-w, -h / 2),
        (0, -h / 2),
        (0, h / 2),
        (-w, h / 2),
        ..styles,
      )
    },
  )

  end-of-track-type(type-def, point, stroke: stroke)
}

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

  /// Element at start of track e.g. `buffer-stop`
  ///```examplec
  /// >>> cetz.canvas({
  /// >>> import rts.draw: *
  /// track(
  ///   (),  (e: 2),
  ///   start: buffer-stop,
  ///   name: "tr-1"
  /// )
  /// >>> })
  /// ```
  /// Elements at the end of track are aliased:
  /// - "\]" #sym.arrow `buffer-stop`
  ///
  /// ```examplec
  /// >>> cetz.canvas({
  /// >>> import rts.draw: *
  /// track(
  ///   (),  (e: 2),
  ///   start: "]",
  ///   name: "tr-1"
  /// )
  /// >>> })
  /// ```
  ///
  /// -> none | function
  start: none,

  /// Element at end of track e.g. `buffer-stop`
  ///```examplec
  /// >>> cetz.canvas({
  /// >>> import rts.draw: *
  /// track(
  ///   (),  (e: 2),
  ///   end: buffer-stop,
  ///   name: "tr-1"
  /// )
  /// >>> })
  /// ```
  ///
  /// Aliases can also be used. See start attribute.
  ///
  /// -> none | function
  end: none,

  /// Anchor name.
  /// -> none | str
  name: none,
) = {
  let aliases = (
    "]": buffer-stop,
  )

  let type-def = (
    name: "track",
    default-styles: (stroke: 1pt, main: (stroke: 2pt)),
    draw: (pts, ..styles) => {
      if kind == "main" {
        styles = set-style-to(styles, "main")
      }

      cetz.draw.line(..pts, ..styles, name: name)

      if type(start) == function {
        (start)(pts.first())
      }

      if type(end) == function {
        (end)(pts.last())
      }

      if type(start) == str {
        assert(start in aliases, message: "Alias for start can not be found: " + start)
        (aliases.at(start))(pts.first())
      }

      if type(end) == str {
        assert(end in aliases, message: "Alias for end can not be found: " + end)
        (aliases.at(end))(pts.last())
      }
    },
  )

  track-type(type-def, points.pos(), stroke: stroke, name: name)
}


/// Draws a turnout.
///
/// Connecting tracks are automatically detected and a turnout is drawn as soon as the turnout is connected on all three sides.
/// The Symbol is automatically placed in the correct orientation.
///
/// Turnouts are only drawn if the match the angle pattern of the two types:
///
/// - straight + 45° diverging branch
/// - two 45° diverging branches
///
/// ```examplec
/// >>> cetz.canvas({
/// >>> import rts.draw: *
/// track((), (e: 3), name: "tr-1")
/// turnout((track: "tr-1", x: 1))
/// track((), (ne: 1), (e: 1))
///
/// track(
///   (4,0), (e:1), (ne:1), (e:1),
///   name: "tr-2"
/// )
/// turnout((track: "tr-2", x: 5))
/// track((), (se: 1), (e:1))
/// >>> })
/// ```
///
/// Three way switches are supported
///
/// ```examplec
/// >>> cetz.canvas({
/// >>> import rts.draw: *
/// track((), (e: 4), name: "tr-1")
/// turnout((track: "tr-1", x: 1), name: "to-1")
/// track("to-1", (se: 1), (e: 2))
/// track("to-1", (ne: 1), (e: 2))
/// >>> })
/// ```
///
/// With four connections the switch converts to a slip switch
///
/// ```examplec
/// >>> cetz.canvas({
/// >>> import rts.draw: *
/// track((), (e: 8), name: "tr-1")
/// track((0,-1), (e:1), (ne: 2), (e: 5))
/// turnout((track: "tr-1", x:2))
/// >>> })
/// ```
///
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
    draw: (ang1, ang2, ..styles) => {
      let r = a => if calc.rem(a.deg(), 90) == 0 { 0.4 } else { calc.sqrt(2) * 0.4 }

      cetz.draw.line((0, 0), (ang1, r(ang1)), (ang2, r(ang2)), ..styles)
    },
  )

  turnout-type(type-def, point, fill: fill, stroke: stroke, name: name)
}



