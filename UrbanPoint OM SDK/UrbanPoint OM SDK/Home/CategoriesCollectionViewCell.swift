//
//  CategoriesCollectionViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit



class CategoriesCollectionViewCell: UICollectionViewCell {

    static let identifier = "CategoriesCollectionViewCell"
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryImageViewContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    var task: URLSessionDataTask?
    
    struct ViewModel{
        let categoryImage: URL?
        let name: String
    }
    
    func configureCellWith(_ viewModel: CategoriesCollectionViewCell.ViewModel){
        
        nameLabel.text = viewModel.name
        categoryImageView.sd_setImage(with: viewModel.categoryImage,placeholderImage: nil)
//        { image, error, cache, url in
//            if error != nil{
//                DispatchQueue.main.async {[weak self] in
//                    self?.categoryImageView.isHidden = true
//                    self?.categoryImageViewContainer.backgroundColor = Colors.urbanPointGrey
//                }
//            }
//        }
    }
    
    
    override func prepareForReuse() {
      //  categoryImageView.image = nil
        super.prepareForReuse()
        
    }
    
    

    
    
    
}
