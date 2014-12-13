{-
  Author    : Tim Dysinger
  Copyright : 2014
  License   : MIT
-}

module System.Log.Winston.Types where

import Control.Monad.Eff

foreign import data Log :: !

foreign import data Logger :: *

data Level = DEBUG
           | INFO
           | WARN
           | ERROR

instance showLevel :: Show Level where
  show DEBUG = "debug"
  show INFO  = "info"
  show WARN  = "warn"
  show ERROR = "error"
