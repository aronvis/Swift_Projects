//
//  ViewController.swift
//  Dicee
//
//  Created by Aron Vischjager on 8/20/19.
//  Copyright © 2019 Aron Vischjager. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var randomDiceIndex1: Int = 0
    var randomDiceIndex2: Int = 0
    var dice1Name = ""
    var dice2Name = ""
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateDiceImages()
    }
    @IBAction func rollButtonPressed(_ sender: Any)
    {
        updateDiceImages()
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
    {
        updateDiceImages()
    }
    func updateDiceImages()
    {
        randomDiceIndex1 = Int.random(in: 1 ... 6) 
        randomDiceIndex2 = Int.random(in: 1 ... 6)
        dice1Name = "dice\(randomDiceIndex1)"
        dice2Name = "dice\(randomDiceIndex2)"
        diceImageView1.image = UIImage(named: dice1Name)
        diceImageView2.image = UIImage(named: dice2Name)
    }
}

