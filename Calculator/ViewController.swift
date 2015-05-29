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
    
    @IBAction func clear() {
        userIsInTheMidleOfTypingSomething = false
        operandsStack.removeAll()
        displayValue = 0
        operandsHistory.removeAll()
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
        let operation = sender.currentTitle!
        if userIsInTheMidleOfTypingSomething {
            addToHistory(display.text!)
            enter()
        }
        addToHistory(operation)
        switch (operation) {
        case "+" : performWithTwoOperators { $0 + $1 }
        case "−" : performWithTwoOperators { $1 - $0}
        case "×" : performWithTwoOperators { $0 * $1 }
        case "÷" : performWithTwoOperators { $1 / $0 }
        case "√" : performWithOneOperator { sqrt($0)}
        case "sin" : performWithOneOperator { sin($0)}
        case "cos" : performWithOneOperator { cos($0)}
        default: break
        }
    }
    
    @IBAction func enterConstant(sender: UIButton) {
        let constant = sender.currentTitle!
        if userIsInTheMidleOfTypingSomething {
            addToHistory(display.text!)
            enter()
        }
        addToHistory(constant)
        switch (constant) {
        case "π" : displayValue = M_PI
        default: break
        }
        enter()
    }
    
    func performWithTwoOperators(operation: (Double, Double) -> Double) {
        if operandsStack.count > 1 {
            displayValue = operation(operandsStack.removeLast(), operandsStack.removeLast())
            enter()
        }
    }
    
    func performWithOneOperator(operation: Double -> Double) {
        if operandsStack.count > 0 {
            displayValue = operation(operandsStack.removeLast())
            enter()
        }
    }
    
    var operandsStack = Array<Double>()
    var operandsHistory = Array<String>()
    
    @IBAction func enter() {
        userIsInTheMidleOfTypingSomething = false
        operandsStack.append(displayValue)
        //addToHistory("\(displayValue)")
    }
    
    func addToHistory(value: String) {
        operandsHistory.append(value)
        displayHistory = "\(operandsHistory)"
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

