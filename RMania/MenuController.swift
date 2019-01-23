//
//  MenuController.swift
//  RMania
//
//  Created by Joel Vangente on 29/11/2018.
//  Copyright © 2018 Joel Vangente. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class MenuController: UIViewController {
    @IBOutlet weak var imageview1: UIImageView!
    @IBOutlet weak var imageview2: UIImageView!
    @IBOutlet weak var imageview3: UIImageView!
    @IBOutlet weak var imageview4: UIImageView!
    
    @IBOutlet weak var lblDescription1: UILabel!
    @IBOutlet weak var lblDescription2: UILabel!
    @IBOutlet weak var lblDescription3: UILabel!
    @IBOutlet weak var lblDescription4: UILabel!
    @IBOutlet weak var lblDescription5: UILabel!
    
    @IBOutlet weak var lblParticipants: UILabel!
    @IBOutlet weak var lblSalers: UILabel!
    
    @IBOutlet weak var lblno_participants: UILabel!
    @IBOutlet weak var lblno_selers: UILabel!
    
    @IBOutlet weak var lblToken: UILabel!
    
    @IBOutlet weak var btnAdmin: UIButton!
    
    var handle:DatabaseHandle?
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        admin_status()
        ref = Database.database().reference()
        chechImages()
        retrieveData()
        showParticipants()
        showSalers()
        display_token()
    }
    
    @IBAction func Pay_PayPal(_ sender: Any) {
        self.performSegue(withIdentifier: "join", sender: self)
    }
    
    @IBAction func logOut(_ sender: Any) {
        if Auth.auth().currentUser != nil{
            try? Auth.auth().signOut()
            let log_regPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(log_regPage, animated: true, completion: nil)
        }
    }
    @IBAction func goToHelp(_ sender: Any) {
        self.performSegue(withIdentifier: "help", sender: self)
    }
    
    @IBAction func Winners(_ sender: Any) {
        let goTo_Winners = self.storyboard?.instantiateViewController(withIdentifier: "HistoricController") as! HistoricController
        self.present(goTo_Winners, animated: true, completion: nil)
    }
    
    @IBAction func adminPage(_ sender: Any) {
        self.performSegue(withIdentifier: "adminpage", sender: self)
    }
    
    func chechImages(){
        let image1 = Storage.storage().reference(withPath: "Images/Number1")
        let image2 = Storage.storage().reference(withPath: "Images/Number2")
        let image3 = Storage.storage().reference(withPath: "Images/Number3")
        let image4 = Storage.storage().reference(withPath: "Images/Number4")
        
        image1.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Add logo image if no image found
                self.imageview1.image = UIImage(named: "RManiav1")
            } else {
                // Data for "images"
                self.imageview1.image = UIImage(data: data!)
                
            }
        }
        image2.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Add logo image if no image found
                self.imageview2.image = UIImage(named: "RManiav1")
            } else {
                // Data for "images"
                self.imageview2.image = UIImage(data: data!)
                
            }
        }
        image3.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Add logo image if no image found
                self.imageview3.image = UIImage(named: "RManiav1")
            } else {
                // Data for "images"
                self.imageview3.image = UIImage(data: data!)
                
            }
        }
        image4.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Add logo image if no image found
                self.imageview4.image = UIImage(named: "RManiav1")
            } else {
                // Data for "images"
                self.imageview4.image = UIImage(data: data!)
                
            }
        }
    }
    
    func retrieveData(){
        let descriptions = ref.child("Description Values")
        handle = descriptions.child("Item").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblDescription1.text = value
            }
        })
        
        handle = descriptions.child("Description").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblDescription2.text = value
            }
        })
        
        handle = descriptions.child("Condition").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblDescription3.text = value
            }
        })
        
        handle = descriptions.child("Price").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblDescription4.text = value
            }
        })
        
        handle = descriptions.child("Extra").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblDescription5.text = value
            }
        })
    }
    
    func isLogged(){
        if Auth.auth().currentUser == nil{
            let log_regPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(log_regPage, animated: true, completion: nil)
        }
    }
    
    func showParticipants(){
        let item = ref.child("Description Values")
        handle = item.child("Item").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                
                var names = [String]()
                var new = "Joined:"
                var loopNum = 0
                let descriptions = self.ref.child(value!).child("Participants")
                descriptions.observe(.value) { (snapshot) in
                    for child in snapshot.children.allObjects as![DataSnapshot]{
                        if loopNum == 1 {
                            names = []
                            new = "Joined:"
                        }
                        loopNum = 0
                        let descrip = child.value as? [String: AnyObject]
                        let entry1 = descrip?["Entry1"]
                        let entry2 = descrip?["Entry2"]
                        let entry3 = descrip?["Entry3"]
                        let entry4 = descrip?["Entry4"]
                        let entry5 = descrip?["Entry5"]
                        if entry1 != nil && entry2 == nil{
                            names.append(entry1 as! String)
                        }else if entry2 != nil && entry3 == nil{
                            names.append(entry1 as! String)
                            names.append(entry2 as! String)
                        }else if entry3 != nil && entry4 == nil{
                            names.append(entry1 as! String)
                            names.append(entry2 as! String)
                            names.append(entry3 as! String)
                        }else if entry4 != nil && entry5 == nil{
                            names.append(entry1 as! String)
                            names.append(entry2 as! String)
                            names.append(entry3 as! String)
                            names.append(entry4 as! String)
                        }else if entry5 != nil{
                            names.append(entry1 as! String)
                            names.append(entry2 as! String)
                            names.append(entry3 as! String)
                            names.append(entry4 as! String)
                            names.append(entry5 as! String)
                        }
                    }
                    for name in names{
                        new = new + " \(name);"
                        loopNum = 1
                    }
                    let names_to_sort = self.ref.child(value!).child("Names to sort")
                    names_to_sort.setValue(new)
                    self.lblParticipants.text = new
                    self.lblno_participants.text = "\(names.count) Participant/s!"
                }
                
            }
        })
        
    }
    
    func showSalers(){
        
        let item = ref.child("Description Values")
        handle = item.child("Item").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                
                var names = [String]()
                var new = "Who sold:"
                var loopNum = 0
                let descriptions = self.ref.child(value!).child("Salers")
                descriptions.observe(.value) { (snapshot) in
                    for child in snapshot.children.allObjects as![DataSnapshot]{
                        if loopNum == 1 {
                            names = []
                            new = "Who sold:"
                        }
                        loopNum = 0
                        let descrip = child.value as? [String: AnyObject]
                        let name = descrip?["Name"]
                        if name != nil{
                            names.append(name as! String)
                        }
                    }
                    for name in names{
                        new = new + " \(name);"
                        loopNum = 1
                    }
                    self.lblSalers.text = new
                    self.lblno_selers.text = "\(names.count) Seler/s!"
                }
            }
        })
        
    }
    
    func display_token(){
        if Auth.auth().currentUser?.uid != nil{
            let token = Auth.auth().currentUser?.uid
            lblToken.text = "Your token is: _\(String((token?.suffix(6))!))"
        }
    }
    
    func admin_status(){
        if Auth.auth().currentUser?.uid != nil{
            if Auth.auth().currentUser?.uid == "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                btnAdmin.isHidden = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if checknet.connection(){
            
        }
            
        else{
            
            let noNet = self.storyboard?.instantiateViewController(withIdentifier: "Connection") as! ConnectionController
            self.present(noNet , animated: true, completion: nil)
            
        }
    }
}
