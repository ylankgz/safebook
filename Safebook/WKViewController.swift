//
//  WKViewController.swift
//  Safebook
//
//  Created by Ulan on 10/9/17.
//  Copyright © 2017 SafebookApp. All rights reserved.
//

import UIKit
import WebKit

class WKViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
