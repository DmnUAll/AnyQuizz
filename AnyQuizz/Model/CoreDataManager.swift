import UIKit
import CoreData

// MARK: - CoreDataManager
final class CoreDataManager {

    // swiftlint:disable force_cast
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // swiftlint:enable force_cast
    static let shared = CoreDataManager()
    var resultsArray = [QuizResult]()
}

extension CoreDataManager {

    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving cintext: \(error)")
        }
    }

    func loadItems(with request: NSFetchRequest<QuizResult> = QuizResult.fetchRequest(),
                   sortedBy sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    ) {
        request.sortDescriptors = [sortDescriptor]
        do {
            resultsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }

    func addItems(gameResult: GameStaticstics) {
        let newItem = QuizResult(context: context)
        newItem.category = gameResult.category
        newItem.numberOfQuestions = gameResult.numberOfQuestions
        newItem.numberOfCorrectAnswers = gameResult.numberOfCorrectAnswers
        newItem.time = gameResult.time
        newItem.date = Date()
        saveItems()
    }

    func deleteItem(atIndex index: Int) {
        context.delete(resultsArray[index])
        resultsArray.remove(at: index)
        saveItems()
    }
}
