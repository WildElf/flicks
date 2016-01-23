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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var searchBar: UISearchBar!
	
	var movies: [NSDictionary]?
	var filteredMovies: [NSDictionary]?
	
	var failedCount = 0
	
	var refreshControl : UIRefreshControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		searchBar.delegate = self
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
		self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
		self.tableView.addSubview(refreshControl)
		
	}
	
	override func viewWillAppear(animated: Bool) {
		
		EZLoadingActivity.showWithDelay("Loading...", disableUI: true, seconds: 20)
		
	}
	override func viewDidAppear(animated: Bool) {
		
		//		EZLoadingActivity.show("Loading...", disableUI: false)
		
		apiDataLoad()
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return filteredMovies?.count ?? 0
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
		
		let movie = self.filteredMovies![indexPath.row]
		let title = movie["title"] as! String
		let overview = movie["overview"] as! String
		let posterPath = movie["poster_path"] as! String
		
		let baseURL = "http://image.tmdb.org/t/p/w500"
		let imageURL = NSURL(string: baseURL + posterPath)
		
		cell.titleLabel?.text = title
		cell.overviewLabel?.text = overview
		imageFadeIn(cell, url: imageURL!)
		//		cell.posterView?.setImageWithURL(imageURL!)
		
		print("row \(indexPath.row)")
		
		return cell
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		filteredMovies = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
			return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
		})
		self.tableView.reloadData()
		
	}
	
	func apiDataLoad()
	{
		// themoviedb.org API setup
		let endPoint = "now_playing"
		
		let apiKey = "f90b40fed338ec99e894fc21438657ba"
		let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
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
							self.filteredMovies = self.movies
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
		
		if failedCount > 0
		{
			EZLoadingActivity.hide(success: false, animated: false)
		}
	}
	
	func refresh()
	{
		EZLoadingActivity.showWithDelay("Loading...", disableUI: true, seconds: 200)
		
		apiDataLoad()
		refreshControl.endRefreshing()
	}
	
	func imageFadeIn(cell: MovieCell, url: NSURL)
	{
		//		cell.posterView?.setImageWithURL(imageURL!)
		let posterRequest = NSURLRequest(URL: url)
		
		cell.posterView.setImageWithURLRequest(
			posterRequest,
			placeholderImage: nil,
			success: { (posterRequest, posterResponse, image) -> Void in
				
				// imageResponse will be nil if the image is cached
				if posterResponse != nil {
					print("Image was NOT cached, fade in image")
					cell.posterView.alpha = 0.0
					cell.posterView.image = image
					cell.posterView.contentMode = .ScaleAspectFit
					UIView.animateWithDuration(0.3, animations: { () -> Void in
						cell.posterView.alpha = 1.0
					})
				} else {
					print("Image was cached so just update the image")
					cell.posterView.image = image
				}
			},
			failure: { (posterRequest, posterResponse, error) -> Void in
				// do something for the failure condition
				print("image failed")
				
			cell.posterView.image = UIImage(named: "posterFail.png")
			cell.posterView.contentMode = .ScaleAspectFit

		})
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
