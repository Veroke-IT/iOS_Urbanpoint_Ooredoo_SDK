//
//  OutletListingViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/3/23.
//

import UIKit

class OutletListingViewController: UIViewController {

    @IBOutlet weak var outletTableView: UITableView!
   
    var outlets: [UPOutletListingTableViewCell.Outlet] = []
  
    var onOfferSelected: ((UPOffer) -> Void)? = nil
    var onTableEndPoisitionReached: (() -> Void)? = nil
    var onOutletSelected: ((UPOutletListingTableViewCell.Outlet) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
   }
    
    //MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        outletTableView.delegate = self
        outletTableView.dataSource = self
    }
  
    internal func showOutletData(_ outlets: [UPOutletListingTableViewCell.Outlet]){
        self.outlets = outlets
        DispatchQueue.main.async {[weak self] in
            self?.outletTableView.reloadData()
        }
    }
}

extension OutletListingViewController: UITableViewDataSource,UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        outlets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if outlets[indexPath.row].isExpanded { return 168 + CGFloat(outlets[indexPath.row].numberOfOffers * 90) }
        else { return 128 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            makeCell(tableView: tableView, indexPath: indexPath)
    }
    
    private func makeCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UPOutletListingTableViewCell.reuseIdentifier, for: indexPath) as? UPOutletListingTableViewCell  else { return UITableViewCell() }
        cell.configureCell(outlet: outlets[indexPath.row], onOutletSelected: onOutletSelected ?? {_ in }, onCellExpanded: onCellExpanded, onOfferSelected: onOfferSelected, indexPath: indexPath)
        return cell
    }
    
    private func onCellExpanded(outlet: UPOutletListingTableViewCell.Outlet,indexPath: IndexPath){
        if let outletIndex = outlets.firstIndex(where: { $0.id == outlet.id }){
               outlets[outletIndex].isExpanded.toggle()
               outletTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == outlets.count - 1 { onTableEndPoisitionReached?() }
    }
    
   
}
