import UIKit

// MARK: - ScoresController
final class ScoresController: UIViewController {

    private let scoresView = ScoresView()
    private var presenter: ScoresPresenter?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scores"
        view.backgroundColor = .aqLime
        view.addSubview(scoresView)
        setupConstraints()
        presenter = ScoresPresenter(viewController: self)
        scoresView.tableView.dataSource = self
        scoresView.tableView.delegate = self
    }
}

// MARK: - Helpers
extension ScoresController {

    private func setupConstraints() {
        let constraints = [
            scoresView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scoresView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoresView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scoresView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - UITableViewDataSource
extension ScoresController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.giveNumberOfScores() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = presenter?.configureCell(on: tableView, at: indexPath) else { return UITableViewCell() }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ScoresController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let result = presenter?.giveResult(forIndexPath: indexPath) else { return }
        let text = """
    Hey!
    I scored \(result.numberOfCorrectAnswers)/\(result.numberOfQuestions) correct answers at AnyQuizz app!
    Category - \(result.category ?? "")!
    It was at \(result.date?.dateTimeString ?? Date().dateTimeString). I finished in \(result.time) seconds.
    """
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.postToFacebook
        ]
        present(activityViewController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let self else { return }
            self.presenter?.deleteScore(at: indexPath)
            tableView.reloadData()
        }
        deleteButton.backgroundColor = .systemRed
        deleteButton.image = UIImage(systemName: "trash")
        let config = UISwipeActionsConfiguration(actions: [deleteButton])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
