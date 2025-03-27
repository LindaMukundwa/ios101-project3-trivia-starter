//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Linda  Mukundwa on 26/03/2025.
//

import Foundation

class TriviaQuestionService {
    static func fetchQuestions(completion: @escaping ([TriviaQuestion]?) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=5&difficulty=easy&type=multiple")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Error fetching questions: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
                let questions = result.results.map { apiQuestion in
                    return TriviaQuestion(
                        question: apiQuestion.question.decodingHTMLEntities(),
                        correctAnswer: apiQuestion.correct_answer.decodingHTMLEntities(),
                        incorrectAnswers: apiQuestion.incorrect_answers.map { $0.decodingHTMLEntities() }, type: <#String#>
                    )
                }
                completion(questions)
            } catch {
                print("Error decoding questions: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    static func resetGame(completion: @escaping ([TriviaQuestion]?) -> Void) {
        fetchQuestions(completion: completion)
    }
}

// Model for API response
struct TriviaAPIResponse: Codable {
    let results: [APITriviaQuestion]
}

struct APITriviaQuestion: Codable {
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    let type: String
}

// main trivia question structure that can do multiple choice and true or false
struct TriviaQuestion {
    let question: String
        let correctAnswer: String
        let incorrectAnswers: [String]
        let type: String  // "multiple" or "boolean"
        
        var allAnswers: [String] {
            if type == "boolean" {
                // For True/False questions, we only want two options
                return ["True", "False"]
            } else {
                // For multiple choice, shuffle all answers
                return (incorrectAnswers + [correctAnswer]).shuffled()
            }
        }
}

// Helper extension to decode HTML entities
extension String {
    func decodingHTMLEntities() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
