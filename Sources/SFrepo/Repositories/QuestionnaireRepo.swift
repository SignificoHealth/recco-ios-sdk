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
}

public final class LiveQuestionnaireRepository: QuestionnaireRepository {
    public func getQuestionnaire(topic: SFEntities.SFTopic) async throws -> [SFEntities.Question] {
        let dto = try await QuestionnaireAPI.getQuestionnaireByTopic(
            topic: .init(entity: topic)
        )
        
        return try dto.map(Question.init)
    }
}
