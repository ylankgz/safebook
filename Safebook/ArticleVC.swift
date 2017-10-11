
import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class ArticleVC: UIViewController, WKUIDelegate {
    
    lazy var json : JSON = JSON.null
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let content = json["text"].string {
            let webContent : String = content
            let mainbundle = Bundle.main.bundlePath
            let bundleURL = URL(fileURLWithPath: mainbundle)
            
            webView.loadHTMLString(webContent, baseURL: bundleURL)
        }
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ArticleVC.ShareLink))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
//    @objc func ShareLink() {
//        let textToShare = json["content"].string! + " "
//
//        if let KeinexWebsite = URL(string: json["link"].string!) {
//            let objectsToShare = [String(encodedString:  textToShare), KeinexWebsite] as [Any]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//            activityVC.popoverPresentationController?.sourceView = self.view
//            activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height, width: 0, height: 0)
//
//            self.present(activityVC, animated: true, completion: nil)
//        }
//    }
}


