import Foundation

// MARK: - NetworkManagerDelegate protocol
protocol NetworkManagerDelegate: AnyObject {
    func receiveQuestion(data: QuestionData)
}

// MARK: - NetworkManager
struct NetworkManager {

    var delegate: NetworkManagerDelegate?

    func performRequest(category: Int = 0, numberOfQuestions: String = "10") {
        let cat = category == 0 ? "" : "&category=\(category)"
        let linkString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)\(cat)&type=multiple"
        guard let url = URL(string: linkString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, _ in
            guard let data else { return }
            self.parseJSON(questionData: data)
        }
        task.resume()
    }

    func parseJSON(questionData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(QuestionData.self, from: questionData)
            delegate?.receiveQuestion(data: decodedData)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
