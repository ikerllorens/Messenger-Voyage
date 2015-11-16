//
//  MissionSelectViewController.swift
//  UltraDelivery
//
//  Created by Iker on 12/11/15.
//  Copyright © 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class CharacterSelectViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var ReadyButton: UIButton!
    @IBOutlet weak var selectDeselectButton: UIButton!
    @IBOutlet weak var infoVehicleName: UILabel!
    @IBOutlet weak var vehicleCollection: UICollectionView!
    @IBOutlet weak var infoVehicleDescription: UITextView!
    @IBOutlet weak var vehicleInfoView: UIView!
    var gameSelections: Array<AnyObject>!
    var selectedCellPath: NSIndexPath!
    private var numberSelected: Int = 0
    private let classes = ["Thug", "Shaman", "Medic", "Scientist"]
    private let classDescription = ["Heavy guy, he assures less attacks", "A bit crazy, weather will be favorable... or not", "No words needed...", "Curious, he may discover things... If payed well"]
    private var thugCharactersList: Array<NSMutableDictionary> = []
    private var shamanCharactersList: Array<NSMutableDictionary> = []
    private var medicCharactersList: Array<NSMutableDictionary> = []
    private var scientistCharacterList: Array<NSMutableDictionary> = []
    private var currentSelectedCharacters: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vehicleInfoView.hidden = true
        self.ReadyButton.hidden = true
        vehicleCollection.reloadData()
        let path = NSBundle.mainBundle().pathForResource("SupportCharactersList", ofType: "plist")
        let allCharacters = NSMutableDictionary.init(contentsOfFile: path!)! as NSDictionary
        let thugCharacters = allCharacters.objectForKey("Thug") as! NSMutableDictionary
        let shamanCharacters = allCharacters.objectForKey("Shaman") as! NSMutableDictionary
        let medicCharacters = allCharacters.objectForKey("Medic") as! NSMutableDictionary
        let scientistCharacters = allCharacters.objectForKey("Scientist") as! NSMutableDictionary
        for thugCharacter in thugCharacters.allKeys {
            self.thugCharactersList.append(thugCharacters.objectForKey(thugCharacter) as! NSMutableDictionary)
        }
        for shamanCharacter in shamanCharacters.allKeys {
            self.shamanCharactersList.append(shamanCharacters.objectForKey(shamanCharacter) as! NSMutableDictionary)
        }
        for medicCharacter in medicCharacters.allKeys {
            self.medicCharactersList.append(medicCharacters.objectForKey(medicCharacter) as! NSMutableDictionary)
        }
        for scientistCharacter in scientistCharacters.allKeys {
            self.scientistCharacterList.append(scientistCharacters.objectForKey(scientistCharacter) as! NSMutableDictionary)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return self.thugCharactersList.count
        case 1:
            return self.shamanCharactersList.count
        case 2:
            return self.medicCharactersList.count
        case 3:
            return self.scientistCharacterList.count
        default:
            return 0
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int   {
        return self.classes.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,atIndexPath indexPath: NSIndexPath) -> CharacterHeaderCollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:  "sectionCharacterHeader", forIndexPath: indexPath) as! CharacterHeaderCollectionReusableView
        let currentClassName = self.classes[indexPath.section]
        let currentClassDescription = self.classDescription[indexPath.section]
        header.className.text = currentClassName
        header.classDescription.text = currentClassDescription
        
        return header
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! VehicleCollectionViewCell
        self.vehicleInfoView.hidden = false
        self.infoVehicleName.text = selectedCell.vehicleInfo.objectForKey("Name") as? String
        self.infoVehicleName.sizeToFit()
        self.infoVehicleDescription.text = selectedCell.vehicleInfo.objectForKey("Description") as? String
        if((selectedCell.vehicleInfo.objectForKey("control_Selected") as? Bool) == true) {
            self.selectDeselectButton.setTitle("Deselect", forState: UIControlState.Normal)
        } else {
            self.selectDeselectButton.setTitle("Select", forState: UIControlState.Normal)
        }
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.vehicleInfoView.alpha = 0.95
            }, completion: {(completed) in self.vehicleInfoView.hidden = false})
        
        self.selectedCellPath = indexPath
    }
    
    @IBAction func dismissDetail(sender: UIButton) {
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.vehicleInfoView.alpha = 0.0
            }, completion: {(completed) in self.vehicleInfoView.hidden = true})
        //self.currentSelectedVehicleInfo = nil
    }
    
    @IBAction func selectVehicle(sender: AnyObject) {
        let selectedCell = self.vehicleCollection.cellForItemAtIndexPath(self.selectedCellPath) as! VehicleCollectionViewCell
        if((selectedCell.vehicleInfo.objectForKey("control_Selected") as? Bool) == true) {
            selectedCell.vehicleInfo.setValue(false, forKey: "control_Selected")
            self.selectDeselectButton.setTitle("Select", forState: UIControlState.Normal)
            selectedCell.backgroundColor = UIColor.clearColor()
            var i = 0
            for character in self.currentSelectedCharacters {
                if(character["Name"] == selectedCell.vehicleInfo.objectForKey("Name") as? String) {
                    self.currentSelectedCharacters.removeAtIndex(i)
                }
                i++
            }
            self.numberSelected--
        } else {
            selectedCell.vehicleInfo.setValue(true, forKey: "control_Selected")
            self.selectDeselectButton.setTitle("Deselect", forState: UIControlState.Normal)
            selectedCell.backgroundColor = UIColor.greenColor()
            self.currentSelectedCharacters.append(["Class": self.classes[self.selectedCellPath.section], "Name": selectedCell.vehicleInfo.objectForKey("Name") as! String])
            self.numberSelected++
        }
        if (numberSelected == 4) {
            self.ReadyButton.hidden = false
        } else {
            self.ReadyButton.hidden = true
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> VehicleCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("characterCell", forIndexPath: indexPath) as! VehicleCollectionViewCell
        var character: NSDictionary!
        switch(indexPath.section) {
        case 0:
            character = self.thugCharactersList[indexPath.row]
            break
        case 1:
            character = self.shamanCharactersList[indexPath.row]
            break
        case 2:
            character = self.medicCharactersList[indexPath.row]
            break
        case 3:
            character = self.scientistCharacterList[indexPath.row]
            break
        default:
            break
        }
        cell.vehicleName.text = character.objectForKey("Name") as? String
        cell.vehicleInfo = character
        if(character.objectForKey("control_Selected") as! Bool == true) {
            cell.backgroundColor = UIColor.greenColor()
        } else {
            cell.backgroundColor = UIColor.clearColor()
        }
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //self.gameSelections.append(currentSelectedVehicleInfo)
        let characterDict = ["Character1": self.currentSelectedCharacters[0], "Character2": self.currentSelectedCharacters[1],"Character3": self.currentSelectedCharacters[2],"Character4": self.currentSelectedCharacters[3]]
        self.gameSelections.append(characterDict)
        (segue.destinationViewController as! GameViewController).initGame = self.gameSelections
    }

}
