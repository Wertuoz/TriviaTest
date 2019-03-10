//
//  UserDataApiParser.swift
//  TriviaTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation
import SwiftyJSON

class QuestionDataApiParser {
    
    static func parseData(data: Data) -> QuestionData {
        
        let json = try! JSON(data: data)
        let question = (json["results"][0]["question"].string ?? "").removingPercentEncoding!
        let incorrectAnswer = json["results"][0]["incorrect_answers"].arrayValue.compactMap({ $0.string?.removingPercentEncoding! })
        let correctAnswer = (json["results"][0]["correct_answer"].string ?? "").removingPercentEncoding!
        
        var allAnswers = [String]()
        allAnswers.append(correctAnswer)
        allAnswers += incorrectAnswer
        
        let questionData = QuestionData(question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswer, allAnswers: allAnswers, difficulty: QuestionDifficulty.Easy)
        return questionData
    }
    
}
