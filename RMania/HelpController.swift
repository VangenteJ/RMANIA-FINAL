//
//  HelpController.swift
//  RMania
//
//  Created by Joel Vangente on 20/12/2018.
//  Copyright © 2018 Joel Vangente. All rights reserved.
//

import UIKit

class HelpController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func back(_ sender: Any) {
        let goBack = self.storyboard?.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        self.present(goBack, animated: true, completion: nil)
    }

}
