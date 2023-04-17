//
//  UPUsedOfferTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import UIKit

class UPUsedOfferTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UPUsedOfferTableViewCell"
    
    @IBOutlet weak var outletNameLabel: UILabel!
    @IBOutlet weak var offerDescriptionLabel: UILabel!
    @IBOutlet weak var confirmationIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var outletImageView: UIImageView!
    
    struct Offer{
        let outletName: String
        let description: String
        let confirmationCode: String
        let date: String
        let image: URL?
    }
    

    func configureCell(with model: Offer){
        outletNameLabel.text = model.outletName
        offerDescriptionLabel.text = model.description
        confirmationIDLabel.text = model.confirmationCode
        dateLabel.text = model.date
        outletImageView.sd_setImage(with: model.image)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
