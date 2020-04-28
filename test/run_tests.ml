open Ctypes
open Ctypes_zarith

module Add = struct
  let add =
    Foreign.foreign "__gmpz_add"
      (mpz_ptr @-> mpz_srcptr @-> mpz_srcptr @-> returning void)

  let add a b =
    let r = make () in
    add r a b;
    to_z r

  let check x = Alcotest.(check bool) "" true x

  let test_add () =
    check (Z.of_int 3 = add (Z.of_int 1) (Z.of_int 2));
    let f n =
      let r = Z.(n + n) in
      check (r = add n n)
    in
    let n = Z.of_int max_int in
    f n;
    let n = Z.(n + n) in
    f n;
    let n = Z.(n * n) in
    f n;
    let n = Z.pow n 256 in
    f n;
    ()
end

let () =
  Alcotest.run "ctypes-zarith"
    [
      ("add", [ ("add", `Quick, Add.test_add) ]);
      ("gc", [ ("gc", `Slow, Gc.compact) ]);
    ]
