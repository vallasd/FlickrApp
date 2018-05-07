//
//  FlickrCVC.swift
//  FlickrApp
//
//  Created by David Vallas on 5/6/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import UIKit

class FlickrCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let reuseIdentifier = "FlickrPhotoCell"
    fileprivate var transitionDelegate: HGTransDelegate?
    
    var photos: [Photo] = []
    var pages: [PagingData]?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set transition delegate
        setTransitionDelegate()
        
        // Add refresh control
        let rc = UIRefreshControl()
        let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
        rc.attributedTitle = NSAttributedString(string: title)
        rc.addTarget(self, action: #selector(refreshModel), for: .primaryActionTriggered)
        collectionView?.refreshControl = rc
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If we haven't already, kick off initial photo request.
        if photos.count == 0 {
            updateModel(withPageData: nil)
        }
    }
    
    // MARK: - Private Functions
    
    /// Refreshes the model.  If user is using app at later day, they simply need to pull down to refresh.
    @objc fileprivate func refreshModel() {
        photos = []
        pages = nil
        collectionView?.reloadData()
        updateModel(withPageData: nil)
    }
    
    /// Adds more photos if we are 20 photos from reaching the end of current photos in model and there are more pages to download.
    fileprivate func updateModel(forRow: Int) {
        if photos.count - 20 == forRow {
            if let p = pages, p.count > 0 {
                updateModel(withPageData: p.last)
                pages?.removeLast()
            }
        }
    }
    
    /// Adds photos to photos model, sets pages if it hasn't already been set
    fileprivate func updateModel(withPageData pd: PagingData?) {
        
        FlickrNetwork.shared.getInterestingnessPhotos(date: Date.yesterday, pagingData: pd) { [weak self] (result: ResultWithPagingData<[Photo]>) in
            switch result {
            case let .value(result):
                // if we haven't set the pages yet, we will now.
                if self?.pages == nil {
                    // get stack of pages to be downloaded.
                    var indexedPages = result.pagingData?.indexedPages ?? []
                    // indexedPages includes current page.  We just downloaded it, so we remove the page.
                    if indexedPages.count > 0 { indexedPages.removeLast() }
                    // update model and reload collectionview
                    self?.pages = indexedPages
                }
                self?.photos += result.value
                self?.collectionView?.reloadData()
                self?.collectionView?.refreshControl?.endRefreshing()
            case let .error(error):
                self?.present(error.alert, animated: true, completion: nil)
            }
        }
    }
    
    /// Sets the transition delegate with view transition settings. (Presentation Controller)
    fileprivate func setTransitionDelegate() {
        
        let chromeColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        let size = UIDevice.current.userInterfaceIdiom == .pad ? HGSize(wFPercent: 0.55, hFPercent: 0.65) : HGSize(wFPercent: 0.9, hFPercent: 0.8)
        let transitionSize = HGTransitionSize(start: size, displayed: size, end: size)
        let settings = HGTransitionSettings(position: .position(.center),
                                            directionIn: .position(.right),
                                            directionOut: .position(.left),
                                            fade: HGFade(fadeIn: false, fadeOut: false),
                                            speed: 0.3,
                                            chrome: chromeColor,
                                            entireScreen: true,
                                            chromeDismiss: true,
                                            size: transitionSize)
        
        transitionDelegate = HGTransDelegate(settings: settings, viewController: self)
    }
    
    /// Presents a FlickPhotoVC for a specific photo
    fileprivate func presentFlickPhotoVC(forRow: Int) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "FlickrPhotoVC") as! FlickrPhotoVC
        vc.photo = photos[forRow]
        vc.shadowAndCorner = true
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transitionDelegate
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
        cell.backgroundColor = UIColor.gray
        let photo = photos[indexPath.row]
        cell.imageView.kf.setImage(with: photo.thumbnailURL)
        updateModel(forRow: indexPath.row) // see if we need more photos
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentFlickPhotoVC(forRow: indexPath.row)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 5.0 : 3.0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + 1 // add one for rounding purposes
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
