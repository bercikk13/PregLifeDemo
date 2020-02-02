//
//  CDManager.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 02/12/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//


import CoreData
import Foundation
import UIKit

class CDManager {
    
   // internal var mainContext: NSManagedObjectContext
    static let shared = CDManager()
    internal var operationQueue: OperationQueue
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = self.mainContext
        
        return managedObjectContext
    }()
    lazy var mainContext: NSManagedObjectContext = {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        
        return viewContext
        
    }()
    
    private init() {
        
//        var appDelegate: AppDelegate!
//        let group = DispatchGroup()
//
//        group.enter()
//        DispatchQueue.main.async {
//            //UIApplication.shared.delegate Must be call in main thread
//            appDelegate = UIApplication.shared.delegate as! AppDelegate
//            group.leave()
//        }
//
//        // wait ...
//        group.wait()
        
        //Manage object context from app delegate
        //Concurency type: main queue
     //   self.mainContext = appDelegate.persistentContainer.viewContext
        
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.name = "CoreDataOperationQueue"
    }
    
    
    func addOperation(operation: CoreDataOperationProtocol) {
        let cdOperation = CoreDataOperation2(context: privateManagedObjectContext, operation: operation)
        self.operationQueue.addOperation(cdOperation)
    }
    
    
    /**
     Try push changes to PersistentStoreCoordinator (permament record)
     It run save on mainQueueManageObjectContext
     */
    func pushToPersistance(){
        mainContext.perform { [weak self] in
            if let context = self?.mainContext {
                if context.hasChanges {
                    do{
                        try self?.mainContext.save()
                    }catch let error{
                        print("Error on push to persistance: \(error)")
                    }
                }
            }
        }
    }
    
}



//MARK: Fetch data
extension CDManager {
    
    /**
     Return all existed items
     */
    func getAllItems() -> [ItemEntity]? {
        
        //Create fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        
        //Make fetch
        do{
            let fetchResults = try mainContext.fetch(fetchRequest) as? [ItemEntity]
            
            return fetchResults
            
        }catch let error {
            print("Error on fetch: \(error)")
            return nil
        }
        
    }
    func getAllItemsNumber() -> Int {
        
        //Create fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        
        //Make fetch
        do{
            let fetchResults = try mainContext.fetch(fetchRequest) as? [ItemEntity]
            
            return fetchResults!.count
            
        }catch let error {
            print("Error on fetch: \(error)")
            return 0
        }
        
    }
    internal func createItemsEntities(fromModels itemModels: [VideoAudioItemModel], completionHandler: @escaping () -> ()) {
        

        
        var operations = Array<CoreDataOperation<InsertOrUpdateItemIfExist>>()
        for model in itemModels {
            operations.append(CoreDataOperation<InsertOrUpdateItemIfExist>(data: model))
        }
        
        MFCoreDataManager.shared.addOperations(mainContext: mainContext, operations: operations, completHandler: {
            completionHandler()
        })
        
    }

    
    /**
     Return all existed groups
     */
    func getItem(forURL itemUrl: String) -> ItemEntity? {
        
        // Initialize Managed Object Context
        let tmpMainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        tmpMainContext.parent = self.mainContext
        
        //Create fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        let predicate = NSPredicate(format: "url = %@", itemUrl)
        fetchRequest.predicate = predicate
        
        //Make fetch
        do{
            let fetchResults = try tmpMainContext.fetch(fetchRequest) as? [ItemEntity]
            
            guard fetchResults != nil, fetchResults!.count > 0 else {
                return nil
            }
            
            return fetchResults![0]
            
        }catch let error {
            print("Error on fetch: \(error)")
            return nil
        }
        
    }
    
}

//class CoreDataOperation2: Operation {
//    
//    var context: NSManagedObjectContext
//    var operationToDo: CoreDataOperationProtocol
//    
//    init(context: NSManagedObjectContext, operation: CoreDataOperationProtocol) {
//        self.context = context
//        self.operationToDo = operation
//    }
//    
//    override func main() {
//        
//        context.performAndWait {
//            
//            //Stuf to do
//            self.operationToDo.execute(forContext: self.context)
//            
//            if self.context.hasChanges {
//                do {
//                    // Save and in private context and push it to mainContext
//                    try self.context.save()
//                    
//                    print("SAVED!")
//                    
//                } catch let error {
//                    print("Error on data saving: \(error)")
//                    
//                }
//            }
//        }
//    }
//    
//}

