//
//  MFCoreDataManager.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 02/12/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import NotificationCenter
import Foundation
import CoreData
import UIKit


public class MFCoreDataManager: NSObject {
    
    
    internal var operationQueue: OperationQueue
    public static let shared = MFCoreDataManager()
    
    /**
     Set max operation run in the same time. May cause a race.
     */
    public var maxConcurrentOperationCount: Int {
        set{
            self.operationQueue.maxConcurrentOperationCount = newValue
        }
        get{
            return self.operationQueue.maxConcurrentOperationCount
        }
    }
    
    private override init() {
        
        self.operationQueue = OperationQueue()
        self.operationQueue.maxConcurrentOperationCount = 1
        self.operationQueue.name = "CoreDataOperationQueue"
        
        super.init()
        
    }
    
    /***************************/
    
    private func getPrivateContext(_ mainContext: NSManagedObjectContext) -> NSManagedObjectContext {
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = mainContext
        
        return managedObjectContext
    }
    
    /**
     Add one core data operation (automaticly start run).
     */
    internal func addOperation(mainContext: NSManagedObjectContext, operation: CoreDataOperationProtocol) {
        let cdOperation = CoreDataOperation2(context: getPrivateContext(mainContext), operation: operation)
        self.operationQueue.addOperation(cdOperation)
    }
    
    /**
     Add one core data operation (automaticly start run).
     */
    internal func addOperation(mainContext: NSManagedObjectContext, operation: CoreDataOperationProtocol, withProgress progress: Progress, becomeCurrent: Int64) {
        let cdOperation = CoreDataOperation2(context: getPrivateContext(mainContext), operation: operation, progress: progress, becomeCurrent: becomeCurrent)
        self.operationQueue.addOperation(cdOperation)
    }
    
    /**
     Add multiple core data operations, run automaticly and send closure when fnish all operations.
     */
    internal func addOperations(mainContext: NSManagedObjectContext, operations: [CoreDataOperationProtocol], completHandler: @escaping ()->Void ) {
        
        //Change core data operations (safezone) to NSOperations
        
        var cdOperations: [CoreDataOperation2] = []
        
        
        for op in operations {
            let cdOp = CoreDataOperation2(context: getPrivateContext(mainContext), operation: op)
            cdOperations.append(cdOp)
        }
        
        //Start runing and wait for finish (in bacground)
        DispatchQueue.global(qos: .background).async {
            self.operationQueue.addOperations(cdOperations, waitUntilFinished: true)
            completHandler()
        }
        
    }
    
    /**
     Add multiple core data operations, run automaticly and send closure when fnish all operations.
     */
    internal func addOperations(mainContext: NSManagedObjectContext,
                              operations: [CoreDataOperationProtocol],
                              withProgress progress: Progress,
                              becomeCurrent: Int64,
                              completHandler: @escaping ()->Void ) {
        
        //Change core data operations (safezone) to NSOperations
        var cdOperations: [CoreDataOperation2] = []
        
        
        for op in operations {
            let cdOp = CoreDataOperation2(context: getPrivateContext(mainContext), operation: op, progress: progress, becomeCurrent: becomeCurrent)
            cdOperations.append(cdOp)
        }
        
        //Start runing and wait for finish (in bacground)
        DispatchQueue.global(qos: .background).async {
            self.operationQueue.addOperations(cdOperations, waitUntilFinished: true)
            completHandler()
        }
        
    }
    
    
    
    /**
     Try push changes to PersistentStoreCoordinator (permament record)
     It run save on mainQueueManageObjectContext
     */
    public func pushToPersistance(mainContext: NSManagedObjectContext){
        mainContext.perform {
            
            if mainContext.hasChanges {
                do{
                    try mainContext.save()
                }catch let error{
                    print("Error on push to persistance: \(error)")
                }
            }
        }
    }
    
}


class CoreDataOperation2: Operation {
    
    var context: NSManagedObjectContext
    var operationToDo: CoreDataOperationProtocol
    var progress: Progress?
    var becomeCurrent: Int64?
    
    init(context: NSManagedObjectContext, operation: CoreDataOperationProtocol) {
        self.context = context
        self.operationToDo = operation
    }
    
    init(context: NSManagedObjectContext, operation: CoreDataOperationProtocol, progress: Progress, becomeCurrent: Int64) {
        self.context = context
        self.operationToDo = operation
        self.progress = progress
        self.becomeCurrent = becomeCurrent
    }
    
    override func main() {
        
        context.performAndWait {
            
            //Progress counting
            if self.progress != nil, self.becomeCurrent != nil {
                self.progress!.becomeCurrent(withPendingUnitCount: self.becomeCurrent!)
            }
            
            //Stuff to do
            self.operationToDo.execute(forContext: self.context)
            
            if self.context.hasChanges {
                do {
                    // Save and in private context and push it to mainContext
                    try self.context.save()
                } catch let error {
                    print("Error on data saving: \(error)")
                }
            }
            
            //End progres counting
            if self.progress != nil {
                self.progress!.resignCurrent()
            }
            
        }
    }
    
}

