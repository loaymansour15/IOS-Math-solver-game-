//
//  ViewController.swift
//  Math Solver
//
//  Created by Loay on 9/5/18.
//  Copyright © 2018 Loay Productions. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var mq = MathQuestion()

    var errorValue = 11
    lazy var errorCounter:Int = errorValue
    let scoreValue:Int = 10
    var currScore:Int = 0
    
    @IBOutlet weak var BestScoreLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var QuestionFiled: UILabel!
    @IBOutlet weak var AnswerField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(saveOnExit), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveOnExit), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        
        print("highScore \(fetchHighScore())")
        BestScoreLabel.text = String(fetchHighScore())
        
        QuestionFiled.text = mq.nextQuestion()
    }
    
    @IBAction func SolveButton(_ sender: UIButton) {
        
        if !(AnswerField.text?.isEmpty)!{
            
            gameController()
        }else{
            
            showMessage(t: "No Answer", msg: "Please Solve the Problem", actionTitle: "Ok")
        }
    }
    
    func gameController(){
        
        let ans = Int(AnswerField.text!)
        let solved = mq.questionSolutionChecher(ans!)
        if solved {
            QuestionFiled.text = ""
            AnswerField.text = ""
            scoreController(ans: true)
            
            errorCounter = errorValue
            QuestionFiled.text = mq.nextQuestion()
        }else{
            AnswerField.text = ""
            errorCounter -= 1
            scoreController(ans: false)
            shortAlertPeriod(t: "Wrong Answer", msg: "Please Try Again")
        }
    }
    
    func showMessage(t: String, msg: String, actionTitle: String){
        
        let alert = UIAlertController(title: t, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default,handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func shortAlertPeriod(t: String, msg: String) {
        let alert = UIAlertController(title: t, message: msg, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func scoreController(ans: Bool){
        if ans{
            
            currScore += scoreValue
            ScoreLabel.text = String(currScore)
        }else{
           
            if errorCounter <= 0{
                errorCounter = 1
            }
            currScore -= Int(ceil(Double(scoreValue/errorCounter)))
            if currScore <= 0{
                currScore = 0
            }
            ScoreLabel.text = String(currScore)
        }
    }
    
    func saveHighScore(score: Int){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ScoreClass", in: context)
        let highScore = NSManagedObject(entity: entity!, insertInto: context)
        
        highScore.setValue(score, forKeyPath: "highScore")
        
        do {
            try context.save()
            print("Saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchHighScore() -> Int{
        
        var ans = 0
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ScoreClass")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                ans = data.value(forKey: "highScore") as! Int
            }
            
        } catch {
            
            print("Failed")
        }
        
        return ans
    }
    
    @objc func saveOnExit() {
        let highScore = fetchHighScore()
        if currScore > highScore{
            print("curr Score: \(currScore) highScore \(highScore)")
            saveHighScore(score: currScore)
        }
    }

}

