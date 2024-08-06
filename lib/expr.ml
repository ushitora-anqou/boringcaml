type t' =
  | Unit
  | String of string
  | Number of float
  | Apply of (t * t)
  | Var of string
  | Fun of (Pat.t list * t)

and t = t' Loc.with_location
