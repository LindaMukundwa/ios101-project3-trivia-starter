//
//  QuizModel.swift
//  Trivia
//
//  Created by Linda  Mukundwa on 13/03/2025.
//

struct Question {
    let questionText: String
    let answers: [String]
    let correctAnswerIndex: Int
}

class Quiz {
    var questions: [Question] = []
    var currentQuestionIndex: Int = 0

    init() {
        // Add at least 3 questions
        questions.append(Question(questionText: "What is the capital of France?",
                                  answers: ["Paris", "London", "Berlin", "Madrid"],
                                  correctAnswerIndex: 0))
        questions.append(Question(questionText: "What is 2 + 2?",
                                  answers: ["3", "4", "5", "6"],
                                  correctAnswerIndex: 1))
        questions.append(Question(questionText: "What is the largest planet?",
                                  answers: ["Earth", "Jupiter", "Mars", "Saturn"],
                                  correctAnswerIndex: 1))
    }

    func getCurrentQuestion() -> Question {
        return questions[currentQuestionIndex]
    }

    func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            currentQuestionIndex = 0 // Restart the quiz
        }
    }
}
