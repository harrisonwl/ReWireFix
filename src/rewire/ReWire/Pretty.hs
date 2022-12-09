{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module ReWire.Pretty (($$), prettyPrint, prettyPrint', text, int, empty, P.Pretty) where

import qualified Prettyprinter as P
import qualified Prettyprinter.Render.Text as P
import TextShow
import Data.Text (Text)

($$) :: P.Doc ann -> P.Doc ann -> P.Doc ann
a $$ b = P.vsep [a, b]

infixl 5 $$

text :: Text -> P.Doc ann
text = P.pretty

int :: Int -> P.Doc ann
int = P.pretty

empty :: P.Doc ann
empty = P.emptyDoc

prettyPrint :: P.Pretty a => a -> Text
prettyPrint = prettyPrint' . P.pretty

prettyPrint' :: P.Doc ann -> Text
prettyPrint' = P.renderStrict . P.layoutPretty (P.defaultLayoutOptions
      { P.layoutPageWidth = P.AvailablePerLine 120 1.0 })

-- TODO(chathhorn): orphan
instance TextShow (P.Doc ann) where
      showb = showb . show
