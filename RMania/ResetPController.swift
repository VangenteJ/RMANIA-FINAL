//
//  ResetPController.swift
//  RMania
//
//  Created by Joel Vangente on 17/01/2019.
//  Copyright © 2019 Joel Vangente. All rights reserved.
//

import UIKit
import Firebase


class ResetPController: UIViewController {

    @IBOutlet weak var lblResetPassword: UILabel!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblResetPassword.textColor = UIColor.black

        // Do any additional setup after loading the view.
    }
    
    @IBAction func reset_Pass(_ sender: Any) {
        if let email = txtemail.text {
            if email != ""{
                Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                }
                lblResetPassword.textColor = UIColor.green
                lblResetPassword.text = "You will receive an email if your detail is correct."
                txtemail.isHidden = true
                btnReset.isHidden = true
                btnCancel.setTitle("Back", for: .normal)
            }else{
                lblResetPassword.text = "Please enter email."
                lblResetPassword.textColor = UIColor.red
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        let goTo_Main = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(goTo_Main, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
