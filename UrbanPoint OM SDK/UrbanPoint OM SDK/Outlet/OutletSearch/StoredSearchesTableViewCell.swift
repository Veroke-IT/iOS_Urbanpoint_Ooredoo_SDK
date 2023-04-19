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
  
    var onDeleteSearchTapped: ((String) -> Void)?
    
    var searchString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWith(_ trendingSearchText: String){
        self.searchString = trendingSearchText
        searchTextLabel.text = trendingSearchText
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onDeleteSearchTapped(_ sender: Any){
        onDeleteSearchTapped?(searchString)
    }

}
