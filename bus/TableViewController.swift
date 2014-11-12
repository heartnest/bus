//
//  TableViewController.swift
//  bus
//
//  Created by HeartNest on 11/11/14.
//  Copyright (c) 2014 asscubo. All rights reserved.
//

import UIKit

class TableViewController: SlashViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView?
    
    
    let cellIdentifier = "cellIdentifier"
    var tableData = [String]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)

        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        // Setup table data
        
        
        let log = NSUserDefaults().objectForKey(LOGKEY) as String;
        var splitted = log.componentsSeparatedByString("@")
        
        for index in splitted {
            self.tableData.append("\(index)")
        }
    }


    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell
        
        cell.textLabel.text = self.tableData[indexPath.row]
        
        return cell
    }
    
    // UITableViewDelegate methods
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {

        let str = self.tableData[indexPath.row]
        updateSearchLog(str)
        
//        let alert = UIAlertController(title: "Item selected", message: "You selected item \(indexPath.row)", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        alert.addAction(UIAlertAction(title: "OK",
//            style: UIAlertActionStyle.Default,
//            handler: {
//                (alert: UIAlertAction!) in println("An alert of type \(alert.style.hashValue) was tapped!")
//                self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
//        }))
//        
//        self.presentViewController(alert, animated: true, completion: nil)
        
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
