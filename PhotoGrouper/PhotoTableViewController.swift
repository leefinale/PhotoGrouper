//
//  PhotoTableViewController.swift
//  PhotoGrouper
//
//  Created by Elex Lee on 7/9/15.
//  Copyright (c) 2015 Elex Lee. All rights reserved.
//

import UIKit

let reuseTableViewCellIdentifier = "PhotoTableViewCell"
let reuseCollectionViewCellIdentifier = "PhotoCollectionViewCell"

class PhotoTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GroupSelectionModalViewControllerDelegate, ImagePreviewModalViewControllerDelegate {
    
    var sourceArray: NSArray!
    var contentOffsetDictionary: NSMutableDictionary!
    var groupTitleHolder: NSMutableArray!
    var selectedCellIndexPath: NSIndexPath?
    var selectedCellInformationArray: NSMutableArray!
    var selectionPresent: Bool!
    var tempGroupNameText: UITextField!
    
    convenience init(source: NSMutableArray) {
        self.init()
        self.tableView.registerClass(PhotoTableViewCell.self, forCellReuseIdentifier: "PhotoTableViewCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.sourceArray = NSArray(array: source)
        self.contentOffsetDictionary = NSMutableDictionary()
        self.groupTitleHolder = NSMutableArray()
        self.selectedCellInformationArray = [0, 0]
        self.selectionPresent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        let imageGalleryButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        imageGalleryButton.frame = CGRectMake(5, 2, 100, 40)
        imageGalleryButton.backgroundColor = UIColor.clearColor()
        imageGalleryButton.setTitle("Add Photo", forState: UIControlState.Normal)
        imageGalleryButton.addTarget(self, action: "imageGalleryButtonPress:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(imageGalleryButton)
        
        let createGroupButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        createGroupButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 105, 2, 100, 40)
        createGroupButton.backgroundColor = UIColor.clearColor()
        createGroupButton.setTitle("Create Group", forState: UIControlState.Normal)
        createGroupButton.addTarget(self, action: "createGroupButtonPress:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(createGroupButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertWithError(error : NSError) {
        println(error.description)
    }
    
    func imageGalleryButtonPress(sender: UIButton!) {
        if groupTitleHolder.count == 0 {
            let alert = UIAlertController(title: "Error", message: "Please create a group before adding pictures.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func createGroupButtonPress(sender: UIButton!) {
        let alert = UIAlertController(title: "Create Picture Group", message: "Please enter a title:", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            self.groupTitleHolder.addObject(self.tempGroupNameText.text)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func configurationTextField(textField: UITextField!)
    {
        textField.placeholder = "e.g. Summer Vacation"
        tempGroupNameText = textField
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if (picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary) {
            var imageToSaveFromLibrary: UIImage = info[(UIImagePickerControllerOriginalImage)] as! UIImage
            let tempGroupSelectionModalViewController = GroupSelectionModalViewController()
            tempGroupSelectionModalViewController.delegate = self
            for var count = 0; count < groupTitleHolder.count; count++ {
                tempGroupSelectionModalViewController.groupTitles.append(groupTitleHolder[count] as! String)
            }
            tempGroupSelectionModalViewController.imageToAdd = imageToSaveFromLibrary
            dismissViewControllerAnimated(true, completion: nil)
            self.presentViewController(tempGroupSelectionModalViewController, animated: true, completion: nil)
        }

    }
    
// MARK: - GroupSelectionModalViewControllerDelegate
    func addPictureToGroup(groupName: String, pictureToAdd: UIImage) {
        for var count = 0; count < groupTitleHolder.count; count++ {
            if groupTitleHolder[count] as! String == groupName {
                sourceArray[count].addObject(pictureToAdd)
                tableView.reloadData()
            }
            println(sourceArray[count])
        }
    }
    
// MARK - ImagePreviewModalViewControllerDelegate
    func imageSwapSelection(selectedImage: UIImage) {
        
    }
    
    func imageDeleteSelection(selectedImage: UIImage) {
        
    }
}

// MARK: - Table view data source

extension PhotoTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.groupTitleHolder.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoTableViewCell", forIndexPath: indexPath) as! PhotoTableViewCell
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.groupTitleHolder[section] as? String
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let collectionCell: PhotoTableViewCell = cell as! PhotoTableViewCell
        collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, indexPath: indexPath)
        let index: NSInteger = collectionCell.collectionView.tag
        let value: AnyObject? = self.contentOffsetDictionary.valueForKey(index.description)
        let horizontalOffset: CGFloat = CGFloat(value != nil ? value!.floatValue : 0)
        collectionCell.collectionView.setContentOffset(CGPointMake(horizontalOffset, 0), animated: false)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
}

// MARK: - Collection View Data source and Delegate

extension PhotoTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionViewArray: NSArray = self.sourceArray[collectionView.tag] as! NSArray
        return collectionViewArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        let collectionViewArray = self.sourceArray[collectionView.tag] as! NSArray
        cell.imageView.image = collectionViewArray[indexPath.item] as? UIImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let imageChoice = self.sourceArray[collectionView.tag][indexPath.item] as! UIImage
        selectedCellIndexPath = indexPath
        
//        var picturePreviewView = ImagePreviewModalViewController()
//        picturePreviewView.delegate = self
//        picturePreviewView.pictureImageView.image = imageChoice
//        self.presentViewController(picturePreviewView, animated: true, completion: nil)

        
        if selectionPresent == false {
            let alert = UIAlertController(title: "Choose an option", message: "Please select another picture to swap with.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            selectedCellInformationArray.replaceObjectAtIndex(0, withObject: collectionView.tag)
            selectedCellInformationArray.replaceObjectAtIndex(1, withObject: indexPath.item)
            println(selectedCellInformationArray[0])
            println(selectedCellInformationArray[1])
            selectionPresent = true
        } else if selectionPresent == true {
            var selectedTag = selectedCellInformationArray[0] as! Int
            var selectedItem = selectedCellInformationArray[1] as! Int
            if selectedTag != collectionView.tag {
                let alert = UIAlertController(title: "Error", message: "You can only swap pictures in the same group.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                selectionPresent = false
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                var selectedImage = self.sourceArray[selectedTag][selectedItem] as! UIImage
                self.sourceArray[selectedTag].replaceObjectAtIndex(selectedItem, withObject: self.sourceArray[collectionView.tag][indexPath.item])
                self.sourceArray[collectionView.tag].replaceObjectAtIndex(indexPath.item, withObject: selectedImage)
                
                selectionPresent = false
                collectionView.reloadData()
            }
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if !scrollView.isKindOfClass(UICollectionView) {
            return
        }
        let horizontalOffset: CGFloat = scrollView.contentOffset.x
        let collectionView: UICollectionView = scrollView as! UICollectionView
        self.contentOffsetDictionary.setValue(horizontalOffset, forKey: collectionView.tag.description)
    }
}

