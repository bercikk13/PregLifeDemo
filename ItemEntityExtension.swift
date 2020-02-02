//
//  ItemEntityExtension.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 02/12/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import Foundation

extension ItemEntity {
    
    
    func insert(model: VideoAudioItemModel)  {
        self.isFav = false
        self.isNew = true
        self.text  = model.text
        self.thumb = model.thumb
        self.title = model.title
        self.type  = model.type
        self.url   = model.url
    }
    func updateFav(isFav: Bool) {
        self.setValue( isFav, forKey: "isFav")
    }
    func updateNew(isNew: Bool) {
        self.setValue(isNew, forKey: "isNew")
    }
}
