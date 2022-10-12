//
//  QuestionModel.swift
//  AnyQuizz
//
//  Created by Илья Валито on 04.10.2022.
//

import Foundation

protocol QuestionManagerDelegate {
    func receiveQuestion(data: QuestionData)
}

struct QuestionManager {
    
    var delegate: QuestionManagerDelegate?
    
    func performRequest(category: Int = 0, numberOfQuestions: String = "10") {
        let cat = category == 0 ? "" : "&category=\(category)"
        if let url = URL(string: "https://opentdb.com/api.php?amount=\(numberOfQuestions)\(cat)&type=multiple") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error as Any)
                    return
                }
                if let safeData = data {
//                    let dataStrng = String(data: safeData, encoding: .utf8)
//                    print(dataStrng)
                    self.parseJSON(questionData: safeData)
                }
            }
            task.resume()
        }
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
