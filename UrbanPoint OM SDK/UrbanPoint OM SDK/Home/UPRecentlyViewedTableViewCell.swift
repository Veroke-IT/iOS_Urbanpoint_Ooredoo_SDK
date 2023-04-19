//
//  UPRecentlyViewedTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/17/23.
//

import UIKit

class UPRecentlyViewedTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UPRecentlyViewedTableViewCell"
    var data: [RecentlyViewedOutlet] = []
    var onOutletSelected: ((Int) -> Void)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    internal func configureCell(with data: [RecentlyViewedOutlet],
                                onOutletSelected: @escaping (Int) -> Void){
        self.data = data
        self.onOutletSelected = onOutletSelected
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension UPRecentlyViewedTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fetchCellCollectionView(collectionView, indexPath: indexPath)
    }
    
    private func fetchCellCollectionView(_ collectionView: UICollectionView,indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UPRecentlyViewedCollectionViewCell.reuseIdentifier, for: indexPath) as! UPRecentlyViewedCollectionViewCell
        
        cell.configureCell(with: data[indexPath.item])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width:  80, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onOutletSelected?(data[indexPath.row].id)
    }
}
