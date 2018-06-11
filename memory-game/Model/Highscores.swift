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
    
    public var description: String { return "+++HighScore: \(self.name)" }
}

