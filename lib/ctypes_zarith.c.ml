let%c () = header {|
#include <gmp.h>
#include <zarith.h>
|}

let%c t = abstract "__mpz_struct"

external mpz_clear : t ptr -> void = "mpz_clear" [@@noalloc]

let make () =
  (* allocate_n zero initializes the memory. It's safe to pass
     such a struct to mpz_clear. *)
  Ctypes.allocate_n ~finalise:mpz_clear t ~count:1

external%c of_z : zt_:(Z.t[@ocaml_type]) -> tptr_:t ptr -> void = {|
   value z = $zt_; /* not converted. The usual rules for stub code must be
                      obeyed (accessors, memory management (GC), etc.) */
   __mpz_struct * p = $tptr_; /* already converted to a native c type, will not
                                 be garbage collected during the stub code */
   ml_z_mpz_init_set_z(p, z);
|}

let of_z x =
  let r = make () in
  of_z x r;
  r

external%c to_z : ptr_:t ptr -> (Z.t[@ocaml_type]) = {|
  return (ml_z_from_mpz($ptr_));
|}

let mpz_ptr = Ctypes.ptr t

let mpz_srcptr : Z.t Ctypes.typ =
  Ctypes.view
    ~format_typ:(fun k fmt -> Format.fprintf fmt "mpz_ptr%t" k)
    ~read:to_z ~write:of_z mpz_ptr
