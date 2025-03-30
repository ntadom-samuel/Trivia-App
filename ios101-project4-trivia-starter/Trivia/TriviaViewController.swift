////
////  ViewController.swift
////  Trivia
////
////  Created by Mari Batilando on 4/6/23.
////
///
import UIKit

struct numQuestions {
    let number: Int
}

class TriviaViewController: UIViewController {
    private var questions_array = [numQuestions]()
    
    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var answerButton0: UIButton!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    
    private var questions = [TriviaQuestion]()
    private var currQuestionIndex = 0
    private var numCorrectQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        
        // Example options — can be used for a selector later
        questions_array = [
            numQuestions(number: 10),
            numQuestions(number: 20),
            numQuestions(number: 30)
        ]
        
        // Fetch trivia questions from API
        TriviaData.fetchTriviaQuestion(numQuestions: 10) { questionSet in
            self.questions = questionSet
            self.currQuestionIndex = 0
            self.numCorrectQuestions = 0
            self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
        }
    }

    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        guard questionIndex < questions.count else { return }

        let question = questions[questionIndex]
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        questionLabel.text = question.question
        categoryLabel.text = question.category

        let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
        let answerButtons = [answerButton0, answerButton1, answerButton2, answerButton3]

        for (i, button) in answerButtons.enumerated() {
            if i < answers.count {
                button?.setTitle(answers[i], for: .normal)
                button?.isHidden = false
            } else {
                button?.isHidden = true
            }
        }
    }

    private func updateToNextQuestion(answer: String) {
        if isCorrectAnswer(answer) {
            numCorrectQuestions += 1
        }
        currQuestionIndex += 1
        guard currQuestionIndex < questions.count else {
            showFinalScore()
            return
        }
        updateQuestion(withQuestionIndex: currQuestionIndex)
    }

    private func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == questions[currQuestionIndex].correctAnswer
    }

    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game Over!",
                                                message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            currQuestionIndex = 0
            numCorrectQuestions = 0
            updateQuestion(withQuestionIndex: currQuestionIndex)
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }

    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Button Actions

    @IBAction func didTapAnswerButton0(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }

    @IBAction func didTapAnswerButton1(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }

    @IBAction func didTapAnswerButton2(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }

    @IBAction func didTapAnswerButton3(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
}

//
//import UIKit
//
//struct numQuestions {
//    let number: Int
//}
//
//class TriviaViewController: UIViewController {
//    private var questions_array = [numQuestions]()
//    
//    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
//    @IBOutlet weak var questionContainerView: UIView!
//    @IBOutlet weak var questionLabel: UILabel!
//    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var answerButton0: UIButton!
//    @IBOutlet weak var answerButton1: UIButton!
//    @IBOutlet weak var answerButton2: UIButton!
//    @IBOutlet weak var answerButton3: UIButton!
//    
//    private var questions = [TriviaQuestion]()
//    private var currQuestionIndex = 0
//    private var numCorrectQuestions = 0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addGradient()
//        questionContainerView.layer.cornerRadius = 8.0
//        // TODO: FETCH TRIVIA QUESTIONS HERE
//        let ten = numQuestions(number:10)
//        let twenty = numQuestions(number:20)
//        let thirty = numQuestions(number:30)
//        questions_array = [ten,twenty,thirty]
//        updateQuestion(withQuestionIndex: 0)
//    }
//    
//    private func updateQuestion(withQuestionIndex questionIndex: Int) {
//        guard questionIndex < questions.count else { return }
//        
//        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
//        let question = questions[questionIndex]
//        questionLabel.text = question.question
//        categoryLabel.text = question.category
//        let answers = ([question.correct_answer] + question.incorrect_answers).shuffled()
//        if answers.count > 0 {
//            answerButton0.setTitle(answers[0], for: .normal)
//        }
//        if answers.count > 1 {
//            answerButton1.setTitle(answers[1], for: .normal)
//            answerButton1.isHidden = false
//        }
//        if answers.count > 2 {
//            answerButton2.setTitle(answers[2], for: .normal)
//            answerButton2.isHidden = false
//        }
//        if answers.count > 3 {
//            answerButton3.setTitle(answers[3], for: .normal)
//            answerButton3.isHidden = false
//        }
//        
//        TriviaData.fetchTriviaQuestion(numQuestions: questions.count){ question_set in
//            //Note: question_set is the returned data
//            //Class calls its configure method
//            self.configure(with: question_set)
//            
//        }
//    }
//    
//    private func updateToNextQuestion(answer: String) {
//        if isCorrectAnswer(answer) {
//            numCorrectQuestions += 1
//        }
//        currQuestionIndex += 1
//        guard currQuestionIndex < questions.count else {
//            showFinalScore()
//            return
//        }
//        //Call to API
//        updateQuestion(withQuestionIndex: currQuestionIndex)
//    }
//    
//    private func configure(with question_set: [TriviaQuestion]) {
//
//        guard 0 < question_set.count else { return } //guards against empty objects
//        answerButton2.isHidden = false
//        answerButton3.isHidden = false
//    
//        var new_array : [String]
//        let randomInt = Int.random(in: 0...question_set.count) //generates random numbers
//        
//        //Loop through array
//        for question in question_set {
//            new_array = question.incorrect_answers
//            new_array.insert(question.correct_answer, at: randomInt)
//            let shuffledAnswers = new_array.shuffled()
//            if question.incorrect_answers.count == 1{
//                answerButton0.setTitle(shuffledAnswers[0], for:.normal)
//                answerButton1.setTitle(shuffledAnswers[1], for:.normal)
//                answerButton2.isHidden = true
//                answerButton3.isHidden = true
//            } else {
//                answerButton0.setTitle(shuffledAnswers[0], for:.normal)
//                answerButton1.setTitle(shuffledAnswers[1], for:.normal)
//                answerButton2.setTitle(shuffledAnswers[2], for:.normal)
//                answerButton3.setTitle(shuffledAnswers[3], for:.normal)
//            }
//            
//        }
//        
//     
//    }
//    
//    private func isCorrectAnswer(_ answer: String) -> Bool {
//        return answer == questions[currQuestionIndex].correct_answer
//    }
//    
//    private func showFinalScore() {
//        let alertController = UIAlertController(title: "Game over!",
//                                                message: "Final score: \(numCorrectQuestions)/\(questions.count)",
//                                                preferredStyle: .alert)
//        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
//            currQuestionIndex = 0
//            numCorrectQuestions = 0
//            updateQuestion(withQuestionIndex: currQuestionIndex)
//        }
//        alertController.addAction(resetAction)
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    private func addGradient() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
//                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//        view.layer.insertSublayer(gradientLayer, at: 0)
//    }
//    
//    @IBAction func didTapAnswerButton0(_ sender: UIButton) {
//        guard 0 < questions.count else { return }
//        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
//    }
//    
//    @IBAction func didTapAnswerButton1(_ sender: UIButton) {
//        guard 0 < questions.count else { return }
//        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
//    }
//    
//    @IBAction func didTapAnswerButton2(_ sender: UIButton) {
//        guard 0 < questions.count else { return }
//        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
//    }
//    
//    @IBAction func didTapAnswerButton3(_ sender: UIButton) {
//        guard 0 < questions.count else { return }
//        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
//    }
//}
//
