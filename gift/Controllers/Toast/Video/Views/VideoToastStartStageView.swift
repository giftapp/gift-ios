//
// Created by Matan Lachmish on 03/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol VideoToastStartStageViewDelegate {
    func didTapTakeVideoNow()
    func didTapSkipToTextualToast()
}

class VideoToastStartStageView: UIView {

    //Views
    private var tintLayer: UIView!

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!

    private var takeVideoNowButton: UIButton!
    private var skipToTextualToastButton: UIButton!

    //Public Properties
    var delegate: VideoToastStartStageViewDelegate!

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
        self.backgroundColor = UIColor.clear

        if tintLayer == nil {
            tintLayer = UIView()
            tintLayer.backgroundColor = UIColor.gftTintViewColor()
            self.addSubview(tintLayer)
        }

        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.text = "VideoToastStartStageViewDelegate.Title".localized
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.font = UIFont.gftHeader1Font()
            titleLabel.textColor = UIColor.gftWaterBlueColor()
            self.addSubview(titleLabel)
        }

        if descriptionLabel == nil {
            descriptionLabel = UILabel()
            descriptionLabel.text = "VideoToastStartStageViewDelegate.Description".localized
            descriptionLabel.textAlignment = NSTextAlignment.center
            descriptionLabel.font = UIFont.gftText1Font()
            descriptionLabel.textColor = UIColor.gftWhiteColor()
            self.addSubview(descriptionLabel)
        }

        if takeVideoNowButton == nil {
            takeVideoNowButton = UIButton()
            takeVideoNowButton.setTitle("VideoToastStartStageViewDelegate.Take video now".localized, for: .normal)
            takeVideoNowButton.titleLabel!.font = UIFont.gftModalButtonFont()
            takeVideoNowButton.setTitleColor(UIColor.gftWhiteColor(), for: .normal)
            takeVideoNowButton.backgroundColor = UIColor.gftAzureColor()
            takeVideoNowButton.layer.cornerRadius = 10
            takeVideoNowButton.addTarget(self, action: #selector(didTapTakeVideoNow(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(takeVideoNowButton)
        }

        if skipToTextualToastButton == nil {
            skipToTextualToastButton = UIButton()
            skipToTextualToastButton.setTitle("VideoToastStartStageViewDelegate.Skip to textual toast".localized, for: .normal)
            skipToTextualToastButton.titleLabel!.font = UIFont.gftModalButtonFont()
            skipToTextualToastButton.setTitleColor(UIColor.gftAzureColor(), for: .normal)
            skipToTextualToastButton.backgroundColor = UIColor.gftWhiteColor()
            skipToTextualToastButton.layer.cornerRadius = 10
            skipToTextualToastButton.addTarget(self, action: #selector(didTapSkipToTextualToast(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(skipToTextualToastButton)
        }
    }

    private func setConstraints() {
        tintLayer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        takeVideoNowButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(skipToTextualToastButton.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(UIComponentConstants.smallButtonHeight)
            make.width.equalTo(300)
        }

        skipToTextualToastButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(UIComponentConstants.smallButtonHeight)
            make.width.equalTo(300)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapTakeVideoNow(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapTakeVideoNow()
    }

    @objc private func didTapSkipToTextualToast(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapSkipToTextualToast()
    }

}
