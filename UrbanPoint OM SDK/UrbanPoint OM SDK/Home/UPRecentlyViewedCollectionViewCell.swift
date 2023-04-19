//
//  UPRecentlyViewedCollectionViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/17/23.
//

import UIKit

class UPRecentlyViewedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outletImageView: UIImageView!
    @IBOutlet weak var outletName: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    static let reuseIdentifier = "UPRecentlyViewedCollectionViewCell"
    
    internal func configureCell(with outlet: RecentlyViewedOutlet){
        self.outletImageView.sd_setImage(with: URL(string: outlet.outletLogoURL))
        self.outletName.text = outlet.outletName
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
}
