//
//  CoreDataHandler.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/16.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(stationName: String, stationID: Int16, hasFavorited: Bool) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ButtonStatus", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(stationName, forKey: "stationName")
        manageObject.setValue(stationID, forKey: "stationID")
        manageObject.setValue(hasFavorited, forKey: "hasFavorited")
        
        do {
            try context.save()
            return true
        } catch  {
            return false
        }
    }
    
    class func fetchObject() -> [ButtonStatus]? {
        let context = getContext()
        var buttonStatus:[ButtonStatus]? = nil
        do {
            buttonStatus = try context.fetch(ButtonStatus.fetchRequest())
            return buttonStatus
        } catch  {
            return buttonStatus
        }
    }
    
}
