//
//  DifficultySelectionViewController.swift
//  TriviaTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit
import BubbleTransition

class DifficultySelectionViewController: UIViewController {

    @IBOutlet weak var difficultyBtnBottom: UIButton!
    @IBOutlet weak var difficultyBtnMiddle: UIButton!
    @IBOutlet weak var difficultyBtnTop:    UIButton!
    
    weak var interactiveTransition: BubbleInteractiveTransition?
    var selectedDifficulty = QuestionDifficulty.Easy
    
    override func viewDidLoad() {
        super.viewDidLoad()

        difficultyBtnTop.setTitle(QuestionDifficulty.Easy.rawValue.uppercased(), for: .normal)
        difficultyBtnMiddle.setTitle(QuestionDifficulty.Medium.rawValue.uppercased(), for: .normal)
        difficultyBtnBottom.setTitle(QuestionDifficulty.Hard.rawValue.uppercased().uppercased(), for: .normal)
        
        difficultyBtnTop.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        difficultyBtnMiddle.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        difficultyBtnBottom.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
        switch sender {
            case difficultyBtnTop:
                selectedDifficulty = QuestionDifficulty.Easy
            case difficultyBtnMiddle:
                selectedDifficulty = QuestionDifficulty.Medium
            case difficultyBtnBottom:
                selectedDifficulty = QuestionDifficulty.Hard
            default:
                selectedDifficulty = QuestionDifficulty.Easy
        }
        
        self.dismiss(animated: true, completion: nil)
        interactiveTransition?.finish()
    }
}
