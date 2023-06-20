//
//  UPNearbyOutletHomeTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/2/23.
//

import UIKit

class UPNearbyOutletHomeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UPNearbyOutletHomeTableViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    var onViewAllTapped: (() -> Void)?
    var onOutletSelected: ((NearbyOutlet) -> Void)?
    var data: [NearbyOutlet] = []
    
    
    internal func configureCell(data: [NearbyOutlet],
                                onViewAllTapped: @escaping () -> Void,
                                onOutletSelected: @escaping (NearbyOutlet) -> Void){
        self.data = data
        self.onViewAllTapped = onViewAllTapped
        self.onOutletSelected = onOutletSelected
        // Initialization code
        collectionView.reloadData()

        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

extension UPNearbyOutletHomeTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fetchCellCollectionView(collectionView, indexPath: indexPath)
    }
    
    
    
    private func fetchCellCollectionView(_ collectionView: UICollectionView,indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UPNearbyOutletHomeCollectionViewCell.reuseIdentifier, for: indexPath) as! UPNearbyOutletHomeCollectionViewCell

        cell.configureOutletCellWith(data[indexPath.item])

        return cell
    }


    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width:  150, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onOutletSelected?(data[indexPath.row])
    }
}

