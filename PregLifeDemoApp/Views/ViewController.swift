//
//  ViewController.swift
//  PregLifeDemoApp
//
//  Created by Hubert Kuzioła on 28/11/2019.
//  Copyright © 2019 HubertApps. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var audioUrl: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let link = URL(string: audioUrl) //URL(string:"https://developer.apple.com/videos/play/wwdc2019/239/")!
        let request = URLRequest(url: link!)
        webView.load(request)
    }


    
}

