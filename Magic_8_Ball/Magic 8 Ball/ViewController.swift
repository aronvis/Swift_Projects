//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Aron Vischjager on 8/20/19.
//  Copyright © 2019 Aron Vischjager. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var ballImage: UIImageView!
    var ballIndex = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        changeImage()
    }
    @IBAction func buttonPressed(_ sender: Any)
    {
        changeImage()
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
    {
        changeImage()
    }
    func changeImage()
    {
        ballIndex = Int.random(in: 1 ... 5)
        ballImage.image = UIImage(named: "ball\(ballIndex)")
    }
}

