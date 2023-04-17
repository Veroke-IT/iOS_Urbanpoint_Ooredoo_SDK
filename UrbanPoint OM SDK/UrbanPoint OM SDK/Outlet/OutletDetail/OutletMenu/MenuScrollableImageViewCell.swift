//
//  MenuScrollableImageViewCell.swift
//  Urban Point - Swift
//
//  Created by Murtaza Mehmood on 28/03/2022.
//  Copyright © 2022 Urban Point. All rights reserved.
//

import UIKit
import SDWebImage

class MenuScrollableImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollableImage: ScrollableImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}

class ScrollableImage: UIScrollView {
    
    private let imageView = UIImageView()
    
    var imageName: String? {
        didSet {
            imageView.sd_setImage(with: URL(string: imageBaseURL + (imageName ?? "") ), placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        // Setup image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        
        // Setup scroll view
        minimumZoomScale = 1
        maximumZoomScale = 3
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        
        
        // Setup tap gesture
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if zoomScale == 1 {
            setZoomScale(2, animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
}


extension ScrollableImage: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
