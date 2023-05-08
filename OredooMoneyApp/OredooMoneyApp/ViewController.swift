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
        let up = UrbanPoint(context: self, walletID: "wallet_11223344", env: "test-up-intrnl", publicKey: "CC32FFA7F856DB79-UP-0")
        
        if p == 0{
            do{
                try up.start()
            }
            catch let error{
                debugPrint(error.localizedDescription)
            }
        }
        p+=1
    }

}



