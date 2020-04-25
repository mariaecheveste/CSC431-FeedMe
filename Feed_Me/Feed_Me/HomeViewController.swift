//
//  ViewController.swift
//  Feed_Me
//
//  Created by Sam Mistretta on 4/15/20.
//  Copyright © 2020 Sam Mistretta. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    struct GlobalVariable{
       static var choiceNum = 3
    }
    
    
 //Feed_ME button
    @IBOutlet var FEEDME: RoundButton!
 
    //MEAL FILTERS
    @IBOutlet weak var Vegan: UILabel!
    @IBOutlet weak var veganSwitch: UISwitch!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var PricePicker: UIPickerView!
    @IBOutlet weak var Distance: UILabel!
    @IBOutlet weak var DistancePicker: UIPickerView!
    
    //values of price/distance filter
    let prices = ["$", "$$", "$$$", "$$$$"]
    let distances = ["<1 mile", "1-5 miles", "5-10 miles"]
    
    //store values to query with
    let price = "$"
    let distance = "<1 mile"
    let vegan = true
    
    //for passing data to meal View
    
    struct mealInformation{
        let restaurantName: String
        let restaurantAddress: String
        let mealName: String
        let mealPrice: String
    }
    
    
    
//SEGUE to meal view controller
   @IBAction func button(sender: UIButton){
    
    
        if GlobalVariable.choiceNum == 0{
            //already chose three times disable button
            return
        } else{
            GlobalVariable.choiceNum -= 1
        }
        
    
        /*practice query
        let data = AppDelegate.dB.query(queryString: "SELECT * FROM Ingredients WHERE ingredient=\"lemon\";")*/
            
        
        
        performSegue(withIdentifier: "counter", sender:sender)
        
    }
    //other stuff:
    
    @IBAction func switchValueChanged (sender: UISwitch) {
        if veganSwitch.isOn{
            print("This person is a vegan")
        }else{
            print("This person is not a vegan")
        }
    }
    
    //picker functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return distances.count
        }
        else{
            return prices.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(distances[row])"
        }
        else{
            return "\(prices[row])"
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PricePicker.delegate = self
        PricePicker.dataSource = self
        
        DistancePicker.delegate = self
        DistancePicker.dataSource = self
        
        // Do any additional setup after loading the view.
    }


}

