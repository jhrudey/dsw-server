module Service.DataManagementPlan.DataManagementPlanService where

import Control.Lens ((^.))
import Control.Monad.Reader (liftIO)
import Data.Aeson (encode)
import qualified Data.ByteString.Lazy as BS
import Data.Time

import Api.Resource.DataManagementPlan.DataManagementPlanDTO
import Database.DAO.Metric.MetricDAO
import Database.DAO.Questionnaire.QuestionnaireDAO
import LensesConfig
import Model.Context.AppContext
import Model.DataManagementPlan.DataManagementPlan
import Model.Error.Error
import Model.FilledKnowledgeModel.FilledKnowledgeModel
import Model.Questionnaire.Questionnaire
import Service.DataManagementPlan.Convertor
import Service.DataManagementPlan.DataManagementPlanMapper
import Service.DataManagementPlan.ReplyApplicator
import Service.DataManagementPlan.Templates.FormatMapper
import Service.Report.ReportGenerator
import Util.Uuid

createFilledKM :: Questionnaire -> FilledKnowledgeModel
createFilledKM questionnaire =
  let plainFilledKM = toFilledKM (questionnaire ^. knowledgeModel)
  in runReplyApplicator plainFilledKM (questionnaire ^. replies)

createDataManagementPlan :: String -> AppContextM (Either AppError DataManagementPlanDTO)
createDataManagementPlan qtnUuid =
  heFindQuestionnaireById qtnUuid $ \qtn ->
    heFindMetrics $ \dmpMetrics -> do
      dmpUuid <- liftIO generateUuid
      let filledKM = createFilledKM $ qtn
      now <- liftIO getCurrentTime
      dmpReport <- liftIO $ generateReport (qtn ^. level) dmpMetrics filledKM
      let dmp =
            DataManagementPlan
            { _dataManagementPlanUuid = dmpUuid
            , _dataManagementPlanQuestionnaireUuid = qtnUuid
            , _dataManagementPlanLevel = qtn ^. level
            , _dataManagementPlanFilledKnowledgeModel = filledKM
            , _dataManagementPlanMetrics = dmpMetrics
            , _dataManagementPlanReport = dmpReport
            , _dataManagementPlanCreatedAt = now
            , _dataManagementPlanUpdatedAt = now
            }
      return . Right . toDTO $ dmp

exportDataManagementPlan :: String -> DataManagementPlanFormat -> AppContextM (Either AppError BS.ByteString)
exportDataManagementPlan qtnUuid format = do
  heCreateDataManagementPlan qtnUuid $ \dmp ->
    case format of
      JSON -> return . Right . encode $ dmp
      HTML -> return . Right . toHTML $ dmp
      other -> do
        result <- liftIO $ toFormat other dmp
        return result

-- --------------------------------
-- HELPERS
-- --------------------------------
heCreateDataManagementPlan qtnUuid callback = do
  eDmp <- createDataManagementPlan qtnUuid
  case eDmp of
    Right dmp -> callback dmp
    Left error -> return . Left $ error
