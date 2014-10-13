//
//  ViewController.swift
//  PhotoSearch Refactoring
//
//  Created by Ron Mauldin on 10/12/14.
//  Copyright (c) 2014 maulr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    let searchBarDelegate = self
    let instagramClientID = "5a1f00b638364d5b82afb9d14bb200ef"


    func searchInstagramByHashtag(searchString: String) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }

        let instagramURLString = "https://api.instagram.com/v1/tags/" + searchString + "/media/recent?client_id=" + instagramClientID

        let manager = AFHTTPRequestOperationManager()

        manager.GET( instagramURLString,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)

                if let dataArray = responseObject.valueForKey("data") as? [AnyObject] {
                    self.scrollView.contentSize = CGSizeMake(320, CGFloat(320*dataArray.count))
                    for var i = 0; i < dataArray.count; i++ {
                        let dataObject: AnyObject = dataArray[i]
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            println("image " + String(i) + " URL is " + imageURLString)

///                            let imageData =  NSData(contentsOfURL: NSURL(string: imageURLString)!)
///                            let imageView = UIImageView(image: UIImage(data: imageData!))
                            let imageView = UIImageView(frame: CGRectMake(0, CGFloat(320*i), 320, 320))
                            self.scrollView.addSubview(imageView)
                            imageView.setImageWithURL(NSURL(string: imageURLString))
                        }
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {

        searchBar.resignFirstResponder()
        searchInstagramByHashtag(searchBar.text)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        searchInstagramByHashtag("clararockmore")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
