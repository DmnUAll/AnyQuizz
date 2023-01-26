import UIKit

// MARK: - ScoresPresenter
final class ScoresPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: ScoresController?
    private var coreDataManager = CoreDataManager.shared

    init(viewController: ScoresController? = nil) {
        self.viewController = viewController
        coreDataManager.loadItems()
    }
}

// MARK: - Helpers
extension ScoresPresenter {

    func giveNumberOfScores() -> Int {
        coreDataManager.resultsArray.count
    }

    func configureCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as? ScoreCell else {
            return UITableViewCell()
        }
        let result = coreDataManager.resultsArray[indexPath.row]
        cell.dateLabel.text = "\(result.date?.dateTimeString ?? Date().dateTimeString)"
        cell.categoryLabel.text = "Category: \(result.category ?? "")"
        cell.timeLabel.text = "Time spended: \(result.time) sec"
        cell.scoreLabel.text = "Correct answers: \(result.numberOfCorrectAnswers)/\(result.numberOfQuestions)"
        tableView.separatorInset = UIEdgeInsets.zero
        return cell
    }

    func giveResult(forIndexPath indexPath: IndexPath) -> QuizResult {
        return coreDataManager.resultsArray[indexPath.row]
    }

    func deleteScore(at indexPath: IndexPath) {
        coreDataManager.deleteItem(atIndex: indexPath.row)
    }
}
