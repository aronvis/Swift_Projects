//
//  ViewController.swift
//  Flashcards
//
//  Created by Aron Vischjager on 2/27/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // Member Variables
    private var dataModel = FlashcardsModel.sharedInstance
    private var emptyCard = Flashcard(question: "There are no more flashcards", answer: "Please add more flashcards")
    private var card:Flashcard?
    private var screen:CGRect  = UIScreen.main.bounds
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    // Member Functions
    // Tap Gestures
    func initTapGestures()
    {
        // Double Tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(userDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        // Single Tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        tap.require(toFail: doubleTap)
        view.addGestureRecognizer(tap)
    }
    
    // Swipe Gestures
    func initSwipeGestures()
    {
        // Swipe Left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(userSwipedLeft))
        view.addGestureRecognizer(swipeLeft)
        swipeLeft.direction = .left
    
        // Swipe Right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(userSwipedRight))
        view.addGestureRecognizer(swipeRight)
        swipeRight.direction = .right
    }
    
    // Transform Animation with question functionality nested
    func transformAnimation(xChange: CGFloat, yChange: CGFloat)
    {
        let animator = UIViewPropertyAnimator(duration: 0.35, curve: .easeIn)
        {
            self.cardView.transform = CGAffineTransform(translationX: xChange, y: yChange)
        }
        animator.addCompletion { (position) in
            let originalPos = UIViewPropertyAnimator(duration: 0.35, curve: .easeOut)
            {
                self.cardView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                self.displayQuestion()
            }
            originalPos.startAnimation()
        }
        animator.startAnimation()
    }
    
    // Fading Animation with question/answer functionality nested
    func fadeAnimation()
    {
        let animator = UIViewPropertyAnimator(duration: 0.35, curve: .easeIn)
        {
            self.cardView.alpha = 0
        }
        animator.addCompletion{ (position) in
            let originalPos = UIViewPropertyAnimator(duration: 0.35, curve: .easeOut)
            {
                self.displayQorA()
                self.cardView.alpha = 1
            }
            originalPos.startAnimation()
        }
        animator.startAnimation()
    }
    
    
    // Displays either the question or answer for the double tap method
    func displayQorA()
    {
        if dataModel.questionDisplayed
        {
            displayAnswer()
        }
        else
        {
            displayQuestion()
        }
    }
    
    // Displays Question
    func displayQuestion()
    {
        dataModel.questionDisplayed = true
        if let currentCard = card
        {
            if currentCard.isFavorite
            {
                let starImage = UIImage(named: "starFilled")
                favoritesButton.setImage(starImage, for: UIControl.State.normal)
            }
            else
            {
                let starImage = UIImage(named: "star")
                favoritesButton.setImage(starImage, for: UIControl.State.normal)
            }
            cardLabel.text = currentCard.getQuestion()
        }
        else
        {
            let starImage = UIImage(named: "star")
            favoritesButton.setImage(starImage, for: UIControl.State.normal)
            cardLabel.text = emptyCard.getQuestion()
        }
        cardLabel.textColor = .black
    }
    
    // Display Answer
    func displayAnswer()
    {
        dataModel.questionDisplayed = false
        if let currentCard = card
        {
            if currentCard.isFavorite
            {
                let starImage = UIImage(named: "starFilled")
                favoritesButton.setImage(starImage, for: UIControl.State.normal)
            }
            else
            {
                let starImage = UIImage(named: "star")
                favoritesButton.setImage(starImage, for: UIControl.State.normal)
            }
            cardLabel.text = currentCard.getAnswer()
        }
        else
        {
            let starImage = UIImage(named: "star")
            favoritesButton.setImage(starImage, for: UIControl.State.normal)
            cardLabel.text = emptyCard.getAnswer()
        }
        cardLabel.textColor = .green
    }
    
    // User Tapped Response
    @objc func userTapped()
    {
        transformAnimation(xChange: 0.0 , yChange: -screen.height)
        card = dataModel.randomFlashcard()
    }
    
    // User Double Tapped Response
    @objc func userDoubleTapped()
    {
        fadeAnimation()
    }
    
    
    // User Swiped Left Response
    @objc func userSwipedRight()
    {
        transformAnimation(xChange: screen.width , yChange: 0.0)
        card = dataModel.nextFlashcard()
    }
    
    // User Swiped Right Response
    @objc func userSwipedLeft()
    {
        transformAnimation(xChange: -screen.width, yChange: 0.0)
        card = dataModel.previousFlashcard()
    }
    
    // Page Loaded Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        card = dataModel.randomFlashcard()
        displayQuestion()
        initTapGestures()
        initSwipeGestures()
    }
    
    // Changes the value of isFavorite of the current card
    @IBAction func ToggleFavorite(_ sender: UIButton)
    {
        if let currentCard = card
        {
            if currentCard.isFavorite
            {
                let starImage = UIImage(named: "star")
                sender.setImage(starImage, for: UIControl.State.normal)
            }
            else
            {
                let starImage = UIImage(named: "starFilled")
                sender.setImage(starImage, for: UIControl.State.normal)
            }
            dataModel.toggleFavorite()
        }
    }
    
    
    // Will reload the table view data everytime that the view appears
    override func viewWillAppear(_ animated: Bool)
    {
        card = dataModel.currentFlashcard()
        displayQuestion()
    }
}

