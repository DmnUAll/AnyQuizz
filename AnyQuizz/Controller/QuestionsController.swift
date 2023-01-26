import UIKit

// MARK: - QuestionsController
final class QuestionsController: UIViewController {

    // MARK: - Properties and Initializers
    let questionsView = QuestionsView()
    private var presenter: QuestionsPresenter?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    convenience init(category: (index: Int, name: String), questionsNumber: String) {
        self.init()
        presenter = QuestionsPresenter(viewController: self)
        presenter?.loadQuestions(questionsAmount: questionsNumber, forCategory: category)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AnyQuiz"
        view.backgroundColor = .aqLime
        view.addSubview(questionsView)
        setupConstraints()
        questionsView.delegate = self
        addNavigationButtons()
        updateUI()
    }
}

// MARK: - Helpers
extension QuestionsController {

    private func setupConstraints() {
        let constraints = [
            questionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            questionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func addNavigationButtons() {
        let searchLink = "https://www.google.com/search?q="
        let webButton = UIBarButtonItem(image: UIImage(systemName: "globe"),
                                        primaryAction: UIAction(handler: { [weak self] _ in
            guard let self,
                  let text = self.questionsView.questionLabel.text,
                  let url = URL(string: "\(searchLink)\(text.replacingOccurrences(of: " ", with: "%20"))") else {
                return
            }
            UIApplication.shared.open(url)
        }))
        navigationItem.rightBarButtonItem = webButton
    }

    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if self.questionsView.activityIndicator.isAnimating {
                self.questionsView.activityIndicator.stopAnimating()
            } else {
                self.questionsView.activityIndicator.startAnimating()
            }
            self.navigationItem.rightBarButtonItem?.isEnabled.toggle()
            self.questionsView.progressView.isHidden.toggle()
            self.questionsView.questionLabel.isHidden.toggle()
            self.questionsView.buttonsStackView.isHidden.toggle()
        }
    }
}

// MARK: - QuestionsViewDelegate
extension QuestionsController: QuestionsViewDelegate {

    func answerGiven(by sender: UIButton) {
        presenter?.proceedAnswer(forButton: sender)
    }
}
