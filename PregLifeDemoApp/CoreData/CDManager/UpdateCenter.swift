//
//  UpdateCenter.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 02/12/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol UpdateCenterDelegate: class {
    
    func insert()
    func update()
    func delete()
}

class CDObserver {
    
    weak var delegate: UpdateCenterDelegate?
    var observerType: NSManagedObject.Type
    
    init(delegate: UpdateCenterDelegate, observerType: NSManagedObject.Type) {
        self.delegate = delegate
        self.observerType = observerType
    }
    
    public func inform(didChangedType: NSManagedObject.Type) {
        if didChangedType == self.observerType {
            delegate?.insert()
        }
    }
    
    public func inform(didUpdateType: NSManagedObject.Type) {
        if didUpdateType == self.observerType {
            delegate?.update()
        }
    }
    
    public func inform(didDeleteType: NSManagedObject.Type) {
        if didDeleteType == self.observerType {
            delegate?.delete()
        }
    }
}

class UpdateCenter: NSObject {

    static let shared = UpdateCenter()
    
    var context:NSManagedObjectContext?
    var observers: [CDObserver] = []
    let notifCenter = NotificationCenter.default

    public func addObserver(observer: CDObserver){
        observers.append(observer)
    }
    
    public func removeObserver(forDelegate delegate:UpdateCenterDelegate) {
        // TODO: Remove obsever
    }
    
    private override init() {
        super.init()
        
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        notifCenter.addObserver(self, selector: #selector(contextDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        
    }

    @objc func contextDidChange(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> , inserts.count > 0 {
            var types: [NSManagedObject] = Array(inserts)
            types.removeDuplicates()
            
            for obs in observers {
                for entity in types {
                    obs.inform(didChangedType: entity.classForCoder as! NSManagedObject.Type)
                }
            }
        }
        
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> , updates.count > 0 {
            var types: [NSManagedObject] = Array(updates)
            types.removeDuplicates()
            
            for obs in observers {
                for entity in types {
                    obs.inform(didUpdateType: entity.classForCoder as! NSManagedObject.Type)
                }
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> , deletes.count > 0 {
            var types: [NSManagedObject] = Array(deletes)
            types.removeDuplicates()
            
            for obs in observers {
                for entity in types {
                    obs.inform(didDeleteType: entity.classForCoder as! NSManagedObject.Type)
                }
            }
        }
    }
    
}
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
