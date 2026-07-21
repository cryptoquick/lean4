/-!
Minimal Lake test driver for `basic_toml` parity package.
`lake test` / `slake test` run this executable; exits 0 on success.
-/

def main : IO Unit :=
  IO.println "basic_toml: test ok"
