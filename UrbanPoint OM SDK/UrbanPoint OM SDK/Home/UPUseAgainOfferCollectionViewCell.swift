//
//  UPUseAgainOfferCollectionViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/20/23.
//

import UIKit

class UPUseAgainOfferCollectionViewCell: UICollectionViewCell {
    static let identifier = "UPUseAgainOfferCollectionViewCell"
    
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var outletNameLabel: UILabel!
    @IBOutlet weak var offerTitleLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    
    @IBOutlet weak var categoryImageViewContainer: UIView!
    var task: URLSessionDataTask?
    
    var viewModel: UseAgainOffer?
    
    func configureCellWith(_ viewModel: UseAgainOffer){
        // Assign Image to ImageView
      
        
        offerImageView.contentMode = .scaleAspectFill
        let url = URL(string: imageBaseURL + (viewModel.outletLogo ?? ""))
        offerImageView.sd_setImage(with: url)
        outletNameLabel.text = viewModel.outletName
        offerTitleLabel.text = viewModel.title
        self.categoryImageViewContainer.layer.masksToBounds = false
        self.categoryImageViewContainer.layer.cornerRadius = 10.0
        self.categoryImageViewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.categoryImageViewContainer.layer.shadowRadius = 3
        self.categoryImageViewContainer.layer.shadowOpacity = 0.1
        
        
        offerPriceLabel.text = ""
        guard let type = viewModel.discountType,
        let price = viewModel.approxSaving?.getNumberWithoutDecimal()
        else { return }
        fetchTextForSavingLabel(type: type, with: price)
    }
    
    private func fetchTextForSavingLabel(type: String,with price: String){
        if type == "0"{
            offerPriceLabel.text = "Save QAR " + price
        }
        else{
            offerPriceLabel.text =  "\(price) % OFF"
        }
    }
    
    override func prepareForReuse() {
        offerImageView.image = nil
        task?.cancel()
        super.prepareForReuse()
        
    }
}
