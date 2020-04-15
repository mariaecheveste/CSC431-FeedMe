//
//  ViewController.swift
//  Feed_Me
//
//  Created by Sam Mistretta on 4/15/20.
//  Copyright © 2020 Sam Mistretta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    struct GlobalVariable{
       static var num = 3
       
    }
    
    
    @IBOutlet var FEEDME: RoundButton!
    
    
    

   @IBAction func button(sender: UIButton){
    
    
    if GlobalVariable.num > 0{
       GlobalVariable.num -= 1
       performSegue(withIdentifier: "counter", sender:sender)
        
    }
    
    }
       // retrys.text = "\(GlobalVariable.num)"
 //   }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

