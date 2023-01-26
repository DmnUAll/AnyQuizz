import UIKit

// MARK: - MainMenuViewDelegate protocol
protocol MainMenuViewDelegate: AnyObject {
    func updateNumberOfQuestions()
    func startQuiz()
}

// MARK: - MainMenuView
final class MainMenuView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: MainMenuViewDelegate?

    let categoryPicker = UIPickerView()

    private lazy var topStackView = makeStackView(alignment: .center)

    lazy var questionsNumberLabel: UILabel = {
        let label = makeLabel(withText: "10", alignedTo: .left)
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return label
    }()

    private lazy var questionsInfoStackView = makeStackView(withAxis: .horizontal, andSpacing: 6)

    let questionsNumberSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 30
        slider.value = 10
        slider.minimumTrackTintColor = .aqGreen
        slider.thumbTintColor = .aqGreenDark
        slider.addTarget(nil, action: #selector(questionsNumberChanged), for: .valueChanged)
        return slider
    }()

    private lazy var questionsConfigStackView = makeStackView(withAxis: .horizontal, andSpacing: 6)

    private lazy var bottomStackView = makeStackView()

    private let startButton: UIButton = {
        let button = UIButton()
        button.toAutolayout()
        button.setTitle("Start Quiz", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitleColor(.aqGreenDark, for: .normal)
        button.backgroundColor = .aqGreen
        button.layer.cornerRadius = 6
        button.addTarget(nil, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = makeStackView(andSpacing: 60)
        stackView.toAutolayout()
        return stackView
    }()

    private lazy var linkTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "This app was made, using opentdb.com API")
        attributedString.addAttribute(.link, value: "https://opentdb.com/", range: NSRange(location: 25, length: 11))
        let textView = UITextView()
        textView.toAutolayout()
        textView.backgroundColor = .clear
        textView.attributedText = attributedString
        textView.textAlignment = .center
        textView.font = UIFont(name: "Kailasa Bold", size: 12)
        textView.textColor = .aqGreen
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .aqSalad
        toAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension MainMenuView {

    @objc private func questionsNumberChanged(_ sender: UISlider) {
        delegate?.updateNumberOfQuestions()
    }

    @objc private func startButtonTapped() {
        delegate?.startQuiz()
    }

    private func addSubviews() {
        topStackView.addArrangedSubview(makeLabel(withText: "Select a QUIZ category:"))
        topStackView.addArrangedSubview(categoryPicker)
        mainStackView.addArrangedSubview(topStackView)
        questionsInfoStackView.addArrangedSubview(makeLabel(withText: "Number of questions:", alignedTo: .left))
        questionsInfoStackView.addArrangedSubview(questionsNumberLabel)
        bottomStackView.addArrangedSubview(questionsInfoStackView)
        questionsConfigStackView.addArrangedSubview(makeLabel(withText: "1"))
        questionsConfigStackView.addArrangedSubview(questionsNumberSlider)
        questionsConfigStackView.addArrangedSubview(makeLabel(withText: "30"))
        bottomStackView.addArrangedSubview(questionsConfigStackView)
        mainStackView.addArrangedSubview(bottomStackView)
        addSubview(mainStackView)
        addSubview(startButton)
        addSubview(linkTextView)
    }

    private func setupConstraints() {
        let constraints = [
            linkTextView.heightAnchor.constraint(equalToConstant: 40),
            linkTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            linkTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            linkTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            startButton.bottomAnchor.constraint(equalTo: linkTextView.topAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func makeLabel(withText text: String, alignedTo alignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = alignment
        label.textColor = .aqGreen
        return label
    }

    private func makeStackView(withAxis axis: NSLayoutConstraint.Axis = .vertical,
                               alignment: UIStackView.Alignment = .fill,
                               distribution: UIStackView.Distribution = .fill,
                               andSpacing spacing: CGFloat = 12
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
}
