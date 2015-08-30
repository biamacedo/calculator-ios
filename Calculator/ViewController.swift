//
//  ViewController.swift
//  Calculator
//
//  Created by Beatriz Macedo on 8/20/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." && display.text!.rangeOfString(".") != nil {
            return
        }
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        updateHistory()
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        updateHistory()
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        updateHistory()
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = 0
        brain.clear()
        updateHistory()
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            display.text = dropLast(display.text!)
            if display.text! == ""{
                displayValue = 0
            }
        }
    }
    
    @IBAction func invertSign() {
        display.text = "\(displayValue * -1)"
        if !userIsInTheMiddleOfTypingANumber {
            enter()
        }
    }
    
    var displayValue: Double {
        get {
            // Constants
            switch display.text! {
            case "π":
                return M_PI
            default:
                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    func updateHistory() {
        historyDisplay.text = brain.stackText()
    }
}

