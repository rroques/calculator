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
    
    var userIsInTheMidlleOfTypingSomething = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMidlleOfTypingSomething {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMidlleOfTypingSomething = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMidlleOfTypingSomething {
            enter()
        }
        switch (operation) {
        case "+" : performOperation { $0 + $1 }
        case "−" : performOperation { $1 - $0}
        case "×" : performOperation { $0 * $1 }
        case "÷" : performOperation { $1 / $0 }
        case "√" : performOperation { sqrt($0)}
        default: break
        }
    
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandsStack.count > 1 {
            displayValue = operation(operandsStack.removeLast(), operandsStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandsStack.count > 0 {
            displayValue = operation(operandsStack.removeLast())
            enter()
        }
    }
    
    var operandsStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMidlleOfTypingSomething = false
        operandsStack.append(displayValue)
        println("\(operandsStack)")
    }
    
    var displayValue: Double {
        set {
            display.text = "\(newValue)"
        }
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
    }
}

