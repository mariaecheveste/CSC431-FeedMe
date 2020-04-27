//
//  MealView.swift
//  Feed_Me
//
//  Created by Sam Mistretta on 4/15/20.
//  Copyright © 2020 Sam Mistretta. All rights reserved.
//

import Foundation
import UIKit

class MealView: UIViewController {

    @IBOutlet var Retrys: UILabel!
    
    @objc func enable(){
        //FEEDME.isEnabled = true
        HomeViewController.GlobalVariable.num = 3
    }
   
    @IBAction func countcheck(_ sender: Any) {
        if HomeViewController.GlobalVariable.num == 0{
            
            let timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(enable), userInfo: nil, repeats: false)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Retrys.text = "\(HomeViewController.GlobalVariable.num)"
        // Do any additional setup after loading the view.
    }


}

