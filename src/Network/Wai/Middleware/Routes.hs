{- |
Module      :  Network.Wai.Middleware.Routes
Copyright   :  (c) Anupam Jain 2013
License     :  MIT (see the file LICENSE)

Maintainer  :  ajnsit@gmail.com
Stability   :  experimental
Portability :  non-portable (uses ghc extensions)

This package provides typesafe URLs for Wai applications.
-}
module Network.Wai.Middleware.Routes
    ( -- * Declaring Routes using Template Haskell
      parseRoutes
    , parseRoutesFile        -- | Parse routes declared in a file
    , parseRoutesNoCheck
    , parseRoutesFileNoCheck -- | Same as parseRoutesFile, but performs no overlap checking.

    , mkRoute
    , mkRouteSub

    -- * Dispatch
    , routeDispatch

    -- * URL rendering and parsing
    , showRouteMaster
    , showRouteQueryMaster
    , readRouteMaster
    , showRouteSub
    , showRouteQuerySub
    , readRouteSub

    -- * Application Handlers
    , Handler
    , HandlerS

    -- * Generated Datatypes
    , Routable(..)           -- | Used internally. However needs to be exported for TH to work.
    , RenderRoute(..)        -- | A `RenderRoute` instance for your site datatype is automatically generated by `mkRoute`
    , ParseRoute(..)         -- | A `ParseRoute` instance for your site datatype is automatically generated by `mkRoute`
    , RouteAttrs(..)         -- | A `RouteAttrs` instance for your site datatype is automatically generated by `mkRoute`

    -- * Accessing Raw Request Data
    , RequestData            -- | An abstract representation of the request data. You can get the wai request object by using `waiReq`
    , waiReq                 -- | Extract the wai `Request` object from `RequestData`
    , nextApp                -- | Extract the next Application in the stack
    , runNext                -- | Run the next application in the stack

    -- * Route Monad makes it easy to compose routes together
    , RouteM
    , DefaultMaster(..)
    , Route(DefaultRoute)
    , handler                -- | Add a wai-routes handler
    , catchall               -- | Catch all routes with the supplied application
    , defaultAction          -- | A synonym for `catchall`, kept for backwards compatibility
    , middleware             -- | Add another middleware to the app
    , route                  -- | Add another routed middleware to the app
    , waiApp                 -- | Convert a RouteM to a wai Application
    , toWaiApp               -- | Similar to waiApp, but result is wrapped in a monad. Kept for backwards compatibility

    -- * HandlerM Monad makes it easy to build a handler
    , HandlerM()
    , runHandlerM            -- | Run a HandlerM to get a Handler
    , mountedAppHandler      -- | Convert a full wai application to a HandlerS
    , request                -- | Access the request data
    , isWebsocket            -- | Is this a websocket request
    , reqHeader              -- | Get a particular request header (case insensitive)
    , reqHeaders             -- | Get all request headers (case insensitive)
    , maybeRootRoute         -- | Access the current route for root route
    , maybeRoute             -- | Access the current route
    , routeAttrSet           -- | Access the current route attributes as a set
    , rootRouteAttrSet       -- | Access the current root route attributes as a set
    , master                 -- | Access the master datatype
    , sub                    -- | Access the sub datatype
    , rawBody                -- | Consume and return the request body as ByteString
    , textBody               -- | Consume and return the request body as Text
    , jsonBody               -- | Consume and return the request body as JSON
    , header                 -- | Add a header to the response
    , status                 -- | Set the response status
    , file                   -- | Send a file as response
    , filepart               -- | Send a part of a file as response
    , stream                 -- | Stream a response
    , raw                    -- | Set the raw response body
    , rawBuilder             -- | Set the raw response body as a ByteString Builder
    , json                   -- | Set the json response body
    , plain                  -- | Set the plain text response body
    , html                   -- | Set the html response body
    , css                    -- | Set the css response body
    , javascript             -- | Set the javascript response body
    , asContent              -- | Set the contentType and a 'Text' body
    , next                   -- | Run the next application in the stack
    , getParams              -- | Get all params (query or post, not file)
    , getParam               -- | Get a particular param (query or post, not file)
    , getQueryParams         -- | Get all query params
    , getQueryParam          -- | Get a particular query param
    , getPostParams          -- | Get all post params
    , getPostParam           -- | Get a particular post param
    , getFileParams          -- | Get all file params
    , getFileParam           -- | Get a particular file param
    , setCookie              -- | Add a cookie to the response
    , getCookie              -- | Get a cookie from the request
    , getCookies             -- | Get all cookies from the request
    , reqVault               -- | Access the vault from the request
    , lookupVault            -- | Lookup a key in the request vault
    , updateVault            -- | Update the request vault

    , module Network.HTTP.Types.Status
    , module Network.Wai.Middleware.RequestLogger
    , module Network.Wai.Application.Static
  )
  where

import Network.Wai.Middleware.Routes.Routes
import Network.Wai.Middleware.Routes.Monad
import Network.Wai.Middleware.Routes.Handler
import Network.HTTP.Types.Status
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Application.Static
