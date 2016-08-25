 The `String.Chars` protocol is responsible for
  converting a structure to a Binary (only if applicable).
  The only function required to be implemented is
  `to_string` which does the conversion.

  The `to_string` function automatically imported
  by Kernel invokes this protocol. String
  interpolation also invokes `to_string` in its
  arguments. For example, `"foo#{bar}"` is the same
  as `"foo" <> to_string(bar)`.
