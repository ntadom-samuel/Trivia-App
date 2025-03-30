//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaAPIResponse: Decodable {
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Decodable {
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    // JSON keys mapping
    private enum CodingKeys: String, CodingKey {
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

class TriviaData {
    static func fetchTriviaQuestion(numQuestions: Int, completion: @escaping ([TriviaQuestion]) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=\(numQuestions)"
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                assertionFailure("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response")
                return
            }

            guard let data = data else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }

            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(TriviaAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(apiResponse.results)
                }
            } catch {
                print("❌ Decoding error: \(error)")
                print("Raw response:\n", String(data: data, encoding: .utf8) ?? "No readable JSON")
            }
        }
        task.resume()
    }
}


//class TriviaData{
//    static func fetchTriviaQuestion(numQuestions: Int, completion: (([TriviaQuestion]) -> Void)? = nil){
//        let parameters = "amount=\(numQuestions)"
//        let url = URL(string: "https://opentdb.com/api.php?\(parameters)")! //exclamation mark is important
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            
//            guard error == nil else {
//                assertionFailure("Error: \(error!.localizedDescription)")
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse else {
//                assertionFailure("Invalid response")
//                return
//            }
//            guard let data = data, httpResponse.statusCode == 200 else {
//                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
//                return
//            }
//            
//            
//            let decoder = JSONDecoder()
//            let apiResponse = try! decoder.decode(TriviaAPIResponse.self, from: data)
//            DispatchQueue.main.async {
//                completion?(apiResponse.results)
//            } 
//        }
//        task.resume()
//    }
//}
