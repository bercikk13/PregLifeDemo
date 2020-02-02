//
//  APIRouter.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 28/11/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import Foundation
import Moya

enum PregLifeAPI {
    case getListOfAudioAndVideo
  
}

extension PregLifeAPI: TargetType{
    
    var headers: [String : String]? {
        var httpHeaders: [String: String] = [:]
        switch self {
        case .getListOfAudioAndVideo:
            httpHeaders["Content-Type"] = "application/json"
            return httpHeaders
        
        }
    }
    
    
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.onlinebaby.se/") else {
            print("No Base URL! Crash!")
            return URL(string: "https://api.onlinebaby.se/")!
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getListOfAudioAndVideo:
            return "v1/content/play/gravidyoga/pl"

            
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .getListOfAudioAndVideo:
            return .get
      
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    

    var task: Task {
        switch self {
       
        case .getListOfAudioAndVideo:
            return .requestParameters(parameters: ["":""], encoding: URLEncoding.default)

        }
    


    }
}
    
    
    
    


