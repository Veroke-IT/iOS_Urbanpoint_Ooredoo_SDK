//
//  OutletDetailViewController.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/7/23.
//

import UIKit
import CoreLocation
import SDWebImage
import BranchSDK




class OutletDetailViewController: UIViewController {
    
    var recentlyVisitEventDelegate: RecentlyViewedOutletEventDelegate? = nil
    
    @IBOutlet weak var offerTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var outletLogoImageView: UIImageView!
    @IBOutlet weak var outletTitle: UILabel!
    @IBOutlet weak var outletAddress: UILabel!
    
    @IBOutlet weak var uberButton: UIView!
    @IBOutlet weak var menuButton: UIView!
    @IBOutlet weak var callButton: UIView!
    @IBOutlet weak var findITButtonView: UIView!
    
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var outletDescription: UILabel!
    @IBOutlet weak var startTimeDateLabel: UILabel!
    @IBOutlet weak var outletImagesPageController: UIPageControl!
    @IBOutlet weak var outletLogoBgImageView: UIView!
    @IBOutlet weak var availableMapView: UIView!
    @IBOutlet weak var outletImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    
    //State
    var currentIndex: Int = 0
    var timer: Timer?
    
    var viewModel: UPOutletDetailViewModel? = nil
    

    
    
    //Event
    var onOfferSelected: ((Int) -> Void)?
    var onBackButtonTapped: (() -> Void)?
    var onOfferShared: ((UPOffer) -> Void)?
    var onMenuSelected: (([UPOutlet.OutletMenu]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outletImagesPageController.numberOfPages = 0
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        offerTableViewHeightConstraint.constant = 90 * 5
        setupInitialUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.isHidden = false
        showActivityIndicator()
        viewModel?.fetchOutlet(completion: {[weak self] errorString in
            self?.hideActivityIndicator()
            if let errorString{
                self?.showAlert(title: .alert, message: errorString,onOkTapped: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }else{
                DispatchQueue.main.async {[weak self] in
                    self?.setupUIWithOutlet()
                    self?.backgroundView.isHidden = true
                }
            }
        })
    }
    
    private func setupInitialUI(){
        setupShadowForTopButtons(button: menuButton)
        setupShadowForTopButtons(button: callButton)
        setupShadowForTopButtons(button: uberButton)
        setupShadowForTopButtons(button: findITButtonView)
        setupShadowForTopButtons(button: availableMapView)
    }
    
    
    private func setupShadowForTopButtons(button: UIView){
        button.shadow(shadowColor: Colors.urbanPointGrey,
                  shadowRadius: 8,
                  shadowOpacity: 1)
    }
    
    private func setupUIWithOutlet(){
        
        recentlyVisitEventDelegate?.saveOutlet(outletName: viewModel?.outlet?.outletName ?? "", outletID: viewModel?.outlet?.id ?? -1 , outletLogoURL: viewModel?.outlet?.outletImage?.absoluteString ?? "")
        outletTitle.text = viewModel?.outlet?.outletName
        outletDescription.text = viewModel?.outlet?.outletDescription
        
        if let startEndTime = viewModel?.outlet?.outletTimings {
            let startEndTimeString = startEndTime.split(separator: ";")
                .map { String($0) }
                .reduce("", { partialResult,string in
                    partialResult.isEmpty ? string : (partialResult + "\n" + string)
                 })
            self.startTimeDateLabel.text = startEndTimeString
        }
        else{
            self.startTimeDateLabel.text = ""
        }
        
        outletAddress.text = viewModel?.outlet?.outletAddress
        menuButton.isHidden = viewModel?.outlet?.outletMenu == nil
        menuButton.isHidden = viewModel?.outlet?.outletMenu == nil
        offerTableViewHeightConstraint.constant = CGFloat(90 * (viewModel?.outlet?.outletOffers.count ?? 0))
        outletLogoImageView.sd_setImage(with: viewModel?.outlet?.outletImage)
        offersTableView.reloadData()
        
        
        if viewModel?.outlet?.bannerImages.count ?? 0 > 1{
            outletImagesPageController.numberOfPages = viewModel?.outlet?.bannerImages.count ?? 0
            imagesCollectionView.reloadData()
        }
        else if let oneAndOnlyImage = viewModel?.outlet?.bannerImages.first{
            imagesCollectionView.isHidden = true
            outletImageView.isHidden = false
            outletImageView.sd_setImage(with: oneAndOnlyImage)
        }
        
        menuButton.isHidden = !(viewModel?.outlet?.outletMenu.count ?? 0 > 0)
        
    }
    
    @IBAction func onFindOutletTapped(_ sender: Any){
        if let longitude = viewModel?.outlet?.outletLongitude,
           let latitude = viewModel?.outlet?.outletLatitude{
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }}
            else {
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
        }
    }
            
    
    fileprivate func callButtonAlertSheet(_ numbers: [String]) {
        
        let alert = UIAlertController(title: "Call", message: nil, preferredStyle: .actionSheet)
        for number in numbers {
            let callAction = UIAlertAction(title: "Call \(number)", style: .default) { action in
                let numberString = action.title ?? ""
                let onlyNumber = numberString.components(separatedBy: " ")
                if let num = onlyNumber.last {
                    let numberURL = URL(string: "tel://"+(num))!
                    UIApplication.shared.open(numberURL, options: [:], completionHandler: nil)
                }

            }
            alert.addAction(callAction)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
    private func shareURL(_ url: String){
        let textToShare = "Check these offers of \(viewModel?.outlet?.outletName ?? "" ) on UrbanPoint.\n" + url
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onCallOutletTapped(_ sender: Any){
        if let phonesArray = viewModel?.outlet?.outletPhonenNumber
        {
            if phonesArray.count > 1 {
                callButtonAlertSheet(phonesArray)
            }else{
                guard let number = URL(string: "tel://" + (phonesArray.first ?? "")) else { return }
                UIApplication.shared.open(number, options: [:], completionHandler: nil)
            }
        }
    }
  
    
    @IBAction func onMenuTapped(_ sender: Any){
      
        guard let menu = viewModel?.outlet?.outletMenu else { return }
        onMenuSelected?(menu)

        
        
        
//            let storyBoardBundle = Bundle(identifier: "com.UrbanPoint-OM-SDK")
//            let viewController = UIStoryboard(name: "OutletDetail", bundle: storyBoardBundle).instantiateViewController(withIdentifier: "UPOutletMenuViewController") as! UPOutletMenuViewController
//            viewController.urlToResource = URL(string: "https://www.google.com")
//            self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onUberTapped(_ sender: Any){
        
//        guard let outlet = viewModel?.outlet,
//        let location = viewModel?.currentLocation
//        else{ return }
////        
//        let builder = RideParametersBuilder()
////        let pickupLocation = CLLocation(latitude: (Constants.UPLOCATION.currentLocation?.coordinate.latitude)!, longitude:(Constants.UPLOCATION.currentLocation?.coordinate.longitude)!)
//        let dropoffLocation = CLLocation(latitude:(outlet.outletLatitude), longitude:outlet.outletLongitude)
//        //builder.pickupLocation = pickupLocation
//        builder.dropoffLocation = dropoffLocation
//        builder.dropoffNickname = outlet.outletName
//        builder.dropoffAddress = outlet.outletAddress
//        let rideParameters = builder.build()
//
//        let deeplink = RequestDeeplink(rideParameters: rideParameters)
//        uberButton.isHidden = false
        
        
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any){
        onBackButtonTapped?()
    }
    
    @IBAction func onShareOutletTapped(_ sender: Any){
        let branchIO = BranchUniversalObject(canonicalIdentifier: "UrbanPoint")
        let appID = "1"
        let linkProperties = BranchLinkProperties()
        linkProperties.addControlParam("id", withValue: String(viewModel?.outlet?.id ?? -1) )
        linkProperties.addControlParam("app_id", withValue: appID)
        linkProperties.addControlParam("navigation_type", withValue: "merchant")
        if let outletID = viewModel?.outlet?.id{
            linkProperties.addControlParam("$android_deeplink_path", withValue: "urban-point.app.link//merchantid=\(outletID)@\(appID)")
        }
        branchIO.getShortUrl(with: linkProperties) { (url, error) in
            if (error == nil) {
                DispatchQueue.main.async {
                    self.shareURL(url ?? "")
                }
            }
            else {
                print(String(format: "Branch error : %@", error! as CVarArg))
            }
        }
    }
    
}

extension OutletDetailViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.outlet?.outletOffers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UPOfferTableViewCell.reuseIdentifier) as! UPOfferTableViewCell
        if let offer = viewModel?.outlet?.outletOffers[indexPath.row]{
            cell.configureCellWith(offer)
        }
        setupShadowForTopButtons(button: cell.mainView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (viewModel?.outlet?.outletOffers[indexPath.row]) != nil ? 90 : 0
    }
    
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let offer = viewModel?.outlet?.outletOffers[indexPath.row]{
            onOfferSelected?(offer.id ?? -1)
        }
    }
}


extension OutletDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.outlet?.bannerImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OutletDetailHeaderCollectionViewCell.identifier, for: indexPath) as! OutletDetailHeaderCollectionViewCell
        
        if let url = viewModel?.outlet?.bannerImages[indexPath.row]{
            cell.setupImage(url: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    @objc func update() {
        guard let count = viewModel?.outlet?.bannerImages.count else { return }
        if currentIndex >= count - 1 {
            currentIndex = 0
        }else{
            currentIndex += 1
        }
     
        imagesCollectionView.scrollRectToVisible(CGRect(x: imagesCollectionView.frame.width * CGFloat(currentIndex), y: 0, width: imagesCollectionView.frame.width, height: imagesCollectionView.frame.height), animated: true)
        outletImagesPageController.currentPage = currentIndex
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        outletImagesPageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        timer?.invalidate()
    }
}
