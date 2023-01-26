import Foundation

// MARK: - RequestResult
struct QuestionData: Codable {
    let responseCode: Int
    var results: [Question]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }

    mutating func getQuestion() -> Question? {
        if results.isEmpty {
            return nil
        } else {
            return results.removeFirst()
        }
    }
}

// MARK: - Result
struct Question: Codable {
    let category, question, correctAnswer: String
    let incorrectAnswers: [String]
    var answers: [String] {
        (incorrectAnswers + [correctAnswer]).shuffled()
    }

    enum CodingKeys: String, CodingKey {
        case category, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}
