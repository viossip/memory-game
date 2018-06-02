//
//  Highscores.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//
import CoreData
import Foundation


class Highscores: NSManagedObject {
    @NSManaged var id: String!
    @NSManaged var name: String!
    @NSManaged var level :String!
    @NSManaged var score: String!
    @NSManaged var time: String!
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    @discardableResult
    func save() -> Bool {
        var isSaved = false
        do {
            try self.managedObjectContext?.save()
            isSaved = true
        } catch {
            print("Error: failed to save user (\(self)) in Core Data: \(error)")
        }
        return isSaved
    }
    func remove() -> Bool {
        self.managedObjectContext?.delete(self)
        return true
    }
}

