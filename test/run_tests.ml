open Ctypes
open Ctypes_zarith

module Add = struct
  let z_add =
    Foreign.foreign "__gmpz_add"
      (MPZ.t_ptr @-> MPZ.zarith @-> MPZ.zarith @-> returning void)

  let z_add a b =
    let r = MPZ.make () in
    z_add r a b;
    MPZ.to_z r

  let q_add =
    Foreign.foreign "__gmpq_add"
      (MPQ.t_ptr @-> MPQ.zarith @-> MPQ.zarith @-> returning void)

  let q_add a b =
    let r = MPQ.make () in
    q_add r a b;
    MPQ.to_q r

  let check x = Alcotest.(check bool) "" true x

  let test_add () =
    let one = Z.of_int 1 in
    let two = Z.of_int 2 in
    let three = Z.of_int 3 in
    let six = Z.of_int 6 in
    let (/) n d = Q.make n d in
    check (three = z_add one two);
    check (one / two = q_add (one / three) (one / six));
    let fz n =
      let r = Z.(n + n) in
      check (r = z_add n n)
    in
    let n = Z.of_int max_int in
    fz n;
    let n = Z.(n + n) in
    fz n;
    let n = Z.(n * n) in
    fz n;
    let n = Z.pow n 256 in
    fz n;
    let fq n =
      let r = Q.(n + n) in
      check (r = q_add n n)
    in
    let n = six / (Z.of_int max_int) in
    fq n;
    let n = Q.(n + n) in
    fq n;
    let n = Q.(n * n) in
    fq n;
    ()
end

let () =
  Alcotest.run "ctypes-zarith"
    [
      ("add", [ ("add", `Quick, Add.test_add) ]);
      ("gc", [ ("gc", `Slow, Gc.compact) ]);
    ]
