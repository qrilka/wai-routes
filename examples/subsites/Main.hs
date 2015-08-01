{-# LANGUAGE OverloadedStrings, TemplateHaskell, QuasiQuotes, TypeFamilies, ViewPatterns, MultiParamTypeClasses, FlexibleInstances #-}
module Main where
{-
  Simple demonstration of subsites
-}

import Network.Wai.Middleware.Routes
import Network.Wai.Application.Static
import Network.Wai.Handler.Warp
import qualified Data.Text.Lazy as T
import Network.Wai.Middleware.RequestLogger

-- Import HelloSub subsite
import HelloSub (HelloSub(..), HelloMaster, hello)
import qualified HelloSub as Sub

-- The Master Site argument
data MyRoute = MyRoute

-- The contract with HelloSub subsite
instance HelloMaster MyRoute where
  hello _ = "John Doe"

-- How to get subsite datatype from the master datatype
getHelloSub :: MyRoute -> HelloSub
getHelloSub = const HelloSub

-- Generate routing code
mkRoute "MyRoute" [parseRoutes|
/      HomeR  GET
/hello HelloR HelloSub getHelloSub
|]

-- Handlers

-- Homepage
getHomeR :: Handler MyRoute
getHomeR = runHandlerM $ do
  Just r <- maybeRoute
  html $ T.concat
    [ "<h1>Home</h1>"
    , "<p>You are on route - "
    ,   T.fromStrict $ showRoute r
    , "</p>"
    , "<p>"
    ,   "<a href=\""
    ,   T.fromStrict $ showRoute $ HelloR Sub.HomeR
    ,   "\">Go to subsite hello</a>"
    ,   " to be greeted!"
    , "</p>"
    ]

-- The application that uses our route
-- NOTE: We use the Route Monad to simplify routing
application :: RouteM ()
application = do
  middleware logStdoutDev
  route MyRoute
  defaultAction $ staticApp $ defaultFileServerSettings "static"

-- Run the application
main :: IO ()
main = do
  putStrLn "Starting server on port 8080"
  toWaiApp application >>= run 8080

