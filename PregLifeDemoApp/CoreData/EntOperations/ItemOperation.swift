//
//  ItemOperation.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 02/12/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import Foundation
import CoreData


/**
 Update item if the local edit date is older than the value from the server.
 */
class InsertOrUpdateItemIfExist: EntitiesOperationsBase, EntitiesOperationsProtocol {
    
    required  override init() { }
    
    func execute(forContext context: NSManagedObjectContext, data: VideoAudioItemModel) {
        

        
        //Prepare predicate
        let predicate = NSPredicate(format: "url = %@", data.url!)
        
        //Fetch if exist
        guard let fetchResults = self.fetch(forContext: context, entityName: "ItemEntity", predicate: predicate) as? [ItemEntity],
            fetchResults.count > 0
            else {
                let managedObject = NSEntityDescription.insertNewObject(forEntityName: "ItemEntity", into: context) as! ItemEntity
                
                managedObject.insert(model: data)
                return
        }
       // let managedObject = NSEntityDescription.insertNewObject(forEntityName: "ItemEntity", into: context) as! ItemEntity
        
       // managedObject.insert(model: data)
        update(forManagedObject: fetchResults[0], modelData: data, context: context)
        
    }
    
    /**
     Insert new Item
     */
    private func insert(context: NSManagedObjectContext, model: VideoAudioItemModel) -> ItemEntity{
        
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: "ItemEntity", into: context) as! ItemEntity
        
        managedObject.insert(model: model)
        
        return managedObject
    }
    

    
    private func update(forManagedObject manageObject: ItemEntity?, modelData: VideoAudioItemModel, context: NSManagedObjectContext){
        
        
        //Is exist?
        guard manageObject != nil else {
            
            //need add object
            _ = insert(context: context, model: modelData)
            
            return
        }
    }
        
}

/**
 Removes aff from the database if it was not sent in the query.
 */
class RemoveNotLoadedItems: EntitiesOperationsBase, EntitiesOperationsProtocol {
    
    required override init() { }
    
    func execute(forContext context: NSManagedObjectContext, data: [VideoAudioItemModel]) {
        
        //Fetch if exist
        guard let fetchResults = self.fetch(forContext: context, entityName: "ItemEntity") as? [ItemEntity],
            fetchResults.count > 0
            else {
                print("RemoveNotLoadedItems: Error on fetch all data")
                return
        }
        
        for n in fetchResults {
            if isExistItem(inArray: data, item: n) == false {
                //remove old items from core data
               
                context.delete(n)
            }
        }
        
    }
    
    
    func isExistItem(inArray modelArray: [VideoAudioItemModel], item: ItemEntity) -> Bool {
        
        for model in modelArray {
            if model.url == item.url {
                return true
            }
        }
        
        return false
    }
    
}


/**
 Update isFav key for selected item
 */
class SetItemFavorite: EntitiesOperationsBase, EntitiesOperationsProtocol {
    
    required override init() { }
    
    func execute(forContext context: NSManagedObjectContext, data: (itemUrl: String, isFav: Bool ) ) {
        
        let predicate = NSPredicate(format: "url = %@", data.itemUrl)
        
        print("Set fav to: \(data.isFav)")
        
        //Fetch if exist
        guard let fetchResults = self.fetch(forContext: context, entityName: "ItemEntity", predicate: predicate) as? [ItemEntity],
            fetchResults.count > 0
            else {
                return
        }
        
        let managedObject = fetchResults[0]
        
//        guard managedObject.isFav != nil else {
//            print("Newer set")
//
//            managedObject.isFav = data.isFav
//            return
//        }
        
        managedObject.updateFav(isFav: data.isFav)
        
    }
    
}

/**
 Update isNew key for selected item
 */
class SetItemIsNew: EntitiesOperationsBase, EntitiesOperationsProtocol {
    
    required override init() { }
    
    func execute(forContext context: NSManagedObjectContext, data: (itemUrl: String, isNew: Bool ))  {
        
        let predicate = NSPredicate(format: "url = %@", data.itemUrl)
        
        //Fetch if exist
        guard let fetchResults = self.fetch(forContext: context, entityName: "ItemEntity", predicate: predicate) as? [ItemEntity],
            fetchResults.count > 0
            else {
                return
        }
        
        let managedObject = fetchResults[0]
        
//        guard managedObject.isNew != nil else {
//            print("Newer set")
//
//            managedObject.isNew =  data.isNew
//            return
//        }
        
        managedObject.updateNew(isNew: data.isNew)
    }
    
}

