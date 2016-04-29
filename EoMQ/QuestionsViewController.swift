//
//  QuestionsViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

var totalQuestions = 0
var totalCorrects = 0

class QuestionsViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var optionA: UIButton!
    @IBOutlet var optionB: UIButton!
    @IBOutlet var optionC: UIButton!
    @IBOutlet var optionD: UIButton!
    @IBOutlet var submit: UIButton!
    
    @IBOutlet var resultsLabel: UILabel!
  
    @IBOutlet var next: UIButton!
    
    var rightAnswerFromFetch = String() // store String Correct Answer from Fetch-To compare
    var selectedAnswer = String() // which Option=Selected? // last one selected B4 'Submit'
    
    var ifOptionSelected : Int = 0 // fix SubmitButton- Ensure Alert if Option Not selected
    
// ---------------------------------------
    @IBAction func cancelButtonQ(sender: AnyObject) {
        totalCorrects = 0
        totalQuestions = 0
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
// ---------------------------------------
    @IBAction func finishButton(sender: AnyObject) {
        
        // if No Q's Answered = Alert + return to Home VC
        if totalQuestions == 0 {
            let alert = UIAlertController(title: "Alert", message: "No Questions Answered!!", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Cancel, handler: {
                UIAlertAction in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            performSegueWithIdentifier("questionsToResults", sender: self)
        }
    }
    
// ---------------------------------------
    @IBAction func nextQuestionButton(sender: AnyObject) {
        
        // ** Clear All button colors
        self.optionA.backgroundColor = UIColor.clearColor()
        self.optionB.backgroundColor = UIColor.clearColor()
        self.optionC.backgroundColor = UIColor.clearColor()
        self.optionD.backgroundColor = UIColor.clearColor()
        
        self.next.backgroundColor = UIColor.clearColor()
        
        // Enable 4 option Buttons
        self.optionA.enabled = true
        self.optionB.enabled = true
        self.optionC.enabled = true
        self.optionD.enabled = true
        self.submit.enabled = true
        
        // results Label Clear
        self.resultsLabel.text = ""
        
        // Reset ifOptionSelected - back to "0"
        self.ifOptionSelected = 0
        
        // Call RN Q.'s again
        getRandomQuestion()
    }
    
// ---------------------------------------
    @IBAction func submitButton(sender: AnyObject) {
        
        // check if an Option is selected 1st - if Not - goto Alert
        if self.optionA.backgroundColor == UIColor.yellowColor() {
            self.ifOptionSelected = 1
        } else if self.optionB.backgroundColor == UIColor.yellowColor() {
            self.ifOptionSelected = 1
        } else if self.optionC.backgroundColor == UIColor.yellowColor() {
            self.ifOptionSelected = 1
        } else if self.optionD.backgroundColor == UIColor.yellowColor() {
            self.ifOptionSelected = 1
        }
        
        // Alert -reminder if no Options are Selected
        if self.ifOptionSelected == 0  {
        
            let alert = UIAlertController(title: "Alert", message: "Please select an Option!", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Cancel, handler: {
                UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
        
            // disable any further options being chosen
            self.optionA.enabled = false
            self.optionB.enabled = false
            self.optionC.enabled = false
            self.optionD.enabled = false
            self.submit.enabled = false
        
            // Check if answer = Correct
            if self.selectedAnswer == self.rightAnswerFromFetch {
                self.resultsLabel.text = "That's RIGHT !!!"
                totalCorrects = totalCorrects + 1
            
            } else {
                self.resultsLabel.text = "Sorry - that's wrong! It is... \(self.rightAnswerFromFetch)"
            } // end IF
        
            // Highlight next-STEP toDo
            self.next.backgroundColor = UIColor.redColor()
        
            // Add tot.Q's to GLobal + (ScoreLabel)
            totalQuestions = totalQuestions + 1
        
            self.scoreLabel.text = "\(totalCorrects) correct out of \(totalQuestions)"
            print(totalCorrects) ; print(totalQuestions)
            
        } // end 1st IF
    }
    
// --------------Option Selections-----------------
    @IBAction func answerAAction(sender: AnyObject) {
        // ** Keep Yellow + clear other button colors
        self.optionA.backgroundColor = UIColor.yellowColor() //*A*
        self.optionB.backgroundColor = UIColor.clearColor()
        self.optionC.backgroundColor = UIColor.clearColor()
        self.optionD.backgroundColor = UIColor.clearColor()
        
        // ** Pass this choice to VAR 'selectedAnswer'
        self.selectedAnswer = (optionA.titleLabel?.text)!
        print(selectedAnswer)
    }
    
    @IBAction func answerBAction(sender: AnyObject) {
        // ** Keep Yellow + clear other button colors
        self.optionB.backgroundColor = UIColor.yellowColor() //*B*
        self.optionA.backgroundColor = UIColor.clearColor()
        self.optionC.backgroundColor = UIColor.clearColor()
        self.optionD.backgroundColor = UIColor.clearColor()
        
        // ** Pass this choice to VAR 'selectedAnswer'
        self.selectedAnswer = (optionB.titleLabel?.text)!
        print(selectedAnswer)
    }

    @IBAction func answerCAction(sender: AnyObject) {
        // ** Keep Yellow + clear other button colors
        self.optionC.backgroundColor = UIColor.yellowColor() //*C*
        self.optionA.backgroundColor = UIColor.clearColor()
        self.optionB.backgroundColor = UIColor.clearColor()
        self.optionD.backgroundColor = UIColor.clearColor()
        
        // ** Pass this choice to VAR 'selectedAnswer'
        self.selectedAnswer = (optionC.titleLabel?.text)!
        print(selectedAnswer)
    }
    
    @IBAction func answerDAction(sender: AnyObject) {
        // ** Keep Yellow + clear other button colors
        self.optionD.backgroundColor = UIColor.yellowColor() //*D*
        self.optionA.backgroundColor = UIColor.clearColor()
        self.optionB.backgroundColor = UIColor.clearColor()
        self.optionC.backgroundColor = UIColor.clearColor()
        
        // ** Pass this choice to VAR 'selectedAnswer'
        self.selectedAnswer = (optionD.titleLabel?.text)!
        print(selectedAnswer)
    }
    
// ---------------------------------------
    func getRandomQuestion() {
        // RN No.
        var randomNumber = arc4random() % 5
        randomNumber += 1
        let randomNoString = String(randomNumber)
        
        // ** Fetch
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "QuestionsDB")
        request.predicate = NSPredicate(format: "number = %@", randomNoString)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                
                    if let question2ask = result.valueForKey("question") as? String {
                        self.questionLabel.text = question2ask
                    }
                
                    if let optionAask = result.valueForKey("optionA") as? String {
                        optionA.setTitle(optionAask, forState: UIControlState.Normal)
                    }
                    
                    if let optionBask = result.valueForKey("optionB") as? String {
                        optionB.setTitle(optionBask, forState: UIControlState.Normal)
                    }
                    
                    if let optionCask = result.valueForKey("optionC") as? String {
                        optionC.setTitle(optionCask, forState: UIControlState.Normal)
                    }
                    
                    if let optionDask = result.valueForKey("optionD") as? String {
                        optionD.setTitle(optionDask, forState: UIControlState.Normal)
                    }
                    
                    if let correct = result.valueForKey("correctAnswer") as? String {
                        self.rightAnswerFromFetch = correct // ** Use with SubmitButton
                    }
                    
                    
                } // end For..in..loop
                
            } // end IF
            
        } catch {
            print("Error fetching results")
        } // end 'do-catch'
        
        
    }
   
// ---------------------------------------
    override func viewWillAppear(animated: Bool) {
        // update Scores at Top
        self.scoreLabel.text = "\(totalCorrects) correct out of \(totalQuestions)"
    }
    
// ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentSize.height = 667
        self.scrollView.contentSize.width = 375
        
        // ** Call Questions at Random **
        getRandomQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
