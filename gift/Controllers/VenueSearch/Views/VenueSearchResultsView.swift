//
// Created by Matan Lachmish on 21/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class VenueSearchResultsView: UIView {

    //Views
    private var venuesTableView: UITableView!
    private var emptyTablePlaceholderView: EmptyTablePlaceholderView!
    private var activityIndicatorView: ActivityIndicatorView!

    //Public Properties
    var tableViewDataSource: UITableViewDataSource! {
        didSet {
            venuesTableView.dataSource = self.tableViewDataSource
        }
    }

    var tableViewDelegate: UITableViewDelegate! {
        didSet {
            venuesTableView.delegate = self.tableViewDelegate
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.gftBackgroundWhiteColor()

        if venuesTableView == nil {
            venuesTableView = UITableView()
            venuesTableView.backgroundColor = UIColor.gftBackgroundWhiteColor()
            venuesTableView.register(VenueCell.self, forCellReuseIdentifier: VenueCellConstants.reuseIdentifier)
            self.addSubview(venuesTableView)

            venuesTableView.tableFooterView = UIView(frame: CGRect.zero)
        }

        if emptyTablePlaceholderView == nil {
            emptyTablePlaceholderView = EmptyTablePlaceholderView()
            emptyTablePlaceholderView.image = UIImage(named: "heartBox")
            emptyTablePlaceholderView.text = "VenueSearchResultsView.Empty results placeholder".localized
            emptyTablePlaceholderView.isHidden = true
            self.addSubview(emptyTablePlaceholderView)
        }

        if activityIndicatorView == nil {
            activityIndicatorView = ActivityIndicatorView()
            self.addSubview(activityIndicatorView)
        }

    }

    private func setConstraints() {
        venuesTableView.snp.makeConstraints { (make) in
            make.center.equalTo(venuesTableView.superview!)
            make.size.equalTo(venuesTableView.superview!)
        }

        emptyTablePlaceholderView.snp.makeConstraints { (make) in
            make.center.equalTo(venuesTableView.snp.center)
        }

        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
            make.size.equalTo(ActivityIndicatorSize.medium)
        }

    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func update() {
        venuesTableView.reloadData()
    }

    func shouldPresentEmptyPlaceholder(shouldPresent: Bool)  {
        emptyTablePlaceholderView.isHidden = !shouldPresent
    }

    func activityAnimation(shouldAnimate: Bool) {
        if shouldAnimate {
            self.isUserInteractionEnabled = false
            activityIndicatorView.startAnimation()
        } else {
            self.isUserInteractionEnabled = true
            activityIndicatorView.stopAnimation()
        }
    }

}
