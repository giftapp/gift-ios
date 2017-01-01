//
// Created by Matan Lachmish on 10/12/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol EventSearchViewDelegate{
    func didTapEventIsNotInTheList()
}

class EventSearchView: UIView {

    //Views
    private var eventsTableView: UITableView!
    private var emptyTablePlaceholderView: EmptyTablePlaceholderView!
    private var eventIsNotInTheListButton: BigButton!

    //Injected
    private var searchView: UIView

    //Public Properties
    var delegate: EventSearchViewDelegate!

    var tableViewDataSource: UITableViewDataSource! {
        didSet {
            eventsTableView.dataSource = self.tableViewDataSource
        }
    }

    var tableViewDelegate: UITableViewDelegate! {
        didSet {
            eventsTableView.delegate = self.tableViewDelegate
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    init(searchView: UIView) {
        self.searchView = searchView
        super.init(frame: CGRect.zero)
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.gftBackgroundWhiteColor()

        if eventsTableView == nil {
            eventsTableView = UITableView()
            eventsTableView.backgroundColor = UIColor.gftBackgroundWhiteColor()
            eventsTableView.register(EventCell.self, forCellReuseIdentifier: EventCellConstants.reuseIdentifier)
            self.addSubview(eventsTableView)

            eventsTableView.tableHeaderView = searchView
            eventsTableView.tableFooterView = UIView(frame: CGRect.zero)
        }

        if emptyTablePlaceholderView == nil {
            emptyTablePlaceholderView = EmptyTablePlaceholderView()
            emptyTablePlaceholderView.image = UIImage(named: "heartBox")
            emptyTablePlaceholderView.text = "EventSearchView.Empty results placeholder".localized
            emptyTablePlaceholderView.isHidden = true
            self.addSubview(emptyTablePlaceholderView)
        }

        if eventIsNotInTheListButton == nil {
            eventIsNotInTheListButton = BigButton()
            eventIsNotInTheListButton.setTitle("EventSearchView.Event is not in the list button".localized, for: UIControlState())
            eventIsNotInTheListButton.addTarget(self, action: #selector(didTapEventIsNotInTheList(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(eventIsNotInTheListButton)
        }

    }

    private func setConstraints() {
        eventsTableView.snp.makeConstraints { (make) in
            make.centerX.equalTo(eventsTableView.superview!)
            make.width.equalTo(eventsTableView.superview!)
            make.top.equalTo(eventsTableView.superview!)
            make.bottom.equalTo(eventIsNotInTheListButton.snp.top)
        }

        emptyTablePlaceholderView.snp.makeConstraints { (make) in
            make.center.equalTo(eventsTableView.snp.center)
        }

        eventIsNotInTheListButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(eventIsNotInTheListButton.superview!)
            make.height.equalTo(UIComponentConstants.bigButtonHeight)
            make.bottom.equalTo(eventIsNotInTheListButton.superview!)
            make.width.equalTo(eventIsNotInTheListButton.superview!)
        }

    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func update() {
        eventsTableView.reloadData()
    }
    
    func shouldPresentEmptyPlaceholder(shouldPresent: Bool)  {
        emptyTablePlaceholderView.isHidden = !shouldPresent
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    func didTapEventIsNotInTheList(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapEventIsNotInTheList()
    }

}
