//
//  DetailViewController.swift
//  Flick Finder
//
//  Created by Eric Zim on 1/29/16.
//  Copyright © 2016 Eric Zim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var posterImageView: UIImageView!
	
	@IBOutlet weak var infoView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var overviewLabel: UILabel!
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	var movie: NSDictionary!
	
    override func viewDidLoad() {
        super.viewDidLoad()
			
			scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: (infoView.frame.origin.y + infoView.frame.height))
			let title = movie["title"] as! String
			let overview = movie["overview"] as! String
			
			titleLabel.text = title
			overviewLabel.text = overview
			overviewLabel.sizeToFit()
			
			let baseURL = "http://image.tmdb.org/t/p/w500"
			if let posterPath = movie["poster_path"] as? String
			{
				let imageURL = NSURL(string: baseURL + posterPath)
//				imageFadeIn(this, url: imageURL!)
					posterImageView.setImageWithURL(imageURL!)
			}
			
			print(movie)
			
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
