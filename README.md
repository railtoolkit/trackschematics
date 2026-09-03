# RailToolkit track schematics

[![User Manual](https://img.shields.io/badge/manual-.pdf-purple)][manual]

Typst package for drawing track schematics based on [CeTZ](https://cetz-package.github.io/).


![image](tests/usage/basic/ref/1.png)

```typ
#import "@preview/railtoolkit-trackschematics:0.1.0"
#import "@preview/cetz:0.5.2"

#cetz.canvas({
  import railtoolkit-trackschematics.draw: *

  track((), (e: 6), name: "tr-1")

  turnout((track: "tr-1", x: 1))
  track((), (ne: 1), (e: 2), (se: 1))
  turnout(())
})
```

See [manual][manual] for further documentation.

## Testing

[Tytanic](https://typst-community.github.io/tytanic/) is used for testing. Please refer to tytanic documentation for installation and usage.

## Principles

- The package is designed to integrate seamlessly with CeTZ
- The use of references over absolute coordinates should be encouraged
- Symbols should be easily exchangeable

## Licensing

This package is distributed under the ISC License.

[manual]: docs/manual.pdf