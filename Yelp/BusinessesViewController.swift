//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,FiltersViewControllerDelegate {

    var businesses: [Business]!
    var searchButtonItem: UIBarButtonItem!
    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var tableNumber=20
    var filteredCata : [String]?
    var loadingMoreView : InfiniteScrollActivityView?
    var filteredBusiness: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        customizeNavigationBar()
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight=180
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        Business.searchWithTerm("Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            self.filteredBusiness=businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
        
        
*/
        
        
        let attributes =  [NSForegroundColorAttributeName: UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha: 1.0),
            NSFontAttributeName: UIFont(name: "Heiti SC", size: 20.0)!]
        self.navigationController?.navigationBar.titleTextAttributes=attributes
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func refreshControlAction() {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        Business.searchWithTerm("Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            self.filteredBusiness=businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        self.refreshControl.endRefreshing()
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView!.frame = frame
                loadingMoreView!.startAnimating()
                
                //load more data
                loadMoreData()
                // ... Code to load more results ...
            }
        }
    }
    
    func loadMoreData() {
        Business.searchWithTerm("Restaurants", offset: tableNumber, sort: nil, categories: filteredCata, deals: nil, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if error != nil {
                self.delay(2.0, closure: {
                    self.loadingMoreView?.stopAnimating()
                    //TODO: show network error
                })
            } else {
                self.delay(0.5, closure: { Void in
                    self.tableNumber += 20
                    self.filteredBusiness.appendContentsOf(businesses)
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                })
            }
        })
    }
    
    func delay(delay: Double, closure: () -> () ) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
    }
    
    func didTapSearchButton(sender: AnyObject?) {
        SearchBar.delegate=self
        print("1")
        navigationItem.titleView = SearchBar
        print("2")
        navigationItem.setRightBarButtonItem(nil , animated: true)
        print("3")
        self.SearchBar.hidden = false
        self.SearchBar.setShowsCancelButton(true, animated: false)
        //self.SearchBar.showsCancelButton=true
        self.SearchBar.becomeFirstResponder()


    }
    
    func searchBarCancelButtonClicked(SearchBar: UISearchBar) {
        SearchBar.hidden=true
        SearchBar.delegate=self
        navigationItem.titleView = nil
        //customizeNavigationBar()
        searchButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "didTapSearchButton:")
        searchButtonItem.tintColor=UIColor.whiteColor()
        navigationItem.rightBarButtonItem = searchButtonItem
        navigationItem.rightBarButtonItem?.tintColor=UIColor.whiteColor()
        self.SearchBar.resignFirstResponder()
        self.SearchBar.showsCancelButton=false
        
        (filteredBusiness, SearchBar.text) = (businesses, "")
        tableView.reloadData()
    }
    
    func customizeNavigationBar() {
        //self.navigationItem.title = "Yelp Test"
        
        //setup for search bar
        SearchBar.delegate=self
        SearchBar.hidden = true
        searchButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "didTapSearchButton:")
        navigationItem.rightBarButtonItem = searchButtonItem
        
        //preare button for the left navigationitem's bar item button and add negative spacer
//        let sorticon = UIImage(named: "sort")
//        let sortButton = UIButton(type: UIButtonType.Custom)
//        sortButton.addTarget(self,
//            action: "didTapFilterButton:", forControlEvents: .TouchUpInside)
//        sortButton.frame = CGRectMake(0, 0, 44, 44)
//        sortButton.setImage(sorticon , forState: UIControlState.Normal)
//        let yelpBarItemButton = UIBarButtonItem(customView: sortButton)
//        let negativeSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil , action: nil )
//        negativeSpacer.width = -15
//        navigationItem.leftBarButtonItems = [negativeSpacer, yelpBarItemButton]
//        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = UIColor.whiteColor()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusiness != nil{
            return filteredBusiness.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        print(indexPath.row)
        cell.business=filteredBusiness[indexPath.row]
        return cell
    }



    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="detailViewSegue"){
            let chosenIndex = self.tableView.indexPathForCell(sender as! BusinessCell)?.row
            
            if let  detailVC = segue.destinationViewController as? detailViewController {
                detailVC.business = filteredBusiness[chosenIndex!]
            }

        }
        
        if let navigationController = segue.destinationViewController as? UINavigationController{
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate=self
        }
        
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters["categories"] as? [String]
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) {
            (businesses: [Business]!, error: NSError!) -> Void in
            self.filteredBusiness = businesses
            
            self.tableView.reloadData()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //searchBar.setShowsCancelButton(true, animated: true)
        
        filteredBusiness = searchText.isEmpty ? businesses : businesses.filter({
            $0.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        tableView.reloadData()
    }
    


}


class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.hidden = true
    }
    
    func startAnimating() {
        self.hidden = false
        self.activityIndicatorView.startAnimating()
    }
}
