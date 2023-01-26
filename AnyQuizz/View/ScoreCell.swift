import UIKit

// MARK: - ScoreCell
final class ScoreCell: UITableViewCell {

    // MARK: - Properties and Initializers
    lazy var dateLabel: UILabel = makeLabel(withText: "dateLabel", alignedTo: .left)

    lazy var categoryLabel: UILabel = makeLabel(withText: "categoryLabel", alignedTo: .left)

    private lazy var leftStackView: UIStackView = makeStackView(distribution: .fillEqually, andSpacing: 3)

    lazy var timeLabel: UILabel = makeLabel(withText: "timeLabel", alignedTo: .right)

    lazy var scoreLabel: UILabel = makeLabel(withText: "scoreLabel", alignedTo: .right)

    private lazy var rightStackView: UIStackView = makeStackView(distribution: .fillEqually, andSpacing: 3)

    private lazy var mainStackView: UIStackView =  {
        let stackView = makeStackView(withAxis: .horizontal, distribution: .fillEqually, andSpacing: 3)
        stackView.toAutolayout()
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .aqSalad
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension ScoreCell {

    private func addSubviews() {
        leftStackView.addArrangedSubview(dateLabel)
        leftStackView.addArrangedSubview(categoryLabel)
        mainStackView.addArrangedSubview(leftStackView)
        rightStackView.addArrangedSubview(timeLabel)
        rightStackView.addArrangedSubview(scoreLabel)
        mainStackView.addArrangedSubview(rightStackView)
        addSubview(mainStackView)
    }

    private func setupConstraints() {
        let constraints = [
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func makeLabel(withText text: String, alignedTo alignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = alignment
        label.textColor = .aqGreen
        label.adjustsFontSizeToFitWidth = true
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
