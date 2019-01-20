//
//  HistoricController.swift
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

class HistoricController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageNun = 0
    
    @IBOutlet weak var imageview1: UIImageView!
    @IBOutlet weak var imageview2: UIImageView!
    @IBOutlet weak var imageview3: UIImageView!
    @IBOutlet weak var imageview4: UIImageView!
    @IBOutlet weak var imageview5: UIImageView!
    @IBOutlet weak var imageview6: UIImageView!
    @IBOutlet weak var imageview7: UIImageView!
    @IBOutlet weak var imageview8: UIImageView!
    
    @IBOutlet weak var btnAdd1: UIButton!
    @IBOutlet weak var btnAdd2: UIButton!
    @IBOutlet weak var btnAdd3: UIButton!
    @IBOutlet weak var btnAdd4: UIButton!
    @IBOutlet weak var btnAdd5: UIButton!
    @IBOutlet weak var btnAdd6: UIButton!
    @IBOutlet weak var btnAdd7: UIButton!
    @IBOutlet weak var btnAdd8: UIButton!
    
    @IBOutlet weak var lblDes1: UILabel!
    @IBOutlet weak var lblDes2: UILabel!
    @IBOutlet weak var lblDes3: UILabel!
    @IBOutlet weak var lblDes4: UILabel!
    @IBOutlet weak var lblDes5: UILabel!
    @IBOutlet weak var lblDes6: UILabel!
    @IBOutlet weak var lblDes7: UILabel!
    @IBOutlet weak var lblDes8: UILabel!
    
    @IBOutlet weak var txtDes1: UITextField!
    @IBOutlet weak var txtDes2: UITextField!
    @IBOutlet weak var txtDes3: UITextField!
    @IBOutlet weak var txtDes4: UITextField!
    @IBOutlet weak var txtDes5: UITextField!
    @IBOutlet weak var txtDes6: UITextField!
    @IBOutlet weak var txtDes7: UITextField!
    @IBOutlet weak var txtDes8: UITextField!
    
    @IBOutlet weak var btnAddDes1: UIButton!
    @IBOutlet weak var btnAddDes2: UIButton!
    @IBOutlet weak var btnAddDes3: UIButton!
    @IBOutlet weak var btnAddDes4: UIButton!
    @IBOutlet weak var btnAddDes5: UIButton!
    @IBOutlet weak var btnAddDes6: UIButton!
    @IBOutlet weak var btnAddDes7: UIButton!
    @IBOutlet weak var btnAddDes8: UIButton!
    
    var handle:DatabaseHandle?
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        admin_status()
        chechImages()
        check_db_for_previous_winners()
    }
    

    @IBAction func Back(_ sender: Any) {
        let goBack = self.storyboard?.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        self.present(goBack, animated: true, completion: nil)
    }
    
    @IBAction func addDes1(_ sender: Any) {
        if txtDes1.text != ""{
            lblDes1.text = txtDes1.text
            let previous_w = ref.child("Winners").child("Winner1")
            previous_w.setValue(txtDes1.text)
            txtDes1.text = ""
            
        }else{
            lblDes1.isHidden = true
            imageview1.isHidden = true
        }
        
    }
    @IBAction func addDes2(_ sender: Any) {
        lblDes2.text = txtDes2.text
        let previous_w = ref.child("Winners").child("Winner2")
        previous_w.setValue(txtDes2.text)
        txtDes2.text = ""
    }
    @IBAction func addDes3(_ sender: Any) {
        lblDes3.text = txtDes3.text
        let previous_w = ref.child("Winners").child("Winner3")
        previous_w.setValue(txtDes3.text)
        txtDes3.text = ""
    }
    @IBAction func addDes4(_ sender: Any) {
        lblDes4.text = txtDes4.text
        let previous_w = ref.child("Winners").child("Winner4")
        previous_w.setValue(txtDes4.text)
        txtDes4.text = ""
    }
    @IBAction func addDes5(_ sender: Any) {
        lblDes5.text = txtDes5.text
        let previous_w = ref.child("Winners").child("Winner5")
        previous_w.setValue(txtDes5.text)
        txtDes5.text = ""
    }
    @IBAction func addDes6(_ sender: Any) {
        lblDes6.text = txtDes6.text
        let previous_w = ref.child("Winners").child("Winner6")
        previous_w.setValue(txtDes6.text)
        txtDes6.text = ""
    }
    @IBAction func addDes7(_ sender: Any) {
        lblDes7.text = txtDes7.text
        let previous_w = ref.child("Winners").child("Winner7")
        previous_w.setValue(txtDes7.text)
        txtDes7.text = ""
    }
    @IBAction func addDes8(_ sender: Any) {
        lblDes8.text = txtDes8.text
        let previous_w = ref.child("Winners").child("Winner8")
        previous_w.setValue(txtDes8.text)
        txtDes8.text = ""
    }
    
    
    
    @IBAction func addImage1(_ sender: Any) {
        imageNun = 1
        addImage()
    }
    @IBAction func addImage2(_ sender: Any) {
        imageNun = 2
        addImage()
    }
    @IBAction func addImage3(_ sender: Any) {
        imageNun = 3
        addImage()
    }
    @IBAction func addImage4(_ sender: Any) {
        imageNun = 4
        addImage()
    }
    @IBAction func addImage5(_ sender: Any) {
        imageNun = 5
        addImage()
    }
    @IBAction func addImage6(_ sender: Any) {
        imageNun = 6
        addImage()
    }
    @IBAction func addImage7(_ sender: Any) {
        imageNun = 7
        addImage()
    }
    @IBAction func addImage8(_ sender: Any) {
        imageNun = 8
        addImage()
    }
    
    func is_admin(){
        btnAdd1.isHidden = false
        btnAdd2.isHidden = false
        btnAdd3.isHidden = false
        btnAdd4.isHidden = false
        btnAdd5.isHidden = false
        btnAdd6.isHidden = false
        btnAdd7.isHidden = false
        btnAdd8.isHidden = false
        txtDes1.isHidden = false
        txtDes2.isHidden = false
        txtDes3.isHidden = false
        txtDes4.isHidden = false
        txtDes5.isHidden = false
        txtDes6.isHidden = false
        txtDes7.isHidden = false
        txtDes8.isHidden = false
        
        lblDes1.isHidden = false
        lblDes2.isHidden = false
        lblDes3.isHidden = false
        lblDes4.isHidden = false
        lblDes5.isHidden = false
        lblDes6.isHidden = false
        lblDes7.isHidden = false
        lblDes8.isHidden = false
        
        btnAddDes1.isHidden = false
        btnAddDes2.isHidden = false
        btnAddDes3.isHidden = false
        btnAddDes4.isHidden = false
        btnAddDes5.isHidden = false
        btnAddDes6.isHidden = false
        btnAddDes7.isHidden = false
        btnAddDes8.isHidden = false
        
        imageview1.isHidden = false
        imageview2.isHidden = false
        imageview3.isHidden = false
        imageview4.isHidden = false
        imageview5.isHidden = false
        imageview6.isHidden = false
        imageview7.isHidden = false
        imageview8.isHidden = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        picker.dismiss(animated: true, completion: nil)
        var data = Data()
        switch imageNun{
        case 1:
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Historic1")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
            chechImages()
        case 2:
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Historic2")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        case 3:
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Historic3")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        case 4:
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Historic4")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        case 5:
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Historic5")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        case 6:
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Historic6")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        case 7:
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Historic7")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        case 8:
            data = image.jpegData(compressionQuality: 0.5)!
            
            let imageRef = Storage.storage().reference().child("Images/Historic8")
            
            _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
            }
        default:
            print ("Error")
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
    
    func admin_status(){
        if Auth.auth().currentUser?.uid != nil{
            if Auth.auth().currentUser?.uid == "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                is_admin()
            }
        }
    }
    
    //Load image from firebase and display in history page
    func chechImages(){
        let image1 = Storage.storage().reference(withPath: "Images/Historic1")
        let image2 = Storage.storage().reference(withPath: "Images/Historic2")
        let image3 = Storage.storage().reference(withPath: "Images/Historic3")
        let image4 = Storage.storage().reference(withPath: "Images/Historic4")
        let image5 = Storage.storage().reference(withPath: "Images/Historic5")
        let image6 = Storage.storage().reference(withPath: "Images/Historic6")
        let image7 = Storage.storage().reference(withPath: "Images/Historic7")
        let image8 = Storage.storage().reference(withPath: "Images/Historic8")
        
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
        image5.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Add logo image if no image found
                self.imageview5.image = UIImage(named: "RManiav1")
            } else {
                // Data for "images"
                self.imageview5.image = UIImage(data: data!)
                
            }
        }
        image6.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Add logo image if no image found
                self.imageview6.image = UIImage(named: "RManiav1")
            } else {
                // Data for "images"
                self.imageview6.image = UIImage(data: data!)
                
            }
        }
        image7.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Add logo image if no image found
                self.imageview7.image = UIImage(named: "RManiav1")
            } else {
                // Data for "images"
                self.imageview7.image = UIImage(data: data!)
                
            }
        }
        image8.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Add logo image if no image found
                self.imageview8.image = UIImage(named: "RManiav1")
            } else {
                // Data for "images"
                self.imageview8.image = UIImage(data: data!)
                
            }
        }
    }
    
    // Check to see if there is any previous winners information from firebase
    // and fetch it to display
    func check_db_for_previous_winners(){
        let previous_w = ref.child("Winners")
        // Winner 1
        handle = previous_w.child("Winner1").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let winner = snapshot.value as? String
                if winner != ""{
                    self.lblDes1.text = winner
                    self.imageview1.isHidden = false
                    self.lblDes1.isHidden = false
                }else{
                    if Auth.auth().currentUser?.uid != nil{
                        if Auth.auth().currentUser?.uid != "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                            self.imageview1.isHidden = true
                            self.lblDes1.isHidden = true
                        }
                    }
                    
                }
                
            }
        })
        // Winner 2
        handle = previous_w.child("Winner2").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let winner = snapshot.value as? String
                if winner != ""{
                    self.lblDes2.text = winner
                    self.imageview2.isHidden = false
                    self.lblDes2.isHidden = false
                }else{
                    if Auth.auth().currentUser?.uid != nil{
                        if Auth.auth().currentUser?.uid != "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                            self.imageview2.isHidden = true
                            self.lblDes2.isHidden = true
                        }
                    }
                    
                }
            }
        })
        // Winner 3
        handle = previous_w.child("Winner3").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let winner = snapshot.value as? String
                if winner != ""{
                    self.lblDes3.text = winner
                    self.imageview3.isHidden = false
                    self.lblDes3.isHidden = false
                }else{
                    if Auth.auth().currentUser?.uid != nil{
                        if Auth.auth().currentUser?.uid != "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                            self.imageview3.isHidden = true
                            self.lblDes3.isHidden = true
                        }
                    }
                    
                }
            }
        })
        // Winner 4
        handle = previous_w.child("Winner4").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let winner = snapshot.value as? String
                if winner != ""{
                    self.lblDes4.text = winner
                    self.imageview4.isHidden = false
                    self.lblDes4.isHidden = false
                }else{
                    if Auth.auth().currentUser?.uid != nil{
                        if Auth.auth().currentUser?.uid != "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                            self.imageview4.isHidden = true
                            self.lblDes4.isHidden = true
                        }
                    }
                    
                }
            }
        })
        // Winner 5
        handle = previous_w.child("Winner5").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let winner = snapshot.value as? String
                if winner != ""{
                    self.lblDes5.text = winner
                    self.imageview5.isHidden = false
                    self.lblDes5.isHidden = false
                }else{
                    if Auth.auth().currentUser?.uid != nil{
                        if Auth.auth().currentUser?.uid != "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                            self.imageview5.isHidden = true
                            self.lblDes5.isHidden = true
                        }
                    }
                    
                }
            }
        })
        // Winner 6
        handle = previous_w.child("Winner6").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let winner = snapshot.value as? String
                if winner != ""{
                    self.lblDes6.text = winner
                    self.imageview6.isHidden = false
                    self.lblDes6.isHidden = false
                }else{
                    if Auth.auth().currentUser?.uid != nil{
                        if Auth.auth().currentUser?.uid != "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                            self.imageview6.isHidden = true
                            self.lblDes6.isHidden = true
                        }
                    }
                    
                }
            }
        })
        // Winner 7
        handle = previous_w.child("Winner7").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let winner = snapshot.value as? String
                if winner != ""{
                    self.lblDes7.text = winner
                    self.imageview7.isHidden = false
                    self.lblDes7.isHidden = false
                }else{
                    if Auth.auth().currentUser?.uid != nil{
                        if Auth.auth().currentUser?.uid != "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                            self.imageview7.isHidden = true
                            self.lblDes7.isHidden = true
                        }
                    }
                    
                }
            }
        })
        // Winner 8
        handle = previous_w.child("Winner8").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let winner = snapshot.value as? String
                if winner != ""{
                    self.lblDes8.text = winner
                    self.imageview8.isHidden = false
                    self.lblDes8.isHidden = false
                }else{
                    if Auth.auth().currentUser?.uid != nil{
                        if Auth.auth().currentUser?.uid != "ATCiDNYJhYUgD8vRORJW7PaDAmj1"{
                            self.imageview8.isHidden = true
                            self.lblDes8.isHidden = true
                        }
                    }
                    
                }
            }
        })
    }
}
