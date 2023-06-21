//
//  File.swift
//  
//
//  Created by Adrián R on 15/6/23.
//

import Foundation
import SFEntities
import SFApi

public protocol QuestionnaireRepository {
    func getOnboardingQuestionnaire() async throws -> [Question]
    func getQuestionnaire(topic: SFTopic) async throws -> [Question]
    func sendQuestionnaire(_ answers: [CreateQuestionnaireAnswer]) async throws
    func sendOnboardingQuestionnaire(_ answers: [CreateQuestionnaireAnswer]) async throws
}

public final class LiveQuestionnaireRepository: QuestionnaireRepository {
    public func getQuestionnaire(topic: SFEntities.SFTopic) async throws -> [SFEntities.Question] {
        try await QuestionnaireAPI.getQuestionnaireByTopic(
            topic: .init(entity: topic)
        ).map(Question.init)
    }
    
    public func sendQuestionnaire(_ answers: [CreateQuestionnaireAnswer]) async throws {
        try await QuestionnaireAPI.answers(
            createQuestionnaireAnswerDTO: answers.map(CreateQuestionnaireAnswerDTO.init)
        )
    }
    
    public func getOnboardingQuestionnaire() async throws -> [Question] {
        return try await QuestionnaireAPI
            .onboarding()
            .map(Question.init)
    }
    public func sendOnboardingQuestionnaire(_ answers: [CreateQuestionnaireAnswer]) async throws {
        try await QuestionnaireAPI.onboardingAnswers(createQuestionnaireAnswerDTO: answers.map(CreateQuestionnaireAnswerDTO.init))
    }
}
