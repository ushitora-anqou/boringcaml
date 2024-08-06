type t =
  | Unit
  | Number of float
  | String of string
  | Fun of (string list * Expr.t)
