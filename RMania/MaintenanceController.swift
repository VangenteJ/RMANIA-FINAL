//
//  MaintenanceController.swift
//  RMania
//
//  Created by Joel Vangente on 23/01/2019.
//  Copyright © 2019 Joel Vangente. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MaintenanceController: UIViewController {

    
    var ref:DatabaseReference!
    var handle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        off_Maintenance_Mode()

        // Do any additional setup after loading the view.
    }
    

    func off_Maintenance_Mode(){
        //let maintenance = ref.child("Maintenance")
        handle = ref.child("Maintenance").child("On_Off").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as! String
                if value == "Off"{
                    let goTo_Main = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.present(goTo_Main, animated: true, completion: nil)
                }
            }
            
        })
    }
}
