//
//  Results+CoreDataProperties.swift
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

extension Results {

    @NSManaged var name: String?
    @NSManaged var photo: NSData?
    @NSManaged var totalAnswered: String?
    @NSManaged var percentCorrect: String?

}
