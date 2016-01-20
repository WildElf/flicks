//
//  MoviesViewController.swift
//  Flick Finder
//
//  Created by Eric Zim on 1/5/16.
//  Copyright © 2016 Eric Zim. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!

	var movies: [NSDictionary]?

	var failedCount = 0
	
	var refreshControl : UIRefreshControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
		self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
		self.tableView.addSubview(refreshControl)

	}
	
	override func viewDidAppear(animated: Bool) {
		
		EZLoadingActivity.showWithDelay("Loading...", disableUI: true, seconds: 15)
		
//		EZLoadingActivity.show("Loading...", disableUI: false)
		
		apiDataLoad()

	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		if let movies = movies
		{
			print("indexes: \(movies.count)")
			return movies.count
		}
		else
		{
			print("movies is nil")
			return 0
		}
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
		
		let movie = self.movies![indexPath.row]
		let title = movie["title"] as! String
		let overview = movie["overview"] as! String
		let posterPath = movie["poster_path"] as! String
		
		let baseURL = "http://image.tmdb.org/t/p/w500"
		let imageURL = NSURL(string: baseURL + posterPath)
		
		cell.titleLabel.text = title
		cell.overviewLabel.text = overview
		cell.posterView.setImageWithURL(imageURL!)

		print("row \(indexPath.row)")
		
		return cell
	}
	
	func apiDataLoad()
	{
		// themoviedb.org API setup

		let apiKey = "f90b40fed338ec99e894fc21438657ba"
		let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate:nil,
			delegateQueue:NSOperationQueue.mainQueue()
		)


		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
			completionHandler: { (dataOrNil, response, error) in
				if let data = dataOrNil {
					if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
						data, options:[]) as? NSDictionary {
							NSLog("response: \(responseDictionary)")
							
							self.movies = responseDictionary["results"] as? [NSDictionary]
							EZLoadingActivity.hide()
							self.tableView.reloadData()
					}
				}
				else
				{
					self.failedCount++
					print("failed \(self.failedCount)")
				}
		});
		task.resume()

		if failedCount > 1000
		{
			EZLoadingActivity.hide(success: false, animated: false)
		}
	}
	
	func refresh()
	{
		EZLoadingActivity.showWithDelay("Loading...", disableUI: true, seconds: 15)

		apiDataLoad()
		refreshControl.endRefreshing()
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
