open Boringcaml

let () =
  let open OUnit2 in
  run_test_tt_main
    ("boringcaml"
    >::: [
           ( "unit" >:: fun _test_ctxt ->
             let v =
               Parser.parse_string "()" |> Result.get_ok |> Evaluator.evaluate
             in
             assert (v = Value.Unit) );
           ( "string" >:: fun _test_ctxt ->
             let v =
               Parser.parse_string {|"he\"llo"|}
               |> Result.get_ok |> Evaluator.evaluate
             in
             assert (v = Value.String {|he"llo|}) );
           ( "number" >:: fun _test_ctxt ->
             let v =
               Parser.parse_string "123.45"
               |> Result.get_ok |> Evaluator.evaluate
             in
             assert (v = Value.Number 123.45) );
           ( "parsing function application" >:: fun _ ->
             let v = Parser.parse_string "a b (c d)" |> Result.get_ok in
             match v with
             | {
              v =
                Expr.Apply
                  ( { v = Apply ({ v = Var "a"; _ }, { v = Var "b"; _ }); _ },
                    { v = Apply ({ v = Var "c"; _ }, { v = Var "d"; _ }); _ } );
              _;
             } ->
                 ()
             | _ -> assert false );
           ( "function" >:: fun _ ->
             let v =
               Parser.parse_string "(fun x -> 1) 0"
               |> Result.get_ok |> Evaluator.evaluate
             in
             assert (v = Value.Number 1.0) );
         ])
