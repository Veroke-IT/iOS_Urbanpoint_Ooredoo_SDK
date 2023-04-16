//
//  Extension+UIViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    
    enum AlertTitle: String{
        case alert = "Alert"
        case error = "Error"
    }
    
    internal func embed(viewController: UIViewController, frame: CGRect? = nil) {
        
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
    }
    
    internal func remove(embeddedViewController: UIViewController) {
        guard children.contains(embeddedViewController) else {
            return
        }
        embeddedViewController.willMove(toParent: nil)
        embeddedViewController.view.removeFromSuperview()
        embeddedViewController.removeFromParent()
    }
    
    internal func showActivityIndicator(){
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.image = UIImage.loadImageWithName("loader")
            imageView.backgroundColor = .clear
            
            hud.customView = imageView
            hud.customView?.backgroundColor = nil
            hud.bezelView.backgroundColor = nil
            hud.bezelView.layer.masksToBounds = true
            hud.mode  = MBProgressHUDMode.customView
            hud.animationType = MBProgressHUDAnimation.fade
            hud.setNeedsDisplay()
            let animation = CABasicAnimation(keyPath: "transform.rotation")
                      animation.fromValue = 0.0
                      animation.toValue = 2.0 * Double.pi
                      animation.duration = 1
                      animation.repeatCount = HUGE
                      animation.isRemovedOnCompletion = false
            hud.customView?.layer.add(animation, forKey: "rotationAnimation")
        }
    }
    
    internal func hideActivityIndicator(){
        DispatchQueue.main.async() { () -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    internal func showAlert(title:AlertTitle, message: String){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: title.rawValue, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
           self.present(alert, animated: true){}
        }
    }
    
}
