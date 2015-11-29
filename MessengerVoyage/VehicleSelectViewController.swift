//
//  MissionSelectViewController.swift
//  UltraDelivery
//
//  Created by Iker on 12/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class VehicleSelectViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var infoVehicleName: UILabel!
    @IBOutlet weak var vehicleCollection: UICollectionView!
    @IBOutlet weak var infoVehicleDescription: UITextView!
    var gameSelections: Array<AnyObject>!
    private var vehicleList: Array<NSDictionary> = []
    @IBOutlet weak var vehicleInfoView: UIView!
    private var currentSelectedVehicleInfo: String!
    let userProfile = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vehicleInfoView.hidden = true
        vehicleCollection.reloadData()
        let path = NSBundle.mainBundle().pathForResource("VehicleList", ofType: "plist")
        let allVehicles = NSDictionary.init(contentsOfFile: path!)! as NSDictionary
        for vehicle in allVehicles.allKeys {
            self.vehicleList.append(allVehicles.objectForKey(vehicle) as! NSDictionary)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let alertController = UIAlertController(title: "Select Vehicle", message:
            "Please select a vehicle, press the image to know more details and select it", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vehicleList.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! VehicleCollectionViewCell
        
        //print((self.missionsTable.cellForRowAtIndexPath(accessoryButtonTappedForRowWithIndexPath) as! MissionTableViewCell).cellInfo)
        self.vehicleInfoView.hidden = false
        self.currentSelectedVehicleInfo = selectedCell.vehicleInfo.objectForKey("Name") as! String
        self.infoVehicleName.text = selectedCell.vehicleInfo.objectForKey("Name") as? String
        self.infoVehicleName.sizeToFit()
        self.infoVehicleDescription.text = selectedCell.vehicleInfo.objectForKey("Description") as? String
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.vehicleInfoView.alpha = 0.95
            }, completion: {(completed) in self.vehicleInfoView.hidden = false})
    }
    
    @IBAction func dismissDetail(sender: UIButton) {
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.vehicleInfoView.alpha = 0.0
            }, completion: {(completed) in self.vehicleInfoView.hidden = true})
        self.currentSelectedVehicleInfo = nil
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> VehicleCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("vehicleCell", forIndexPath: indexPath) as! VehicleCollectionViewCell
        let vehicle = self.vehicleList[indexPath.row]
        cell.vehicleImage.image = UIImage(named: vehicle.objectForKey("Art") as! String)
        cell.vehicleName.text = vehicle.objectForKey("Name") as? String
        cell.vehicleInfo = vehicle
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let _ = segue.destinationViewController as? CharacterSelectViewController {
            self.gameSelections.append(currentSelectedVehicleInfo)
            (segue.destinationViewController as! CharacterSelectViewController).gameSelections = self.gameSelections
        }
        if let destination = segue.destinationViewController as? HelpViewController {
            destination.tempText = "You must select a vehicle. Each vehicle has a velocity and will modify the events in the game"
        }
        
    }

}
