module C = Configurator.V1

let () =
  C.main ~name:"gmp" @@ fun c ->
  let default = { C.Pkg_config.libs = [ "-lgmp" ]; cflags = [] } in
  let conf =
    match C.Pkg_config.get c with
    | None -> default
    | Some pc -> (
      match C.Pkg_config.query pc ~package:"gmp" with
      | None -> default
      | Some deps -> deps )
  in

  C.Flags.write_sexp "c_flags.sexp" conf.cflags;

  C.Flags.write_sexp "c_library_flags.sexp" conf.libs;

  C.Flags.write_lines "c_flags.lines" conf.cflags
