//
//  AddQuoteViewController.swift
//  RandomQuoteGenerator
//
//  Created by Aron Vischjager on 3/14/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import UIKit

class AddQuoteViewController: UIViewController
{
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    
    // Remove keyboard for messageTextField or authorTextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if messageTextField.isFirstResponder && touch?.view != messageTextField
        {
            messageTextField.resignFirstResponder()
        }
        else if authorTextField.isFirstResponder && touch?.view != messageTextField
        {
            authorTextField.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func messageTextFieldTapped(_ sender: Any)
    {
        if authorTextField.isFirstResponder
        {
            authorTextField.resignFirstResponder()
        }
        messageTextField.becomeFirstResponder()
    }
    
    @IBAction func authorTextFieldTapped(_ sender: Any)
    {
        if messageTextField.isFirstResponder
        {
            messageTextField.resignFirstResponder()
        }
        authorTextField.becomeFirstResponder()
    }
    
    @IBAction func saveButtonDidTapped(_ sender: UIButton)
    {
        guard let message = messageTextField?.text else
        {
            return
        }
        guard let author = authorTextField?.text else
        {
            return
        }
        let quote = Quote(message: message, author: author)
        QuoteService.shared.add(quote: quote)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        messageTextField.becomeFirstResponder()
    }
}
