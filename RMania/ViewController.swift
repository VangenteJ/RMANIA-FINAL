//
//  ViewController.swift
//  RMania
//
//  Created by Joel Vangente on 28/11/2018.
//  Copyright © 2018 Joel Vangente. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var segLog_reg: UISegmentedControl!
    
    @IBOutlet weak var lblLog_Reg: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblReenter_Password: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    
    @IBOutlet weak var btnLog_Reg: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    @IBOutlet weak var stackYesNo: UIStackView!
    @IBOutlet weak var reStack: UIStackView!
    
    @IBOutlet weak var btnResetPassword: UIButton!
    
    var user:DatabaseReference!
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        isLogged()
        
    }

    @IBAction func yesLog(_ sender: Any) {
        mainMenu()
    }
    
    @IBAction func noLogout(_ sender: Any) {
        try? Auth.auth().signOut()
        let login = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(login, animated: true, completion: nil)
    }
    
    @IBAction func btnLogin_Register(_ sender: Any) {
        
        if let email = txtEmail.text, let pass = txtPassword.text, let pass2 = txtRePassword.text {
            if segLog_reg.selectedSegmentIndex == 0 {
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    if user != nil{
                        self.performSegue(withIdentifier: "menu", sender: self)
                    }else{
                        self.lblLog_Reg.textColor = UIColor.red
                        self.lblLog_Reg.text = "Please enter correct details!"
                    }
                }
            }else {
                if email != "" && pass != "" && pass2 == pass{
                    Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                        if user != nil {
                            self.ref.child("Admin").child((user?.uid)!).child("Access").setValue("No")
                            self.mainMenu()
                        }
                        self.lblLog_Reg.textColor = UIColor.red
                        self.lblLog_Reg.text = "Email either invalid or already in use, password must be at least 6 characters long!"
                    }
                }else {
                    self.lblLog_Reg.textColor = UIColor.red
                    self.lblLog_Reg.text = "Please enter correct details!"
                }
            }
            }
    }
    
    @IBAction func segLog_Reg(_ sender: Any) {
        if segLog_reg.selectedSegmentIndex == 0 {
            lblLog_Reg.textColor = UIColor.black
            lblLog_Reg.text = "Log in"
            btnLog_Reg.setTitle("Log in", for: .normal)
            reStack.isHidden = true
            btnResetPassword.isHidden = false
        }else {
            lblLog_Reg.textColor = UIColor.black
            lblLog_Reg.text = "Register"
            btnLog_Reg.setTitle("Register", for: .normal)
            reStack.isHidden = false
            btnResetPassword.isHidden = true

        }
    }
    
    func isLogged(){
        let user = Auth.auth().currentUser?.email
        if Auth.auth().currentUser != nil{
            segLog_reg.isEnabled = false
            lblLog_Reg.isEnabled = false
            lblEmail.isEnabled = false
            lblPassword.isEnabled = false
            txtEmail.isEnabled = false
            txtPassword.isEnabled = false
            lblUser.isHidden = false
            stackYesNo.isHidden = false
            btnLog_Reg.isEnabled = false
            btnResetPassword.isEnabled = false
            lblUser.text = "Email \(user!)?"
        }
    }
    
    func mainMenu(){
        let goTo_Main = self.storyboard?.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        self.present(goTo_Main, animated: true, completion: nil)
    }
    
    @IBAction func reset_password(_ sender: Any) {
        self.performSegue(withIdentifier: "ResetPassword", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtRePassword.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if checknet.connection(){}else{
            let noNet = self.storyboard?.instantiateViewController(withIdentifier: "Connection") as! ConnectionController
            self.present(noNet , animated: true, completion: nil)
        }
    }
}
