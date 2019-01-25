//
//  JoinController.swift
//  RMania
//
//  Created by Joel Vangente on 20/12/2018.
//  Copyright © 2018 Joel Vangente. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class JoinController: UIViewController, PayPalPaymentDelegate{

    @IBOutlet weak var stackEntry2: UIStackView!
    @IBOutlet weak var stackEntry3: UIStackView!
    @IBOutlet weak var stackEntry4: UIStackView!
    @IBOutlet weak var stackEntry5: UIStackView!
    
    @IBOutlet weak var txtEntry1: UITextField!
    @IBOutlet weak var txtEntry2: UITextField!
    @IBOutlet weak var txtEntry3: UITextField!
    @IBOutlet weak var txtEntry4: UITextField!
    @IBOutlet weak var txtEntry5: UITextField!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var txtSelerName_Token: UITextField!
    
    @IBOutlet weak var btnpay: UIButton!
    
    var stack_control = 1
    
    var handle:DatabaseHandle?
    var ref:DatabaseReference!
    
    let user = Auth.auth().currentUser
    
    //Paypal integration
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        checkEntries()
        isMaintaining()
        
        
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "Joel Vangente"
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full") as URL?
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")! as URL
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
        
        PayPalMobile.preconnect(withEnvironment: environment)

    }
    
    @IBAction func addEntry(_ sender: Any) {
        if stack_control < 5{
            stack_control = stack_control + 1
            if stack_control == 2{
                stackEntry2.isHidden = false
                getPrice_From_DB()
            }else if stack_control == 3{
                stackEntry2.isHidden = false
                stackEntry3.isHidden = false
                getPrice_From_DB()
            }else if stack_control == 4{
                stackEntry2.isHidden = false
                stackEntry3.isHidden = false
                stackEntry4.isHidden = false
                getPrice_From_DB()
            }else if stack_control == 5{
                stackEntry2.isHidden = false
                stackEntry3.isHidden = false
                stackEntry4.isHidden = false
                stackEntry5.isHidden = false
                getPrice_From_DB()
            }
        }
    }
    @IBAction func removeEntry(_ sender: Any) {
        if stack_control >= 2{
            if stack_control == 5{
                if txtEntry5.isEnabled{
                   txtEntry5.text = nil
                }
                stackEntry5.isHidden = true
                getPrice_From_DB()
            }else if stack_control == 4{
                if txtEntry4.isEnabled{
                    txtEntry4.text = nil
                }
                stackEntry4.isHidden = true
                stackEntry5.isHidden = true
                getPrice_From_DB()
            }else if stack_control == 3{
                if txtEntry3.isEnabled{
                    txtEntry3.text = nil
                }
                stackEntry3.isHidden = true
                stackEntry4.isHidden = true
                stackEntry5.isHidden = true
                getPrice_From_DB()
            }else if stack_control == 2{
                if txtEntry2.isEnabled{
                    txtEntry2.text = nil
                }
                stackEntry2.isHidden = true
                stackEntry3.isHidden = true
                stackEntry4.isHidden = true
                stackEntry5.isHidden = true
                getPrice_From_DB()
            }
            stack_control = stack_control - 1
        }
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            self.add_entry_to_db()
            self.add_seler_to_DB()
            
            let receipt = self.ref.child("Receipt").child((self.user?.uid)!).child(self.d_stamp())
            receipt.setValue(completedPayment.confirmation)
        })
        let goBack = self.storyboard?.instantiateViewController(withIdentifier: "JoinController") as! JoinController
        self.present(goBack, animated: true, completion: nil)
    }
    
    @IBAction func payment(_ sender: Any) {
        if stack_control == 1 && txtEntry1.text == ""{
            
           txtEntry1.placeholder = "Please add name here!"
        }else if stack_control == 2 && (txtEntry1.text == "" || txtEntry2.text == ""){
            
            txtEntry1.placeholder = "Please add name here!"
            txtEntry2.placeholder = "Please add name here!"
        }else if stack_control == 3 && (txtEntry1.text == "" || txtEntry2.text == "" || txtEntry3.text == ""){
            
            txtEntry1.placeholder = "Please add name here!"
            txtEntry2.placeholder = "Please add name here!"
            txtEntry3.placeholder = "Please add name here!"
        }else if stack_control == 4 && (txtEntry1.text == "" || txtEntry2.text == "" || txtEntry3.text == "" || txtEntry4.text == ""){
            
            txtEntry1.placeholder = "Please add name here!"
            txtEntry2.placeholder = "Please add name here!"
            txtEntry3.placeholder = "Please add name here!"
            txtEntry4.placeholder = "Please add name here!"
        }else if stack_control == 5 && (txtEntry1.text == "" || txtEntry2.text == "" || txtEntry3.text == "" || txtEntry4.text == "" || txtEntry5.text == ""){
            
            txtEntry1.placeholder = "Please add name here!"
            txtEntry2.placeholder = "Please add name here!"
            txtEntry3.placeholder = "Please add name here!"
            txtEntry4.placeholder = "Please add name here!"
            txtEntry5.placeholder = "Please add name here!"
        }else{
            let item = ref.child("Description Values")
            handle = item.child("Item").observe(.value, with: { (snapshot) in
                if snapshot.value as? String != nil{
                    let value = snapshot.value as? String
                    
                    // Process Payment once the pay button is clicked.
                    let price_to_pay = self.lblPrice.text
                    
                    let item1 = PayPalItem(name: value!, withQuantity: 1, withPrice: NSDecimalNumber(string: price_to_pay), withCurrency: "GBP", withSku: "Joel-0001")
                    
                    let items = [item1]
                    let subtotal = PayPalItem.totalPrice(forItems: items)
                    
                    // Optional: include payment details
                    let shipping = NSDecimalNumber(string: "0.00")
                    let tax = NSDecimalNumber(string: "0.00")
                    let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
                    
                    let total = subtotal.adding(shipping).adding(tax)
                    
                    let payment = PayPalPayment(amount: total, currencyCode: "GBP", shortDescription: "Entry to participate", intent: .sale)
                    
                    payment.items = items
                    payment.paymentDetails = paymentDetails
                    
                    if (payment.processable) {
                        
                        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: self.payPalConfig, delegate: self)
                        self.present(paymentViewController!, animated: true, completion: nil)
                    }
                    else {
                        
                        print("Payment not processalbe: \(payment)")
                    }
                }
            })
        }
        
    }
    
    @IBAction func cancellation(_ sender: Any) {
        let goBack = self.storyboard?.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        self.present(goBack, animated: true, completion: nil)
    }
    
    func add_entry_to_db(){
        let item = ref.child("Description Values")
        handle = item.child("Item").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                let timeStamp = self.ref.child(value!).child("01_Time Stamp")
                
                let descriptions = self.ref.child(value!).child("Participants").child((self.user?.uid)!)
                if self.txtEntry1.text != ""{
                    let token = ((self.user?.uid)!)
                    if self.txtEntry1.isEnabled{
                        let name_token = self.txtEntry1.text! + "_" + String(token.suffix(6))
                        descriptions.child("Entry1").setValue(name_token)
                        timeStamp.child(self.d_stamp()).setValue(name_token)
                    }
                    
                }
                if self.txtEntry2.text != ""{
                    let token = ((self.user?.uid)!)
                    if self.txtEntry2.isEnabled{
                        let name_token = self.txtEntry2.text! + "_" + String(token.suffix(6))
                        descriptions.child("Entry2").setValue(name_token)
                        timeStamp.child(self.d_stamp()).setValue(name_token)
                    }
                }
                if self.txtEntry3.text != ""{
                    let token = ((self.user?.uid)!)
                    if self.txtEntry3.isEnabled{
                        let name_token = self.txtEntry3.text! + "_" + String(token.suffix(6))
                        descriptions.child("Entry3").setValue(name_token)
                        timeStamp.child(self.d_stamp()).setValue(name_token)
                    }
                }
                if self.txtEntry4.text != ""{
                    let token = ((self.user?.uid)!)
                    if self.txtEntry4.isEnabled{
                        let name_token = self.txtEntry4.text! + "_" + String(token.suffix(6))
                        descriptions.child("Entry4").setValue(name_token)
                        timeStamp.child(self.d_stamp()).setValue(name_token)
                    }
                }
                if self.txtEntry5.text != ""{
                    let token = ((self.user?.uid)!)
                    if self.txtEntry5.isEnabled{
                        let name_token = self.txtEntry5.text! + "_" + String(token.suffix(6))
                        descriptions.child("Entry5").setValue(name_token)
                        timeStamp.child(self.d_stamp()).setValue(name_token)
                    }
                }
            }
        })
        
    }
    
    func add_seler_to_DB(){
        let item = ref.child("Description Values")
        handle = item.child("Item").observe(.value, with: { (snapshot) in
            if snapshot.value as? String != nil{
                let value = snapshot.value as? String
                
                let descriptions = self.ref.child(value!).child("Sellers").child((self.user?.uid)!)
                if self.txtSelerName_Token.isEnabled{
                    if self.txtSelerName_Token.text != ""{
                        descriptions.child("Name").setValue(self.txtSelerName_Token.text)
                    }
                }
            }
        })
    }
    
    func getPrice_From_DB(){
        let descriptions = ref.child("Description Values")
        handle = descriptions.child("PricePayPal").observe(.value, with: { (snapshot) in
            if snapshot.value as? NSNumber != nil{
                let value = snapshot.value as! NSNumber
                
                var total = (Float(truncating: value))
                if self.stack_control == 5{
                    if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled && !self.txtEntry3.isEnabled && !self.txtEntry4.isEnabled && !self.txtEntry5.isEnabled{
                        
                        self.lblPrice.text = "0"
                        self.btnpay.isEnabled = false
                    }else if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled && !self.txtEntry3.isEnabled && !self.txtEntry4.isEnabled && self.txtEntry5.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled && !self.txtEntry3.isEnabled && self.txtEntry4.isEnabled && self.txtEntry5.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        total = total * 2
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled && self.txtEntry3.isEnabled && self.txtEntry4.isEnabled && self.txtEntry5.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        total = total * 3
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else if !self.txtEntry1.isEnabled && self.txtEntry2.isEnabled && self.txtEntry3.isEnabled && self.txtEntry4.isEnabled && self.txtEntry5.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        total = total * 4
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else if self.txtEntry1.isEnabled && self.txtEntry2.isEnabled && self.txtEntry3.isEnabled && self.txtEntry4.isEnabled && self.txtEntry5.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        total = total * 5
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }
                    
                }else if self.stack_control == 4{
                    if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled && !self.txtEntry3.isEnabled && !self.txtEntry4.isEnabled{
                        
                        self.lblPrice.text = "0"
                        self.btnpay.isEnabled = false
                    }else if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled && !self.txtEntry3.isEnabled && self.txtEntry4.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled && self.txtEntry3.isEnabled && self.txtEntry4.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        total = total * 2
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else if !self.txtEntry1.isEnabled && self.txtEntry2.isEnabled && self.txtEntry3.isEnabled && self.txtEntry4.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        total = total * 3
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else{
                        
                        self.btnpay.isEnabled = true
                        total = total * 4
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }
                    
                }else if self.stack_control == 3{
                    if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled && !self.txtEntry3.isEnabled{
                        
                        self.lblPrice.text = "0"
                        self.btnpay.isEnabled = false
                    }else if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled && self.txtEntry3.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else if !self.txtEntry1.isEnabled && self.txtEntry2.isEnabled && self.txtEntry3.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        total = total * 2
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else{
                        
                        self.btnpay.isEnabled = true
                        total = total * 3
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }
                    
                }else if self.stack_control == 2{
                    
                    if !self.txtEntry1.isEnabled && !self.txtEntry2.isEnabled{
                        self.lblPrice.text = "0"
                        self.btnpay.isEnabled = false
                    }else if !self.txtEntry1.isEnabled && self.txtEntry2.isEnabled{
                        
                        self.btnpay.isEnabled = true
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }else{
                        
                        self.btnpay.isEnabled = true
                        total = total * 2
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }
                    
                }else if self.stack_control == 1{
                    
                    if !self.txtEntry1.isEnabled{
                        self.lblPrice.text = "0"
                        self.btnpay.isEnabled = false
                    }else{
                        
                        self.btnpay.isEnabled = true
                        total = total * 1
                        self.lblPrice.text = (String(format: "%.2f", total))
                    }
                    
                }
            }
        })
    }
    
    func checkEntries(){
        getPrice_From_DB()
        let item = ref.child("Description Values")
        handle = item.child("Item").observe(.value, with: { (snapshotItem) in
            if snapshotItem.value as? String != nil{
                let valueItem = snapshotItem.value as? String
                
                let descriptions = self.ref.child(valueItem!).child("Participants").child((self.user?.uid)!)
                let seler = self.ref.child(valueItem!).child("Sellers").child((self.user?.uid)!)
                
                self.handle = descriptions.child("Entry1").observe(.value, with: { (snapshot) in
                    if snapshot.value as? String != nil{
                        let valueE1 = snapshot.value as? String
                        
                        if valueE1 != ""{
                            self.txtEntry1.text = valueE1
                            self.txtEntry1.isEnabled = false
                            self.getPrice_From_DB()
                        }
                    }
                })
                
                self.handle = descriptions.child("Entry2").observe(.value, with: { (snapshot) in
                    if snapshot.value as? String != nil{
                        let value = snapshot.value as? String
                        
                        if value != ""{
                            self.txtEntry2.text = value
                            self.txtEntry2.isEnabled = false
                        }
                    }
                })
                
                self.handle = descriptions.child("Entry3").observe(.value, with: { (snapshot) in
                    if snapshot.value as? String != nil{
                        let value = snapshot.value as? String
                        
                        if value != ""{
                            self.txtEntry3.text = value
                            self.txtEntry3.isEnabled = false
                        }
                    }
                })
                
                self.handle = descriptions.child("Entry4").observe(.value, with: { (snapshot) in
                    if snapshot.value as? String != nil{
                        let value = snapshot.value as? String
                        
                        if value != ""{
                            self.txtEntry4.text = value
                            self.txtEntry4.isEnabled = false
                        }
                    }
                })
                
                self.handle = descriptions.child("Entry5").observe(.value, with: { (snapshot) in
                    if snapshot.value as? String != nil{
                        let value = snapshot.value as? String
                        
                        if value != ""{
                            self.txtEntry5.text = value
                            self.txtEntry5.isEnabled = false
                        }
                    }
                })
                
                self.handle = seler.child("Name").observe(.value, with: { (snapshot) in
                    if snapshot.value as? String != nil{
                        let value = snapshot.value as? String
                        
                        if value != ""{
                            self.txtSelerName_Token.text = value
                            self.txtSelerName_Token.isEnabled = false
                        }
                    }
                })
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if checknet.connection(){}else{
            let noNet = self.storyboard?.instantiateViewController(withIdentifier: "Connection") as! ConnectionController
            self.present(noNet , animated: true, completion: nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtEntry1.resignFirstResponder()
        txtEntry2.resignFirstResponder()
        txtEntry3.resignFirstResponder()
        txtEntry4.resignFirstResponder()
        txtEntry5.resignFirstResponder()
        txtSelerName_Token.resignFirstResponder()
    }
    
    func isMaintaining(){
        let maintenance = ref.child("Maintenance")
        
        handle = maintenance.child("On_Off").observe(.value, with: { (snapshot) in
            let value = snapshot.value as! String
            if value == "On"{
                
                let adminAcess = self.ref.child("Admin").child((self.user?.uid)!)
                self.handle = adminAcess.child("Access").observe(.value, with: { (snapshot) in
                    if snapshot.value as? String != nil{
                        let value = snapshot.value as! String
                        if value != "Yes"{
                            let maintain = self.storyboard?.instantiateViewController(withIdentifier: "Maintenance") as! MaintenanceController
                            self.present(maintain, animated: true, completion: nil)
                        }
                    }
                })
            }
        })
    }
    
    func d_stamp() -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let myDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        // again convert your date to string
        let myStringafd = formatter.string(from: myDate!)
        
        return myStringafd
    }
}
