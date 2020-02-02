//
//  VideoModel.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 28/11/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import Foundation

struct VideoAudioItemModel {
    let type:         String
    let thumb:        String?
    let title:        String?
    let text:         String?
    let url:          String?
}

extension VideoAudioItemModel: Decodable {
    enum VideoAudioItemCodingKeys: String,CodingKey {
        
        case type  = "type"
        case thumb
        case title
        case text
        case url
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:VideoAudioItemCodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        do {
             thumb = try! container.decode(String.self, forKey: .thumb)
             title = try! container.decode(String.self, forKey: .title)
             text = try! container.decode(String.self, forKey: .text)
             url = try! container.decode(String.self, forKey: .url)
          
        } catch  {
              print(error.localizedDescription)
        }

    }
    

    
}
