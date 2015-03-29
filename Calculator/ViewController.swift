//
//  ViewController.swift
//  Calculator
//
//  Created by Remi Roques on 28/03/15.
//  Copyright (c) 2015 Remi Roques. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMidlleOfTypingSomething: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMidlleOfTypingSomething {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMidlleOfTypingSomething = true
        }
    }
    
}

