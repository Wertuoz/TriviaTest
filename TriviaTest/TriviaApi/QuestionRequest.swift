//
//  BatchCommitsRequest.swift
//  GitHubTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation
import SwiftyJSON

class QuestionRequest {
    
    private let apiUrl = "https://opentdb.com/api.php"
    private let tokenUrl = "https://opentdb.com/api_token.php?command=request"
    private let dispatchGroup = DispatchGroup()
    private static var token: String = ""
    private var category: Int = 0
    private var type: QuestionType = QuestionType.Multiple
    private var numberOfQuestions = 1
    private var difficulty: QuestionDifficulty = QuestionDifficulty.Easy
    private var apiError: Error?
    private var questionData: QuestionData?
    private let semaphore = DispatchSemaphore(value: 0)
    
    func makeRequest(category: Int, type: QuestionType = QuestionType.Multiple, numberOfQuestions: Int = 1, difficulty: QuestionDifficulty = QuestionDifficulty.Easy, completion: @escaping (QuestionData?, Error?) -> Void) {
        
        self.type = type
        self.numberOfQuestions = numberOfQuestions
        self.difficulty = difficulty
        self.category = category
        
        DispatchQueue.global(qos: .default).async {
            let _ = self.dispatchGroup.wait(timeout: .distantFuture)
            if QuestionRequest.token.count == 0 {
                self.tokenRequest()
            }
            self.questionRequest()
            
            self.dispatchGroup.notify(queue: DispatchQueue.global(qos: .default)) {
                completion(self.questionData, self.apiError)
            }
        }
    }

    private func questionRequest() {

        dispatchGroup.enter()
        
        let urlComponents = NSURLComponents(string: apiUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: QuestionApiParam.Amount.rawValue, value: String(numberOfQuestions)),
            URLQueryItem(name: QuestionApiParam.Category.rawValue, value: String(category)),
            URLQueryItem(name: QuestionApiParam.Difficulty.rawValue, value: difficulty.rawValue),
            URLQueryItem(name: QuestionApiParam.QuestionType.rawValue, value: type.rawValue),
            URLQueryItem(name: "encode", value: "url3986"),
            URLQueryItem(name: "token", value: QuestionRequest.token)
            
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            do {
                try self.parseResponseForErrors(data: data, response: response, errorResp: error)
            } catch {
                self.apiError = error
                self.semaphore.signal()
                return
            }
            
            self.questionData = QuestionDataApiParser.parseData(data: data!)
            self.semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        self.dispatchGroup.leave()
    }
    
    private func tokenRequest() {
        
        dispatchGroup.enter()

        let tokenApiUrl = URL(string: tokenUrl)
        let request = URLRequest(url: tokenApiUrl!)
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            do {
                try self.parseResponseForErrors(data: data, response: response, errorResp: error)
            } catch {
                self.semaphore.signal()
                return
            }
            
            let json = try! JSON(data: data!)
            QuestionRequest.token = json["token"].stringValue
            self.semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        dispatchGroup.leave()
    }
    
    private func parseResponseForErrors(data: Data?, response: URLResponse?, errorResp: Error?) throws {
        
        if let _ = errorResp {
            throw NSError(domain: "", code: 301, userInfo: [ NSLocalizedDescriptionKey: ApiError.unknownError.rawValue])
        }
        guard let successReposnse = response else {
            throw NSError(domain: "", code: 302, userInfo: [NSLocalizedDescriptionKey: ApiError.emptyResponse.rawValue])
        }
        guard let dataToParse = data else {
            throw NSError(domain: "", code: 303, userInfo: [ NSLocalizedDescriptionKey: ApiError.emptyData.rawValue])
        }
        
        if let httpResponse = successReposnse as? HTTPURLResponse {
            if httpResponse.statusCode == 1 {
                throw NSError(domain: "", code: 305, userInfo: [NSLocalizedDescriptionKey: ApiError.noEnoughQuesions.rawValue])
            }
            if httpResponse.statusCode == 2 {
                throw NSError(domain: "", code: 306, userInfo: [NSLocalizedDescriptionKey: ApiError.badParams.rawValue])
            }
            if httpResponse.statusCode == 3 {
                throw NSError(domain: "", code: 307, userInfo: [NSLocalizedDescriptionKey: ApiError.tokenNotFound.rawValue])
            }
            if httpResponse.statusCode == 4 {
                throw NSError(domain: "", code: 308, userInfo: [NSLocalizedDescriptionKey: ApiError.tokenNeedsToUpdate.rawValue])
            }
        }
        
        do {
            let json = try JSON(data: dataToParse)
            print(json)
        } catch {
            throw NSError(domain: "", code: 309, userInfo: [NSLocalizedDescriptionKey: ApiError.badResponseJson.rawValue])
        }
    }
}
