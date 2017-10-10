import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class DocsViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.allowsBackForwardNavigationGestures = true
        
        
        let webContent : String = "<!DOCTYPE html><html> <head> <!-- Required meta tags--> <meta charset='utf-8'> <meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, minimal-ui'> <meta name='apple-mobile-web-app-capable' content='yes'> <meta name='apple-mobile-web-app-status-bar-style' content='black'> <!-- Your app title --> <title>Safebook</title> <!-- Path to Framework7 iOS CSS theme styles--> <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/framework7/1.6.5/css/framework7.ios.min.css'> </head> <body> <!-- Views --> <div class='views'> <!-- Your main view, should have 'view-main' class --> <div class='view view-main'> <!-- Top Navbar--> <div class='navbar'> <div class='navbar-inner'> <!-- We need cool sliding animation on title element, so we have additional 'sliding' class --> <div class='center sliding'>Образцы заявлений</div> </div> </div> <!-- Pages container, because we use fixed-through navbar and toolbar, it has additional appropriate classes--> <div class='pages navbar-through toolbar-through'> <!-- Page, 'data-page' contains page name --> <div data-page='index' class='page'> <!-- Scrollable page content --> <div class='page-content'> <!-- Content block --> <div class='list-block inset'> <ul> <li> <a href='https://drive.google.com/open?id=1vLB51c3jwc0BmW1ghjA8dulYYNFn4jX09sZlb5BPNWI' class='item-link list-button'>Заявление</a> </li> <li> <a href='https://drive.google.com/open?id=1wFEQdQuuYMW_38IvRXbmxVnKgxwTHuzAuJWJMcTbzNo' class='item-link list-button'>Заявление о выдаче медицинской документации</a> </li> <li> <a href='https://drive.google.com/open?id=1un28u3YSDQKTNNL96BcgdB1xWSw-m1hTj1HdMori-zs' class='item-link list-button'>Заявление об угрозе жизни</a> </li> <li> <a href='https://drive.google.com/open?id=1L_NHldVGCRPhCy9Jx4hgT_2RhFUSW0Wsw8WaehCovxk' class='item-link list-button'>Заявление о возбуждении уголовного дела</a> </li> <li> <a href='https://drive.google.com/open?id=1jg8MzuQsS0Nzk6B95H1AdTktkhi_f-1_RXLd-YA7SWg' class='item-link list-button'>Заявление об изнасиловании</a> </li> <li> <a href='https://drive.google.com/open?id=13tUDWuR6vqJaTyASoW6UoLgU__qUaCyfIgH5WOSP3TM' class='item-link list-button'>Заявление о преступлении</a> </li> <li> <a href='https://drive.google.com/open?id=1bsTjneYQWsOCdE9ilFH1zdqqYZejh8fvtPUQeqzuo1w' class='item-link list-button'>Жалоба на постановление об отказе в возбуждении уголовного дела</a> </li> </ul> </div> </div> </div> </div> </div> </div> <!-- Path to Framework7 Library JS--> </body></html> "
        let mainbundle = Bundle.main.bundlePath
        let bundleURL = URL(fileURLWithPath: mainbundle)
        
        webView.loadHTMLString(webContent, baseURL: bundleURL)
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.ShareLink))
    }
    
//    @objc func ShareLink() {
//                let textToShare = "https://www.icloud.com/iclouddrive/03PrJ5kjFzdwZutW58Gg3_bjg#adobe-acrobat-xi-create-form-or-template-tutorial%5Fue.pdf"
//
//
//                    let objectsToShare = [String(encodedString:  textToShare)] as [Any]
//                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//                    activityVC.popoverPresentationController?.sourceView = self.view
//                    activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height, width: 0, height: 0)
//
//                    self.present(activityVC, animated: true, completion: nil)
//
//            }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        if let content = json["text"].string {
////            let webContent : String = content
////            let mainbundle = Bundle.main.bundlePath
////            let bundleURL = URL(fileURLWithPath: mainbundle)
////
////            webView.loadHTMLString(webContent, baseURL: bundleURL)
////        }
//    }
    @IBAction func doneTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

