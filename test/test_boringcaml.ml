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
         ])
