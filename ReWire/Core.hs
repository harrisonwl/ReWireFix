{-# LANGUAGE TemplateHaskell,FlexibleInstances,MultiParamTypeClasses,FlexibleContexts,UndecidableInstances #-}

-- Some scribbles as I try to figure out what form ReWire Core will take. Note
-- that the term ReWire Core as used here is different from the term as used
-- in the ICFPT paper; rather than being a normal form of Haskell it is a
-- separate language like GHC Core. This is the input to the partial
-- evaluator.

module ReWire.Core where

import Unbound.LocallyNameless

-- Identifier is used instead of Name for anything that occurs at the top
-- level of the program (type names, constructor names, class names,
-- functions defined at top level) -- i.e. things that cannot be substituted
-- for.
type Identifier = String

data RWCTy = RWCTyApp RWCTy RWCTy
           | RWCTyCon Identifier
           | RWCTyVar (Name RWCTy)
           deriving Show

data RWCExp = RWCApp RWCTy RWCExp RWCExp
            | RWCLam RWCTy (Bind (Name RWCExp,Embed RWCTy) RWCExp)
            | RWCVar RWCTy (Name RWCExp)
            | RWCCon RWCTy Identifier
            | RWCLiteral RWCTy RWCLit
            | RWCCase RWCTy RWCExp [RWCAlt]
            deriving Show

data RWCLit = RWCLitInteger Integer
            | RWCLitFloat Double
            | RWCLitChar Char
            deriving Show

data RWCAlt = RWCAlt (Bind RWCPat (RWCExp,RWCExp)) -- (guard,body)
              deriving Show

data RWCPat = RWCPatCon (Embed RWCTy) Identifier [RWCPat]
            | RWCPatLiteral (Embed RWCTy) RWCLit
            | RWCPatVar (Embed RWCTy) (Name RWCExp)
            deriving Show

data RWCConstraint = RWCConstraint Identifier [RWCTy] deriving Show

data RWCClassMethod = RWCClassMethod (Name RWCExp) (Embed (Bind [Name RWCTy]
                                                               ([RWCConstraint],
                                                                RWCTy,
                                                                Maybe RWCExp)))
                      deriving Show

data RWCDefn = RWCDefn (Name RWCExp) (Embed (Bind [Name RWCTy]
                                                 ([RWCConstraint],
                                                   RWCTy,
                                                   RWCExp)))
             | RWCClass Identifier (Embed (Bind [Name RWCTy]
                                               ([RWCConstraint],
                                                [RWCTy])))
                                   [RWCClassMethod]
               deriving Show

data RWCData = RWCData Identifier (Bind [Name RWCTy]
                                    [RWCDataCon])
               deriving Show

data RWCDataCon = RWCDataCon Identifier [RWCTy]
                  deriving Show

data RWCNewtype = RWCNewtype Identifier (Bind [Name RWCTy]
                                          RWCNewtypeCon)
                  deriving Show

data RWCNewtypeCon = RWCNewtypeCon Identifier RWCTy
                     deriving Show

data RWCProg = RWCProg { dataDecls    :: [RWCData],
                         newtypeDecls :: [RWCNewtype],
                         defns        :: TRec [RWCDefn] }
                       deriving Show

-- Boilerplate for Unbound.
instance Alpha RWCExp where
instance Alpha RWCAlt where
instance Alpha RWCPat where
instance Alpha RWCLit where
instance Alpha RWCTy where
instance Alpha RWCData where
instance Alpha RWCDataCon where
instance Alpha RWCNewtype where
instance Alpha RWCNewtypeCon where
instance Alpha RWCConstraint where
instance Alpha RWCClassMethod where
instance Alpha RWCDefn where
--instance Alpha RWCProg where      (can't have this anymore due to recbind)
  
instance Subst RWCExp RWCDefn where
  isvar _ = Nothing
  
instance Subst RWCExp RWCClassMethod where
  isvar _ = Nothing

instance Subst RWCExp RWCConstraint where
  isvar _ = Nothing

instance Subst RWCExp RWCExp where
  isvar (RWCVar _ n) = Just (SubstName n)
  isvar _            = Nothing

instance Subst RWCExp RWCAlt where
  isvar _ = Nothing

instance Subst RWCExp RWCPat where
  isvar _ = Nothing

instance Subst a RWCLit where
  isvar _ = Nothing

instance Subst RWCExp RWCTy where
  isvar _ = Nothing

instance Subst RWCTy RWCTy where
  isvar (RWCTyVar n) = Just (SubstName n)
  isvar _            = Nothing
  
instance Subst RWCTy RWCExp where
  isvar _ = Nothing

instance Subst RWCTy RWCAlt where
  isvar _ = Nothing

instance Subst RWCTy RWCPat where
  isvar _ = Nothing

$(derive [''RWCExp,''RWCAlt,''RWCPat,''RWCTy,''RWCLit,''RWCData,''RWCDataCon,''RWCNewtype,''RWCNewtypeCon,''RWCConstraint,''RWCClassMethod,''RWCDefn{-,''RWCProg-}])
