//
//  Database.swift
//  FoodApp
//
//  Created by MAC OSX on 12/4/20.
//  Copyright © 2020 Mitesh's MAC. All rights reserved.
//
import SQLite
import Foundation

class Database{
    static let shared = Database()
    public let connection:Connection?
    public let databaseName = "db.sqlite3"
    private init(){
        let dbPath=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String?
        do{
            connection = try Connection("\(dbPath!)/ (databaseName)");
        }catch{
            connection=nil
            let nsError=error as NSError
            print("Connection database. Error is \(nsError), \(nsError.userInfo)")
        }
    }
}
