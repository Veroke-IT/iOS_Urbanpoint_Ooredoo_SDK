//
//  UPOutletMenuViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/10/23.
//

import UIKit
import WebKit

class UPOutletMenuViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    var urlToResource: URL? = nil
    var closeResource: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let urlToResource else {
            closeResource?()
            return
        }
        let urlRequesst = URLRequest(url: urlToResource)
        self.webView.load(urlRequesst)
    }
    

  

}
