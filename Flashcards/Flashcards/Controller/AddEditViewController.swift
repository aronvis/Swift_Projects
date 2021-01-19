//
//  AddEditViewController.swift
//  Flashcards
//
//  Created by Aron Vischjager on 4/4/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController, UITextViewDelegate, UISearchTextFieldDelegate
{
    // Member Variables
    private var dataModel = FlashcardsModel.sharedInstance
    var navTitleText: String = ""
    var instructionText: String = ""
    var editSelectedIndex: Int?
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var favoriteCardSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // Member Functions
    // Removes all content inside the text field
    func clearFields()
    {
        questionTextView.text = ""
        answerTextField.text = ""
        favoriteCardSwitch.setOn(false, animated: true)
    }
    
    // Displays an alert when the user if trying to add a question that already exits
    func displayAlert(alertTitle:String, alertMessage: String)
    {
         // Code sniplet in a method
        let alertController = UIAlertController(title: alertTitle , message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Remove keyboard for messageTextField or authorTextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if questionTextView.isFirstResponder && touch?.view != questionTextView
        {
            questionTextView.resignFirstResponder()
        }
        else if answerTextField.isFirstResponder && touch?.view != answerTextField
        {
            answerTextField.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
       
    // Allows user to save answer if the user has entered at least one character for both the question and the answer field
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let updatedText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        guard let answerString = answerTextField.text else
        {
            return true
        }
        if updatedText != "" && answerString != ""
        {
            saveButton.isEnabled = true
        }
        else
        {
            saveButton.isEnabled = false
        }
        if(text == "\n")
        {
            textView.resignFirstResponder()
            answerTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    // Allows user to save answer if the user has entered at least one character for both the question and the answer field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let answerString = textField.text else
        {
            return true
        }
        let updatedText = (answerString as NSString).replacingCharacters(in: range, with: string)
        if updatedText != "" && questionTextView.text != ""
        {
            saveButton.isEnabled = true
        }
        else
        {
            saveButton.isEnabled = false
        }
        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: Any)
    {
        answerTextField.resignFirstResponder()
    }
    
    // Adds or edits a flashcard depending scene navigation
    @IBAction func saveDidTapped(_ sender: UIBarButtonItem)
    {
        // Variables needed for adding or modifying flashcard
        guard let question = questionTextView.text else
        {
            return
        }
        guard let answer = answerTextField.text else
        {
            return
        }
        var isFavorite = false
        if favoriteCardSwitch.isOn
        {
            isFavorite = true
        }
        
        // Checks if the current question already exists and returns an alert if that is the case
        let questionUsed = dataModel.checkAskedQuestion(potentialQuestion: question)
        if questionUsed
        {
            displayAlert(alertTitle: "Warning!", alertMessage: "The question you have entered already exits, try a new question")
            clearFields()
        }
        else
        {
            // Adds a new flashcard
            if instructionText == "Enter" && !questionUsed
            {
                dataModel.insert(question: question, answer: answer, favorite: isFavorite)
            }
                
            // Edits an existing flashcard
            else
            {
                guard let cardIndex = editSelectedIndex else
                {
                    return
                }
                print(cardIndex)
                dataModel.editFlashcard(at: cardIndex , question: question, answer: answer, favorite: isFavorite)
            }
            clearFields()
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // Removes all text from the question text view and the answer text field
    @IBAction func cancelDidTapped(_ sender: UIBarButtonItem)
    {
        clearFields()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = navTitleText
        questionTextView.delegate = self
        answerTextField.delegate = self
        saveButton.isEnabled = false
        favoriteCardSwitch.setOn(false, animated: true)
        questionTextView.becomeFirstResponder()
    }
}
