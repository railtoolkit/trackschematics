#let to-str(value) = {
  if type(value) == array {
    let f = value.fold("", (x, v) => x + to-str(v) + ", ")

    if f.len() > 0 { f = f.slice(0, -2) }

    return "(" + f + ")"
  }

  if type(value) == dictionary {
    let f = ""

    f = for e in value {
      e.at(0) + ": " + to-str(e.at(1)) + ", "
    }

    if f.len() > 0 { f = f.slice(0, -2) }

    return "(" + f + ")"
  }

  if type(value) == angle {
    return str(value.deg()) + "deg"
  }

  if type(value) == int or type(value) == float {
    return str(value)
  }

  if type(value) == str {
    return "\"" + value + "\""
  }

  if value == none {
    return "none"
  }

  if type(value) == ratio {
    return str(value / 1%) + "%"
  }

  if type(value) == length {
    return "<length>"
  }

  if type(value) == bool {
    return if value { "true" } else { "false" }
  }
}

#let element-to-string(element-type, pos, name) = {
  "\nERROR: " + element-type + " at " + to-str(pos) + " "
  if name != none {
    "with name \"" + name + "\""
  }
  "\n"
}
