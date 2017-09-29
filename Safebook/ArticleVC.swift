//
//  ArticleVC.swift
//  Keinex
//
//  Created by Андрей on 9/16/15.
//  Copyright (c) 2016 Keinex. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

import SafariServices

class ArticleVC: UIViewController, UIWebViewDelegate {
    
    lazy var json : JSON = JSON.null
//    lazy var indexRow : Int = Int()
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var featuredImageHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var commentsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ArticleVC.changeOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        commentsButton.isHidden = true
    
        
        if isiPad {
            featuredImageHeightConstant.constant = featuredImageHeightConstant.constant * 1.5
        }
        
        if let featured = json["better_featured_image"]["source_url"].string{
            featuredImage.clipsToBounds = true
            ImageLoader.sharedLoader.imageForUrl(urlString: featured, completionHandler:{(image: UIImage?, url: String) in self.featuredImage.image = image
            })
        }
        
        if let title = json["content"].string {
            postTitle.text = String(encodedString:  title)
        }
        
        if let content = json["text"].string {
            
            return
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ArticleVC.ShareLink))
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        postContentWeb.layoutIfNeeded()
//        textView.reload()
        
        var finalHeight : CGFloat = 0
        self.scrollView.subviews.forEach { (subview) -> () in
            finalHeight += subview.frame.height
        }
        self.scrollView.contentSize.height = finalHeight
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
//        webContentHeightConstant.constant = postContentWeb.scrollView.contentSize.height
//        postContentWeb.layoutIfNeeded()
        
        var finalHeight : CGFloat = 0
        self.scrollView.subviews.forEach { (subview) -> () in
            finalHeight += subview.frame.height
        }
        self.scrollView.contentSize.height = finalHeight
        
//        showCommentsButton()
    }
    
    @objc func changeOrientation() {
//        webContentHeightConstant.constant = postContentWeb.scrollView.contentSize.height
//        postContentWeb.layoutIfNeeded()
    
        
        var finalHeight : CGFloat = 0
        self.scrollView.subviews.forEach { (subview) -> () in
            finalHeight += subview.frame.height
        }
        
        self.scrollView.contentSize.height = finalHeight
    }
    
//    func showCommentsButton() {
//        commentsButton.layer.cornerRadius = 25
//        commentsButton.layer.shadowOffset = CGSize(width: 1, height: 0)
//        commentsButton.layer.shadowOpacity = 0.5
//        commentsButton.layer.shadowColor = UIColor.black.cgColor
//        commentsButton.addTarget(self, action: #selector(commentsButtonAction), for: .touchUpInside)
//        commentsButton.isHidden = false
//        commentsButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//        UIView.animate(withDuration: 0.5, animations: { () -> Void in
//            self.commentsButton.transform = CGAffineTransform(scaleX: 1,y: 1)
//        })
//    }
    
//    func commentsButtonAction(_ sender: UIButton!) {
//        let CommentsVC : ArticleCommentsVC = storyboard!.instantiateViewController(withIdentifier: "ArticleCommentsVC") as! ArticleCommentsVC
//        CommentsVC.indexRow = indexRow
//        CommentsVC.PostID = self.json["id"].int!
//        self.navigationController?.pushViewController(CommentsVC, animated: true)
//    }
    func openWebView(url: URL) {
        let browser = SFSafariViewController(url: url)
        present(browser, animated: true, completion: nil)
    }
    
    @objc func ShareLink() {
        let textToShare = json["content"].string! + " "
        
        if let KeinexWebsite = URL(string: json["link"].string!) {
            let objectsToShare = [String(encodedString:  textToShare), KeinexWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height, width: 0, height: 0)
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


