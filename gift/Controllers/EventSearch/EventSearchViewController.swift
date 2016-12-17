//
// Created by Matan Lachmish on 10/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class EventSearchViewController : UIViewController, EventSearchViewDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {

    //Injections
    private var appRoute: AppRoute
    private var eventService: EventService
    private var locationManager: LocationManager

    //Views
    private var eventSearchView: EventSearchView!

    //Controllers
    private var searchController: UISearchController!

    //Private Properties
    private var events: Array<Event> = []
    private var currentLocation: (lat: Double, lng: Double)!;

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute,
                          eventService: EventService,
                          locationManager: LocationManager) {
        self.appRoute = appRoute
        self.eventService = eventService
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    //-------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addCustomViews()
    }

    private func addCustomViews() {
        if searchController == nil {
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
        }

        if eventSearchView == nil {
            eventSearchView = EventSearchView(searchView: searchController.searchBar)
            eventSearchView.delegate = self
            eventSearchView.tableViewDataSource = self
            eventSearchView.tableViewDelegate = self
            self.view = eventSearchView
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()
        updateCustomViews()
    }

    //TODO: consider extension
    private func setupNavigationBar() {
        self.title = "EventSearchViewController.Title".localized

        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.barTintColor = UIColor.gftWaterBlueColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.gftNavigationTitleFont()!, NSForegroundColorAttributeName: UIColor.gftWhiteColor()]

        let cancelBarButtonItem = UIBarButtonItem(title: "NavigationViewController.Cancel".localized, style: .plain, target: self, action: #selector(didTapCancel))
        cancelBarButtonItem.tintColor = UIColor.gftWhiteColor()
        cancelBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont.gftNavigationItemFont()!, NSForegroundColorAttributeName: UIColor.gftWhiteColor()], for: .normal)
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
    }

    private func updateCustomViews() {
        locationManager.getCurrentLocation(
                success: { (location) in
                    self.currentLocation = (location.coordinate.latitude, location.coordinate.longitude)

                    self.eventService.findEventsByLocation(
                            lat: location.coordinate.latitude,
                            lng: location.coordinate.longitude,
                            success: { (events) in
                                Logger.debug("Successfully got all events \(events)")
                                self.events = events
                                self.eventSearchView.update()
                            },
                            failure: { (error) in
                                Logger.error("Failed to get event list \(error)")
                            })
            
                }, failure: { (error) in
            Logger.error("Failed to get location \(error)")
        })
        
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func didTapCancel() {
        self.appRoute.dismiss(controller: self, animated: true)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - EventSearchViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapEventIsNotInTheList() {
        Logger.debug("User tapped event is not in the list")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UISearchResultsUpdating
    //-------------------------------------------------------------------------------------------
    func updateSearchResults(`for` searchController: UISearchController) {
        Logger.debug("Updatind search results")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    //-------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventCell = tableView.dequeueReusableCell(withIdentifier: EventCellConstants.reuseIdentifier, for: indexPath) as! EventCell

        let event = events[indexPath.item];
        cell.eventName = event.title
        cell.venueName = event.venue?.name
        cell.distanceAmount = LocationUtils.distanceBetween(lat1: currentLocation.lat, lng1: currentLocation.lng, lat2: (event.venue?.latitude)!, lng2: (event.venue?.longitude)!)
        cell.distanceUnit = EventCellDistanceUnit.kiloMeter

        return cell
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    //-------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EventCellConstants.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
