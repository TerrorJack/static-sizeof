module Data.SizeOf.Internals where

import Convert
import Data.Functor
import Data.Traversable
import DynFlags
import GHC hiding (Name, Type)
import GHC.Paths
import Language.Haskell.TH
import OccName
import RdrName
import Unsafe.Coerce

storableSizeOfExpr :: Type -> LHsExpr RdrName
storableSizeOfExpr ty =
  noLoc $
  HsApp
    (noLoc $
     HsVar $
     noLoc $ mkRdrQual (mkModuleName "Foreign.Storable") (mkVarOcc "sizeOf"))
    (noLoc $
     ExprWithTySig
       (noLoc $
        HsVar $
        noLoc $ mkRdrQual (mkModuleName "Prelude") (mkVarOcc "undefined"))
       HsWC
         { hswc_wcs = PlaceHolder
         , hswc_body =
             HsIB
               { hsib_vars = PlaceHolder
               , hsib_body = hs_ty
               , hsib_closed = PlaceHolder
               }
         })
  where
    Right hs_ty = convertToHsType noSrcSpan ty

intFromGHCi :: HValue -> Int
intFromGHCi = unsafeCoerce

evalStorableSize :: Type -> Ghc Int
evalStorableSize = fmap intFromGHCi . compileParsedExpr . storableSizeOfExpr

evalStorableSizes :: [Type] -> IO [Int]
evalStorableSizes tys =
  defaultErrorHandler defaultFatalMessager defaultFlushOut $
  runGhc (Just libdir) $ do
    dflags <- getSessionDynFlags
    void $ setSessionDynFlags dflags
    setContext $
      map
        (IIDecl . simpleImportDecl)
        [mkModuleName m | m <- ["Prelude", "Foreign.Storable"]]
    for tys evalStorableSize

storableSizeOfDecs' :: [Type] -> DecsQ
storableSizeOfDecs' tys = do
  sz <- runIO $ evalStorableSizes tys
  pure
    [ TySynInstD (mkName "SizeOf") $
    TySynEqn [t] $ LitT $ NumTyLit $ fromIntegral s
    | (t, s) <- zip tys sz
    ]

storableSizeOfDecs :: [Name] -> DecsQ
storableSizeOfDecs = storableSizeOfDecs' . map ConT
