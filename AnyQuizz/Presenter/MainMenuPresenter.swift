import Foundation

// MARK: - MainMenuPresenter
final class MainMenuPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: MainMenuController?
    private let categoriesDictionary: [String: Int] = [
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
        Array(categoriesDictionary.keys).sorted(by: {$0 < $1})
    }

    init(viewController: MainMenuController? = nil) {
        self.viewController = viewController
    }
}

// MARK: - Helpers
extension MainMenuPresenter {

    func giveCategoryNumber(forCategory category: String) -> Int? {
        categoriesDictionary[category]
    }
}
