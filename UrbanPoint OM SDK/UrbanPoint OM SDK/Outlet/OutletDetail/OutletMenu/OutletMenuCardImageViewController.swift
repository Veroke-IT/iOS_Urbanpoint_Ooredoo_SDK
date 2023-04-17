//
//  OutletMenuCardImageViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import UIKit

class OutletMenuCardImageViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    var outletMenu: [UPOutlet.OutletMenu] = []
    
    //MARK: - PROPERTIES

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    @IBAction func dismissScreen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK:- COLLECTIONVIEW DELEGATE DATASOURCE
extension OutletMenuCardImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuImageCell", for: indexPath) as! MenuImageCollectionCell
        cell.menuImage.sd_setImage(with: URL(string: imageBaseURL + (outletMenu[indexPath.row].file ?? "") ), placeholderImage: UIImage(named: "placeholder"))
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return outletMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if outletMenu.count == 1 {
            return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        } else {
            return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width * 0.8)
        }

    }
    
    //HORIZONTAL SPACING BETWEEN CELLS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 00
    }
    
    //VERTICAL SPACING BETWEEN CELLS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 00
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = OutletMenuImageViewerViewController()
//        vc.modalPresentationStyle = .overFullScreen
//        vc.currentIndex = indexPath.row + 1
//        if let tabBar = self.tabBarController {
//            tabBar.present(vc, animated: true, completion: nil)
//        } else {
//            self.present(vc, animated: true, completion: nil)
//        }
    }
}
