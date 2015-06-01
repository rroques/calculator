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
    @IBOutlet weak var history: UILabel!
    
    var brain = CalculatorBrain()
    
    @IBAction func clear() {
        userIsInTheMidleOfTypingSomething = false
        brain.clear()
        displayValue = 0
        displayHistory = ""
    }
    
    @IBAction func backspace() {
        if userIsInTheMidleOfTypingSomething {
            display.text = dropLast(display.text!)
        }
    }
    
    var userIsInTheMidleOfTypingSomething = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if (digit == "." && display.text!.rangeOfString(".") != nil) {
            return
        }
        if userIsInTheMidleOfTypingSomething {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMidleOfTypingSomething = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMidleOfTypingSomething {
            enter()
        }
        if let operation = sender.currentTitle {
            let (result, history) = brain.addOperand(operation)
            if (result != nil) {
                displayValue = result!
                displayHistory = "\(history)"
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enterConstant(sender: UIButton) {
        let constant = sender.currentTitle!
        if userIsInTheMidleOfTypingSomething {
            enter()
        }
        switch (constant) {
        case "π" : displayValue = M_PI
        default: break
        }
        enter()
    }
    
    @IBAction func enter() {
        userIsInTheMidleOfTypingSomething = false
        brain.addOperand(displayValue)
    }
    
    var displayValue: Double {
        set {
            display.text = "\(newValue)"
        }
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
    }
    
    var displayHistory: String {
        set {
            history.text = "\(newValue)"
        }
        get {
            return history.text!
        }
    }
}

