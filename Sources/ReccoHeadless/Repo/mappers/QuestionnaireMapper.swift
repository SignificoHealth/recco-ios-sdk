//
//  File.swift
//  
//
//  Created by Adrián R on 15/6/23.
//

import Foundation



extension QuestionType {
    init(dto: QuestionAnswerTypeDTO) {
        switch dto {
        case .multichoice:
            self = .multichoice
        case .numeric:
            self = .numeric
        }
    }
}

extension MultiChoiceAnswerOption {
    init(dto: MultiChoiceAnswerOptionDTO) {
        self.init(id: dto.id, text: dto.text)
    }
}

extension MultiChoiceQuestion {
    init(dto: MultiChoiceQuestionDTO) {
        self.init(
            maxOptions: dto.maxOptions,
            minOptions: dto.minOptions,
            options: dto.options.map(MultiChoiceAnswerOption.init)
        )
    }
}

extension NumericQuestionFormat {
    init(dto: NumericQuestionDTO.FormatDTO) {
        switch dto {
        case .humanHeight:
            self = .humanHeight
        case .humanWeight:
            self = .humanWeight
        case .integer:
            self = .integer
        case .decimal:
            self = .decimal
        }
    }
}

extension NumericQuestion {
    init(dto: NumericQuestionDTO) {
        self.init(
            maxValue: dto.maxValue,
            minValue: dto.minValue,
            format: .init(dto: dto.format)
        )
    }
}

extension Question {
    init(dto: QuestionDTO) throws {
        try self.init(
            id: dto.id,
            questionnaireId: dto.questionnaireId,
            index: dto.index,
            text: dto.text,
            type: .init(dto: dto.type),
            multiChoice: dto.multiChoice.map(MultiChoiceQuestion.init),
            numeric: dto.numeric.map(NumericQuestion.init),
            numericAnswer: dto.numericSelected,
            multichoiceAnswer: dto.multiChoiceSelectedIds
        )
    }
}

extension QuestionAnswerTypeDTO {
    init(entity: QuestionType) {
        switch entity {
        case .multichoice:
            self = .multichoice
        case .numeric:
            self = .numeric
        }
    }
}

extension CreateQuestionnaireAnswerDTO {
    init(entity: CreateQuestionnaireAnswer) {
        self.init(
            multichoice: entity.value.multichoice,
            numeric: entity.value.numeric,
            questionnaireId: entity.questionnaireId,
            questionId: entity.questionId,
            type: .init(entity: entity.type)
        )
    }
}
