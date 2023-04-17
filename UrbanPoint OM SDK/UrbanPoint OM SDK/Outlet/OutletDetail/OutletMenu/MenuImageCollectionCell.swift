//
//  MenuImageCollectionCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import UIKit

class MenuImageCollectionCell: UICollectionViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var menuImage: UIImageView!
    
    //MARK: - PROPERTIES
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.menuImage.contentMode = .scaleAspectFill
    }
}
