module Model.Event.EventAccessors where

import Control.Lens ((^.))
import qualified Data.UUID as U

import LensesConfig
import Model.Event.Answer.AnswerEvent
import Model.Event.Chapter.ChapterEvent
import Model.Event.Event
import Model.Event.EventPath
import Model.Event.Expert.ExpertEvent
import Model.Event.KnowledgeModel.KnowledgeModelEvent
import Model.Event.Question.QuestionEvent
import Model.Event.Reference.ReferenceEvent

isAddAction :: Event -> Bool
isAddAction (AddKnowledgeModelEvent' _) = True
isAddAction (AddChapterEvent' _) = True
isAddAction (AddQuestionEvent' _) = True
isAddAction (AddAnswerEvent' _) = True
isAddAction (AddExpertEvent' _) = True
isAddAction (AddReferenceEvent' _) = True
isAddAction _ = False

isEditAction :: Event -> Bool
isEditAction (EditKnowledgeModelEvent' _) = True
isEditAction (EditChapterEvent' _) = True
isEditAction (EditQuestionEvent' _) = True
isEditAction (EditAnswerEvent' _) = True
isEditAction (EditExpertEvent' _) = True
isEditAction (EditReferenceEvent' _) = True
isEditAction _ = False

isDeleteAction :: Event -> Bool
isDeleteAction (DeleteChapterEvent' _) = True
isDeleteAction (DeleteQuestionEvent' _) = True
isDeleteAction (DeleteAnswerEvent' _) = True
isDeleteAction (DeleteExpertEvent' _) = True
isDeleteAction (DeleteReferenceEvent' _) = True
isDeleteAction _ = False

getEventUuid' :: Event -> U.UUID
getEventUuid' (AddKnowledgeModelEvent' event) = getEventUuid event
getEventUuid' (EditKnowledgeModelEvent' event) = getEventUuid event
getEventUuid' (AddChapterEvent' event) = getEventUuid event
getEventUuid' (EditChapterEvent' event) = getEventUuid event
getEventUuid' (DeleteChapterEvent' event) = getEventUuid event
getEventUuid' (AddQuestionEvent' event) = getEventUuid event
getEventUuid' (EditQuestionEvent' event) = getEventUuid event
getEventUuid' (DeleteQuestionEvent' event) = getEventUuid event
getEventUuid' (AddAnswerEvent' event) = getEventUuid event
getEventUuid' (EditAnswerEvent' event) = getEventUuid event
getEventUuid' (DeleteAnswerEvent' event) = getEventUuid event
getEventUuid' (AddExpertEvent' event) = getEventUuid event
getEventUuid' (EditExpertEvent' event) = getEventUuid event
getEventUuid' (DeleteExpertEvent' event) = getEventUuid event
getEventUuid' (AddReferenceEvent' event) = getEventUuid event
getEventUuid' (EditReferenceEvent' event) = getEventUuid event
getEventUuid' (DeleteReferenceEvent' event) = getEventUuid event

class EventAccesors a where
  getEventUuid :: a -> U.UUID
  getEventNodeUuid :: a -> U.UUID
  getPath :: a -> EventPath

instance EventAccesors AddKnowledgeModelEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. kmUuid
  getPath event = event ^. path

instance EventAccesors EditKnowledgeModelEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. kmUuid
  getPath event = event ^. path

instance EventAccesors AddChapterEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. chapterUuid
  getPath event = event ^. path

instance EventAccesors EditChapterEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. chapterUuid
  getPath event = event ^. path

instance EventAccesors DeleteChapterEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. chapterUuid
  getPath event = event ^. path

instance EventAccesors AddQuestionEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. questionUuid
  getPath event = event ^. path

instance EventAccesors EditQuestionEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. questionUuid
  getPath event = event ^. path

instance EventAccesors DeleteQuestionEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. questionUuid
  getPath event = event ^. path

instance EventAccesors AddAnswerEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. answerUuid
  getPath event = event ^. path

instance EventAccesors EditAnswerEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. answerUuid
  getPath event = event ^. path

instance EventAccesors DeleteAnswerEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. answerUuid
  getPath event = event ^. path

instance EventAccesors AddExpertEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. expertUuid
  getPath event = event ^. path

instance EventAccesors EditExpertEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. expertUuid
  getPath event = event ^. path

instance EventAccesors DeleteExpertEvent where
  getEventUuid event = event ^. uuid
  getEventNodeUuid event = event ^. expertUuid
  getPath event = event ^. path

instance EventAccesors AddReferenceEvent where
  getEventUuid (AddResourcePageReferenceEvent' event) = event ^. uuid
  getEventUuid (AddURLReferenceEvent' event) = event ^. uuid
  getEventUuid (AddCrossReferenceEvent' event) = event ^. uuid
  getEventNodeUuid (AddResourcePageReferenceEvent' event) = event ^. referenceUuid
  getEventNodeUuid (AddURLReferenceEvent' event) = event ^. referenceUuid
  getEventNodeUuid (AddCrossReferenceEvent' event) = event ^. referenceUuid
  getPath (AddResourcePageReferenceEvent' e) = e ^. path
  getPath (AddURLReferenceEvent' e) = e ^. path
  getPath (AddCrossReferenceEvent' e) = e ^. path

instance EventAccesors EditReferenceEvent where
  getEventUuid (EditResourcePageReferenceEvent' event) = event ^. uuid
  getEventUuid (EditURLReferenceEvent' event) = event ^. uuid
  getEventUuid (EditCrossReferenceEvent' event) = event ^. uuid
  getEventNodeUuid (EditResourcePageReferenceEvent' event) = event ^. referenceUuid
  getEventNodeUuid (EditURLReferenceEvent' event) = event ^. referenceUuid
  getEventNodeUuid (EditCrossReferenceEvent' event) = event ^. referenceUuid
  getPath (EditResourcePageReferenceEvent' e) = e ^. path
  getPath (EditURLReferenceEvent' e) = e ^. path
  getPath (EditCrossReferenceEvent' e) = e ^. path

instance EventAccesors DeleteReferenceEvent where
  getEventUuid (DeleteResourcePageReferenceEvent' event) = event ^. uuid
  getEventUuid (DeleteURLReferenceEvent' event) = event ^. uuid
  getEventUuid (DeleteCrossReferenceEvent' event) = event ^. uuid
  getEventNodeUuid (DeleteResourcePageReferenceEvent' event) = event ^. referenceUuid
  getEventNodeUuid (DeleteURLReferenceEvent' event) = event ^. referenceUuid
  getEventNodeUuid (DeleteCrossReferenceEvent' event) = event ^. referenceUuid
  getPath (DeleteResourcePageReferenceEvent' e) = e ^. path
  getPath (DeleteURLReferenceEvent' e) = e ^. path
  getPath (DeleteCrossReferenceEvent' e) = e ^. path
