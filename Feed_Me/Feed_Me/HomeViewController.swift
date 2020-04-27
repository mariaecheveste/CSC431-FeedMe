//
//  ViewController.swift
//  Feed_Me
//
//  Created by Sam Mistretta on 4/15/20.
//  Copyright © 2020 Sam Mistretta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    struct GlobalVariable{
       static var num = 3
       
    }
    
 //Feed_ME button
    @IBOutlet var FEEDME: RoundButton!
 
    //MEAL FILTERS
    @IBOutlet weak var Vegan: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var PricePicker: UIPickerView!
    @IBOutlet weak var Distance: UILabel!
    @IBOutlet weak var DistancePicker: UIPickerView!
    
    //values of price/distance filter
    let prices = ["$", "$$", "$$$", "$$$$"]
    let distances = ["<1 mile", "1-5 miles", "5-10 miles"]
    
    
//SEGUE to meal view controller
   @IBAction func button(sender: UIButton){
    
    
    if GlobalVariable.num > 0{
       GlobalVariable.num -= 1
       performSegue(withIdentifier: "counter", sender:sender)
        
    }
    
    }
    
    //picker functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return prices.count
        }
        else{
            return distances.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.tag == 1 {
    return "\(prices[row])"
    }
    else{
    return "\(distances[row])"
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

