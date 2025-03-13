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

    let quiz = Quiz()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI() {
        let currentQuestion = quiz.getCurrentQuestion()
        questionLabel.text = currentQuestion.questionText
        answerButton1.setTitle(currentQuestion.answers[0], for: .normal)
        answerButton2.setTitle(currentQuestion.answers[1], for: .normal)
        answerButton3.setTitle(currentQuestion.answers[2], for: .normal)
        answerButton4.setTitle(currentQuestion.answers[3], for: .normal)
    }

    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let selectedAnswerIndex = sender.tag
        let currentQuestion = quiz.getCurrentQuestion()

        if selectedAnswerIndex == currentQuestion.correctAnswerIndex {
            print("Correct!")
        } else {
            print("Wrong!")
        }

        quiz.moveToNextQuestion()
        updateUI()
    }
}
