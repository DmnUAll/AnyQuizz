import UIKit

// MARK: - QuestionsPresenter
final class QuestionsPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: QuestionsController?
    private var networkManager = NetworkManager()
    private let coreDataManager = CoreDataManager.shared
    private var gameStatistics = GameStaticstics()
    private var questions: QuestionData?
    private var currentQuestion: Question?
    var answerButtonsCollection: [UIButton] {
        guard let viewController = self.viewController else { return [] }
        return [
            viewController.questionsView.firstButton,
            viewController.questionsView.secondButton,
            viewController.questionsView.thirdButton,
            viewController.questionsView.fourthButton
        ]
    }

    init(viewController: QuestionsController? = nil) {
        self.viewController = viewController
        networkManager.delegate = self
    }
}

// MARK: - Helpers
extension QuestionsPresenter {

    private func showAlert() {
        let message = """
Congratulations!
Your result:  \(gameStatistics.numberOfCorrectAnswers)/\(gameStatistics.numberOfQuestions)
Time: \(gameStatistics.time) seconds
"""
        let alertControler = UIAlertController(title: "Game Ended",
                                               message: message,
                                               preferredStyle: .alert)
        let saveResultAction = UIAlertAction(title: "Save Result", style: .default) { [weak self] _ in
            guard let self else { return }
            self.coreDataManager.addItems(gameResult: self.gameStatistics)
            self.viewController?.navigationController?.popToRootViewController(animated: true)
        }
        let backToMenuAction = UIAlertAction(title: "Back To Menu", style: .default) { [weak self] _ in
            guard let self else { return }
            self.viewController?.navigationController?.popToRootViewController(animated: true)
        }
        alertControler.addAction(saveResultAction)
        alertControler.addAction(backToMenuAction)
        viewController?.present(alertControler, animated: true)
    }

    func loadQuestions(questionsAmount: String, forCategory category: (index: Int, name: String)) {
        gameStatistics.category = category.name
        if category.index == 8 {
            networkManager.performRequest(numberOfQuestions: questionsAmount)
        } else {
            networkManager.performRequest(category: category.index, numberOfQuestions: questionsAmount)
        }
    }

    func showNextQuestion() {
        DispatchQueue.main.async { [weak self] in
            guard let self,
            let viewController = self.viewController else { return }
            self.currentQuestion = self.questions?.getQuestion()
            guard let currentQuestion = self.currentQuestion else {
                self.gameStatistics.time = Int64(Date().timeIntervalSince1970) - self.gameStatistics.time
                self.showAlert()
                return
            }
            viewController.navigationItem.title = currentQuestion.category
            let questionsView = viewController.questionsView
            questionsView.progressView.progress += Float(1) / Float(self.gameStatistics.numberOfQuestions)
            questionsView.questionLabel.text = String(htmlEncodedString: currentQuestion.question)
            for (index, title) in currentQuestion.answers.enumerated() {
                self.answerButtonsCollection[index].setTitle(String(htmlEncodedString: title), for: .normal)
            }
            viewController.updateUI()
        }
    }

    func proceedAnswer(forButton tappedButton: UIButton) {
        viewController?.view.isUserInteractionEnabled = false
        if tappedButton.titleLabel?.text == currentQuestion?.correctAnswer {
            tappedButton.backgroundColor = .green
            gameStatistics.numberOfCorrectAnswers += Int64(1)
        } else {
            tappedButton.backgroundColor = .red
            for button in answerButtonsCollection where button.titleLabel?.text == currentQuestion?.correctAnswer {
                    button.backgroundColor = .green
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            for button in self.answerButtonsCollection {
                button.backgroundColor = .aqGreen
            }
            self.viewController?.updateUI()
            self.showNextQuestion()
            self.viewController?.view.isUserInteractionEnabled = true
        }
    }
}

extension QuestionsPresenter: NetworkManagerDelegate {

    func receiveQuestion(data: QuestionData) {
        self.questions = data
        self.gameStatistics.time = Int64(Date().timeIntervalSince1970)
        self.gameStatistics.numberOfQuestions = Int64(data.results.count)
        self.showNextQuestion()
    }
}
