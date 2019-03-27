//
//  ViewController.swift
//  WeatherMap
//
//  Created by Aseel Alshohatee on 3/13/19.
//  Copyright © 2019 Aseel Alshohatee. All rights reserved.
//

import UIKit
var decider: String = ""
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func convertToCelsius(_ sender: Any) {
        decider = "c";
    }
    
    @IBAction func convertToFahrenheit(_ sender: Any) {
        decider = "f";
    }
}

