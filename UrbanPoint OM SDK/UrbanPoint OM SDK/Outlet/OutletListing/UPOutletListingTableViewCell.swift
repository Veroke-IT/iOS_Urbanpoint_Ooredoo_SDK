//
//  UPOutletListingTableViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import UIKit

class UPOutletListingTableViewCell: UITableViewCell {

    struct Outlet{
        let id: Int
        let outletName: String
        let image: URL?
        let distance: String
        var isExpanded: Bool
        let offers: [UPOffer]
        let isParentOutlet: Bool 
        var numberOfOffers: Int {
            offers.count
        }
    }
    
    static let reuseIdentifier = "UPOutletListingTableViewCell"
 
    var indexPath: IndexPath? = nil
    @IBOutlet weak var offerTableView: UITableView!
    @IBOutlet weak var offerTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var outletImageView: UIImageView!
    @IBOutlet weak var outletNameLabel: UILabel!
    @IBOutlet weak var outletAddressLabel: UILabel!
    @IBOutlet weak var offerButtonLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var seperatorView: UIView!
    
    private var onOfferSelected: ((UPOffer) -> Void)?
    private var onCellExpanded:  ((UPOutletListingTableViewCell.Outlet,IndexPath) -> Void)?
    private var onOutletSelected: ((UPOutletListingTableViewCell.Outlet) -> Void)?
  
    var outlet: UPOutletListingTableViewCell.Outlet?{
        didSet{
            if outlet?.isExpanded ?? false{
                seperatorView.isHidden = false
                offerTableViewHeightConstraint.constant = CGFloat(90 * (outlet?.numberOfOffers ?? 0))
            }else{
                seperatorView.isHidden = true
                offerTableViewHeightConstraint.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        offerTableView.delegate = self
        offerTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func configureCell(outlet: UPOutletListingTableViewCell.Outlet,
                                onOutletSelected: @escaping ((UPOutletListingTableViewCell.Outlet) -> Void),
                                onCellExpanded:@escaping (UPOutletListingTableViewCell.Outlet,IndexPath) -> Void,
                                onOfferSelected: ((UPOffer) -> Void)? = nil,
                                indexPath: IndexPath){
        
        self.indexPath = indexPath
        self.outlet = outlet
        self.onCellExpanded = onCellExpanded
        self.onOfferSelected = onOfferSelected
        self.onOutletSelected = onOutletSelected
        offerTableView.reloadData()
        setupCellUI()
    }
  
    private func setupCellUI(){
        if let outlet{
            outletNameLabel.text = outlet.outletName
            outletAddressLabel.text = outlet.distance
            if let url = outlet.image{
                outletImageView.sd_setImage(with: url)
            }
        }
    }
    @IBAction func nextButtonTouched(_ sender: Any){
        if let outlet{
            onOutletSelected?(outlet)
        }
    }
    @IBAction func offersButtonTouched(_ sender: Any){
        if let outlet,
        let indexPath{
            onCellExpanded?(outlet,indexPath)
        }
    }
}

extension UPOutletListingTableViewCell: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let outlet, outlet.isExpanded{
            return outlet.numberOfOffers
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        makeCell(tableView: tableView, indexPath: indexPath)
    }
    
    private func makeCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UPOfferTableViewCell.reuseIdentifier, for: indexPath) as? UPOfferTableViewCell  else { return UITableViewCell() }
   
        if let offer = outlet?.offers[indexPath.row]{
            cell.configureCellWith(offer)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let offer = outlet?.offers[indexPath.row]{
            onOfferSelected?(offer)
        }
    }
    
}
