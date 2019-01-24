//
//  MathQuestion.swift
//  Math Solver
//
//  Created by Loay on 9/6/18.
//  Copyright © 2018 Loay Productions. All rights reserved.
//

import Foundation

class MathQuestion{
    
    var signs = ["+", "-", "*", "/"]
    var lNum = 0
    var rNum = 0
    var opera = ""
    
    func nextQuestion() -> String{
        let q = makeQuestion()
        
        lNum = q.num1
        rNum = q.num2
        opera = q.sign
        
        let question = questionString(sign: opera, num1: lNum, num2: rNum)
        
        return question
    }
    
    func questionSolutionChecher(_ answer: Int) -> Bool{
        
        var ans = 0
        if opera == "+"{
            ans = lNum + rNum
        }else if opera == "-"{
            ans = lNum - rNum
        }else if opera == "*"{
            ans = lNum * rNum
        }else if opera == "/"{
            ans = lNum / rNum
        }
        
        if answer == ans{
            return true
        }
        
        return false
    }
    
    func questionString(sign: String, num1: Int, num2: Int) -> String{
        
        return "\(num1) \(sign) \(num2)"
    }
    
    func makeQuestion() -> (num1: Int, num2: Int, sign: String){
        
        let operation = getSign()
        var leftNum = 0
        var rightNum = 0
        
        if operation == "+"{
            leftNum = getNum(min: 0, max: 101)
            rightNum = getNum(min: 0, max: 101)
        }else if operation == "-"{
            leftNum = getNum(min: 0, max: 101)
            rightNum = getNum(min: 0, max: UInt32(leftNum+1))
        }else if operation == "*"{
            leftNum = getNum(min: 0, max: 13)
            rightNum = getNum(min: 0, max: 13)
        }else if operation == "/"{
            leftNum = getNum(min: 1, max: 21)
            rightNum = getNum(min: 1, max: UInt32(leftNum+1))
        }
        
        return (leftNum, rightNum, operation)
    }
    
    func getSign() -> String{
        
        let randIndex = signs.index(signs.startIndex, offsetBy: signs.count.randomNum)
        //print("sign index \(randIndex)")
        
        return "\(signs[randIndex])"
    }
    
    func getNum(min: UInt32, max: UInt32) -> Int{
        
        let randNum = Int(arc4random_uniform(max) + min)
        
        return randNum
    }
    
}

extension Int{
    
    var randomNum: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(self)))
        }else{
            return 0
        }
    }
}
