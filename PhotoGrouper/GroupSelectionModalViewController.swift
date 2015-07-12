//
//  GroupSelectionModalViewController.swift
//  PhotoGrouper
//
//  Created by Elex Lee on 7/10/15.
//  Copyright (c) 2015 Elex Lee. All rights reserved.
//

import UIKit

protocol GroupSelectionModalViewControllerDelegate: class {
    func addPictureToGroup(groupName: String, pictureToAdd: UIImage)
}

class GroupSelectionModalViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController! = UISearchController(searchResultsController: nil)
    var filteredGroups: [String] = []
    var groupTitles: [String] = []
    var imageToAdd: UIImage?
    var delegate: GroupSelectionModalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SearchQueryCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.placeholder = "Choose a group to add picture"
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterGroupTitles(searchController.searchBar.text)
        self.tableView.reloadData()
    }
    
    func filterGroupTitles(searchString: String) {
        self.filteredGroups = self.groupTitles.filter({( currentSearch: String) -> Bool in
            let stringMatch = currentSearch.rangeOfString(searchString)
            return (stringMatch != nil)
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.searchBar.text == "" {
            return groupTitles.count
        } else {
            return filteredGroups.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchQueryCell", forIndexPath: indexPath) as! UITableViewCell
        if self.searchController.searchBar.text == "" {
            cell.textLabel!.text = groupTitles[indexPath.row]
        } else {
            cell.textLabel!.text = filteredGroups[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selection: String
        if self.searchController.searchBar.text == "" {
            selection = groupTitles[indexPath.row]
            println(selection)
        } else {
            selection = filteredGroups[indexPath.row]
            println(selection)
        }
        dismissViewControllerAnimated(true, completion: {() -> Void in
            self.delegate?.addPictureToGroup(selection, pictureToAdd: self.imageToAdd!)
        })
    }
}

