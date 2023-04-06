//
//  StoredSearchesTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/31/23.
//

import UIKit

class StoredSearchesTableViewCell: UITableViewCell {

    static let cellIdentifierString = "StoredSearchesTableViewCell"
    @IBOutlet weak var searchTextLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWith(_ trendingSearchText: String){
        searchTextLabel.text = trendingSearchText
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
