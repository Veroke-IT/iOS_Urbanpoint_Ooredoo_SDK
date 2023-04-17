//
//  UPOutletMenuViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/10/23.
//

import UIKit
import WebKit

class UPWebViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    var urlToResource: URL? = nil
    var closeWebView: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let urlToResource else {
           closeWebView?()
            return
        }
        let urlRequesst = URLRequest(url: urlToResource)
        self.webView.load(urlRequesst)
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any){
        closeWebView?()
    }

  

}
