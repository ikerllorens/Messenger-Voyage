//
//  ScoreViewController.swift
//  ScrambleMyWords
//
//  Created by Iker on 10/19/15.
//  Copyright © 2015 IHMaquina. All rights reserved.
//

import UIKit

class MissionSelectViewController: UIViewController {
    @IBOutlet var tableHistory: UITableView!
    let sections =  ["Easy", "Medium", "Hard", "Insane"]
//    var missions: Dictionary<String, Array<NSDictionary>> = [
//        "Easy": [],
//        "Medium": [],
//        "Hard": [],
//        "Insane": []
//    ]
    var missions: Array<Array<NSDictionary>> = [
        [],
        [],
        [],
        []
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("MissionList", ofType: "plist")
        let allMissions = NSDictionary.init(contentsOfFile: path!)! as NSDictionary
        for easyMissions in allMissions.objectForKey("Easy") as! Array<AnyObject> {
            self.missions[0].append(easyMissions as! NSDictionary)
        }
        for mediumMissions in allMissions.objectForKey("Medium") as! Array<AnyObject> {
            self.missions[1].append(mediumMissions as! NSDictionary)
        }
        for hardMissions in allMissions.objectForKey("Hard") as! Array<AnyObject> {
            self.missions[2].append(hardMissions as! NSDictionary)
        }
        for insaneMissions in allMissions.objectForKey("Insane") as! Array<AnyObject> {
            self.missions[3].append(insaneMissions as! NSDictionary)
        }

        self.tableHistory.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return self.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.missions[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionString = self.sections[section]
        
        return sectionString as String
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("missionCell", forIndexPath: indexPath) as! MissionTableViewCell
        
        //let sectionString = sections[indexPath.section]
        let mission = self.missions[indexPath.section]
        
        cell.textLabel?.text = mission[indexPath.row].objectForKey("Title") as? String
        cell.cellInfo = mission[indexPath.row]
//        cell.detailTextLabel?.text = data[sectionString]![indexPath.row].getScore() + "\n" + data[sectionString]![indexPath.row].getDate()
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectedCell = sender as? MissionTableViewCell {
            print(selectedCell.cellInfo)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}