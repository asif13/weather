//
//  WeatherDetailViewController.swift
//  weather
//
//  Created by Asif Junaid on 6/21/18.
//  Copyright © 2018 Asif Junaid. All rights reserved.
//

import UIKit

//Viewcontroller to display weather and forecast data
class WeatherViewController: UIViewController {

    var viewModel : WeatherViewModel?
    
    @IBOutlet var weatherDetails: [UILabel]!
    
    @IBOutlet weak var additionalInfo: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var forecastView: ForecastCollectionView!
    @IBOutlet weak var popularRestaurantsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViewModel(){
        
        viewModel = WeatherViewModel()
        viewModel?.updateCurrentLocation()
        popularRestaurantsButton.isEnabled = false
        
        //closure to update view when model is updated
        viewModel?.didUpdateModel = { [weak self] weather in
            DispatchQueue.main.async {
                self?.weatherDetails[0].text = weather?.location ?? ""
                self?.weatherDetails[1].text = weather?.date ?? ""
                self?.weatherDetails[2].text = weather?.weatherDescription ?? ""
                self?.weatherDetails[3].text = weather?.iconText ?? ""
                self?.weatherDetails[4].text = weather?.temperature ?? ""
                self?.updateAdditionalInfo(info: weather?.info)
                if let forecast = weather?.forecasts{
                    self?.forecastView.model = forecast
                }
                self?.popularRestaurantsButton.isEnabled = true
                self?.activityIndicator.stopAnimating()
            }
        }
        
        //closure to display error

        viewModel?.didGetError = { [weak self] error in
            
            DispatchQueue.main.async {
                self?.alert("Alert", message: error.error.rawValue)
                self?.activityIndicator.stopAnimating()
            }
            
        }
        
    }
    
    /// Updates addtional info, displayed as pagination
    ///
    /// - Parameter info: WeatherExtraInfo
    func updateAdditionalInfo(info:WeatherExtraInfo?){
        
        guard let weatherInfo = info else { return }

        additionalInfo.delegate = self
        
        let infoview1 : AdditionalInfo = UIView.fromNib()
        additionalInfo.addSubview(infoview1)
        
        let infoview2 : AdditionalInfo = UIView.fromNib()
        infoview2.frame.origin.x = view.frame.width
        additionalInfo.addSubview(infoview2)
        
        updateAdditionalInfoValues(info: weatherInfo,infoView1: infoview1,infoView2: infoview2)

        
        additionalInfo.contentSize = CGSize(width: view.frame.width * 2, height: infoview2.frame.height)
        
    }
    
    /// Update values for additional info
    ///
    /// - Parameters:
    ///   - info: WeatherExtraInfo
    ///   - infoView1: First view in pagination
    ///   - infoView2: Second view in pagination
    func updateAdditionalInfoValues(info:WeatherExtraInfo,infoView1 : AdditionalInfo,infoView2:AdditionalInfo){
        
        infoView1.titles[0].text = info.pressure ?? ""
        
        infoView1.titles[1].text = info.humidity ?? ""
        
        infoView1.titles[2].text = info.windSpeed ?? ""
        
        infoView2.titles[0].text = info.minimumTemp ?? ""
        infoView2.subtitles[0].text = "Min Temp"
        
        infoView2.titles[1].text = info.maximumTemp ?? ""
        infoView2.subtitles[1].text = "Max Temp"
        
        infoView2.titles[2].text =  ""
        infoView2.subtitles[2].text = ""

    }
    
}
extension WeatherViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //update page control values
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(view.frame.width))
        
    }
}


