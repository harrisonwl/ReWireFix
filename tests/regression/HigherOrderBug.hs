import ReWire

-- This used to fail because the type checker would try to take the type on the
-- left-hand side of f's arrow while it was still tagged with an evar.
f :: (() -> ()) -> () -> ()
f = \ f -> \ x -> f x

start :: ReacT () () Identity ()
start = do
  signal ()
  start

main = undefined
