//
//  UPUsedOfferViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/16/23.
//

import UIKit

class UPUsedOfferViewController: UIViewController {

    var viewModel: UPUsedOfferViewModel? = nil
    @IBOutlet weak var offerTableView: UITableView!
    private var index: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOffers()
        
    }

    private func fetchOffers(){
        showActivityIndicator()
        viewModel?.fetchUsedOffer(index: 1, completion: {[weak self] errorString in
            self?.hideActivityIndicator()
            if let errorString{
                self?.showAlert(title: .alert, message: errorString)
            }else{
                self?.offerTableView.reloadData()
            }
        })
    }

}

extension UPUsedOfferViewController: UITableViewDelegate,UITableViewDataSource{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.offers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UPUsedOfferTableViewCell.reuseIdentifier, for: indexPath)
        as! UPUsedOfferTableViewCell
        if let offer = viewModel?.offers[indexPath.row]{
            cell.configureCell(with: createModel(with: offer))
        }
        return cell
    }
    
    private func createModel(with offer: UPOffer) -> UPUsedOfferTableViewCell.Offer{
        UPUsedOfferTableViewCell.Offer(outletName: offer.outletName, description: offer.description, confirmationCode: String(offer.id), date: offer.endDatetime, image: URL(string: imageBaseURL + offer.image))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
