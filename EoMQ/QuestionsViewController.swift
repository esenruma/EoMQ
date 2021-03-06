//
//  QuestionsViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

// ** For Results VC **
var totalQuestions = 0  // To Hold Score-Total 'SubmitButton'
var totalCorrects = 0   // To Hold Score-Correct 'SubmitButton'

// Values Set from StartButton - HomeVC
var questionsListNumbers : [String] = [] // = 100 questions // For Rn(minusPast)
var randomRange = Int() // from 0 - 99 = 100 questions // For Rn(minusPast)
// ------------------------------

class QuestionsViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var questionLabel: UILabel! // make class 'InsetLabel' instead
    
    
    @IBOutlet var optionA: UIButton!
    @IBOutlet var optionB: UIButton!
    @IBOutlet var optionC: UIButton!
    @IBOutlet var optionD: UIButton!
    @IBOutlet var submit: UIButton!
    
    @IBOutlet var resultsLabel: UILabel!
  
    @IBOutlet var next: UIButton!
    
    @IBOutlet var nextLabelForHighlight: UILabel!
    
    var rightAnswerFromFetch = String() // store String Correct Answer from Fetch-To compare
    var selectedAnswer = String() // which Option=Selected? // last one selected B4 'Submit'
    
    var ifOptionSelected : Int = 0 // SubmitButton- Ensures Alert if Option Not selected
    
    var audioPlayer : AVAudioPlayer?

    // ** Lite Animation set up **
    @IBOutlet var imageViewLiteAnimation: UIImageView!
    var isAnimating = false
    var counter = 1
    var timer = NSTimer()
    
    // ** Lines Animation **
    @IBOutlet weak var yellLine1: UIImageView!
    @IBOutlet weak var yellLine2: UIImageView!
    
// -----------Vertical Lines Animation--------------
    override func viewDidLayoutSubviews() {
        // Lines
        self.yellLine1.center = CGPointMake(self.yellLine1.center.x + 700, self.yellLine1.center.y)
        self.yellLine2.center = CGPointMake(self.yellLine2.center.x - 700, self.yellLine2.center.y)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.9) {
            // Lines
            self.yellLine1.center = CGPointMake(self.yellLine1.center.x - 700, self.yellLine1.center.y)
            self.yellLine2.center = CGPointMake(self.yellLine2.center.x + 700, self.yellLine2.center.y)
        }
    }
    
// ---------------------------------------
    func clickSound() {
        if soundAnimationOption == 1 {
            do {
                let path = NSBundle.mainBundle().pathForResource("Click", ofType: "wav")
                let url = NSURL(fileURLWithPath: path!)
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer!.play()
                
            } catch {
                print("Unable to play 'Click' Sound!!")
            } // end do-try-catch
        } // End If on sound animation
    }
    
// ---------------------------------------
    func alertSound() {
        if soundAnimationOption == 1 {
            do {
                let path = NSBundle.mainBundle().pathForResource("Alert_2secs", ofType: "m4a")
                let url = NSURL(fileURLWithPath: path!)
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer!.play()
    
            } catch {
                print("Unable to play 'Alert_2secs' Sound!!")
            } // end do-try-catch
        } // End If on sound animation
    }
    
// ---------------------------------------
    func cheeringFinished() {
        if soundAnimationOption == 1 {
            do {
                let path = NSBundle.mainBundle().pathForResource("Person_cheering", ofType: "mp3")
                let url = NSURL(fileURLWithPath: path!)
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer!.play()
                
            } catch {
                print("Unable to play 'Person_cheering' Sound!!")
            } // end do-try-catch
        } // End If on sound animation
    }
// ---------------------------------------
    func correctSound() {
        if soundAnimationOption == 1 {
            do {
                let path = NSBundle.mainBundle().pathForResource("Correct_KidLaugh", ofType: "mp3")
                let url = NSURL(fileURLWithPath: path!)
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer!.play()
                
            } catch {
                print("Unable to play 'Correct_KidLaugh' Sound!!")
            } // end do-try-catch
        } // end If on sound animation
    }
// ---------------------------------------
    func wrongSound() {
        if soundAnimationOption == 1 {
            do {
                let path = NSBundle.mainBundle().pathForResource("Wrong_thunder_secs", ofType: "m4a")
                let url = NSURL(fileURLWithPath: path!)
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer!.play()
                
            } catch {
                print("Unable to play 'Wrong_thunder_secs' Sound!!")
            } // end do-try-catch
        } // end If on sound animation
    }
    
// ---------------------------------------
    @IBAction func homeButton(sender: AnyObject) {
        clickSound()
        
        totalCorrects = 0
        totalQuestions = 0
        
        performSegueWithIdentifier("QuestionsToHome", sender: self)
        // self.dismissViewControllerAnimated(true, completion: nil) // Not use-'Dismiss' causes: "no" questions to show after "Start"button starts process again
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
            
            // Alert sound
            alertSound()
            
        } else {
            
            // ** Make sound-YiPPi !!! **
            cheeringFinished()
            
            performSegueWithIdentifier("questionsToResults", sender: self)
        }
    }
    
// ---------------------------------------
    @IBAction func nextQuestionButton(sender: AnyObject) {
        
        clickSound()
        
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
        self.resultsLabel.hidden = false
        self.resultsLabel.backgroundColor = UIColor.clearColor()
        
        // Next Button Highlighter Clear
        self.nextLabelForHighlight.backgroundColor = UIColor.clearColor()
        
        // Stop Lite Animation
        timer.invalidate()
        isAnimating = false
        self.imageViewLiteAnimation.image = UIImage()
            
        // Reset ifOptionSelected - back to "0"
        self.ifOptionSelected = 0
        
        // if Range <0 - do Alert and go to results = finished Quiz
        if randomRange < 1 {
            
            let alert = UIAlertController(title: "Alert", message: "No More Questions. Goto Results.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Cancel, handler: {
                UIAlertAction in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                // GoTo Results...
                self.performSegueWithIdentifier("questionsToResults", sender: self)
            })
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
           
            // Call RN Q.'s again
            getRandomQuestion()
        }
    }
    
// ---------------------------------------
    @IBAction func submitButton(sender: AnyObject) {
        
        // check if an Option is selected 1st - if Not - Need for ALERT
        if self.optionA.backgroundColor == UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0) {
            self.ifOptionSelected = 1
        } else if self.optionB.backgroundColor == UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0) {
            self.ifOptionSelected = 1
        } else if self.optionC.backgroundColor == UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0) {
            self.ifOptionSelected = 1
        } else if self.optionD.backgroundColor == UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0) {
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
            
            // ** Make Alert Sound **
            alertSound()
            
        } else {
        
            // disable any further options being chosen
            self.optionA.enabled = false
            self.optionB.enabled = false
            self.optionC.enabled = false
            self.optionD.enabled = false
            self.submit.enabled = false
        
            // Add tot.Q's to GLobal + (ScoreLabel)
            totalQuestions = totalQuestions + 1
            
            // Check if answer = Correct
            if self.selectedAnswer == self.rightAnswerFromFetch {
                
                self.resultsLabel.hidden = false
                self.resultsLabel.backgroundColor = UIColor.yellowColor()
                self.resultsLabel.text = "'✔'  RIGHT!!!"
                
                totalCorrects = totalCorrects + 1
                
                // ** Make sound-CORRECT!! **
                correctSound()
            
            } else {
                self.resultsLabel.hidden = false
                self.resultsLabel.backgroundColor = UIColor.yellowColor()
                self.resultsLabel.text = "'✖'  Wrong! It's- \n'\(self.rightAnswerFromFetch)'"
                
                
                // ** Make sound-WRONG!! **
                wrongSound()
                
            } // end IF
        
            // Highlight next-STEP toDo
            self.nextLabelForHighlight.backgroundColor = UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0)
            
            // ** Animation Timer **
            if isAnimating == false {
                timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(QuestionsViewController.liteAnimation), userInfo: nil, repeats: true)
                isAnimating = true
            }
            // ** Goto (Click) Next Button to Stop Timer

            
            // Score Update
            self.scoreLabel.text = "\(totalCorrects) correct out of \(totalQuestions)"
            print(totalCorrects) ; print(totalQuestions)
            
        } // end 1st IF
    } // End Func 
    
// --------------Animation Lite-----------------
    func liteAnimation() {
        
        if counter == 10 {
            counter = 1
        } else {
            counter += 1
        }
        self.imageViewLiteAnimation.image = UIImage(named: "Lite_\(counter)")
    }
    
// --------------Option Selections-----------------
    @IBAction func answerAAction(sender: AnyObject) {
        // ** Keep Red + clear other button colors
        self.optionA.backgroundColor = UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0) //*A*
        self.optionB.backgroundColor = UIColor.clearColor()
        self.optionC.backgroundColor = UIColor.clearColor()
        self.optionD.backgroundColor = UIColor.clearColor()
        
        // ** Pass this choice to VAR 'selectedAnswer'
        self.selectedAnswer = (optionA.titleLabel?.text)!
        
        // ** Make Sound
        clickSound()
        
    } // End Func
    
    @IBAction func answerBAction(sender: AnyObject) {
        // ** Keep Red + clear other button colors
        self.optionB.backgroundColor = UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0) //*B*
        self.optionA.backgroundColor = UIColor.clearColor()
        self.optionC.backgroundColor = UIColor.clearColor()
        self.optionD.backgroundColor = UIColor.clearColor()
        
        // ** Pass this choice to VAR 'selectedAnswer'
        self.selectedAnswer = (optionB.titleLabel?.text)!
        
        // ** Make Sound
        clickSound()
        
    } // End Func

    @IBAction func answerCAction(sender: AnyObject) {
        // ** Keep Red + clear other button colors
        self.optionC.backgroundColor = UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0) //*C*
        self.optionA.backgroundColor = UIColor.clearColor()
        self.optionB.backgroundColor = UIColor.clearColor()
        self.optionD.backgroundColor = UIColor.clearColor()
        
        // ** Pass this choice to VAR 'selectedAnswer'
        self.selectedAnswer = (optionC.titleLabel?.text)!
        
        // ** Make Sound
        clickSound()
        
    } // End Func
    
    @IBAction func answerDAction(sender: AnyObject) {
        // ** Keep Red + clear other button colors
        self.optionD.backgroundColor = UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0) //*D*
        self.optionA.backgroundColor = UIColor.clearColor()
        self.optionB.backgroundColor = UIColor.clearColor()
        self.optionC.backgroundColor = UIColor.clearColor()
        
        // ** Pass this choice to VAR 'selectedAnswer'
        self.selectedAnswer = (optionD.titleLabel?.text)!
        
        // ** Make Sound
        clickSound()
        
    } // End Func
    
// ---------------------------------------
    func getRandomQuestion() {
        
        if pickerSelection == 0 {
            // Gen. RN No.
            var randomNumber = arc4random_uniform(101) // 0-100
            randomNumber += 1 // 1-100 i.e. questions from 1 to 100
            let randomNoString = String(randomNumber) // convert to Str for Predicate CoreD
        
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
        } // end IF pickerSelection == 0
        
        else if pickerSelection == 1 { // Rn.No (minus Past Ones)
            
            // RN No.(minus Past)
            let convertedIntRandomRange = UInt32(randomRange) // Int: 100 - converted Int to UInt32 for arc4Random
            let randomNumber = arc4random_uniform(convertedIntRandomRange) // 0-99=100 in Indx as UInt32
            
            let selectedNumberFromArray = questionsListNumbers[Int(randomNumber)] // convert UInt32 to Int to use in Array Indx... to Give Value as.."selectedNumberFromArray"
            
            // remove the value for this Indx so not Use again
            questionsListNumbers.removeAtIndex(Int(randomNumber))
            
            // use "selectedNumberFromArray" for Predicate after convert to String
            let randomString = String(selectedNumberFromArray)
            
            
            // ** Fetch
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            
            let request = NSFetchRequest(entityName: "QuestionsDB")
            request.predicate = NSPredicate(format: "number = %@", randomString)
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
            
            // reduce Global RandomRange by 1
            randomRange = randomRange - 1
            
        } // end IF pickerSelection == 1
    } // End FUNC

// ---------------------------------------
    override func viewWillAppear(animated: Bool) {
        // update Scores at Top
        self.scoreLabel.text = "\(totalCorrects) correct out of \(totalQuestions)"
        
        // Fix prob. of no Questions showing when repeatedly moving to + from btn Home Start - Questions Back buttons
        if self.questionLabel.text == "Question" {
            getRandomQuestion()
        }
        
        // results Label = Hidden
        self.resultsLabel.hidden = true
        
    } // End FUNC
    
// ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ** ScrollView **
        self.scrollView.contentSize.height = 667
        
        // ** Call Questions at Random **
        getRandomQuestion()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
