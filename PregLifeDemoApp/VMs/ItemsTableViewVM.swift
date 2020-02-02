//
//  ItemsTableViewVM.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 28/11/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//


import UIKit

class ItemsTableViewVM: NSObject {

    let itemManager = CDManager.shared
    var fetchedItems: Array<ItemEntity>?
    
    typealias DataRefreshCompletionHandler =  () -> (Void)
    var refresh: DataRefreshCompletionHandler?
    
    override init() {

        if let tests = itemManager.getAllItems(){
            fetchedItems = tests
        } else {
            fetchedItems = nil
        }
        
        
        super.init()
        
        UpdateCenter.shared.addObserver(observer: CDObserver(delegate: self, observerType: ItemEntity.self))

    }
    
    private func refreshData() {
    
        if let tests = itemManager.getAllItems(){
            fetchedItems = tests
        } else {
            fetchedItems = nil
        }
        
        refresh?()
    }
    
     func getModel(forIndex index:Int) -> ItemEntity? {
        if let _ = fetchedItems, index < fetchedItems!.count {
            return fetchedItems![index]
        }
        return nil
    }
    
    var numberOfItems: Int {
        get {
            if let items = fetchedItems {
                return items.count
            } else {
                return 0
            }
        }
    }
    
    func getVMForItem(atIndex index:Int) -> ItemTableViewCellVM {
        return ItemTableViewCellVM(item: getModel(forIndex: index)!)
    }
    
    
}



extension ItemsTableViewVM: UpdateCenterDelegate {
    
    func insert() {
     
        
        refreshData()
    }
    
    func update() {
      
        
        refreshData()
    }
    
    func delete() {
       
        
        refreshData()
    }
    
    
}
