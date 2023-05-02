//
//  UPUseAgainOfferHomeTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/31/23.
//

import UIKit

class UPUseAgainOfferHomeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UPUseAgainOfferHomeTableViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var onOfferSelected: ((UseAgainOffer) -> Void)? = nil
    var onViewAllTapped: (() -> Void)? = nil

    var data: [UseAgainOffer] = []
    
    
    
    internal func configureCell(data: [UseAgainOffer],
                                onOfferSelected: @escaping (UseAgainOffer) -> Void,
                                onViewAllTapped: @escaping () -> Void){
        self.data = data
        self.onOfferSelected = onOfferSelected
        self.onViewAllTapped = onViewAllTapped
   
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onViewAllOffersTapped(_ sender: Any){
        onViewAllTapped?()
    }
    
    
    
}

extension UPUseAgainOfferHomeTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        fetchCellForCategoriesCollectionView(collectionView, indexPath: indexPath)
        
    }
    
    private func fetchCellForCategoriesCollectionView(_ collectionView: UICollectionView,indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UPUseAgainOfferCollectionViewCell.identifier, for: indexPath) as! UPUseAgainOfferCollectionViewCell
       
        cell.configureCellWith(data[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width * 0.9, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onOfferSelected?(data[indexPath.row])
    }
}
