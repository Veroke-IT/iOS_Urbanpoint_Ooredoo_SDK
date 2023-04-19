//
//  PopularCategoriesTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/31/23.
//

import UIKit

class UPPopularCategoriesTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UPPopularCategoriesTableViewCell"
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var onShowAllPopularCategoriesTapped: (() -> Void)?
    var onPopularCategoruSelected: ((PopularCategory) -> Void)?
    var data: [PopularCategory] = []
    var isExpanded: Bool = false
    
    internal func configureCell(with data: [PopularCategory],isExpanded: Bool){
        self.isExpanded = isExpanded
        self.data = data
        let imageName = isExpanded ? "uparrow" : "downarrow"
        
        viewAllButton.setImage(UIImage.loadImageWithName(imageName), for: .normal)
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAllButton.shadow(shadowColor: Colors.urbanPointGrey, shadowOffset: .zero, shadowRadius: viewAllButton.layer.cornerRadius, shadowOpacity: 0.3, shadowPath: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onViewAllTapped(_ sender: Any){
        onShowAllPopularCategoriesTapped?()
    }

}

extension UPPopularCategoriesTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        fetchCellForCategoriesCollectionView(collectionView, indexPath: indexPath)
        
    }
    
    private func fetchCellForCategoriesCollectionView(_ collectionView: UICollectionView,indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as! CategoriesCollectionViewCell
        let imageURL = "\(imageBaseURL)\(data[indexPath.row].image)"
        cell.configureCellWith(CategoriesCollectionViewCell.ViewModel(categoryImage: URL(string: imageURL)!))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let popularCategoriesItemCount = data.count
        let itemsToShow = isExpanded ? popularCategoriesItemCount : (popularCategoriesItemCount > 6 ? 6 : popularCategoriesItemCount)
        return itemsToShow
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.width / 3 * 0.99
        return CGSize(width:  size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onPopularCategoruSelected?(data[indexPath.row])
    }
}
