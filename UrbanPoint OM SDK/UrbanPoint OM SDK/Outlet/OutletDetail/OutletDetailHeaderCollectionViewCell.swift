//
//  OutletDetailHeaderCollectionViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/7/23.
//

import UIKit
@_implementationOnly import SDWebImage

class OutletDetailHeaderCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var outletImageView: UIImageView!
    static let identifier = "OutletDetailHeaderCollectionViewCell"
   // let configurationManager = ConfigurationManager()
    
    
    func setupImage(url: URL){
        outletImageView.backgroundColor = .red
//        let urlImage = String(format: "%@%@",configurationManager.getBaseURLImage().absoluteString,urlString)
        let transformer = SDImageResizingTransformer(size: CGSize(width: 720, height: 480), scaleMode: .fill)

        outletImageView.sd_setImage(with: url, placeholderImage: nil,context: [.imageTransformer: transformer])
        outletImageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        outletImageView.sd_cancelCurrentImageLoad()
    }
}

