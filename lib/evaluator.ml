let rec evaluate e =
  match e.Loc.v with
  | Expr.Unit -> Value.Unit
  | Number n -> Number n
  | String s -> String s
  | Fun (params, body) ->
      let params' =
        params |> List.map (function Loc.{ v = Pat.Var id; _ } -> id)
      in
      Fun (params', body)
  | Apply (l, r) -> (
      let l' = evaluate l in
      let _r' = evaluate r in
      match l' with
      | Value.Fun (_params, body) -> evaluate body
      | _ -> assert false)
  | Var _ -> assert false
