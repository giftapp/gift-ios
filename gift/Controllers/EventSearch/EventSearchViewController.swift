//
// Created by Matan Lachmish on 10/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class EventSearchViewController: UIViewController, EventSearchViewDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {

    //Injections
    private var appRoute: AppRoute
    private var eventService: EventService
    private var locationManager: LocationManager
    private var eventSearchResultsViewController: EventSearchResultsViewController
    private var venueSearchViewController: VenueSearchViewController
    private var videoToastViewController: VideoToastViewController

    //Views
    private var eventSearchView: EventSearchView!

    //Controllers
    private var searchController: UISearchController!

    //Private Properties
    private var nearbyEvents: Array<Event> = [] {
        didSet {
            eventSearchView.update()
        }
    }

    private var currentLocation: (lat: Double, lng: Double)! {
        didSet {
            eventSearchView.update()
        }
    }

    private var searchPaceTimer: Timer?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute,
                          eventService: EventService,
                          locationManager: LocationManager,
                          eventSearchResultsViewController: EventSearchResultsViewController,
                          venueSearchViewController: VenueSearchViewController,
                          videoToastViewController:VideoToastViewController) {
        self.appRoute = appRoute
        self.eventService = eventService
        self.locationManager = locationManager
        self.eventSearchResultsViewController = eventSearchResultsViewController
        self.venueSearchViewController = venueSearchViewController
        self.videoToastViewController = videoToastViewController
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
            searchController = UISearchController(searchResultsController: eventSearchResultsViewController)
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

    private func setupNavigationBar() {
        self.title = "EventSearchViewController.Title".localized

        self.setupNavigationBarStyle()

        let cancelBarButtonItem = UIBarButtonItem(title: "NavigationViewController.Cancel".localized, style: .plain, target: self, action: #selector(didTapCancel))
        cancelBarButtonItem.tintColor = UIColor.gftWhiteColor()
        cancelBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont.gftNavigationItemFont()!, NSForegroundColorAttributeName: UIColor.gftWhiteColor()], for: .normal)
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    private func updateCustomViews() {
        getNearbyEvents()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapCancel() {
        self.appRoute.dismiss(controller: self, animated: true)
    }

    private func getNearbyEvents() {
        locationManager.getCurrentLocation(
                success: { (location) in
                    self.currentLocation = (location.coordinate.latitude, location.coordinate.longitude)

                    self.eventService.findEventsByLocation(
                            lat: location.coordinate.latitude,
                            lng: location.coordinate.longitude,
                            success: { (events) in
                                Logger.debug("Successfully got \(events.count) nearby events")
                                let sortedEvents = self.sortEventsByDistance(events: events, fromLat: self.currentLocation.lat, fromLng: self.currentLocation.lng)
                                self.nearbyEvents = sortedEvents
                                self.eventSearchView.shouldPresentEmptyPlaceholder(shouldPresent: sortedEvents.count == 0)
                            },
                            failure: { (error) in
                                Logger.error("Failed to get nearby event list \(error)")
                                self.eventSearchView.shouldPresentEmptyPlaceholder(shouldPresent: true)
                            })

                }, failure: { (error) in
            Logger.error("Failed to get location \(error)")
            self.eventSearchView.shouldPresentEmptyPlaceholder(shouldPresent: true)
        })
    }

    @objc private func getSearchResultEvents() {
        Logger.debug("Updating search results")
        eventSearchResultsViewController.activityAnimation(shouldAnimate: true)

        let keyword = searchController.searchBar.text!
        eventService.findEventsByKeyword(keyword: keyword,
                success: { (events) in
                    Logger.debug("Successfully got \(events.count) searched events")
                    let sortedEvents = self.sortEventsByDistance(events: events, fromLat: self.currentLocation.lat, fromLng: self.currentLocation.lng)
                    self.eventSearchResultsViewController.activityAnimation(shouldAnimate: false)
                    self.eventSearchResultsViewController.searchResultEvents = sortedEvents
                    self.eventSearchResultsViewController.currentLocation = self.currentLocation
                    self.eventSearchResultsViewController.shouldPresentEmptyPlaceholder(shouldPresent: sortedEvents.count == 0)
                }, failure: { (error) in
            Logger.error("Failed to search events \(error)")
            self.eventSearchResultsViewController.activityAnimation(shouldAnimate: false)
            self.eventSearchResultsViewController.shouldPresentEmptyPlaceholder(shouldPresent: true)
        })
    }

    private func sortEventsByDistance(events: Array<Event>, fromLat: Double, fromLng: Double) -> Array<Event> {
        return events.sorted(by:) { (event1, event2) -> Bool in
            let distanceFrom1 = LocationUtils.distanceBetween(lat1: fromLat, lng1: fromLng, lat2: (event1.venue?.latitude)!, lng2: (event1.venue?.longitude)!)
            let distanceFrom2 = LocationUtils.distanceBetween(lat1: fromLat, lng1: fromLng, lat2: (event2.venue?.latitude)!, lng2: (event2.venue?.longitude)!)
            return distanceFrom1 < distanceFrom2
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - EventSearchViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapEventIsNotInTheList() {
        Logger.debug("User tapped event is not in the list")
        appRoute.presentNavigationViewController(controller: venueSearchViewController, animated: true)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UISearchResultsUpdating
    //-------------------------------------------------------------------------------------------
    func updateSearchResults(`for` searchController: UISearchController) {
        searchPaceTimer?.invalidate()
        
        if (searchController.searchBar.text?.isEmpty)! {
            eventSearchResultsViewController.clearSearchResults()
        } else {
            searchPaceTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.getSearchResultEvents), userInfo: nil, repeats: false)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    //-------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "EventSearchViewController.Nearby".localized
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventCell = tableView.dequeueReusableCell(withIdentifier: EventCellConstants.reuseIdentifier, for: indexPath) as! EventCell

        let event = nearbyEvents[indexPath.item];
        cell.eventName = event.title
        cell.venueName = event.venue?.name
        cell.distanceAmount = LocationUtils.distanceBetween(lat1: currentLocation.lat, lng1: currentLocation.lng, lat2: (event.venue?.latitude)!, lng2: (event.venue?.longitude)!)
        cell.distanceUnit = DistanceUnit.kiloMeter

        return cell
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    //-------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EventCellConstants.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Logger.debug("Did select event")
        //TODO: add push to search results
        let selectedEvent = nearbyEvents[indexPath.item];
        videoToastViewController.selectedEvent = selectedEvent
        appRoute.pushViewController(controller: videoToastViewController, animated: true)
    }

}
