//
//  AppLogic.swift
//  AnyQuizz
//
//  Created by Илья Валито on 27.09.2022.
//

import UIKit
import CoreData

class AppLogic {
    
    let categoriesDictionary: [String: Int] = [
        "Random": 8,
        "General Knowledge": 9,
        "Entertainment: Books": 10,
        "Entertainment: Film": 11,
        "Entertainment: Music": 12,
        "Entertainment: Musicals & Theatres": 13,
        "Entertainment: Television": 14,
        "Entertainment: Video Games": 15,
        "Entertainment: Board Games": 16,
        "Science & Nature": 17,
        "Science: Computers": 18,
        "Science: Mathematics": 19,
        "Mythology": 20,
        "Sports": 21,
        "Geography": 22,
        "History": 23,
        "Politics": 24,
        "Art": 25,
        "Celebrities": 26,
        "Animals": 27,
        "Vehicles": 28,
        "Entertainment: Comics": 29,
        "Science: Gadgets": 30,
        "Entertainment: Japanese Anime & Manga": 31,
        "Entertainment: Cartoon & Animations": 32
    ]
    var categoriesArray: [String] {
        return Array(categoriesDictionary.keys).sorted(by: {$0 < $1})
    }
    
    var resultsArray = [QuizResult]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving cintext: \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<QuizResult> = QuizResult.fetchRequest(), sortedBy sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)) {
        request.sortDescriptors = [sortDescriptor]
        do {
            resultsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func addItems(gameResult: GameStaticstics) {
        let newItem = QuizResult(context: context)
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
