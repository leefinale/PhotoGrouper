//
//  ImagePreviewModalViewController.swift
//  PhotoGrouper
//
//  Created by Elex Lee on 7/11/15.
//  Copyright (c) 2015 Elex Lee. All rights reserved.
//

//import UIKit
//
//protocol ImagePreviewModalViewControllerDelegate: class {
//    func imageSwapSelection(selectedImage: UIImage)
//    func imageDeleteSelection(selectedImage: UIImage)
//}
//
//class ImagePreviewModalViewController:  UIViewController {
//    
//    @IBOutlet var pictureImageView: UIImageView!
//    
//    var delegate = ImagePreviewModalViewControllerDelegate?.self
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        pictureImageView.contentMode = UIViewContentMode.ScaleAspectFit
//        pictureImageView.backgroundColor = UIColor.blackColor()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBAction func swapButtonPress(sender: AnyObject) {
//        dismissViewControllerAnimated(true, completion: {() -> Void in
//            self.delegate?
//        })
//    }
//    
//    @IBAction func deleteButtonPress(sender: AnyObject) {
//    }
//    
//    @IBAction func cancelButtonPress(sender: AnyObject) {
//    }
//}
