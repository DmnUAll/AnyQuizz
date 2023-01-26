import UIKit

// MARK: - QuestionsViewDelegate protocol
protocol QuestionsViewDelegate: AnyObject {
    func answerGiven(by sender: UIButton)
}

// MARK: - QuestionsView
final class QuestionsView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: QuestionsViewDelegate?

    let progressView: UIProgressView = {
        var progressView = UIProgressView()
        progressView.toAutolayout()
        progressView.tintColor = .aqGreen
        return progressView
    }()

    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .aqGreen
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .aqGreenDark
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = makeStackView(alignment: .center, andSpacing: 36)
        stackView.toAutolayout()
        return stackView
    }()

    lazy var firstButton = makeButton(withTitle: "Answer 1", andAction: #selector(firstButtonTapped))

    lazy var secondButton = makeButton(withTitle: "Answer 2", andAction: #selector(secondButtonTapped))

    lazy var thirdButton = makeButton(withTitle: "Answer 3", andAction: #selector(thirdButtonTapped))

    lazy var fourthButton = makeButton(withTitle: "Answer 4", andAction: #selector(fourthButtonTapped))

    lazy var buttonsStackView: UIStackView = {
        let stackView = makeStackView(andSpacing: 12)
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
extension QuestionsView {

    @objc private func firstButtonTapped(_ sender: UIButton) {
        delegate?.answerGiven(by: sender)
    }

    @objc private func secondButtonTapped(_ sender: UIButton) {
        delegate?.answerGiven(by: sender)
    }

    @objc private func thirdButtonTapped(_ sender: UIButton) {
        delegate?.answerGiven(by: sender)
    }

    @objc private func fourthButtonTapped(_ sender: UIButton) {
        delegate?.answerGiven(by: sender)
    }

    private func addSubviews() {
        addSubview(progressView)
        topStackView.addArrangedSubview(activityIndicator)
        topStackView.addArrangedSubview(questionLabel)
        addSubview(topStackView)
        buttonsStackView.addArrangedSubview(firstButton)
        buttonsStackView.addArrangedSubview(secondButton)
        buttonsStackView.addArrangedSubview(thirdButton)
        buttonsStackView.addArrangedSubview(fourthButton)
        addSubview(buttonsStackView)
        addSubview(linkTextView)
    }

    private func setupConstraints() {
        let constraints = [
            linkTextView.heightAnchor.constraint(equalToConstant: 40),
            linkTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            linkTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            linkTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            topStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            topStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            topStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            buttonsStackView.bottomAnchor.constraint(equalTo: linkTextView.topAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func makeButton(withTitle title: String, andAction action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitleColor(.aqGreenDark, for: .normal)
        button.backgroundColor = .aqGreen
        button.layer.cornerRadius = 6
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(nil, action: action, for: .touchUpInside)
        return button
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
