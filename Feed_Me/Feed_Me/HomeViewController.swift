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
           static var choiceNum = 3
        }
        
    //UI buttons:
        //Feed_ME button
        @IBOutlet var FEEDME: RoundButton!
    
        //MEAL criteria FILTERS
        @IBOutlet weak var Vegan: UILabel!
        @IBOutlet weak var veganSwitch: UISwitch!
        @IBOutlet weak var Price: UILabel!
        @IBOutlet weak var PricePicker: UIPickerView!
        @IBOutlet weak var Distance: UILabel!
        @IBOutlet weak var DistancePicker: UIPickerView!
    
        //lockout label after three tries
        @IBOutlet var Lockout: UILabel!
        @IBOutlet var NotFound: UILabel!
        
        //values of price/distance filter
        let prices = ["$", "$$", "$$$", "$$$$"]
        let distances = ["<1 mile", "1-5 miles", "5-10 miles"]
        
        //for passing data to meal View
        struct mealInformation{
            var rID: String?
            var restaurantName: String?
            var restaurantAddress: String?
            var mealName: String?
            var mealPrice: String?
        }
        //store values to query with filled with defaults
        var vegan = "yes"
        var price = "(\"$\")"
        var distance = "(\"1\")"
        
        var mealDetails : mealInformation?
        
    
        
    
    func getAddress(id:String)->String{
        
        let addressKeys = ["street", "city", "state", "zipCode"]
        let query = "SELECT street, city, state, zipCode FROM Address WHERE restaurantId=\"\(id)\";"
        let addressData = AppDelegate.dB.query(queryString: query, keys: addressKeys)
        
        let address = addressData[0].joined(separator: ", ")
        return address
        
    }
        func pullRestaurant(rDetails :inout Array<String>) -> Bool {
    
            let restaurantKeys = ["restaurantID", "restaurantName", "menuID"]
            let query = "SELECT restaurantId, restaurantName, menuId FROM Restaurants WHERE veganOptions=\"\(vegan)\" AND price IN \(price) AND distance IN \(distance);"
            
            let restaurantData = AppDelegate.dB.query(queryString: query, keys: restaurantKeys)
            let randomRestaurant = restaurantData.randomElement()
            
            if(randomRestaurant == nil){
                return false
            }
            
            let restaurantID = randomRestaurant![0]
        
            rDetails.append(contentsOf:(randomRestaurant)!)
            rDetails.append(getAddress(id:restaurantID))

            return true
        }
    
        func pullMenu(rDetails:inout Array<String>){
            
            let mID = 2 //index in rDetails
            let menuKeys = ["mealName", "priceDollars"]
            let query = "SELECT mealName, priceDollars FROM Menus WHERE vegan=\"\(vegan)\" AND menuId=\"\(rDetails[mID])\";"
            let mealData = AppDelegate.dB.query(queryString: query, keys: menuKeys)
            
            let randomMeal = mealData.randomElement()
            
            if(randomMeal == nil){
                print("Something went wrong!")
                return
            }
            
            rDetails.append(contentsOf: (randomMeal)!)
        
            
        }
    //SEGUE to meal view controller
        func getMealStruct() -> Bool { //turn into boolean
            let rID = 0 , rName = 1, rAdd = 3, mName = 4, mPrice = 5
            var restaurantDetails = [String]()
            
            if !pullRestaurant(rDetails : &restaurantDetails){
                    return false
                    //TO BE COMPLETED
                    //add message regarding no restaurants with that criteria
                }
                
            pullMenu(rDetails : &restaurantDetails)
                
                //insert into struct that will be passed through
                
           mealDetails = mealInformation(rID: restaurantDetails[rID], restaurantName: restaurantDetails[rName], restaurantAddress: restaurantDetails[rAdd], mealName: restaurantDetails[mName], mealPrice: restaurantDetails[mPrice])
            
            print(restaurantDetails)
            
            return true
        }
       @IBAction func button(sender: UIButton){
            
            if GlobalVariable.choiceNum == 0{
                //already chose three times disable button
                Lockout.isHidden = false
                return
            }
            if(!getMealStruct()){
                NotFound.isHidden = false
                return
            }
            GlobalVariable.choiceNum -= 1
        
            performSegue(withIdentifier: "displayMeal", sender:sender)
            
        }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "displayMeal"){
            if let mealView = segue.destination as? MealView {
                mealView.mealInfo = mealDetails
                print(mealDetails?.mealPrice)
            }
        }
        
        
    }
    
    //switch functions
    
        //that is triggered with switch change
    @IBAction func switchValueChanged (sender: UISwitch) {
        if veganSwitch.isOn{
            vegan = "yes"
                //print("This person is a vegan")
        }else{
            vegan = "no"
                //print("This person is not a vegan")
        }
    }
        
    //picker functions
        //how many columns/components in each picker
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    
        //gives picker the number of rows in each component
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView.tag == 1 {
                return distances.count
            }
            else{
                return prices.count
            }
        }
        //where the picker data is coming from
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView.tag == 1 {
                return "\(distances[row])"
            }
            else{
                return "\(prices[row])"
            }
        }
        // Capture the picker view selection
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // This method is triggered whenever the user makes a change to the picker selection.
            // The parameter named row and component represents what was selected.
            if pickerView.tag == 1{
                distance = getDistance(distanceLimit: distances[row])
                //print(distance)
            } else{
                price = getPrice(priceLimit: prices[row])
                //print(price)
            }
            
        }
       
        override func viewDidLoad() {
            super.viewDidLoad()
            
            PricePicker.delegate = self
            PricePicker.dataSource = self
            PricePicker.tag = 2;
            
            DistancePicker.delegate = self
            DistancePicker.dataSource = self
            DistancePicker.tag = 1;
            
            Lockout.isHidden = true;
            NotFound.isHidden = true;
            // Do any additional setup after loading the view.
            
        }
    //getters
    func getDistance(distanceLimit:String) -> String{
        switch(distanceLimit){
            case("<1 mile"):
                return "(\"0\",\"1\")"
            case("1-5 miles"):
                return "(\"0\",\"1\",\"2\",\"3\",\"4\",\"5\")"
            case("5-10 miles"):
                return "(\"0\",\"1\",\"2\",\"3\",\"4\",\"5\"\"6\",\"7\",\"8\",\"9\",\"10\")"
            default:
                return "(\"0\",\"1\")"
        }
    }
    
    func getPrice(priceLimit:String) -> String{
        switch(priceLimit){
            case("$"):
                return "(\"$\")"
            case("$$"):
                return "(\"$\",\"$$\")"
            case("$$$"):
                return "(\"$\",\"$$\",\"$$$\")"
            case("$$$$"):
                return "(\"$\",\"$$\",\"$$$\",\"$$$$\")"
            default:
                return "(\"$\")"
        }
    }


}

