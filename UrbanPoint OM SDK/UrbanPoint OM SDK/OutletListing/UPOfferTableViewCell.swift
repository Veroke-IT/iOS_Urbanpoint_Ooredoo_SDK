//
//  UPOfferTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import UIKit

class UPOfferTableViewCell: UITableViewCell {

    
    
    static let reuseIdentifier = "UPOfferTableViewCell"
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var specialFlagBg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var approxSavingsLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var favouritImage: UIImageView!
    @IBOutlet weak var titleLabelStackCenterConstraint: NSLayoutConstraint!
    
    private var offer: UPOffer?
    
    internal func configureCellWith(_ offer: UPOffer){
        self.offer = offer
        setupCellUI()
    }
    
    private func setupCellUI(){
       titleLabel.text = offer?.title
        if let price = offer?.price,
           let type = offer?.discountType{
             fetchTextForSavingLabel(type: type, with: String(price))
        }
        else{
            approxSavingsLabel.isHidden = true
        }
        
    }
    
    private func fetchTextForSavingLabel(type: String,with price: String){
        if type == "0"{
            approxSavingsLabel.text = "Save QAR " + price
        }
        else{
            approxSavingsLabel.text =  "\(price) % OFF"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func favouriteButtonTouched(_ sender: Any){}
    @IBAction func giftButtonTouched(_ sender: Any){}
    
}
