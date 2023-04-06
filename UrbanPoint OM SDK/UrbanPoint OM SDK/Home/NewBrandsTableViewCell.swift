//
//  NewBrandsTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/2/23.
//

import UIKit

class NewBrandsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "NewBrandsTableViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var onViewAllTapped: (() -> Void)?
    var onOutletSelected: ((NewBrand) -> Void)?
    var data: [NewBrand] = []
    
    
    internal func configureCell(data: [NewBrand],
                                onViewAllTapped: @escaping () -> Void,
                                onOutletSelected: @escaping (NewBrand) -> Void){
        self.data = data
        self.onViewAllTapped = onViewAllTapped
        self.onOutletSelected = onOutletSelected

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

    }
    
    @IBAction func onViewAllTapped(_ sender: Any){
        onViewAllTapped?()
    }

}

extension NewBrandsTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fetchCellCollectionView(collectionView, indexPath: indexPath)
    }
    
    private func fetchCellCollectionView(_ collectionView: UICollectionView,indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBrandsHomeCollectionViewCell.reuseIdentifier, for: indexPath) as! NewBrandsHomeCollectionViewCell
        
        cell.configureOutletCellWith(data[indexPath.item])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width:  150, height: collectionView.bounds.height)
    }
    
}
