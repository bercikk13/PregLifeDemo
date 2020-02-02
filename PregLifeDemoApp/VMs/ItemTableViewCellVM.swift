//
//  ItemTableViewCellVM.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 28/11/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import Foundation
import UIKit
/**
 Usefull protocol for cells
 */
protocol VMCellProtocol {
    associatedtype ConformVM
    func fill(by: ConformVM)
}

/**
 View model that controll item list cell
 */
class ItemTableViewCellVM {
    
    private var itemUrl: String
 
    var title: String {
        get{
            return item.title!
        }
    
    }
    
    var isNew: Bool {
        get {
            let val = item.isNew
            
            return val

        }
        set {
            let cdOperation = CoreDataOperation<SetItemIsNew>(data: (itemUrl, newValue) )
            CDManager.shared.addOperation(operation: cdOperation)
        }
    }
    
    var isFav: Bool {
        get {
            let val = item.isFav
            
            return val
        }
        set {
  
            let cdOperation = CoreDataOperation<SetItemFavorite>(data: (itemUrl, newValue) )
            CDManager.shared.addOperation(operation: cdOperation)
        }
    }
    var fileType: String {
        
        get {
            
            guard let fileType = item.type else {
                return ""
            }
            
            return fileType
        }
    }
    
    var audioUrl: String {
        
        get {
            
            guard let audioUrl = item.url else {
                return ""
            }
            
            return audioUrl
        }
    }
    
    var imageUrl: String {
        
        get {
            
            guard let imageUrl = item.thumb else {
                return ""
            }
            
            return imageUrl
        }
    }
    
    var contentText: String {
        get {
            
            guard let strContent = item.text else {
                return ""
            }
            
            return strContent
        }
    }
    
    var item: ItemEntity
    
    init(item: ItemEntity) {

        self.itemUrl = item.url!
        self.item = item
        
    }
    
}
