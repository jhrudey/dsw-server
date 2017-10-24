module Api.Handler.Token.TokenHandler where

import Control.Lens ((^.))
import Control.Monad.Reader
import Data.Aeson
import Data.Monoid ((<>))
import Data.Text.Lazy
import Data.UUID
import Network.HTTP.Types.Status (created201, noContent204)
import qualified Web.Scotty as Scotty

import Api.Handler.Common
import Api.Resources.Token.TokenCreateDTO
import Api.Resources.Token.TokenDTO
import Context
import Service.Token.TokenService

postTokenA :: Context -> Scotty.ActionM ()
postTokenA context = do
  tokenCreateDto <- Scotty.jsonData
  maybeTokenDto <- liftIO $ getToken context tokenCreateDto
  case maybeTokenDto of
    Just tokenDto -> Scotty.json tokenDto
    Nothing -> unauthorizedA
