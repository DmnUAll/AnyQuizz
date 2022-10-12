//
//  QuizQuestionsViewController.swift
//  AnyQuizz
//
//  Created by Илья Валито on 04.10.2022.
//

import UIKit

class QuizQuestionsViewController: UIViewController {
    
    lazy var questionManager = QuestionManager()
    var questionData: QuestionData?
    var currentQuestion: Question?
    private var gameStatistics = GameStaticstics()
    
    @IBOutlet private weak var webSearchButton: UIBarButtonItem!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var answerButtonsCollection: [UIButton]!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var buttonStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionManager.delegate = self
        updateUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.activityIndicator.isAnimating ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
            self.webSearchButton.isEnabled.toggle()
            self.progressBar.isHidden.toggle()
            self.questionLabel.isHidden.toggle()
            self.buttonStackView.isHidden.toggle()
        }
    }
    
    private func showNextQuestion() {
        DispatchQueue.main.async {
            self.currentQuestion = self.questionData?.getQuestion()
            guard let currentQuestion = self.currentQuestion else {
                self.gameStatistics.time = Int64(Date().timeIntervalSince1970) - self.gameStatistics.time
                self.showAlert()
                return
            }
            
            self.navigationItem.title = currentQuestion.category
            self.progressBar.progress += Float(1) / Float(self.gameStatistics.numberOfQuestions)
            self.questionLabel.text = currentQuestion.question
            for (index, title) in currentQuestion.answers.enumerated() {
                self.answerButtonsCollection[index].setTitle(title, for: .normal)
            }
            self.updateUI()
        }
    }
    
    private func proceedAnswer(forButton tappedButton: UIButton) {
        if tappedButton.titleLabel?.text == currentQuestion?.correctAnswer {
            tappedButton.tintColor = .green
            gameStatistics.numberOfCorrectAnswers += Int64(1)
        } else {
            tappedButton.tintColor = .red
            for button in answerButtonsCollection {
                if button.titleLabel?.text == currentQuestion?.correctAnswer {
                    button.tintColor = .green
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            for button in self.answerButtonsCollection {
                button.tintColor = #colorLiteral(red: 0.5244796872, green: 0.67960006, blue: 0.5814298987, alpha: 1)
            }
            self.updateUI()
            self.showNextQuestion()
        }
    }
    
    private func showAlert() {
        let alertControler = UIAlertController(title: "Game Ended",
                                               message: "Congratulations!\nYour result:  \(gameStatistics.numberOfCorrectAnswers)/\(gameStatistics.numberOfQuestions)\nTime: \(gameStatistics.time) seconds",
                                                preferredStyle: .alert)
        
        let saveResultAction = UIAlertAction(title: "Save Result", style: .default) { _ in
            self.performSegue(withIdentifier: "saveQuizResult", sender: self)
        }
        let backToMenuAction = UIAlertAction(title: "Back To Menu", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertControler.addAction(saveResultAction)
        alertControler.addAction(backToMenuAction)
        present(alertControler, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainViewController
        destinationVC.appLogic.addItems(gameResult: gameStatistics)
    }
    
    @IBAction private func answerButtonTapped(_ sender: UIButton) {
        proceedAnswer(forButton: sender)
    }
    
    @IBAction func webSearchTapped(_ sender: UIBarButtonItem) {
        guard let url = URL(string:"https://www.google.com/search?q=\(questionLabel.text!.replacingOccurrences(of: " ", with: "%20"))") else {
          return
        }
        UIApplication.shared.open(url)
    }
}

extension QuizQuestionsViewController: QuestionManagerDelegate {
    func receiveQuestion(data: QuestionData) {
        DispatchQueue.main.async {
            self.questionData = data
            
            self.gameStatistics.time = Int64(Date().timeIntervalSince1970)
            self.gameStatistics.numberOfQuestions = Int64(data.results.count)
                        
            self.showNextQuestion()
        }
    }
}
