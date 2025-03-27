//
//  ViewController.swift
//  Trivia
//
//  Created by Linda  Mukundwa on 13/03/2025.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    var quiz = Quiz()
    var selectedAnswerIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        loadQuestions()
    }
    
    func setupButtons() {
        answerButton1.tag = 0
        answerButton2.tag = 1
        answerButton3.tag = 2
        answerButton4.tag = 3
        
        // Add border to buttons for better visual feedback
        [answerButton1, answerButton2, answerButton3, answerButton4].forEach { button in
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.systemBlue.cgColor
            button?.layer.cornerRadius = 8
        }
    }
    
    func loadQuestions() {
        TriviaQuestionService.fetchQuestions { [weak self] questions in
            DispatchQueue.main.async {
                if let questions = questions {
                    self?.quiz.questions = questions
                    self?.updateUI()
                } else {
                    self?.showErrorAlert()
                }
            }
        }
    }
    
    func updateUI() {
        guard quiz.currentQuestionIndex < quiz.questions.count else {
            showFinalScore()
            return
        }
        
        let currentQuestion = quiz.getCurrentQuestion()
        questionLabel.text = currentQuestion.questionText
        progressLabel.text = "Question \(quiz.currentQuestionIndex + 1)/\(quiz.questions.count)"
        
        // Update answer buttons
        answerButton1.setTitle(currentQuestion.answers[0], for: .normal)
        answerButton2.setTitle(currentQuestion.answers[1], for: .normal)
        
        // Checks for a true/false question and only shows 2 answers
        let isTrueFalseQuestion = quiz.questions[quiz.currentQuestionIndex].type == "boolean"
        answerButton3.isHidden = isTrueFalseQuestion
        answerButton4.isHidden = isTrueFalseQuestion
        
        // different button style for True/False questions
        if isTrueFalseQuestion {
            answerButton1.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            answerButton2.backgroundColor = .systemRed.withAlphaComponent(0.1)
        } else {
            answerButton1.backgroundColor = .systemBackground
            answerButton2.backgroundColor = .systemBackground
        }
        
        if !isTrueFalseQuestion {
            answerButton3.setTitle(currentQuestion.answers[2], for: .normal)
            answerButton4.setTitle(currentQuestion.answers[3], for: .normal)
        }
        
        // Reset selection
        selectedAnswerIndex = nil
        resetButtonSelection()
    }
    
    func resetButtonSelection() {
        [answerButton1, answerButton2, answerButton3, answerButton4].forEach { button in
            button?.backgroundColor = .systemBackground
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        resetButtonSelection()
        sender.backgroundColor = .systemBlue
        selectedAnswerIndex = sender.tag
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let selectedAnswerIndex = selectedAnswerIndex else {
            showAlert(title: "No Answer Selected", message: "Please select an answer before submitting.")
            return
        }
        
        let currentQuestion = quiz.getCurrentQuestion()
        if selectedAnswerIndex == currentQuestion.correctAnswerIndex {
            quiz.score += 1
        }
        
        quiz.moveToNextQuestion()
        updateUI()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        quiz.reset()
        loadQuestions()
    }
    
    func showFinalScore() {
        let alert = UIAlertController(
            title: "Quiz Completed",
            message: "Your score: \(quiz.score)/\(quiz.questions.count)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            self.resetButtonTapped(self.resetButton)
        })
        present(alert, animated: true)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Failed to load questions. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
