open Boringcaml

let () =
  let open OUnit2 in
  run_test_tt_main
    ("boringcaml"
    >::: [ ("unit" >:: fun _test_ctxt -> assert (evaluate EUnit = VUnit)) ])
