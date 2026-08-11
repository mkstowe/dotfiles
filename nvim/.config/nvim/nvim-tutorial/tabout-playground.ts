function call(value: unknown) { return value }

const nested = call(alpha(beta[gamma]))
const quoted = call("move out of this string")
const object = { outer: { inner: [1, 2, 3] } }

// Put the cursor inside nested delimiters in Insert mode and test Tab / Shift-Tab.
