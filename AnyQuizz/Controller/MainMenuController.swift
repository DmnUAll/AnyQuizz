import UIKit

// MARK: - MainMenuController
final class MainMenuController: UIViewController {

    // MARK: - Properties and Initializers
    private let mainMenuView = MainMenuView()
    private var presenter: MainMenuPresenter?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AnyQuiz"
        view.backgroundColor = .aqLime
        view.addSubview(mainMenuView)
        setupConstraints()
        presenter = MainMenuPresenter(viewController: self)
        mainMenuView.delegate = self
        mainMenuView.categoryPicker.delegate = self
        mainMenuView.categoryPicker.selectRow(18, inComponent: 0, animated: false)
    }
}

// MARK: - Helpers
extension MainMenuController {

    private func setupConstraints() {
        let constraints = [
            mainMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainMenuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainMenuView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - UIPickerViewDataSource
extension MainMenuController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let numberOfRows = presenter?.categoriesArray.count else { return 0 }
        return numberOfRows
    }

    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?
    ) -> UIView {
        let label = UILabel()
        label.text =  presenter?.categoriesArray[row]
        label.font = UIFont.systemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .aqGreenDark
        return label
    }
}

// MARK: - UIPickerViewDelegate
extension MainMenuController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        presenter?.categoriesArray[row]
    }
}

// MARK: - MainMenuViewDelegate
extension MainMenuController: MainMenuViewDelegate {

    func updateNumberOfQuestions() {
        mainMenuView.questionsNumberLabel.text = "\(Int(mainMenuView.questionsNumberSlider.value))"
    }

    func startQuiz() {

        guard let categoryName = presenter?.categoriesArray[mainMenuView.categoryPicker.selectedRow(inComponent: 0)],
              let categoryNumber = presenter?.giveCategoryNumber(forCategory: categoryName),
              let questionsAmount = mainMenuView.questionsNumberLabel.text else { return }
        navigationController?.pushViewController(QuestionsController(category: (categoryNumber, categoryName),
                                                                     questionsNumber: questionsAmount), animated: true)
    }
}
