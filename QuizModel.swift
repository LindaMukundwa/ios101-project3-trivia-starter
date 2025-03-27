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
    var questions: [TriviaQuestion] = []
        var currentQuestionIndex = 0
        var score = 0
    
    // updated current question to handle difference between multiple choice or true/false
    func getCurrentQuestion() -> (questionText: String, answers: [String], correctAnswerIndex: Int) {
        guard currentQuestionIndex < questions.count else {
            return ("", [], -1)
        }
        
        let question = questions[currentQuestionIndex]
        let answers = question.allAnswers
        let correctAnswer = question.correctAnswer
        
        // For True/False questions, we need to map "True"/"False" to the API's actual answers
        let correctIndex: Int
        if question.type == "boolean" {
            correctIndex = (correctAnswer.lowercased() == "true") ? 0 : 1
        } else {
            correctIndex = answers.firstIndex(of: correctAnswer) ?? 0
        }
        
        return (question.question, answers, correctIndex)
    }
        
        func moveToNextQuestion() {
            currentQuestionIndex += 1
        }
        
        func reset() {
            currentQuestionIndex = 0
            score = 0
            questions = []
        }}
