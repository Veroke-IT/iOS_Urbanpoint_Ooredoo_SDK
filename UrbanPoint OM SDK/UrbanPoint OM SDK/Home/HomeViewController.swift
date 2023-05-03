
//  HomeViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/8/23.
//

import UIKit

class UPHomeViewController: UIViewController {

    var homePresenter: UPHomeViewModel!
    var isPopularCategoriesListExpanded: Bool = false
  
    @IBOutlet weak var tableView: UITableView!
    
    //Events
    
    var showOutletDetail: ((Int) -> Void)?
    var showUseAgainOffer: ((Int) -> Void)?
    
    var onNewBrandsTapped: (() -> Void)?
    var onParentBrandSelected: ((Int,String) -> Void)?
    var onViewAllNearbyOutletsTapped: (() -> Void)?
    
    var onCategorySelected: ((Int) -> Void)?
    var onPopoularCategorySelected: ((Int,String) -> Void)?
    
    var onSettingButtonTapped: (() -> Void)?
    var onTopBarTapped: (() -> Void)?
    
    var onViewAllOffersTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicator()
        tableView.isHidden = true
        homePresenter.fetchEssentialData {[weak self] errorString in
            if let errorString{
                self?.hideActivityIndicator()
                self?.showAlert(title: .alert, message: errorString)
            }else{
                self?.homePresenter.fetchCachedData {[weak self]  errorString in
                    self?.hideActivityIndicator()
                    if let errorString{
                        self?.showAlert(title: .alert, message: errorString)
                    }else{
                        DispatchQueue.main.async {
                            self?.tableView.isHidden = false
                            self?.homePresenter.fetchRecentlyViewedOutlets()
                            self?.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homePresenter.fetchRecentlyViewedOutlets()
        if homePresenter.recentlyViewedOutlet.count > 0{
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        }
    }
    
    @IBAction private func onSettingsButtonTapped(_ sender: Any){
        onSettingButtonTapped?()
    }
  
    @IBAction private func onTopBarTapped(_ sender: Any){
        onTopBarTapped?()
    }
    
}
extension UPHomeViewController: UITableViewDataSource,UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return homePresenter.categories.count > 0 ? UITableView.automaticDimension : 0
        }
        else if indexPath.row == 1{
            return (homePresenter.useAgainOffers.count > 0) ? UITableView.automaticDimension : 0
        }
        else if indexPath.row == 2{
            return (homePresenter.recentlyViewedOutlet.count > 0) ? UITableView.automaticDimension : 0
           
        }
        else if indexPath.row == 3{
            return (homePresenter.nearbyOutlet.count > 0) ? UITableView.automaticDimension : 0
        }
        else if indexPath.row == 4{
            
            return (homePresenter.popularCategories.count > 0) ? fetchTableRowSizeForPopularCategories() : 0
            
        }
        else if indexPath.row == 5{
            return (homePresenter.newBrand.count > 0) ?
                UITableView.automaticDimension : 0
        }
        
        return UITableView.automaticDimension
    }
    
    private func fetchTableRowSizeForPopularCategories() -> CGFloat{
        let heightForOneRow = (tableView.bounds.width - 32) / 3 * 0.99
        let popularCategoriesItemCount = homePresenter.popularCategories.count
        let itemsToShow = isPopularCategoriesListExpanded ? popularCategoriesItemCount : (popularCategoriesItemCount > 6 ? 6 : popularCategoriesItemCount)
        return (ceil(CGFloat(itemsToShow) / 3) * heightForOneRow) + 105 + 25 + 16
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: UPHomeCategoriesTableViewCell.reuseIdentifier, for: indexPath) as! UPHomeCategoriesTableViewCell
            cell.configureCell(with: homePresenter.categories, onCategorySelected: onCategorySelected)
                return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: UPUseAgainOfferHomeTableViewCell.reuseIdentifier, for: indexPath) as! UPUseAgainOfferHomeTableViewCell
            cell.configureCell(data: homePresenter.useAgainOffers, onOfferSelected: onUsedOfferSelected, onViewAllTapped: onViewAllUsedOffersTapped )
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: UPRecentlyViewedTableViewCell.reuseIdentifier, for: indexPath)
            as! UPRecentlyViewedTableViewCell
            cell.configureCell(with: homePresenter.recentlyViewedOutlet, onOutletSelected: onRecentlyViewedOutletSelected)
        
            return cell
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UPNearbyOutletHomeTableViewCell.reuseIdentifier, for: indexPath) as! UPNearbyOutletHomeTableViewCell
            cell.configureCell(data: homePresenter.nearbyOutlet, onViewAllTapped: onViewAllNearbyTapped, onOutletSelected: onNeerbyOutletSelected)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: UPPopularCategoriesTableViewCell.reuseIdentifier, for: indexPath) as! UPPopularCategoriesTableViewCell
            cell.configureCell(with: homePresenter.popularCategories,isExpanded: isPopularCategoriesListExpanded)
            cell.onPopularCategoruSelected = onPopularCategorySelected
            cell.onShowAllPopularCategoriesTapped = {
                self.isPopularCategoriesListExpanded.toggle()
                self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewBrandsTableViewCell.reuseIdentifier, for: indexPath) as! NewBrandsTableViewCell
            cell.configureCell(data: homePresenter.newBrand,
                               onViewAllTapped: onViewAllNewBrandTapped,
                               onOutletSelected: onNewBrandSelected )
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    private func onPopularCategorySelected(category: PopularCategory){
        onPopoularCategorySelected?(category.id, category.name)
        
    }
    
    private func onCategorySelected(category: Category){
        if let id = Int(category.id){
            onCategorySelected?(id)
        }
    }
    
    private func onViewAllUsedOffersTapped(){
        onViewAllOffersTapped?()
    }
    private func onUsedOfferSelected(category: UseAgainOffer){
        if let id = category.id,
        let offerID = Int(id){
            showUseAgainOffer?(offerID)
        }
    }
    
    private func onViewAllNewBrandTapped(){
        onNewBrandsTapped?()
    }
   
    private func onNewBrandSelected(_ brand: NewBrand){
        
        guard let id = Int(brand.id) else { return }
        if brand.isMultipleChild{
            onParentBrandSelected?(id,brand.parentOutletName)
        }else{
            showOutletDetail?(id)
        }
    }
    
    private func onViewAllNearbyTapped(){
        onViewAllNearbyOutletsTapped?()
    }
    
    private func onNeerbyOutletSelected(_ nearbyOutlet: NearbyOutlet){
        showOutletDetail?(nearbyOutlet.id)
    }
    
    private func onRecentlyViewedOutletSelected(_ id: Int){
        showOutletDetail?(id)
    }
}
