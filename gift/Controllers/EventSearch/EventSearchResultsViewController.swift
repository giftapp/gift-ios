//
// Created by Matan Lachmish on 18/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class EventSearchResultsViewController: UIViewController, EventSearchResultsViewDelegate, UITableViewDataSource, UITableViewDelegate {

    //Injections
    private var appRoute: AppRoute
    private var venueSearchViewController: VenueSearchViewController

    //Views
    private var eventSearchResultsView: EventSearchResultsView!

    //Public Properties
    public var searchResultEvents: Array<Event> = [] {
        didSet {
            eventSearchResultsView.update()
        }
    }

    public var currentLocation: (lat: Double, lng: Double)! {
        didSet {
            eventSearchResultsView.update()
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute,
                          venueSearchViewController: VenueSearchViewController) {
        self.appRoute = appRoute
        self.venueSearchViewController = venueSearchViewController
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
        if eventSearchResultsView == nil {
            eventSearchResultsView = EventSearchResultsView()
            eventSearchResultsView.delegate = self
            eventSearchResultsView.tableViewDataSource = self
            eventSearchResultsView.tableViewDelegate = self
            self.view = eventSearchResultsView
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func clearSearchResults() {
        searchResultEvents.removeAll()
        shouldPresentEmptyPlaceholder(shouldPresent: false)
    }

    func activityAnimation(shouldAnimate: Bool) {
        eventSearchResultsView.activityAnimation(shouldAnimate: shouldAnimate)
    }

    func shouldPresentEmptyPlaceholder(shouldPresent: Bool)  {
        eventSearchResultsView.shouldPresentEmptyPlaceholder(shouldPresent: shouldPresent)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - EventSearchResultViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapEventIsNotInTheList() {
        Logger.debug("User tapped event is not in the list")
        appRoute.presentNavigationViewController(controller: venueSearchViewController, animated: true)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    //-------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventCell = tableView.dequeueReusableCell(withIdentifier: EventCellConstants.reuseIdentifier, for: indexPath) as! EventCell

        let event = searchResultEvents[indexPath.item]

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
        Logger.debug("User tapped on event")
    }

}
