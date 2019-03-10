//
//  QuestionData.swift
//  TriviaTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation

struct QuestionData {
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    var allAnswers: [String]
    var difficulty: QuestionDifficulty
}
