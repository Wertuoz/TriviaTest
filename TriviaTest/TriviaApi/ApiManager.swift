//
//  ApiManager.swift
//  TriviaTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ApiError: String {
    case unknownApiError    = "Unknows api error"
    case unknownError       = "Connection issues"
    case emptyData          = "Empty data received"
    case emptyResponse      = "Empty response"
    case badResponseJson    = "An error occured while parsing json(bad json)"
    case noEnoughQuesions   = "The API doesn't have enough questions for your query"
    case badParams          = "Arguements passed in aren't valid."
    case tokenNotFound      = "Session Token does not exist"
    case tokenNeedsToUpdate = "Session Token has returned all possible questions for the specified query"
}

class ApiManager {
    
    static let shared = ApiManager()
    
    func makeQuestionRequest(category: Int, type: QuestionType = QuestionType.Multiple, numberOfQuestions: Int = 1, difficulty: QuestionDifficulty, completion: @escaping (QuestionData?, Error?) -> Void) {
   
        let request = QuestionRequest()
        request.makeRequest(category: category, type: type, numberOfQuestions: numberOfQuestions, difficulty: difficulty, completion: completion)
    }
}
