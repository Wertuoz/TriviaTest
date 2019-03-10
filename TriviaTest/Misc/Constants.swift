//
//  Constants.swift
//  TriviaTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation
import ChameleonFramework

struct QuestionCategory {
    static let ScienceAndNature     = (17, "Science & Nature", UIColor.flatLime)
    static let ScienceComputers     = (18, "Science: Computers", UIColor.flatBlue)
    static let ScienceMathematics   = (19, "Science: Mathematics", UIColor.flatMint)
    static let Mythology            = (20, "Mythology", UIColor.flatRed)
    static let Sports               = (21, "Sports", UIColor.flatPlum)
    static let Geography            = (22, "Geography", UIColor.flatGreen)
    static let History              = (23, "History", UIColor.flatSand)
    static let Animals              = (27, "Animals", UIColor.flatBrown)
    static let Vehicles             = (28, "Vehicles", UIColor.flatPink)
    static let ScienceGadgets       = (30, "Science: Gadgets", UIColor.flatOrange)
}

enum QuestionDifficulty: String {
    case Easy                       = "easy"
    case Medium                     = "medium"
    case Hard                       = "hard"
}

enum QuestionType: String {
    case Multiple                   = "multiple"
    case Boolean                    = "boolean"
}

enum QuestionApiParam: String {
    case Amount                     = "amount"
    case Category                   = "category"
    case Difficulty                 = "difficulty"
    case QuestionType               = "type"
}
