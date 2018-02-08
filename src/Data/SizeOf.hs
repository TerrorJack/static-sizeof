{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Data.SizeOf
  ( SizeOf
  ) where

import Data.SizeOf.Internals
import Foreign
import Foreign.C
import GHC.Fingerprint.Type
import GHC.TypeLits
import Language.Haskell.TH
import System.Posix.Types

type family SizeOf t :: Nat

$(storableSizeOfDecs
    [ ''Bool
    , ''Char
    , ''Double
    , ''Float
    , ''Int
    , ''Int8
    , ''Int16
    , ''Int32
    , ''Int64
    , ''Word
    , ''Word8
    , ''Word16
    , ''Word32
    , ''Word64
    , ''()
    , ''Fingerprint
    , ''IntPtr
    , ''WordPtr
    , ''CUIntMax
    , ''CIntMax
    , ''CUIntPtr
    , ''CIntPtr
    , ''CSUSeconds
    , ''CUSeconds
    , ''CTime
    , ''CClock
    , ''CSigAtomic
    , ''CWchar
    , ''CSize
    , ''CPtrdiff
    , ''CDouble
    , ''CFloat
    , ''CBool
    , ''CULLong
    , ''CLLong
    , ''CULong
    , ''CLong
    , ''CUInt
    , ''CInt
    , ''CUShort
    , ''CShort
    , ''CUChar
    , ''CSChar
    , ''CChar
    , ''Fd
    , ''CClockId
    , ''CSsize
    , ''CPid
    , ''COff
    , ''CMode
    , ''CIno
    , ''CDev
    ])

$(storableSizeOfDecs'
    [AppT (ConT tc) (VarT $ mkName "a") | tc <- [''StablePtr, ''Ptr, ''FunPtr]])
