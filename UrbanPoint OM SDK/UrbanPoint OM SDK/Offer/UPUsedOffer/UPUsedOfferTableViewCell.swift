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
    @IBOutlet weak var outletSavingText: UILabel!
    
    struct Offer{
        let outletName: String
        let description: String
        let confirmationCode: String
        let saving: String
        let date: String
        let image: URL?
    }
    

    func configureCell(with model: Offer){
        outletNameLabel.text = model.outletName
        offerDescriptionLabel.text = model.description
        confirmationIDLabel.text = model.confirmationCode
        dateLabel.text = getDate(dateString: model.date)
        outletImageView.sd_setImage(with: model.image)
        outletSavingText.text = "You saved approximately QAR " + model.saving.getNumberWithoutDecimal()
    }
    
    
    private func getDate(dateString: String) -> String{
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString)else { return "" }
        formatter.dateFormat = "MMMM dd,yyyy"
        return formatter.string(from: date)
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
