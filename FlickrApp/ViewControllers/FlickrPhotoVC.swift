//
//  FlickrPhotoVC.swift
//  FlickrApp
//
//  Created by David Vallas on 5/6/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import UIKit

class FlickrPhotoVC: UIViewController {
    
    var photo: Photo! // we want to crash if photo is not set before viewDidLoad
    var shadowAndCorner = false // if we want to add shadow and rounded corner to view
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var dateTakenLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add shadow and rounded corner if set
        if shadowAndCorner {
            view.shadowAndCorner()
        }
        
        // Add photo details
        imageView.kf.setImage(with: photo.imageURL)
        titleLabel.text = photo.title
        ownerNameLabel.text = photo.ownerName
        dateTakenLabel.text = photo.dateTaken == nil ? "Not provided" : photo.dateTaken!.complexDate
        descriptionTextView.text = photo.description
        
        // Update label sizes
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        ownerNameLabel.numberOfLines = 0
        ownerNameLabel.sizeToFit()
        descriptionTextView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    
}
