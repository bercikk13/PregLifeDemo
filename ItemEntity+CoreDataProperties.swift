//
//  ItemEntity+CoreDataProperties.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 02/12/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var text: String?
    @NSManaged public var thumb: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var isNew: Bool
    @NSManaged public var isFav: Bool

}
