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
    
    var onBackButtonTapped: (() -> Void)?
    var showOfferDetail: ((Int) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOffers()
       

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func onBackButtonTapped(_ sender: Any){
        onBackButtonTapped?()
    }
    
    
    
    private func fetchOffers(){
        showActivityIndicator()
        viewModel?.fetchUsedOffer(index: index, completion: {[weak self] errorString in
            self?.hideActivityIndicator()
            if let errorString{
                self?.showAlert(title: .alert, message: errorString)
            }else{
                DispatchQueue.main.async {
                    if self?.viewModel?.offers.count == 0{
                        self?.showAlert(title: .alert, message: "No data found",
                        onOkTapped: {[weak self] in
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.offerTableView.reloadData()
                    }
                }
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
        UPUsedOfferTableViewCell.Offer(outletName: offer.outletName ?? "", description: offer.title ?? "", confirmationCode: String(offer.id ?? -1), saving: String(offer.approxSaving ?? 0), date: offer.endDatetime ?? "", image: URL(string: imageBaseURL + (offer.logo ?? "")))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let offers = viewModel?.offers, !offers.isEmpty{
            if indexPath.row == offers.count{
                index += 1
                fetchOffers()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedOffer = viewModel?.offers[indexPath.row] else { return }
        if let id = selectedOffer.id{
            showOfferDetail?(id)
        }
        
    }
}
