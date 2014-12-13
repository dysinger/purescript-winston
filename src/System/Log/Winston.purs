{-
  Author    : Tim Dysinger
  Copyright : 2014
  License   : MIT
-}

module System.Log.Winston where

import Control.Monad.Eff

import System.Log.Winston.Types

foreign import logger
  "function logger() {\
  \  return new (require('winston').Logger)({ transports: [] });\
  \}"
  :: forall e. Eff (log :: Log | e) Logger

foreign import addConsoleTransport
  "function addConsoleTransport(l) {\
  \  return function() {\
  \    return l.add(require('winston').transports.Console);\
  \  }\
  \}"
  :: forall e. Logger -> Eff (log :: Log | e) Logger

foreign import addFileTransport
  "function addFileTransport(f) {\
  \  return function(l) {\
  \    return function() {\
  \      return l.add(require('winston').transports.File, { filename: f });\
  \    };\
  \  }\
  \}"
  :: forall e. String -> Logger -> Eff (log :: Log | e) Logger

foreign import join
  "function join(f1) {\
  \  return function(f2) {\
  \    return require('path').join(f1, f2);\
  \  }\
  \}"
  :: String -> String -> String

mkFileLogger :: forall e. String -> String -> Eff (log :: Log | e) Logger
mkFileLogger dir fname = logger >>= addFileTransport (join dir fname)

foreign import logFFI
  "function logFFI(logger) {\
  \  return function(level) {\
  \    return function(obj) {\
  \      return function() {\
  \        logger.log(level, obj);\
  \      }\
  \    }\
  \  }\
  \}"
  :: forall a e. Logger -> String -> a -> Eff (log :: Log | e) Unit

log :: forall a e. Logger -> Level -> a -> Eff (log :: Log | e) Unit
log logger level a = logFFI logger (show level) a
