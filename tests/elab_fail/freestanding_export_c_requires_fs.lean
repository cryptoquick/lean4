/-!
# Freestanding K12: `@[export_c]` requires `compiler.freestanding`.
-/

@[export_c lean_bad]
def add (x y : Nat) : Nat := x + y
