//
//  Highscores.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//
import CoreData
import Foundation


class Highscores {
     var contextLocal : NSManagedObjectContext!
     var id: String!
     var name: String!
     var myLevel :String!
     var score: String!
     var time: String!
//     var someInts = [Highscores]()
    var entityName :String!
    
   

    init(insertInto contextLocal: NSManagedObjectContext?,id : String,name : String,myLevel : String,score: String,time : String,entityName:String) {
        self.contextLocal = contextLocal
        self.id = id
        self.name = name
        self.myLevel = myLevel
        self.score = score
        self.time = time
        self.entityName = entityName

    }
//
//    func addNewUser()
//    {
//         let newUser = NSEntityDescription.insertNewObject(forEntityName: entityName , into: context)
//        newUser.setValue(self.name, forKey: "name")
//        newUser.setValue(self.myLevel, forKey: "level")
//        newUser.setValue(self.id, forKey: "id")
//        newUser.setValue(self.score, forKey: "score")
//
//
//    }
//    @discardableResult
//    func save() -> Bool
//    {
//        var isSaved = false
//        do {
//            try context.save()
//            isSaved = true
//
//        } catch {
//            print("Error: failed to save user (\(self)) in Core Data: \(error)")
//        }
//        return isSaved
//    }
//    func remove() -> Bool {
//        self.managedObjectContext?.delete(self)
//        return true
//    }
    
    
//    func getHighScores ()
//    {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName )
//        //request.predicate = NSPredicate(format: "age = %@", "12")
//        request.returnsObjectsAsFaults = false
//        
//        do {
//            
//            
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject]
//                
//            {
//                var tempClass = Highscores(insertInto: <#NSManagedObjectContext?#>, id: <#String#>, name: <#String#>)
//                print(data.value(forKey: "name") as! String)
//                print(data.value(forKey: "id") as! String)
//                
//            }
//            
//        } catch {
//            
//            print("Failed")
//        }
//        
//    }
    
    
}

