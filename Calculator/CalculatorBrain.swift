//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Remi Roques on 30/05/15.
//  Copyright (c) 2015 Remi Roques. All rights reserved.
//

import Foundation

public class CalculatorBrain {
    
    private var ops = [Op]()
    
    private var knownOperators = [String:Op]()
    
    enum Op: Printable{
        case Operand(Double)
        case UnaryOperator(String, Double -> Double)
        case Operator(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Operator(let symbol, _):
                    return symbol
                case .UnaryOperator(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    public init() {
        knownOperators["+"] = Op.Operator("+", +)
        knownOperators["−"] = Op.Operator("−") { $1 - $0}
        knownOperators["×"] = Op.Operator("×", *)
        knownOperators["÷"] = Op.Operator("÷") { $1 / $0}
        knownOperators["√"] = Op.UnaryOperator("√", sqrt)
        knownOperators["sin"] = Op.UnaryOperator("sin", sin)
        knownOperators["cos"] = Op.UnaryOperator("cos", cos)
    }
    
    func addOperand (operand: Double) -> (Double?, [Op]) {
        ops.append(Op.Operand(operand))
        return perform()
    }
    
    func addOperand (symbol: String) -> (Double?, [Op]) {
        if let operation = knownOperators[symbol] {
            ops.append(operation)
        }
        return perform()
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remaindingOps: [Op]) {
        if ops.count > 0 {
            var remaining = ops;
            let op = remaining.removeLast()
            switch op {
            case Op.Operand(let operand):
                return (operand, remaining)
            case Op.UnaryOperator(_, let operation):
                let operandEvaluation = evaluate(remaining)
                if let operand = operandEvaluation.result {
                    return (operation(operand), remaining)
                }

            case Op.Operator(_, let operation):
                let operand1Evaluation = evaluate(remaining)
                if let operand1 = operand1Evaluation.result {
                    let operand2Evaluation = evaluate(operand1Evaluation.remaindingOps)
                    if let operand2 = operand2Evaluation.result {
                        return (operation(operand1, operand2), operand2Evaluation.remaindingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func perform() -> (Double?, [Op]) {
        let (result, remainingOps) = evaluate(ops)
        return (result, remainingOps);
    }
    
    func clear() {
        ops.removeAll()
    }
    
}