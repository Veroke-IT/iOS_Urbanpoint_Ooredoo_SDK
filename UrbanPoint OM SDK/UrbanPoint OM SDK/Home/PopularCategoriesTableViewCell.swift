//
//  PopularCategoriesTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/31/23.
//

import UIKit

class UPPopularCategoriesTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UPPopularCategoriesTableViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var onShowAllPopularCategoriesTapped: (() -> Void)?
    var onPopularCategoruSelected: ((PopularCategory) -> Void)?
    var data: [PopularCategory] = []
    
    internal func configureCell(with data: [PopularCategory]){
        self.data = data
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        let imageURL = "https://urbanpoint-storage.azureedge.net/test/uploads_staging/uploads/\(data[indexPath.row].image)"
        cell.configureCellWith(CategoriesCollectionViewCell.ViewModel(categoryImage: URL(string: imageURL)!))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.width / 3 * 0.99
        return CGSize(width:  size, height: size)
    }
    
}
