import UIKit

// MARK: - ScoresView
final class ScoresView: UIView {

    // MARK: - Properties and Initializers
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.toAutolayout()
        tableView.backgroundColor = .aqSalad
        tableView.separatorColor = .aqGreenDark
        tableView.register(ScoreCell.self, forCellReuseIdentifier: "scoreCell")
        return tableView
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
extension ScoresView {

    private func addSubviews() {
        addSubview(tableView)
        addSubview(linkTextView)
    }

    private func setupConstraints() {
        let constraints = [
            linkTextView.heightAnchor.constraint(equalToConstant: 40),
            linkTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            linkTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            linkTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: linkTextView.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
