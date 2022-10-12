//
//  ResultsViewController.swift
//  AnyQuizz
//
//  Created by Илья Валито on 10.10.2022.
//

import UIKit

class ResultsViewController: UITableViewController {
    
    var appLogic: AppLogic?
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appLogic?.resultsArray.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizResultCell") as! QuizResultCell
        
        guard let result = appLogic?.resultsArray[indexPath.row] else { return cell }
        cell.dateLabel.text = "\(result.date?.dateTimeString ?? Date().dateTimeString)"
        cell.timeLabel.text = "Time spended:\(result.time) sec"
        cell.scoreLabel.text = "Correct answers: \(result.numberOfCorrectAnswers)/\(result.numberOfQuestions)"
        
        return cell
    }
    
    // MARK: - Table View delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let result = appLogic?.resultsArray[indexPath.row] else { return }
        let text = """
Hey! I scored \(result.numberOfCorrectAnswers)/\(result.numberOfQuestions) correct answers at AnyQuizz app!
It was at \(result.date?.dateTimeString ?? Date().dateTimeString). I finished in \(result.time) seconds.
"""
        
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.appLogic?.deleteItem(atIndex: indexPath.row)
            tableView.reloadData()
        }
        deleteButton.backgroundColor = .systemRed
        deleteButton.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [deleteButton])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
