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
    @IBOutlet var RestaurantName: UITextView!
    @IBOutlet var MealName: UITextView!
    @IBOutlet var priceAmount: UITextField!
    @IBOutlet var Address: UITextView!
    @IBOutlet var Website: UITextView!
    @IBOutlet var Delivery: UILabel!
    var mealInfo : HomeViewController.mealInformation?
     
     @objc func enable(){
         //FEEDME.isEnabled = true
         HomeViewController.GlobalVariable.choiceNum = 3
     }
    
     @IBAction func countcheck(_ sender: Any) {
         if HomeViewController.GlobalVariable.choiceNum == 0{
             
             let timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(enable), userInfo: nil, repeats: false)
             
         }
     }
    func getDelivery(){
        let rID = mealInfo?.rID as! String
        let deliveryKeys = ["uberEatsAvailability", "postmatesAvailability", "website"]
        let query = "SELECT uberEatsAvailability, postmatesAvailability, website FROM DeliveryOptions WHERE restaurantID=\"\(rID)\";"
        
        print(rID)
        let data = AppDelegate.dB.query(queryString: query, keys: deliveryKeys)
        
        print(data)
        let deliveryData = data[0]
        
        Website.text = deliveryData[2]
        let uberEats = deliveryData[0], postmates = deliveryData[1]
        
        if(uberEats == "yes" && postmates=="yes"){
            Delivery.text = "UberEats & Postmates"
        }else if(uberEats == "yes"){
            Delivery.text = "UberEats"
        }else if(postmates == "yes"){
            Delivery.text = "Postmates"
        } else {
            Delivery.text = "None"
        }
        
    }
    func loadInfo(){
        RestaurantName.text = mealInfo?.restaurantName
        MealName.text = mealInfo?.mealName
        print(mealInfo?.mealPrice)
        priceAmount.text = mealInfo?.mealPrice
        Address.text = mealInfo!.restaurantAddress
        
        getDelivery()
    }
     override func viewDidLoad() {
         super.viewDidLoad()
         
         Retrys.text = "\(HomeViewController.GlobalVariable.choiceNum)"
         print(mealInfo?.restaurantName)
         self.Website.linkTextAttributes = [
             .foregroundColor: UIColor.blue,
             .underlineStyle: NSUnderlineStyle.single.rawValue
         ]
         // Do any additional setup after loading the view.
        loadInfo()
     }


}

