//
//  UPNearbyOutletHomeCollectionViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/2/23.
//

import UIKit

class UPNearbyOutletHomeCollectionViewCell: UICollectionViewCell {
 
    static let reuseIdentifier = "UPNearbyOutletHomeCollectionViewCell"
    
    @IBOutlet weak var outletCategoryLabel: UILabel!
    @IBOutlet weak var outletImageView: UIImageView!
    @IBOutlet weak var outletTitleLabel: UILabel!
    @IBOutlet weak var offersAvailableLabel: UILabel!
    var task: URLSessionDataTask?
    
    internal func configureOutletCellWith(_ outlet: NearbyOutlet){
        if let url = URL(string: imageBaseURL + outlet.image){
            
            outletImageView.sd_setImage(with: url,placeholderImage: placeHolderImage)
            
        }
        outletCategoryLabel.text = outlet.linkedOutletCategory.first?.name
        outletTitleLabel.text = outlet.name
        offersAvailableLabel.text = createOffersLabelText(numOfOffers: outlet.offersCount)
    }
    
    private func createOffersLabelText(numOfOffers: Int) -> String{
         "\(numOfOffers) offers available"
    }
    
    override func prepareForReuse() {
        outletImageView.image = nil
        task?.cancel()
        super.prepareForReuse()
        
    }
    
    
}
