//
//  UserProfileViewController.swift
//  UltraDelivery
//
//  Created by Iker on 16/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    let healthManager = HealthManager()
    let userProfile = UserModel()
    let bloodTypes = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
    var errorFlag: Bool = false
    var fetchHeightFin = false
    var fetchWeightFin = false
    
    @IBOutlet weak var ageTextInput: UITextField!
    @IBOutlet weak var bloodTypePicker: UIPickerView!
    @IBOutlet weak var nameTextInput: UITextField!
    @IBOutlet weak var weightTextInput: UITextField!
    @IBOutlet weak var heightTextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "valHeightUpdated", name: "heightUpdated", object: self.healthManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "valWeightUpdated", name: "weightUpdated", object: self.healthManager)
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        let done: UIBarButtonItem = UIBarButtonItem(title: "Hecho", style: UIBarButtonItemStyle.Done, target: self, action: Selector("dismissKeyboard:"))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        doneToolbar.items = [ flexSpace, done]
        
        if(self.userProfile.userProfileName != nil) {
            self.ageTextInput.text = String(format: "%i", self.userProfile.userProfileAge)
            self.nameTextInput.text = self.userProfile.userProfileName
            self.weightTextInput.text = String(format: "%.1f", self.userProfile.userProfileWeight)
            self.heightTextInput.text = String(format: "%.1f", self.userProfile.userProfileHeight)
            self.bloodTypePicker.selectRow(self.userProfile.userProfileBloodType, inComponent: 0, animated: true)
        }
        
        self.ageTextInput.inputAccessoryView = doneToolbar
         self.nameTextInput.inputAccessoryView = doneToolbar
         self.weightTextInput.inputAccessoryView = doneToolbar
         self.heightTextInput.inputAccessoryView = doneToolbar
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypes.count
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypes[row]
    }

    @IBAction func saveData(sender: UIButton) {
        if(self.ageTextInput.text! != "") {
            self.userProfile.userProfileAge = Int(self.ageTextInput.text!)
            
            if(self.nameTextInput.text! != "" ){
                self.userProfile.userProfileName = self.nameTextInput.text!
                
                if(self.heightTextInput.text! != "") {
                    self.userProfile.userProfileHeight = Double(self.heightTextInput.text!)
                    
                    if(self.weightTextInput.text! != "") {
                        self.userProfile.userProfileWeight = Double(self.weightTextInput.text!)
                        self.userProfile.userProfileBloodType = self.bloodTypePicker.selectedRowInComponent(0)
                        self.userProfile.saveData()
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        let alertController = UIAlertController(title: "Error", message:
                            "Please fill the fields", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message:
                        "Please fill the fields", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Error", message:
                    "Please fill the fields", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertController = UIAlertController(title: "Error", message:
                "Please fill the fields", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func loadFromHealthKit(sender: UIButton) {
        healthManager.authorizeHealthKit()
        self.errorFlag = false
        
        healthManager.updateHeight()
        healthManager.updateWeight()
        
        if(healthManager.getBloodType() != -1) {
            self.bloodTypePicker.selectRow(healthManager.getBloodType(), inComponent: 0, animated: true)
        } else {
            errorFlag = true
        }
        
        if(healthManager.getAge() != -1) {
            self.ageTextInput.text = String(format: "%i", healthManager.getAge())
        } else {
            errorFlag = true
        }
        
    }
    
    func valHeightUpdated () {
        if(self.healthManager.getHeight() == -2) {
            self.errorFlag = true
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.heightTextInput.text = String(format: "%.1f", self.healthManager.getHeight())
            })
        }
        
        self.fetchHeightFin = true
        if(self.fetchHeightFin && self.fetchWeightFin) {
            if (self.errorFlag) {
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Error", message:
                        "No permission to read some data or missing from HealthKit", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
            self.fetchWeightFin = false
            self.fetchHeightFin = false
            self.errorFlag = false
        }
    }
    
    func valWeightUpdated() {
        if(self.healthManager.getWeight() == -2) {
            self.errorFlag = true
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.weightTextInput.text = String(format: "%.1f", self.healthManager.getWeight())
            })
        }
        
        self.fetchWeightFin = true
        if(self.fetchHeightFin && self.fetchWeightFin) {
            if (self.errorFlag) {
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Error", message:
                        "Could read some data from HealthKit (Check if data exists or the app has permission)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
            self.fetchWeightFin = false
            self.fetchHeightFin = false
            self.errorFlag = false
        }
    }
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destinationViewController as? HelpViewController {
            destination.tempText = "You have to fill the profile, with this data the game will calculate your character's stamina"
        }
    }
    

}
