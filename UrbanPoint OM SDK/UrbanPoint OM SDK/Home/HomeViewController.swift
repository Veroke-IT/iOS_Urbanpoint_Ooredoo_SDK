
//  HomeViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/8/23.
//

import UIKit

class UPHomeViewController: UIViewController {

    let homePresenter: UPHomeViewModel = UPHomeViewModel(homeService: HttpHomeService(httpClient: UPURLSessionHttpClient(session: URLSession(configuration: .ephemeral))))
    
    var isPopularCategoriesListExpanded: Bool = false
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        homePresenter.fetchEssentialData { errorString in
            if let errorString{
                debugPrint(errorString)
            }else{
                self.homePresenter.fetchCachedData { errorString in
                    if let errorString{
                        debugPrint(errorString)
                    }else{
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
  
    @IBAction private func onTopBarTapped(_ sender: Any){
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "OutletSearch", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "OutletSearchViewController") as! OutletSearchViewController
        navigationController?.pushViewController(viewController, animated: true)
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
            return (homePresenter.nearbyOutlet.count > 0) ? UITableView.automaticDimension : 0
        }
        else if indexPath.row == 3{
            
            return (homePresenter.popularCategories.count > 0) ? fetchTableRowSizeForPopularCategories() : 0
            
        }
        else if indexPath.row == 4{
            return (homePresenter.newBrand.count > 0) ?
                UITableView.automaticDimension : 0
        }
        
        return UITableView.automaticDimension
    }
    
    private func fetchTableRowSizeForPopularCategories() -> CGFloat{
        let heightForOneRow = (tableView.bounds.width - 32) / 3 * 0.99
        let popularCategoriesItemCount = homePresenter.popularCategories.count
        let itemsToShow = isPopularCategoriesListExpanded ? popularCategoriesItemCount : (popularCategoriesItemCount > 6 ? 6 : popularCategoriesItemCount)
        return (ceil(CGFloat(itemsToShow) / 3) * heightForOneRow) + 105 + 25
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: UPHomeCategoriesTableViewCell.reuseIdentifier, for: indexPath) as! UPHomeCategoriesTableViewCell
            cell.configureCell(with: homePresenter.categories, onViewAllTapped: onViewAllCategoriesTapped)
                return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: UPUseAgainOfferHomeTableViewCell.reuseIdentifier, for: indexPath) as! UPUseAgainOfferHomeTableViewCell
            cell.configureCell(data: [], onOfferSelected: onUsedOfferSelected, onViewAllTapped: onViewAllUsedOffersTapped )
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UPNearbyOutletHomeTableViewCell.reuseIdentifier, for: indexPath) as! UPNearbyOutletHomeTableViewCell
            cell.configureCell(data: homePresenter.nearbyOutlet, onViewAllTapped: onViewAllNearbyTapped, onOutletSelected: onNeerbyOutletSelected)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: UPPopularCategoriesTableViewCell.reuseIdentifier, for: indexPath) as! UPPopularCategoriesTableViewCell
            cell.configureCell(with: homePresenter.popularCategories)
            cell.onShowAllPopularCategoriesTapped = {
                self.isPopularCategoriesListExpanded.toggle()
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewBrandsTableViewCell.reuseIdentifier, for: indexPath) as! NewBrandsTableViewCell
            cell.configureCell(data: homePresenter.newBrand,
                               onViewAllTapped: onViewAllNewBrandTapped,
                               onOutletSelected: onNewBrandSelected )
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    private func onViewAllCategoriesTapped(){}
    private func onCategorySelected(category: Category){}
    
    private func onViewAllUsedOffersTapped(){}
    private func onUsedOfferSelected(category: UseAgainOffer){}
    
    private func onViewAllNewBrandTapped(){
        
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "OutletListing", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "UPCategoriesViewController") as! UPCategoriesViewController
    
        let httpClient = UPURLSessionHttpClient(session: URLSession.shared)
        let outletRespository = URLSessionOutletRepository(httpClient: httpClient)
        let outletPresenter = OutletListingPresenter(outletRepository: outletRespository)
 
        viewController.titleString = "New Brands"
        viewController.listingViewModel = outletPresenter
        navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    private func onNewBrandSelected(_ brand: NewBrand){}
    
    private func onViewAllNearbyTapped(){
        let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
        let viewController = UIStoryboard(name: "OutletListing", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "UPCategoriesViewController") as! UPCategoriesViewController
        let httpClient = UPURLSessionHttpClient(session: URLSession.shared)
        let outletRespository = URLSessionOutletRepository(httpClient: httpClient)
        let outletPresenter = OutletListingPresenter(outletRepository: outletRespository)

        viewController.titleString = "Nearby Outlets"
        viewController.listingViewModel = outletPresenter
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    private func onNeerbyOutletSelected(_ nearbyOutlet: NearbyOutlet){}
    
}
