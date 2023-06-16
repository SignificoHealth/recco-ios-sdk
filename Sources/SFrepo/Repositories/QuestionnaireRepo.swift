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
    func getQuestionnaire(topic: SFTopic) async throws -> [Question]
    func sendQuestionnaire(_ answers: [CreateQuestionnaireAnswer]) async throws
}

public final class LiveQuestionnaireRepository: QuestionnaireRepository {
    public func getQuestionnaire(topic: SFEntities.SFTopic) async throws -> [SFEntities.Question] {
        let dto = try await QuestionnaireAPI.getQuestionnaireByTopic(
            topic: .init(entity: topic)
        )
        
        return try dto.map(Question.init)
    }
    
    public func sendQuestionnaire(_ answers: [CreateQuestionnaireAnswer]) async throws {
        try await QuestionnaireAPI.answers(
            createQuestionnaireAnswerDTO: answers.map(CreateQuestionnaireAnswerDTO.init)
        )
    }
}
