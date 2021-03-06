module Service.Event.EventService where

import Control.Lens ((^.))

import Api.Resource.Event.EventDTO
import Database.DAO.Event.EventDAO
import LensesConfig
import Model.Context.AppContext
import Model.Error.Error
import Service.Branch.BranchService
import Service.Event.EventMapper
import Service.KnowledgeModel.KnowledgeModelService

getEvents :: String -> AppContextM (Either AppError [EventDTO])
getEvents branchUuid = do
  eitherBranchWithEvents <- findBranchWithEventsById branchUuid
  case eitherBranchWithEvents of
    Right branchWithEvents -> return . Right . toDTOs $ branchWithEvents ^. events
    Left error -> return . Left $ error

createEvents :: String -> [EventDTO] -> AppContextM (Either AppError [EventDTO])
createEvents branchUuid eventsCreateDto = do
  eitherBranch <- getBranchById branchUuid
  case eitherBranch of
    Right _ -> do
      let events = fromDTOs eventsCreateDto
      insertEventsToBranch branchUuid events
      result <- recompileKnowledgeModel branchUuid
      case result of
        Right km -> return . Right . toDTOs $ events
        Left error -> return . Left $ error
    Left error -> return . Left $ error

deleteEvents :: String -> AppContextM (Maybe AppError)
deleteEvents branchUuid = do
  eitherBranch <- getBranchById branchUuid
  case eitherBranch of
    Right _ -> do
      deleteEventsAtBranch branchUuid
      result <- recompileKnowledgeModel branchUuid
      case result of
        Right km -> return Nothing
        Left error -> return . Just $ error
    Left error -> return . Just $ error
