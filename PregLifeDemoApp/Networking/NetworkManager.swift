//
//  NetworkManager.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 28/11/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

public enum APIManagerFacadeError: Error {
    case serverResponseError(String?)
    case noInternetConnection(String?)

}

struct NetworkManager {
    internal let provider = MoyaProvider<PregLifeAPI>(callbackQueue: DispatchQueue.global(qos: .default))
    //internal let provider = MoyaProvider<PregLifeAPI>()
    
    
    internal func getListOfAudioAndVideo( completion: @escaping (_ error:Error?, _ data: [VideoAudioItemModel]?) -> ()) {
        provider.request(.getListOfAudioAndVideo, completion:  { result in
            switch result {
              case let .success(moyaResponse):
                if 200...202 ~= moyaResponse.statusCode {
                   
               
                    do{
                        let filteredResponse = try  moyaResponse.filterSuccessfulStatusCodes()
                        let jsonData = try filteredResponse.map(Array<VideoAudioItemModel>.self)
                        
                        completion(nil,jsonData)
                    }catch{
                        print(error)
                        completion(error, nil)
                    }
                }else{
                    completion(APIManagerFacadeError.serverResponseError("Wrong status code \(moyaResponse.statusCode)"), nil)
                }
                 
                
              case let .failure(error):
                print(error.localizedDescription)
                completion(error,nil)
              }
        })
    }
   
    
}


// MARK: PromiseKit extension
extension NetworkManager {
    
    
    public func getListOfAudioAndVideo() -> Promise<[VideoAudioItemModel]> {
        
        return Promise<[VideoAudioItemModel]> { seal in
            getListOfAudioAndVideo { error, data in
                seal.resolve( error,data)
            }
        }
        
    }
    
    
}
