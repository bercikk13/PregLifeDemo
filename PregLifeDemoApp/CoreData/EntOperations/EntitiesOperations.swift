//
//  EntitiesOperations.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 02/12/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import Foundation
import CoreData


protocol EntitiesOperationsProtocol {
    associatedtype DataModel = AnyObject
    init()
    func execute(forContext context: NSManagedObjectContext, data: DataModel)
}

class EntitiesOperationsBase {
    
    internal func fetch(forContext context: NSManagedObjectContext, entityName: String, predicate: NSPredicate) -> [NSManagedObject]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do{
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            
            return fetchResults
            
        }catch{
            print("Error on fetch: \(error)")
            return nil
        }
    }
    
    internal func fetch(forContext context: NSManagedObjectContext, entityName: String) -> [NSManagedObject]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do{
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            
            return fetchResults
            
        }catch let error {
            print("Error on fetch: \(error)")
            return nil
        }
    }
}

/**
 Operation example!!!
 */
class CoreDataEntityOperationExample: EntitiesOperationsProtocol {
    func execute(forContext context: NSManagedObjectContext, data: Bool) {
        fatalError("CoreDataEntityOperationExample is only a example!!!")
    }
    
    required init() {
        fatalError("CoreDataEntityOperationExample is only a example!!!")
    }
}


/**
 Object that is used by core data manager to run some operations
 */
protocol CoreDataOperationProtocol {
    func execute(forContext context: NSManagedObjectContext)
}

class CoreDataOperation<T: EntitiesOperationsProtocol>: CoreDataOperationProtocol {
    
    private let data: T.DataModel
    
    init(data: T.DataModel) {
        self.data = data
    }
    
    func execute(forContext context: NSManagedObjectContext) {
        let operation = T()
        operation.execute(forContext: context, data: data)
    }
    
}
