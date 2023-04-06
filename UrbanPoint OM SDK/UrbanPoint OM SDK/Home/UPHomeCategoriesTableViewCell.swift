//
//  UPHomeCategoriesTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/31/23.
//

import UIKit

class UPHomeCategoriesTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UPHomeCategoriesTableViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var data: [Category] = []
    private var onViewAllTapped: (() -> Void)? = nil
    
    
    internal func configureCell(with data: [Category],
                                onViewAllTapped: @escaping () -> Void){
        self.data = data
        self.onViewAllTapped = onViewAllTapped
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
            collectionView.delegate = self
            collectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onViewAllTapped(_ sender: Any){}
    
}

extension UPHomeCategoriesTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    
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
        CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
}
