{-# LANGUAGE Safe #-}
module ReWire.Flags where

data Flag = FlagO !String
          | FlagV       | FlagH
          | FlagFirrtl  | FlagVerilog | FlagVhdl
          | FlagDHask1  | FlagDHask2 | FlagDCrust0
          | FlagDCrust1 | FlagDCrust2 | FlagDCrust2b | FlagDCrust3 | FlagDCrust4 | FlagDCrust5
          | FlagDCore1  | FlagDCore2
          | FlagFlatten
          | FlagInvertReset
          | FlagNoReset | FlagNoClock
          | FlagSyncReset
          | FlagPkgs !String
          | FlagClockName !String
          | FlagResetName !String
          | FlagInputNames !String | FlagOutputNames !String | FlagStateNames !String
          | FlagLoadPath !String
          | FlagTop !String
          | FlagInterpret !(Maybe String) | FlagCycles !String
      deriving (Eq, Show)
