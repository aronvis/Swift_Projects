//
//  Flashcard.swift
//  Flashcards
//
//  Created by Aron Vischjager on 2/27/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import Foundation

struct Flashcard:Equatable, Codable
{
    // Member Functions
    init(question: String, answer: String, isFavorite: Bool=false)
    {
        self.question = question
        self.answer = answer
        self.isFavorite = isFavorite
    }
    func getQuestion() -> String
    {
        return question
    }
    func getAnswer() -> String
    {
        return answer
    }
    // Member Variables
    private var question: String
    private var answer: String
    public var isFavorite: Bool
}
