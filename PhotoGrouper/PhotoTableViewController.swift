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

class PhotoTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var sourceArray: NSArray!
    var contentOffsetDictionary: NSMutableDictionary!
    var imageHolder: NSMutableDictionary!
    var selectedCellIndexPath: NSIndexPath?
    var selectedCellInformationArray: NSMutableArray!
    var selectionPresent: Bool!
    
    convenience init(source: NSMutableArray) {
        self.init()
        self.tableView.registerClass(PhotoTableViewCell.self, forCellReuseIdentifier: "PhotoTableViewCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.sourceArray = NSArray(array: source)
        self.contentOffsetDictionary = NSMutableDictionary()
        self.imageHolder = NSMutableDictionary()
        self.selectedCellInformationArray = [0, 0]
        self.selectionPresent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(5, 0, 100, 40)
        button.backgroundColor = UIColor.blackColor()
        button.setTitle("Image Library", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonPress:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertWithError(error : NSError) {
        println(error.description)
    }
    
    func buttonPress(sender: UIButton!) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    }
}

// MARK: - Table view data source

extension PhotoTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoTableViewCell", forIndexPath: indexPath) as! PhotoTableViewCell
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let collectionCell: PhotoTableViewCell = cell as! PhotoTableViewCell
        collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.row)
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
        if let nsStr = collectionViewArray[indexPath.item] as? NSString {
            var imgURL = NSURL(string: nsStr as String)
            if let img: AnyObject = imageHolder[nsStr as! String] {
                cell.imageView.image = img as? UIImage
            } else {
                let request: NSURLRequest = NSURLRequest(URL: imgURL!)
                let mainQueue = NSOperationQueue.mainQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if let error = error {
                        self.alertWithError(error)
                    } else {
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: data)
                        // Store the image in to our cache
                        self.imageHolder[nsStr as! String] = image
                        // Update the cell
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) as? PhotoCollectionViewCell {
                                cellToUpdate.imageView?.image = image
                            }
                        })
                    }
                })
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let imageChoice = imageHolder[self.sourceArray[collectionView.tag][indexPath.item] as! String] as! UIImage
        selectedCellIndexPath = indexPath
        println(selectionPresent)
        if selectionPresent == false {
            let alert = UIAlertController(title: "Selection", message: "Please choose another picture in this category to swap images with \n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler: nil))
            let imageSelection: UIView = UIView(frame: CGRectMake(87, 90, 100, 100))
            imageSelection.backgroundColor = UIColor(patternImage: imageChoice)
            alert.view.addSubview(imageSelection)
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
                let alert = UIAlertController(title: "Error", message: "Please only select pictures within the same category", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                selectionPresent = false
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                var selectedStringOfImage = self.sourceArray[selectedTag][selectedItem] as! String
                var selectedImage = imageHolder[selectedStringOfImage] as! UIImage
                
                self.sourceArray[selectedTag].replaceObjectAtIndex(selectedItem, withObject: self.sourceArray[collectionView.tag][indexPath.item])
                self.sourceArray[collectionView.tag].replaceObjectAtIndex(indexPath.item, withObject: selectedStringOfImage)
                
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

