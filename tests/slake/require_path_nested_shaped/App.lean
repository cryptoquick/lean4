import Foo.Bar

/-!
Root package module that imports path-require nested `Foo.Bar` (A31 nested ModRel).
-/

def appNested : String := Foo.Bar.marker ++ " app"
