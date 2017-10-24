module Service.User.UserService where

import Control.Lens ((^.))
import Control.Monad.Reader
import Crypto.PasswordStore
import Data.ByteString.Char8 as BS
import Data.UUID as U

import Api.Resources.User.UserCreateDTO
import Api.Resources.User.UserDTO
import Common.Types
import Common.Uuid
import Context
import Database.DAO.UserDAO
import Database.Entity.User
import Service.User.UserMapper

getPermissionForRole :: Role -> [Permission]
getPermissionForRole _ = ["ADD_CHAPTER", "EDIT_CHAPTER", "DELETE_CHAPTER"]

getUsers :: Context -> IO [UserDTO]
getUsers context = do
  users <- findUsers context
  return . fmap toDTO $ users

createUser :: Context -> UserCreateDTO -> IO UserDTO
createUser context userCreateDto = do
  uuid <- generateUuid
  createUserWithGivenUuid context uuid userCreateDto

createUserWithGivenUuid :: Context -> U.UUID -> UserCreateDTO -> IO UserDTO
createUserWithGivenUuid context userUuid userCreateDto = do
  let roles = getPermissionForRole (userCreateDto ^. ucdtoRole)
  passwordHash <- makePassword (BS.pack (userCreateDto ^. ucdtoPassword)) 17
  let user = fromUserCreateDTO userCreateDto userUuid (BS.unpack passwordHash) roles
  insertUser context user
  return $ toDTO user

getUserById :: Context -> String -> IO (Maybe UserDTO)
getUserById context userUuid = do
  maybeUser <- findUserById context userUuid
  case maybeUser of
    Just user -> return . Just $ toDTO user
    Nothing -> return Nothing

modifyUser :: Context -> String -> UserDTO -> IO (Maybe UserDTO)
modifyUser context userUuid userDto = do
  maybeUser <- findUserById context userUuid
  case maybeUser of
    Just user -> do
      let user = fromUserDTO userDto (user ^. uUuid) (user ^. uPasswordHash)
      updateUserById context user
      return . Just $ userDto
    Nothing -> return Nothing

deleteUser :: Context -> String -> IO Bool
deleteUser context userUuid = do
  maybeUser <- findUserById context userUuid
  case maybeUser of
    Just user -> do
      deleteUserById context userUuid
      return True
    Nothing -> return False
