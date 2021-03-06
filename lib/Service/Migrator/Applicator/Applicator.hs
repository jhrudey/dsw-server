module Service.Migrator.Applicator.Applicator
  ( runApplicator
  ) where

import Localization
import Model.Error.Error
import Model.Event.Event
import Model.Event.EventAccessors
import Model.KnowledgeModel.KnowledgeModel
import Service.Migrator.Applicator.ApplyEvent
import Service.Migrator.Applicator.ApplyEventInstances ()

runApplicator :: Maybe KnowledgeModel -> [Event] -> Either AppError KnowledgeModel
runApplicator mKM events =
  case foldl foldEvent (Right mKM) events of
    Left error -> Left error
    Right Nothing -> Left . MigratorError $ _ERROR_MT_APPLICATOR__UNSPECIFIED_ERROR
    Right (Just km) -> Right km
  where
    foldEvent :: Either AppError (Maybe KnowledgeModel) -> Event -> Either AppError (Maybe KnowledgeModel)
    foldEvent emKM (AddKnowledgeModelEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (EditKnowledgeModelEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (AddChapterEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (EditChapterEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (DeleteChapterEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (AddQuestionEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (EditQuestionEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (DeleteQuestionEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (AddAnswerEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (EditAnswerEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (DeleteAnswerEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (AddExpertEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (EditExpertEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (DeleteExpertEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (AddReferenceEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (EditReferenceEvent' e) = applyEventToKM e (getPath e) emKM
    foldEvent emKM (DeleteReferenceEvent' e) = applyEventToKM e (getPath e) emKM
