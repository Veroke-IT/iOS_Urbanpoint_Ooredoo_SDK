//
//  OutletMenuImageViewerViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import UIKit


class OutletMenuImageViewerViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var backwardImage: UIImageView!
    
    internal var outletMenu: [UPOutlet.OutletMenu] = []
    
    //MARK: - PROPERTIES
    var currentIndex: Int = 1
    private var currentImageIndex: Int = 1 {
        didSet {
                            indicatorLabel.text = "\(currentImageIndex)\\\(outletMenu.count)"
//            if Constants.UPDATA.appLanguage == .English {
//                indicatorLabel.text = "\(currentImageIndex)\\\(Constants.UPDATA.tempOutletMenu?.count ?? 0)"
//            } else {
//                let currentIndex = String(currentImageIndex).convertedDigitsToLocale((Locale(identifier: "ar")))
//                let totalImages = String((Constants.UPDATA.tempOutletMenu?.count ?? 0)).convertedDigitsToLocale((Locale(identifier: "ar")))
//                indicatorLabel.text = "\(currentIndex)\\\(totalImages)"
//            }
//
            let indexPath = IndexPath(row: self.currentImageIndex-1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if Constants.UPDATA.appLanguage == .Arabic {
//            collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
//        }
        
        let indexPath = IndexPath(row: self.currentIndex-1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    fileprivate func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        backwardImage.transform = CGAffineTransform(rotationAngle: .pi)
        currentImageIndex = self.currentIndex
        

    }
    
    @IBAction func backButton(_ sender: UIButton) {
//        if Constants.UPDATA.appLanguage == .English {
//
//        } else {
//            scrollImageForward()
//        }
        scrollImageBackward()

    }
    
    @IBAction func forwardButton(_ sender: UIButton) {
            scrollImageForward()
    }
    
    fileprivate func scrollImageBackward() {
        if currentImageIndex > 1 {
            currentImageIndex -= 1
        }
    }
    
    fileprivate func scrollImageForward() {
//        if currentImageIndex < (Constants.UPDATA.tempOutletMenu?.count ?? 0) {
//            currentImageIndex += 1
//        }
    }

    @IBAction func dismissScreen(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- COLLECTIONVIEW DELEGATE DATASOURCE
extension OutletMenuImageViewerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuImageCell", for: indexPath) as! MenuScrollableImageViewCell
//        if let menu = Constants.UPDATA.tempOutletMenu?[indexPath.row] {
//            cell.scrollableImage.imageName = menu.file ?? ""
//        }
//        return cell
        UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return Constants.UPDATA.tempOutletMenu?.count ?? 0
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: collectionView.frame.size.height)
    }
    
    //HORIZONTAL SPACING BETWEEN CELLS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //VERTICAL SPACING BETWEEN CELLS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
