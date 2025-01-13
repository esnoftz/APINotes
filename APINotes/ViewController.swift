//
//  ViewController.swift
//  APINotes
//
//  Created by EVANGELINE NOFTZ on 1/8/25.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tempOutlet: UILabel!
    
    @IBOutlet weak var tempOutlet2: UILabel!
    
    @IBOutlet weak var tempOutlet3: UILabel!
    
    @IBOutlet weak var maxTempOutlet: UILabel!
    
    @IBOutlet weak var minTempOutlet: UILabel!
    
    @IBOutlet weak var humidityOutlet: UILabel!
    
    @IBOutlet weak var windOutlet: UILabel!
    
    
    
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
                        print(jsonObj)
                        if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary {
                            print(mainDictionary)
                            if let theTemp = mainDictionary.value(forKey: "temp") {
                                // happens on the main thread
                                DispatchQueue.main.async {
                                    self.tempOutlet.text = "Temp is \(theTemp)"
                                }
                            }
                            
                            if let maxTemp = mainDictionary.value(forKey: "temp_max") {
                                // happens on the main thread
                                DispatchQueue.main.async {
                                    print(maxTemp)
                                    self.maxTempOutlet.text = "Max temp is \(maxTemp) degrees F"
                                }
                            }

                            if let minTemp = mainDictionary.value(forKey: "temp_min") {
                                // happens on the main thread
                                DispatchQueue.main.async {
                                    print(minTemp)
                                    self.minTempOutlet.text = "Min temp is \(minTemp) degrees F"
                                }
                            }
                            
                            if let humidity = mainDictionary.value(forKey: "humidity") {
                                // happens on the main thread
                                DispatchQueue.main.async {
                                    print(humidity)
                                    self.humidityOutlet.text = "Humidity is \(humidity)%"
                                }
                            }
                            
                        }
                        
                        if let sysDictionary = jsonObj.value(forKey: "sys") as? NSDictionary {
                            print(sysDictionary)
                            if let theSunrise = sysDictionary.value(forKey: "sunrise") as? Int {
                                let timeInterval = TimeInterval(theSunrise)
                                let sunriseDate = Date(timeIntervalSince1970: timeInterval)
                                print(sunriseDate)
                                
                                let formatter = DateFormatter()
                                formatter.dateStyle = .none // we don't care about the date for sunrise time
                                formatter.timeStyle = .short
                                
                                let sunriseFormatterDate = formatter.string(from: sunriseDate)
                                print(sunriseFormatterDate)
                                
                                
                                // happens on the main thread
                                DispatchQueue.main.async {
                                    self.tempOutlet2.text = "Sunrise is \(sunriseFormatterDate)"
                                }
                            }
                            
                            if let theSunset = sysDictionary.value(forKey: "sunset") as? Int {
                                let timeInterval = TimeInterval(theSunset)
                                let sunsetDate = Date(timeIntervalSince1970: timeInterval)
                                print(sunsetDate)
                                
                                let formatter = DateFormatter()
                                formatter.dateStyle = .none // we don't care about the date for sunrise time
                                formatter.timeStyle = .short
                                
                                let sunsetFormatterDate = formatter.string(from: sunsetDate)
                                print(sunsetFormatterDate)

                                // happens on the main thread
                                DispatchQueue.main.async {
                                    self.tempOutlet3.text = "Sunset is \(sunsetFormatterDate)"
                                }
                            }

                        }
                        
                        
                        if let windDictionary = jsonObj.value(forKey: "wind") as? NSDictionary {
                            print(windDictionary)
                            if let windSpeed = windDictionary.value(forKey: "speed") {
                                var direction = ""
                                if let windDegree = windDictionary.value(forKey: "deg") as? Double {
                                    //var direction = "North"
                                    
                                    if windDegree >= 0 && windDegree <= 22.5 {
                                        direction = "North"
                                    } else if windDegree <= 45 {
                                        direction = "Northeast"
                                    } else if windDegree == 90 {
                                        direction = "East"
                                    } else if windDegree < 180 {
                                        direction = "Southeast"
                                    } else if windDegree == 180 {
                                        direction = "South"
                                    } else if windDegree < 270 {
                                        direction = "Southwest"
                                    } else if windDegree == 270 {
                                        direction = "West"
                                    } else {
                                        direction = "Northwest"
                                    }
                                }
                                // happens on the main thread
                                DispatchQueue.main.async {
                                    self.windOutlet.text = "Wind is \(windSpeed) mph in the direction of \(direction)"
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

