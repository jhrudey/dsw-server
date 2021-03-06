module Api.Resource.User.UserDTO where

import Control.Monad
import Data.Aeson
import Data.Time
import Data.UUID

import Model.User.User

data UserDTO = UserDTO
  { _userDTOUuid :: UUID
  , _userDTOName :: String
  , _userDTOSurname :: String
  , _userDTOEmail :: Email
  , _userDTORole :: Role
  , _userDTOPermissions :: [Permission]
  , _userDTOActive :: Bool
  , _userDTOCreatedAt :: Maybe UTCTime
  , _userDTOUpdatedAt :: Maybe UTCTime
  } deriving (Show, Eq)

instance FromJSON UserDTO where
  parseJSON (Object o) = do
    _userDTOUuid <- o .: "uuid"
    _userDTOName <- o .: "name"
    _userDTOSurname <- o .: "surname"
    _userDTOEmail <- o .: "email"
    _userDTORole <- o .: "role"
    _userDTOPermissions <- o .: "permissions"
    _userDTOActive <- o .: "active"
    _userDTOCreatedAt <- o .: "createdAt"
    _userDTOUpdatedAt <- o .: "updatedAt"
    return UserDTO {..}
  parseJSON _ = mzero

instance ToJSON UserDTO where
  toJSON UserDTO {..} =
    object
      [ "uuid" .= _userDTOUuid
      , "name" .= _userDTOName
      , "surname" .= _userDTOSurname
      , "email" .= _userDTOEmail
      , "role" .= _userDTORole
      , "permissions" .= _userDTOPermissions
      , "active" .= _userDTOActive
      , "createdAt" .= _userDTOCreatedAt
      , "updatedAt" .= _userDTOUpdatedAt
      ]
