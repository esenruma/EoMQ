//
//  ViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var tableView: UITableView!
    
    var resultsList : [Results] = []
    
    
// ---------------------------------------
    @IBAction func settingsButton(sender: AnyObject) {
        performSegueWithIdentifier("toSettings", sender: self)
    }
    
// ---------------------------------------
    @IBAction func startButton(sender: AnyObject) {
        performSegueWithIdentifier("toQuestions", sender: self)
    }
    
// ---------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! CustomCell
        
        let accessToEntity = self.resultsList[indexPath.row]
        cell.nameLabelCustom.text = accessToEntity.name
        cell.imageViewCustom?.image = UIImage(data: accessToEntity.photo!)
        
        let correct = accessToEntity.percentCorrect
        let totalQ = accessToEntity.totalAnswered
        cell.resultsLabelCustom.text = "\(correct!) out of \(totalQ!) Questions!"
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            context.deleteObject(self.resultsList[indexPath.row]) // Always before as CoreD
            self.resultsList.removeAtIndex(indexPath.row)
            
                do {
                    try context.save()
                } catch {
                    print("Error unable to save Deletion")
                }
        } // end IF EditingStyle
        
        self.tableView.reloadData()
    }
    
// ---------------------------------------
    override func viewWillAppear(animated: Bool) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Results")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                self.resultsList = results as! [Results]
            }
        } catch {
            print("Unable to Fetch 'Results' Entity")
        }
        
        // Refresh TAble
        self.tableView.reloadData()
        
    }
    
    
// ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add Questions x5
//        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let context: NSManagedObjectContext = appDel.managedObjectContext
//        
//        let addNewQuestion = NSEntityDescription.insertNewObjectForEntityForName("QuestionsDB", inManagedObjectContext: context) as! QuestionsDB
//        
//        addNewQuestion.number = "5"
//        addNewQuestion.question = "What is Max Weber 1864 - 1920, associated with?"
//        
//        addNewQuestion.optionA = "Bureaucracy"
//        addNewQuestion.optionB = "Tradition "
//        addNewQuestion.optionC = "Military"
//        addNewQuestion.optionD = "Communication"
//        
//        addNewQuestion.correctAnswer = "Bureaucracy"
//        
//        do {
//            try context.save()
//            print("Saved !!!")
//
//        } catch {
//            print("Error Saving Data to CoreD")
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}








