//
//  RestaurantTableViewCell.swift
//  weather
//
//  Created by Asif Junaid on 6/23/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var cuisines: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(restaurant : CMRestaurant){
        
        name.text = restaurant.name ?? ""
        location.text = restaurant.city ?? ""
        cuisines.text = restaurant.cuisines ?? ""
        rating.text = " \(restaurant.rating ?? 0)"
        ratingView.rating = restaurant.rating ?? 0
        reviews.text = "\(restaurant.reviewCount ?? 0) reviews"
        if let url = restaurant.imageUrl {
            
           thumbnail.sd_setShowActivityIndicatorView(true)
           thumbnail.sd_setIndicatorStyle(.gray)
            
            thumbnail.sd_setImage(with: url) { [weak self](image, error, cache, url) in
                if error == nil {
                    DispatchQueue.main.async {
                        self?.thumbnail.image = image
                    }
                }
            }
            
        }
    }
}
