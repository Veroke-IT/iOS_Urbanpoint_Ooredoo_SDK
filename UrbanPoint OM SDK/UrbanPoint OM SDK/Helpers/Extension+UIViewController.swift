//
//  Extension+UIViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import UIKit

extension UIViewController {

    func embed(viewController: UIViewController, frame: CGRect? = nil) {
        
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
    }

    func remove(embeddedViewController: UIViewController) {
        guard children.contains(embeddedViewController) else {
            return
        }
        embeddedViewController.willMove(toParent: nil)
        embeddedViewController.view.removeFromSuperview()
        embeddedViewController.removeFromParent()
    }
}
