//
// Created by Matan Lachmish on 21/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class VenueSearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Injections
    private var appRoute: AppRoute
    private var createCoupleViewController: CreateCoupleViewController

    //Views
    private var venueSearchResultsView: VenueSearchResultsView!

    //Public Properties
    public var searchResultVenues: Array<Venue> = [] {
        didSet {
            venueSearchResultsView.update()
        }
    }

    public var currentLocation: (lat: Double, lng: Double)! {
        didSet {
            venueSearchResultsView.update()
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute,
                          createCoupleViewController: CreateCoupleViewController) {
        self.appRoute = appRoute
        self.createCoupleViewController = createCoupleViewController
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
        if venueSearchResultsView == nil {
            venueSearchResultsView = VenueSearchResultsView()
            venueSearchResultsView.tableViewDataSource = self
            venueSearchResultsView.tableViewDelegate = self
            self.view = venueSearchResultsView
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func clearSearchResults() {
        searchResultVenues.removeAll()
        shouldPresentEmptyPlaceholder(shouldPresent: false)
    }

    func activityAnimation(shouldAnimate: Bool) {
        venueSearchResultsView.activityAnimation(shouldAnimate: shouldAnimate)
    }

    func shouldPresentEmptyPlaceholder(shouldPresent: Bool)  {
        venueSearchResultsView.shouldPresentEmptyPlaceholder(shouldPresent: shouldPresent)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    //-------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultVenues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VenueCell = tableView.dequeueReusableCell(withIdentifier: VenueCellConstants.reuseIdentifier, for: indexPath) as! VenueCell

        let venue = searchResultVenues[indexPath.item]

        cell.venueName = venue.name
        cell.venueAddress = venue.address
        cell.venueImageUrl = venue.imageUrl
        cell.distanceAmount = LocationUtils.distanceBetween(lat1: currentLocation.lat, lng1: currentLocation.lng, lat2: (venue.latitude)!, lng2: (venue.longitude)!)
        cell.distanceUnit = DistanceUnit.kiloMeter

        return cell
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    //-------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VenueCellConstants.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Logger.debug("User tapped on venue")
        let venue = searchResultVenues[indexPath.item];
        createCoupleViewController.selectedVenue = venue
        appRoute.pushViewController(controller: createCoupleViewController, animated: true)
    }

}
