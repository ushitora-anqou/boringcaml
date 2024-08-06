let evaluate e =
  match e.Expr.v with
  | Expr.Unit -> Value.Unit
  | Number n -> Number n
  | String s -> String s
