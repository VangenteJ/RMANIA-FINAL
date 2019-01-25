//
//  ConnectionController.swift
//  RMania
//
//  Created by Joel Vangente on 23/01/2019.
//  Copyright © 2019 Joel Vangente. All rights reserved.
//

import UIKit

class ConnectionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func tryConnect(_ sender: Any) {
        if checknet.connection(){
            let back_to_main = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(back_to_main, animated: true, completion: nil)
        }
            
        else{
            
            let noNet = self.storyboard?.instantiateViewController(withIdentifier: "Connection") as! ConnectionController
            self.present(noNet , animated: true, completion: nil)
            
        }
    }

}
