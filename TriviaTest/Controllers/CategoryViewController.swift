//
//  ViewController.swift
//  TriviaTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit
import ChameleonFramework
import BubbleTransition
import NotificationBannerSwift

class CategoryViewController: UITableViewController {

    private let transition                  = BubbleTransition()
    private let interactiveTransition       = BubbleInteractiveTransition()
    private var selectedCatColor            = UIColor.flatWhite
    private var selectedCategory            : (Int, String, UIColor)?
    private var cellPoint                   = CGPoint(x: 0, y: 0)
    private var selectedDifficulty          = QuestionDifficulty.Easy
    private var loadedQuestion              : QuestionData?
    
    private lazy var categories = {
        return [
            QuestionCategory.Animals, QuestionCategory.Geography,
            QuestionCategory.History, QuestionCategory.Mythology,
            QuestionCategory.ScienceAndNature, QuestionCategory.ScienceComputers,
            QuestionCategory.ScienceGadgets, QuestionCategory.ScienceMathematics,
            QuestionCategory.Sports, QuestionCategory.Vehicles
        ]
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: [categories[categories.count - 1].2, categories[0].2])
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.updateViewBy(category: category)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        cellSelected(indexPath: indexPath)
    }
    
    private func cellSelected(indexPath: IndexPath) {
        let category = categories[indexPath.row]
        selectedCatColor = category.2
        selectedCategory = category
        let rectOfCell = tableView.rectForRow(at: indexPath)
        let cellRect = tableView.convert(rectOfCell, to: tableView.superview)
        cellPoint = CGPoint(x: cellRect.minX + cellRect.width/2, y: cellRect.minY + cellRect.height/2)
        performSegue(withIdentifier: "DifficultySelect", sender: self)
    }
    
    private func processQuestionRequest() {
        showActivityIndicator()
        ApiManager.shared.makeQuestionRequest(category: selectedCategory!.0, type: QuestionType.Multiple, numberOfQuestions: 1, difficulty: selectedDifficulty) { [unowned self] (data, error) in
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
                receivedData.difficulty = self.selectedDifficulty
                self.loadedQuestion = receivedData
                self.performSegue(withIdentifier: "ToQuestionView", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DifficultySelectionViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.view.backgroundColor = selectedCatColor
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        } else if let controller = segue.destination as? QuestionViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
            controller.selectedCategory = selectedCategory
            controller.currentQuestion = loadedQuestion
        }
    }
}

extension CategoryViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = cellPoint
        transition.bubbleColor = selectedCatColor
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = cellPoint
        transition.bubbleColor = selectedCatColor
        
        if let difficultyVC = dismissed as? DifficultySelectionViewController {
            selectedDifficulty = difficultyVC.selectedDifficulty
            processQuestionRequest()
        }
        
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
    
}
