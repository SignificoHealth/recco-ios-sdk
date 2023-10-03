import Combine
@testable import ReccoHeadless
import XCTest

final class MockQuestionnaireRepository: QuestionnaireRepository {
    enum ExpectationType {
        case getOnboardingQuestionnaire
        case getQuestionnaire
        case sendQuestionnaire
        case sendOnboardingQuestionnaire
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]

    var getOnboardingQuestionnaireError: NSError?
    var getQuestionnaireError: NSError?
    var sendQuestionnaireError: NSError?
    var sendOnboardingQuestionnaireError: NSError?

    func getOnboardingQuestionnaire() async throws -> [Question] {
        expectations[.getOnboardingQuestionnaire]?.fulfill()
        if let getOnboardingQuestionnaireError = getOnboardingQuestionnaireError {
            throw getOnboardingQuestionnaireError
        }
        return Mocks.numericQuestions
    }

    func getQuestionnaire(topic: ReccoHeadless.ReccoTopic) async throws -> [Question] {
        expectations[.getQuestionnaire]?.fulfill()

        if let getQuestionnaireError = getQuestionnaireError {
            throw getQuestionnaireError
        }
        return Mocks.numericQuestions
    }

    func sendQuestionnaire(_ answers: [CreateQuestionnaireAnswer]) async throws {
        expectations[.sendQuestionnaire]?.fulfill()

        if let sendQuestionnaireError = sendQuestionnaireError {
            throw sendQuestionnaireError
        }
    }

    func sendOnboardingQuestionnaire(_ answers: [CreateQuestionnaireAnswer]) async throws {
        expectations[.sendOnboardingQuestionnaire]?.fulfill()

        if let sendOnboardingQuestionnaireError = sendOnboardingQuestionnaireError {
            throw sendOnboardingQuestionnaireError
        }
    }
}
