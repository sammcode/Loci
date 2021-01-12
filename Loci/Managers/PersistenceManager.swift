//
//  PersistenceManager.swift
//  Loci
//
//  Created by Sam McGarry on 1/11/21.
//

import UIKit
import CoreData

class PersistenceManager {
    
    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentCloudKitContainer = {
        
        PinsDataValueTransformer.register()
        PinTypesDataValueTransformer.register()
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Loci")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func retrievePins() -> [Pin] {
        var pins: [Pin] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pins")
        do {
            let result = try context.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let pin = data.value(forKey: "pin") as? Pin
                pin?.coordinate.longitude = data.value(forKey: "longitude") as? Double ?? 0.0
                pin?.coordinate.latitude = data.value(forKey: "latitude") as? Double ?? 0.0
                print(pin!.coordinate.latitude)
                pins.append(pin!)
            }
        }catch {
            print("failed")
        }
        return pins
    }
    
    static func retrievePinTypes() -> [PinType] {
        var pintypes: [PinType] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PinTypes")
        
        do {
            let result = try context.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let pintype = data.value(forKey: "pintype") as? PinType
                pintypes.append(pintype!)
            }
        }catch {
            print("failed")
        }
        return pintypes
    }
    
    static func saveNewPin(pin: Pin){
        let entityPin = NSEntityDescription.entity(forEntityName: "Pins", in: context)!
        
        let mPin = NSManagedObject(entity: entityPin, insertInto: context)
        
        mPin.setValue(pin, forKey: "pin")
        mPin.setValue(pin.coordinate.latitude, forKey: "latitude")
        mPin.setValue(pin.coordinate.longitude, forKey: "longitude")
        
        PersistenceManager.saveContext()
        print("successfully saved!")
    }
    
    static func saveNewPinType(pin: PinType){
        let entityPintype = NSEntityDescription.entity(forEntityName: "Pintypes", in: context)!
        
        let mPintype = NSManagedObject(entity: entityPintype, insertInto: context)
        
        mPintype.setValue(pin, forKey: "pintype")
        
        PersistenceManager.saveContext()
    }
}

