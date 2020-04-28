type t

val make : unit -> t Ctypes.abstract Ctypes.ptr
(** like {!Ctypes.make}, but with finalise and type already specified *)

val of_z : Z.t -> t Ctypes.abstract Ctypes.ptr

val to_z : t Ctypes.abstract Ctypes.ptr -> Z.t

val mpz_srcptr : Z.t Ctypes.typ

val mpz_ptr : t Ctypes.abstract Ctypes.ptr Ctypes.typ
