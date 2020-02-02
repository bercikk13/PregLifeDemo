//
//  LoadDataFacade.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 02/12/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import Foundation
import Reachability
import PromiseKit


protocol APIManagerFacadeRechability {
    func hasConnectivity() -> Bool
}



class LoadDataFacade {
    public func getListOfAudioAndVideo(completionHandler: @escaping (Error?, Bool?) -> Void) {
        
        
        
        firstly {
            NetworkManager().getListOfAudioAndVideo()
            }.done { result in
                print(result)
                CDManager.shared.createItemsEntities(fromModels: result, completionHandler: {
                    print("Save")
                    completionHandler(nil, true)
                })
                
                
            }.catch { error in
                print(error)
                completionHandler(error, false)
                
                
        }
    }
    
    
}

// MARK: Load data facade promisekit extension
extension LoadDataFacade {
    
    public func getListOfAudioAndVideo() -> Promise<Bool> {
        return Promise { seal in
            getListOfAudioAndVideo{ error, result in
                seal.resolve(error, result)
            }
        }
    }
    
}
