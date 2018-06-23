//
//  RestaurantTableView.swift
//  weather
//
//  Created by Asif Junaid on 6/23/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit
import SDWebImage
class RestaurantTableView: UITableView {
    
    var model = [CMRestaurant](){
        didSet {
            reloadData()
        }
    }
    let cellIdentifier = "RestaurantTableViewCell"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        dataSource = self
        tableFooterView = UIView()
        tableHeaderView = UIView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        tableFooterView = UIView()
        tableHeaderView = UIView()

    }
    
}

extension RestaurantTableView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RestaurantTableViewCell else {
            return UITableViewCell()
        }
        let restaurant = model[indexPath.row]
        
        cell.updateCell(restaurant: restaurant)
        
        return cell
    }
    
    
}
