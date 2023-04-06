//
//  TrendingTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/30/23.
//

import UIKit

class TrendingTableViewCell: UITableViewCell {
    
    static let cellIdentifierString = "TrendingTableViewCell"
    @IBOutlet weak var trendingLabel: UILabel!
    
    
    func configureCellWith(_ trendingSearchText: String){
        trendingLabel.text = trendingSearchText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
    }

    
    
    
}
