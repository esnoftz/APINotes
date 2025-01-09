//
//  ViewController.swift
//  APINotes
//
//  Created by EVANGELINE NOFTZ on 1/8/25.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tempOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeather()
    }
    
    func getWeather() {
        
        // creating an object of URLSession class to make an API call
        let session = URLSession.shared
        
        // creating object of URL class (replace the fillers in the API link with the actual latitude and longitude and API key)
        // make it http instead of https (gets rid of the "secure")
        // units = imperial changes units from Kelvins to Farenheit
        let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=42.2&lon=-88.3&appid=62e7a38621e16fe7701f67585431f99c&units=imperial")!
        
        // completionHandler is what you want to happen once weatherURL is completed (similar to ALERT CONTROLLERS)
        let dataTask = session.dataTask(with: weatherURL) { data, response, error in
            if let e = error {
               print("Error! \(e)")
            } else {
                if let d = data {
                    // try? means that if it doesn't work, jsonObj will be nil (doesn't catch the error though)
                    // getting the json object from the API
                    if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: .fragmentsAllowed) as! NSDictionary {
                        //print(jsonObj)
                        if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary {
                            print(mainDictionary)
                            if let theTemp = mainDictionary.value(forKey: "temp") {
                                // happens on the main thread
                                DispatchQueue.main.async {
                                    self.tempOutlet.text = "Temp is \(theTemp)"
                                }
                            }
                        }
                    } else {
                        print("Can't convert to json")
                    }
                } else {
                    print("Couldn't get data")
                }
            }
        }
        
        // constantly calling for the data
        dataTask.resume()
    }


}

