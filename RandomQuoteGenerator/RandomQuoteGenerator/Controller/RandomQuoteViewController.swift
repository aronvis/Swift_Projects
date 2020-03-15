//
//  RandomQuoteViewController.swift
//  RandomQuoteGenerator
//
//  Created by Aron Vischjager on 3/14/20.
//  Copyright © 2020 App Factory. All rights reserved.
//

import UIKit

class RandomQuoteViewController: UIViewController
{
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBAction func randomQuoteDidTapped(_ sender: UIButton)
    {
        if let randomQuote = QuoteService.shared.getRandomQuote()
        {
            messageLabel.text = randomQuote.message
            authorLabel.text = randomQuote.author
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}
