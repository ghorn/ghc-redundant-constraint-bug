{-# OPTIONS_GHC -Wall -Werror -fwarn-redundant-constraints #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleContexts #-}

module Bug
       ( bug
       , workaround
       ) where

import GHC.Generics ( D1, Datatype, Meta, Rep, datatypeName )

import Data.Proxy ( Proxy )

-- /home/greghorn/hslibs/ghc82_bug_maybe/Bug.hs:17:1: warning: [-Wredundant-constraints]
--     • Redundant constraint: Rep a ~ D1 d p
--     • In the type signature for:
--            bug :: forall a (d :: Meta) (p :: * -> *).
--                   (Datatype d, Rep a ~ D1 d p) =>
--                   Proxy a -> String
--    |
-- 25 | bug :: forall a d p . (Datatype d, Rep a ~ D1 d p) => Proxy a -> String
--    | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
bug :: forall a d p . (Datatype d, Rep a ~ D1 d p) => Proxy a -> String
bug = const name
  where
    name = datatypeName (undefined :: D1 d p b)


type family GetD a :: Meta where
  GetD (D1 d p) = d

workaround :: forall a d p . (Datatype (GetD (Rep a)), Rep a ~ D1 d p) => Proxy a -> String
workaround = const name
  where
    name = datatypeName (undefined :: D1 d p b)
