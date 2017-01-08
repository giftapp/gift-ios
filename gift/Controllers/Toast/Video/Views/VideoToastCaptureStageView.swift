//
// Created by Matan Lachmish on 03/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol VideoToastCaptureStageViewDelegate {
    func didTapExit()
    func didTapAskForHint()
    func didTapSwitchCameraSource()
}

class VideoToastCaptureStageView: UIView {

    //Views
    private var headerViewBackground: UIView!
    private var headerViewFill: UIView!
    private var exitButton: UIButton!
    private var durationCounterLabel: UILabel!

    private var startCounterLabel: UILabel!
    private var descriptionLabel: UILabel!

    private var askForHintButton: UIButton!
    private var switchCameraSourceButton: UIButton!

    //Public Properties
    var delegate: VideoToastCaptureStageViewDelegate!

    var durationCounter: String? {
        get {
            return durationCounterLabel.text
        }
        set {
            durationCounterLabel.text = newValue
        }
    }

    var startCounter: String? {
        get {
            return startCounterLabel.text
        }
        set {
            startCounterLabel.text = newValue
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
        self.backgroundColor = UIColor.clear

        if headerViewBackground == nil {
            headerViewBackground = UIView()
            headerViewBackground.backgroundColor = UIColor.gftTintViewColor()
            self.addSubview(headerViewBackground)
        }

        if headerViewFill == nil {
            headerViewFill = UIView()
            headerViewFill.backgroundColor = UIColor.gftAzureColor()
            self.addSubview(headerViewFill)
        }

        if exitButton == nil {
            exitButton = UIButton()
            exitButton.setImage(UIImage(named: "x"), for: .normal)
            exitButton.addTarget(self, action: #selector(didTapExit(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(exitButton)
        }

        if durationCounterLabel == nil {
            durationCounterLabel = UILabel()
            durationCounterLabel.textAlignment = NSTextAlignment.center
            durationCounterLabel.font = UIFont(name: "Rubik-Regular", size: 20.0)
            durationCounterLabel.textColor = UIColor.gftWhiteColor()
            self.addSubview(durationCounterLabel)
        }

        if startCounterLabel == nil {
            startCounterLabel = UILabel()
            startCounterLabel.textAlignment = NSTextAlignment.center
            startCounterLabel.font = UIFont(name: "Rubik-Light", size: 200.0)
            startCounterLabel.textColor = UIColor.gftTurquoiseBlueColor()
            self.addSubview(startCounterLabel)
        }

        if descriptionLabel == nil {
            descriptionLabel = UILabel()
            descriptionLabel.text = "VideoToastCaptureStageViewDelegate.Description".localized
            descriptionLabel.textAlignment = NSTextAlignment.center
            descriptionLabel.numberOfLines = 2
            descriptionLabel.font = UIFont.gftHeader2Font()
            descriptionLabel.textColor = UIColor.gftWhiteColor()
            self.addSubview(descriptionLabel)
        }

        if askForHintButton == nil {
            askForHintButton = UIButton()
            askForHintButton.setImage(UIImage(named: "giftBoxVideoHintUnselected"), for: .normal)
            askForHintButton.addTarget(self, action: #selector(didTapAskForHint(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(askForHintButton)
        }

        if switchCameraSourceButton == nil {
            switchCameraSourceButton = UIButton()
            switchCameraSourceButton.setImage(UIImage(named: "switchCameraInput"), for: .normal)
            switchCameraSourceButton.addTarget(self, action: #selector(didTapSwitchCameraSource(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(switchCameraSourceButton)
        }
    }

    private func setConstraints() {
        headerViewBackground.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(42)
        }

        headerViewFill.snp.makeConstraints { (make) in
            make.top.equalTo(headerViewBackground)
            make.left.equalTo(headerViewBackground)
            make.right.equalTo(headerViewBackground)
            make.height.equalTo(headerViewBackground)
        }

        exitButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerViewBackground)
            make.right.equalToSuperview().offset(-15)
        }

        durationCounterLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerViewBackground)
            make.left.equalToSuperview().offset(15)
        }

        startCounterLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(startCounterLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        askForHintButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
        }

        switchCameraSourceButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.right.equalToSuperview().offset(-15)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------

    //Reset startCounterLabel, descriptionLabel and headerViewFill views to start capture state
    func resetUIComponents(duration: Double) {
        startCounterLabel.alpha = 1.0
        startCounterLabel.isHidden = false

        descriptionLabel.alpha = 1.0
        descriptionLabel.isHidden = false

        headerViewFill.snp.remakeConstraints { (make) in
            make.top.equalTo(headerViewBackground)
            make.left.equalTo(headerViewBackground)
            make.right.equalTo(headerViewBackground)
            make.height.equalTo(headerViewBackground)
        }
        self.layoutIfNeeded()
    }

    func hideStartCounterAndDescription() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.startCounterLabel.alpha = 0.0
            self.descriptionLabel.alpha = 0.0
        }, completion: { (completed) in
            self.startCounterLabel.isHidden = true
            self.descriptionLabel.isHidden = true
        })
    }

    func animateHeaderView(duration: Double) {
        headerViewFill.snp.remakeConstraints { (make) in
            make.top.equalTo(headerViewBackground)
            make.left.equalTo(headerViewBackground)
            make.right.equalTo(headerViewBackground.snp.left)
            make.height.equalTo(headerViewBackground)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            self.layoutIfNeeded()
        }, completion: nil)

    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapExit(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapExit()
    }

    @objc private func didTapAskForHint(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapAskForHint()
    }

    @objc private func didTapSwitchCameraSource(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapSwitchCameraSource()
    }

}
