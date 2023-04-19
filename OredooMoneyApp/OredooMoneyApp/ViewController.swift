//
//  ViewController.swift
//  OredooMoneyApp
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit
import UrbanPoint_OM_SDK



class ViewController: UIViewController {

    var p = 0
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let nav = UINavigationController()
        let up = UrbanPoint(navigationController: nav, context: self)
        
        if p == 0{
            up.start()
        }
        p+=1
    }

}



