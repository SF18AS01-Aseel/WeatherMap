
//
//  WeatherTableViewController.swift
//  WeatherMap
//
//  Created by Aseel Alshohatee on 3/13/19.
//  Copyright © 2019 Aseel Alshohatee. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    var days: [Day] = [Day](); //  Model is array instances, initially empty.
    let formatter: DateFormatter = DateFormatter();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let string: String = "https://api.openweathermap.org/data/2.5/forecast/daily";
        
        
        guard let baseURL: URL = URL(string: string) else {
            fatalError("could not create URL from string \"\(string)\"");
        }
        print("baseURL = \(baseURL)");
        /*
         let query: [String: String] = [
         "api_key": "DEMO_KEY",
         "date":    "2019-03-01"
         ];
         */
        let query: [String: String] = [
            "q":     "11207,US", //New York City
            "cnt":   "7",        //number of days
            "units": "imperial", //fahrenheit, not celsius
            "mode":  "json",     //vs. xml or html
            "APPID": "532d313d6a9ec4ea93eb89696983e369"
        ];
        guard let url: URL = baseURL.withQueries(query) else {
            fatalError("could not add queries to base URL");
        }
        print("    url = \(url)");
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if let error: Error = error {
                print("error = \(error)");
            }
            
            if let data: Data = data {
                let dictionary: [String: Any];
                do {
                    // taking the data object from the web to store it inside the dictionary
                    try dictionary = JSONSerialization.jsonObject(with: data) as! [String: Any];
                } catch {
                    fatalError("could not create dictionary: \(error)");
                }
                
                
                self.formatter.dateStyle = .full;
                
                let week: [[String: Any]] = dictionary["list"] as! [[String: Any]]; //an array of dictionaries
                
                for day in week {   //day is a [String: Any]
                    let dt: Int = day["dt"] as! Int;
                    let date: Date = Date(timeIntervalSince1970: TimeInterval(dt));
                    let dateString: String = self.formatter.string(from: date);
                    let temp: [String: NSNumber] = day["temp"] as! [String: NSNumber];
                    let max: NSNumber = temp["max"]!;
                   
                    let weathers: [[String: Any]] = day["weather"] as! [[String: Any]];
                    let weather: [String: Any] = weathers[0];
                    let icon: String = weather["icon"]! as! String
                     print("\(dateString) \(max.floatValue)° F \(icon)");
                    self.days.append(Day(date: date, temperature: max.floatValue, icon: icon));
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
            
        }
        
        
        task.resume();
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return days.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        // Configure the cell...
        let day: Day = days[indexPath.row];
        cell.textLabel!.text = formatter.string(from: day.date);
        if (decider == "c"){
            let convertToCelsius = Int(5.0 / 9.0 * (Double(day.temperature) - 32.0))
        cell.detailTextLabel!.text =  "\(convertToCelsius) C";
       }else {
           cell.detailTextLabel!.text =  "\(day.temperature) F";
        }
       
        cell.imageView!.image = UIImage(named: day.icon)!
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
