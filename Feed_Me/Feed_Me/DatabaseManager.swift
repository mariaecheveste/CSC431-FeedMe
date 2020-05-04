//
//  DatabaseManager.swift
//  Feed_Me
//
//  Created by Maria Echeveste on 4/24/20.
//  Copyright © 2020 Sam Mistretta. All rights reserved.
//

import UIKit;
import Foundation;
import SQLite3;


class DatabaseManager: NSObject {
        
    static let shared: DatabaseManager = DatabaseManager()
    private let dbFileName = "restaurants.db"
    private var database:FMDatabase!

    override init() {
        super.init()
        if openDatabase() {
            print("Open for Business!")
        }
    }

    func openDatabase() -> Bool {
        //let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        //let dbPath = documentsDirectory.appending("/\(dbFileName)")
        let resourcePath = Bundle.main.resourceURL!.absoluteString
        let dbPath = resourcePath+dbFileName
        let database = FMDatabase(path: dbPath)

        /* Open database read-only. */
        if (!database.open(withFlags: 1)) {
            print("Could not open database at \(dbPath).")
            return false
        } else {
            self.database = database;
        }
        return true
    }

    func closeDatabase() {
        if (database != nil) {
            if database.close(){
                print("Database Closed!")
            }
        }
    }

    func query(queryString:String, keys:[String]) -> Array<Array<String>>{
        let db = database
        var data = Array<[String]>()
        var query = [String]()
        if let q = try?db?.executeQuery(queryString, values:nil) {
            while q.next() {
                for key in keys{
                    query.append(q[key] as! String)
                }
                // Do whatever here with fetched data, usually add it to an array and return that array
                data.append(query);
                query.removeAll()
            }
                
        }
        return data;
    }

}
