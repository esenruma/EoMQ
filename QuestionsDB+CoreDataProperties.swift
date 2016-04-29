//
//  QuestionsDB+CoreDataProperties.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension QuestionsDB {

    @NSManaged var number: String?
    @NSManaged var question: String?
    @NSManaged var optionA: String?
    @NSManaged var optionB: String?
    @NSManaged var optionC: String?
    @NSManaged var optionD: String?
    @NSManaged var correctAnswer: String?

}
