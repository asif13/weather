//
//  ForecastCollectionView.swift
//  weather
//
//  Created by Asif Junaid on 6/23/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit

//Displays upcoming fore cast data
class ForecastCollectionView: UICollectionView {
    var model = [CMForecast](){
        didSet {
            dataSource = self
            reloadData()
        }
    }
    let cellIdentifier = "ForecastCollectionViewCell"
    
}
extension ForecastCollectionView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let forecast = model[indexPath.row]
        
        cell.updateCell(forecast: forecast)
        
        return cell
    }
    
    
}
