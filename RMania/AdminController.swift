//
//  AdminController.swift
//  RMania
//
//  Created by Joel Vangente on 15/12/2018.
//  Copyright © 2018 Joel Vangente. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class AdminController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblExtra: UILabel!
    
    @IBOutlet weak var btnMaintenance: UIButton!
    @IBOutlet weak var lblMaintenance: UILabel!
    
    @IBOutlet weak var btnStart_Stop: UIButton!
    @IBOutlet weak var lblStart_Stop: UILabel!
    
    @IBOutlet weak var segTab_To_Add: UISegmentedControl!
    @IBOutlet weak var toggle: UISwitch!
    
    @IBOutlet weak var txtAddInfo: UITextField!
    
    var ref:DatabaseReference!
    var handle:DatabaseHandle?
    
    let user = Auth.auth().currentUser
    
    var image_number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        retrieveData()
        maintenance_payment()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addimage1(_ sender: Any) {
        image_number = 1
        addImage()
    }
    
    @IBAction func addimage2(_ sender: Any) {
        image_number = 2
        addImage()
    }
    
    @IBAction func addimage3(_ sender: Any) {
        image_number = 3
        addImage()
    }
    
    @IBAction func addimage4(_ sender: Any) {
        image_number = 4
        addImage()
    }
    
    @IBAction func addDetails(_ sender: Any) {
        let descriptions = ref.child("Description Values")
        if segTab_To_Add.selectedSegmentIndex == 0{
            lblItem.text = txtAddInfo.text
            descriptions.child("Item").setValue(lblItem.text)
            txtAddInfo.text = ""
            
        }else if segTab_To_Add.selectedSegmentIndex == 1{
            lblDescription.text = txtAddInfo.text
            descriptions.child("Description").setValue(lblDescription.text)
            txtAddInfo.text = ""
            
        }else if segTab_To_Add.selectedSegmentIndex == 2{
            lblCondition.text = txtAddInfo.text
            descriptions.child("Condition").setValue(lblCondition.text)
            txtAddInfo.text = ""
            
        }else if segTab_To_Add.selectedSegmentIndex == 3{
            if let numbers = Float(txtAddInfo.text!){
                lblPrice.textColor = UIColor.black
                lblPrice.text = "£\(String(numbers))"
                descriptions.child("Price").setValue(lblPrice.text)
                descriptions.child("PricePayPal").setValue(numbers)
                txtAddInfo.text = ""
                
            }else {
                lblPrice.textColor = UIColor.red
                lblPrice.text = "Insert decimal number!"
                txtAddInfo.text = ""
                
            }
        }else if segTab_To_Add.selectedSegmentIndex == 4{
            lblExtra.text = txtAddInfo.text
            descriptions.child("Extra").setValue(lblExtra.text)
            txtAddInfo.text = ""
            
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        let goBack = self.storyboard?.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        self.present(goBack, animated: true, completion: nil)
    }
    
    func retrieveData(){
        let descriptions = ref.child("Description Values")
        handle = descriptions.child("Item").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblItem.text = value
            }else {
                print ("Se fudeu")
            }
        })
        
        handle = descriptions.child("Description").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblDescription.text = value
            }
        })
        
        handle = descriptions.child("Condition").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblCondition.text = value
            }
        })
        
        handle = descriptions.child("Price").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblPrice.text = value
            }
        })
        
        handle = descriptions.child("Extra").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                self.lblExtra.text = value
            }
        })
    }
    
    func addImage(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        picker.dismiss(animated: true, completion: nil)
        var data = Data()
        if image_number == 1{
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Number1")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        }else if image_number == 2{
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Number2")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        }else if image_number == 3{
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Number3")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        }else if image_number == 4{
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Number4")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func turn_maintenance_on_off(_ sender: Any) {
        let maintenance = ref.child("Maintenance")
        if lblMaintenance.text == "Main ON"{
            maintenance.child("On_Off").setValue("Off")
        }else{
            maintenance.child("On_Off").setValue("On")
        }
    }
    
    @IBAction func disable_purchases(_ sender: Any) {
        let stop_p = ref.child("PayStop")
        if lblStart_Stop.text == "Pay ON"{
            stop_p.child("Stop_Start").setValue("Stopped")
        }else{
            stop_p.child("Stop_Start").setValue("Started")
        }
    }
    
    func maintenance_payment(){
        // Get info from database regarding maintenance and purchase status
        let maintenance = ref.child("Maintenance")
        let stop_p = ref.child("PayStop")
        
        handle = maintenance.child("On_Off").observe(.value, with: { (snapshot) in
            let value = snapshot.value as! String
            if value == "On"{
                self.btnMaintenance.setTitle("M OFF", for: .normal)
                self.lblMaintenance.text = "Main ON"
            }else if value == "Off"{
                self.btnMaintenance.setTitle("M ON", for: .normal)
                self.lblMaintenance.text = "Main OFF"
            }
        })
        handle = stop_p.child("Stop_Start").observe(.value, with: { (snapshot) in
            let value = snapshot.value as! String
            if value == "Stopped"{
                self.btnStart_Stop.setTitle("P ON", for: .normal)
                self.lblStart_Stop.text = "Pay OFF"
            }else if value == "Started"{
                self.btnStart_Stop.setTitle("P OFF", for: .normal)
                self.lblStart_Stop.text = "Pay ON"
            }
        })
        
        
    }
    
    @IBAction func toggle(_ sender: Any) {
        if !toggle.isOn{
//            let maintain = self.storyboard?.instantiateViewController(withIdentifier: "Maintenance") as! MaintenanceController
//            self.present(maintain, animated: true, completion: nil)
        }else{
            let adminAcess = ref.child("Admin").child((user?.uid)!)
            handle = adminAcess.child("Access").observe(.value, with: { (snapshot) in
                if snapshot.value != nil{
                    let value = snapshot.value as! String
                    if value != "Yes"{
                        let maintain = self.storyboard?.instantiateViewController(withIdentifier: "Maintenance") as! MaintenanceController
                        self.present(maintain, animated: true, completion: nil)
                    }
                }
                
            })
        }
    }
    
    func isMaintaining(){
        if toggle.isOn{
            let adminAcess = ref.child("Admin").child((user?.uid)!)
            handle = adminAcess.child("Access").observe(.value, with: { (snapshot) in
                if snapshot.value != nil{
                    let value = snapshot.value as! String
                    if value != "Yes"{
                        let maintain = self.storyboard?.instantiateViewController(withIdentifier: "Maintenance") as! MaintenanceController
                        self.present(maintain, animated: true, completion: nil)
                    }
                }
                
            })
        }else{
            
        }
    }
    
    // Check if there is internet int he device
    override func viewDidAppear(_ animated: Bool) {
        if checknet.connection(){}else{
            let noNet = self.storyboard?.instantiateViewController(withIdentifier: "Connection") as! ConnectionController
            self.present(noNet , animated: true, completion: nil)
        }
    }
}
