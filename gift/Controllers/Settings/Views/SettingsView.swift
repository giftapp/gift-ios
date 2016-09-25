//
// Created by Matan Lachmish on 24/09/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIView {

    //Views
    private var headerView: UIView!
    private var avatarView: UIView!
    private var nameLabel: UILabel!
    var tableView: UITableView!

    //Public Properties
    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    var tableViewDelegate: UITableViewDelegate! {
        didSet{
            tableView.delegate = tableViewDelegate
        }
    }
    
    var tableViewDataSource: UITableViewDataSource! {
        didSet{
            tableView.dataSource = tableViewDataSource
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    init(avatarView: UIView) {
        self.avatarView = avatarView
        super.init(frame: CGRect.zero)
        self.addCustomViews()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomViews() {
        self.backgroundColor = UIColor.gftBackgroundWhiteColor()

        if tableView == nil {
            tableView = UITableView(frame: CGRect.zero, style: .grouped)
            tableView.register(SettingsProfileDetailsCell.self, forCellReuseIdentifier: SettingsProfileDetailsCellConsts.reuseIdentifier)
            tableView.register(SettingsPushButtonCell.self, forCellReuseIdentifier: SettingsPushButtonCellConsts.reuseIdentifier)
            tableView.register(SettingsModalButtonCell.self, forCellReuseIdentifier: SettingsModalButtonCellConsts.reuseIdentifier)
            self.addSubview(self.tableView)
        }
        
        if nameLabel == nil {
            nameLabel = UILabel()
            nameLabel.numberOfLines = 1
            nameLabel.textAlignment = NSTextAlignment.center
            nameLabel.font = UIFont.gftHeader1Font()
            nameLabel.textColor = UIColor.gftWaterBlueColor()
            self.addSubview(nameLabel)
        }
        
        if headerView == nil {
            headerView = UIView()
            headerView.addSubview(avatarView)
            headerView.addSubview(nameLabel)
            tableView.tableHeaderView = headerView
        }

    }

    private func setConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView.superview!)
        }

        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.width.equalTo(tableView)
        }

        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.superview!).offset(20)
            make.centerX.equalTo(avatarView.superview!)
            make.size.equalTo(110)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(20)
            make.centerX.equalTo(nameLabel.superview!)
        }

        
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func updateTableViewHeaderSize() {
        tableView.sizeHeaderToFit()
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------

}
