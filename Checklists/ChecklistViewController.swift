//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by mac on 15/9/18.
//  Copyright © 2015年 mac. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        title = checklist.name
    }


    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return checklist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem")

        let label = cell!.viewWithTag(1000) as! UILabel
        
        let item = checklist.items[indexPath.row]
        
        label.text = item.text

        configureCheckmarkForCell(cell!, withChecklistItem: item)
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        checklist.items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        
        if item.checked {
            label.text = "✓"
        } else {
            label.text = ""
        }
    }
    
    
    func itemDetailViewControllerDidCancel(controller:ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller:ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.reloadData()

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller:ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        if let index = checklist.items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = item.text
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as!ItemDetailViewController
            controller.delegate = self
            controller.itemToEdit = nil
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as!ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
}
