module RWC.Primitives where

-- Imports in this file are ignored by rwc.
import Prelude (Integer, String)
import qualified Prelude                           as GHC
import qualified Control.Monad.Identity            as GHC
import qualified Control.Monad.Resumption.Reactive as GHC
import qualified Control.Monad.State               as GHC

type I = GHC.Identity
type ReT = GHC.ReacT
type StT = GHC.StateT
type Bits = [Bit]

-- ReWire primitives.

-- Primitive types:
-- data (->) a b
-- data ReT i o m a
-- data StT s m a
-- data I a
-- data Integer
-- data Bit

-- Also tuples:
-- data () = ()
-- data (a, b) = (a, b)
-- ...

data R_ -- Ctors generated during program build.
data A_ -- Ctors generated during program build.

data PuRe s o = Done (A_, s) | Pause (o, (R_, s))

data Bit = C | S

-- Definitions in this file are for ghc compat and ignored by rwc.

error :: String -> a
error = GHC.error

-- | The String and list arguments must be literals (after inlining).
externWithSig :: [(String, Integer)] -- ^ Module parameters (name and integer literal value).
              -> String              -- ^ Clock signal name or empty for no clock.
              -> [(String, Integer)] -- ^ Module inputs (name and integer literal bitwidth).
              -> [(String, Integer)] -- ^ Module outputs (name and integer literal bitwidth).
              -> String              -- ^ Module name.
              -> a                   -- ^ Haskell definition to use when interpreting.
              -> String              -- ^ Instance name to use in generated Verilog.
              -> a
externWithSig _ _ _ _ _ f _ = f

-- | bits a j i returns bits j (most significant) to i (least significant) from a (j >= i).
--   The Integer arguments must be non-negative integer literals (after inlining).
bits :: a -> Integer -> Integer -> b
bits = GHC.error "Prim: bit string extraction"

-- | bit a i == bits a i i.
--   The Integer argument must be a non-negative integer literal (after inlining).
bit :: a -> Integer -> Bit
bit = GHC.error "Prim: bit extraction"

data Ref a = Ref String
setRef :: Ref a -> a -> b -> b
setRef _ _ b = b

getRef :: Ref a -> a 
getRef = GHC.error "Prim: get"

rwReturn :: GHC.Monad m => a -> m a
rwReturn = GHC.return

rwBind :: GHC.Monad m => m a -> (a -> m b) -> m b
rwBind = (GHC.>>=)

get :: GHC.Monad m => StT s m s
get = GHC.get

put :: GHC.Monad m => s -> StT s m ()
put = GHC.put

signal :: GHC.Monad m => o -> ReT i o m i
signal = GHC.signal

lift :: (GHC.MonadTrans t, GHC.Monad m) => m a -> t m a
lift = GHC.lift

extrude :: ReT i o (StT s m) a -> s -> ReT i o m a
extrude = GHC.error "Prim: extrude"

unfold :: ((R_, s) -> i -> PuRe s o) -> PuRe s o -> ReT i o I a
unfold = GHC.error "Prim: unfold"
