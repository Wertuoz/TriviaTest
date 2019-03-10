//
//  QuestionViewController.swift
//  TriviaTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit
import BubbleTransition

class QuestionViewController: UIViewController {
    
    weak var interactiveTransition: BubbleInteractiveTransition?

    @IBOutlet weak var btnFirstAnswer:  UIButton!
    @IBOutlet weak var btnSecondAnswer: UIButton!
    @IBOutlet weak var btnThirdAnswer:  UIButton!
    @IBOutlet weak var btnFourthAnswer: UIButton!
    
    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var questionLbl:     UILabel!
    
    @IBOutlet weak var btnShowAnswer:   UIButton!
    @IBOutlet weak var btnNextQuestion: UIButton!
    @IBOutlet weak var btnClose:        UIButton!
    
    var selectedCategory:               (Int, String, UIColor)?
    var currentQuestion:                QuestionData?
    
    private var answerBtns = [UIButton]()
    private var defaultDisabledBtnTitleColor = UIColor.white
    private var questions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultDisabledBtnTitleColor = btnFirstAnswer.titleColor(for: .disabled)!
        answerBtns.append(contentsOf: [btnFirstAnswer, btnSecondAnswer, btnThirdAnswer, btnFourthAnswer])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        view.backgroundColor = selectedCategory?.2
        
        categoryNameLbl.text = "Category: " + (selectedCategory?.1 ?? "")
        questionLbl.text = currentQuestion?.question
        
        guard let answers = currentQuestion?.allAnswers else {
            print("Some error, questions are empty")
            return
        }
        
        if answers.count != 4 {
            print("Some error, questions count not equals 4")
            return
        }
        
        questions = answers.shuffled()
        
        btnFirstAnswer.setTitle(questions[0], for: .normal)
        btnSecondAnswer.setTitle(questions[1], for: .normal)
        btnThirdAnswer.setTitle(questions[2], for: .normal)
        btnFourthAnswer.setTitle(questions[3], for: .normal)
        
        disableAllBtns(enable: true)
        btnResetBtnsColors()
    }
    
    @IBAction func onAnswerBtnClick(_ sender: UIButton) {
        btnsResetAnimations()
        disableBtns()
        
        let rightAnswer = currentQuestion?.correctAnswer
        let selectedAnswer = questions[sender.tag]
        if selectedAnswer == rightAnswer {
            processRightAnswer(btnTag: sender.tag)
        } else {
            processWrongAnswer(btnTag: sender.tag)
        }
    }

    private func btnsResetAnimations() {
        for btn in answerBtns {
            btn.removePulsation()
        }
    }
    
    private func btnResetBtnsColors() {
        for btn in answerBtns {
            btn.setTitleColor(defaultDisabledBtnTitleColor, for: .disabled)
        }
    }
    
    private func disableBtns(enable: Bool = false) {
        for btn in answerBtns {
            btn.isEnabled = enable
        }
        btnShowAnswer.isEnabled = enable
    }
    
    private func disableAllBtns(enable: Bool = false) {
        disableBtns(enable: enable)
        btnClose.isEnabled = enable
        btnNextQuestion.isEnabled = enable;
    }
    
    private func processRightAnswer(btnTag: Int) {
        showSuccess(message: "You are right:)")
        answerBtns[btnTag].setTitleColor(UIColor.green, for: .disabled)
    }
    
    private func processWrongAnswer(btnTag: Int) {
        showSuccess(message: "You are wrong, the answer is:\n \(currentQuestion!.correctAnswer)", success: false)
        answerBtns[btnTag].setTitleColor(UIColor.red, for: .disabled)
    }
    
    @IBAction func onShowAnswerBtnClick(_ sender: UIButton) {
        
        guard let rightAnswer = currentQuestion?.correctAnswer else {
            return
        }
        let indexOf = questions.firstIndex(of: rightAnswer)!
        answerBtns[indexOf].removePulsation()
        answerBtns[indexOf].animatePulsation()
    }
    
    @IBAction func onCloseBtnClick(_ sender: UIButton) {
        disableAllBtns()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onNextQuestionBtnClick(_ sender: UIButton) {
        processQuestionRequest()
    }
    
    private func processQuestionRequest() {
        btnsResetAnimations()
        disableAllBtns()
        showActivityIndicator()
        ApiManager.shared.makeQuestionRequest(category: selectedCategory!.0, type: QuestionType.Multiple, numberOfQuestions: 1, difficulty: currentQuestion!.difficulty) { [unowned self] (data, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                if error != nil {
                    self.showAlertBar(with: "Some error occures", subText: error!.localizedDescription)
                    return
                }
                guard var receivedData = data else {
                    self.showAlertBar(with: "Data error", subText: "Something goes wrong")
                    return
                }
                receivedData.difficulty = self.currentQuestion!.difficulty
                self.currentQuestion = receivedData
                self.updateUI()
            }
        }
    }
}
