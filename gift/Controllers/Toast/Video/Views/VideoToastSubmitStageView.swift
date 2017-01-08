//
// Created by Matan Lachmish on 04/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation

protocol VideoToastSubmitStageViewDelegate {
    func didTapShareViaFacebook()
    func didTapShareViaInstagram()
    func didTapDidntLikeSwitchToTextualToastAnyway()
    func didTapContinue()
}

class VideoToastSubmitStageView: UIView {

    //Views
    private var toastPreviewView: UIView!

    private var tintLayer: UIView!

    private var presenterNameLabel: UILabel!
    private var presenterNameTextField : UITextField!

    private var shareTitleLabel: UILabel!
    private var shareDescriptionLabel: UILabel!

    private var shareViaFacebookButton: UIButton!
    private var shareViaFacebookLabel: UILabel!
    private var shareViaInstagramButton: UIButton!
    private var shareViaInstagramLabel: UILabel!

    private var didntLikeSwitchToTextualToastAnywayButton: UIButton!
    private var continueButton: BigButton!

    //Public Properties
    var delegate: VideoToastSubmitStageViewDelegate!

    var presenterName: String? {
        get {
            return presenterNameTextField.text
        }
        set {
            presenterNameTextField.text = newValue
        }
    }

    var videoPreviewLayer: AVPlayerLayer! {
        didSet {
            toastPreviewView.layer.addSublayer(videoPreviewLayer)
            videoPreviewLayer?.frame = toastPreviewView.bounds
        }
    }

    var textFieldDelegate: UITextFieldDelegate! {
        didSet {
            presenterNameTextField.delegate = self.textFieldDelegate
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

        if toastPreviewView == nil {
            toastPreviewView = UIView()
            self.addSubview(toastPreviewView)
        }

        if tintLayer == nil {
            tintLayer = UIView()
            tintLayer.backgroundColor = UIColor.gftTintViewColor()
            self.addSubview(tintLayer)
        }

        if presenterNameLabel == nil {
            presenterNameLabel = UILabel()
            presenterNameLabel.text = "VideoToastSubmitStageView.Presenter name".localized
            presenterNameLabel.textAlignment = NSTextAlignment.center
            presenterNameLabel.font = UIFont.gftHeader2Font()
            presenterNameLabel.textColor = UIColor.gftWaterBlueColor()
            self.addSubview(presenterNameLabel)
        }

        if presenterNameTextField == nil {
            presenterNameTextField = UITextField()
            presenterNameTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            presenterNameTextField.addTopBottomBorders()
            presenterNameTextField.textAlignment = NSTextAlignment.center
            presenterNameTextField.font = UIFont(name: "Rubik-Light", size: 25.0)
            presenterNameTextField.textColor = UIColor.gftWhiteColor()
            self.addSubview(presenterNameTextField)
        }

        if shareTitleLabel == nil {
            shareTitleLabel = UILabel()
            shareTitleLabel.text = "VideoToastSubmitStageView.Share.Title".localized
            shareTitleLabel.textAlignment = NSTextAlignment.center
            shareTitleLabel.font = UIFont.gftHeader2Font()
            shareTitleLabel.textColor = UIColor.gftWaterBlueColor()
            self.addSubview(shareTitleLabel)
        }

        if shareDescriptionLabel == nil {
            shareDescriptionLabel = UILabel()
            shareDescriptionLabel.text = "VideoToastSubmitStageView.Share.Description".localized
            shareDescriptionLabel.textAlignment = NSTextAlignment.center
            shareDescriptionLabel.font = UIFont.gftText1Font()
            shareDescriptionLabel.textColor = UIColor.gftWhiteColor()
            self.addSubview(shareDescriptionLabel)
        }

        if shareViaFacebookButton == nil {
            shareViaFacebookButton = UIButton()
            shareViaFacebookButton.setImage(UIImage(named: "shareViaFacebook"), for: .normal)
            shareViaFacebookButton.addTarget(self, action: #selector(didTapShareViaFacebook(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(shareViaFacebookButton)
        }

        if shareViaFacebookLabel == nil {
            shareViaFacebookLabel = UILabel()
            shareViaFacebookLabel.text = "VideoToastSubmitStageView.Share.Facebook".localized
            shareViaFacebookLabel.textAlignment = NSTextAlignment.center
            shareViaFacebookLabel.font = UIFont.gftText1Font()
            shareViaFacebookLabel.textColor = UIColor.gftWhiteColor()
            self.addSubview(shareViaFacebookLabel)
        }

        if shareViaInstagramButton == nil {
            shareViaInstagramButton = UIButton()
            shareViaInstagramButton.setImage(UIImage(named: "shareViaInstagram"), for: .normal)
            shareViaInstagramButton.addTarget(self, action: #selector(didTapShareViaInstagram(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(shareViaInstagramButton)
        }

        if shareViaInstagramLabel == nil {
            shareViaInstagramLabel = UILabel()
            shareViaInstagramLabel.text = "VideoToastSubmitStageView.Share.Instagram".localized
            shareViaInstagramLabel.textAlignment = NSTextAlignment.center
            shareViaInstagramLabel.font = UIFont.gftText1Font()
            shareViaInstagramLabel.textColor = UIColor.gftWhiteColor()
            self.addSubview(shareViaInstagramLabel)
        }

        if didntLikeSwitchToTextualToastAnywayButton == nil {
            didntLikeSwitchToTextualToastAnywayButton = UIButton()
            didntLikeSwitchToTextualToastAnywayButton.setTitle("VideoToastSubmitStageView.Switch ToTextual Toast Anyway".localized, for: .normal)
            didntLikeSwitchToTextualToastAnywayButton.titleLabel!.font = UIFont(name: "Rubik-Light", size: 15.0)
            didntLikeSwitchToTextualToastAnywayButton.setTitleColor(UIColor.gftAzureColor(), for: .normal)
            didntLikeSwitchToTextualToastAnywayButton.backgroundColor = UIColor.gftWhiteColor()
            didntLikeSwitchToTextualToastAnywayButton.addTarget(self, action: #selector(didTapDidntLikeSwitchToTextualToastAnyway(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(didntLikeSwitchToTextualToastAnywayButton)
        }

        if continueButton == nil {
            continueButton = BigButton()
            continueButton.style = .rightAlignedWithChevron
            continueButton.setTitle("VideoToastSubmitStageView.Save and continue".localized, for: UIControlState())
            continueButton.addTarget(self, action: #selector(didTapContinue(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(continueButton)
        }

    }

    private func setConstraints() {
        toastPreviewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        tintLayer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        presenterNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(55)
            make.centerX.equalToSuperview()
        }

        presenterNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(presenterNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(UIComponentConstants.textFieldHeight)
        }

        shareTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(presenterNameTextField.snp.bottom).offset(75)
            make.centerX.equalToSuperview()
        }

        shareDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(shareTitleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        shareViaFacebookButton.snp.makeConstraints { (make) in
            make.top.equalTo(shareDescriptionLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(83)
        }

        shareViaFacebookLabel.snp.makeConstraints { (make) in
            make.top.equalTo(shareViaFacebookButton.snp.bottom).offset(10)
            make.centerX.equalTo(shareViaFacebookButton)
        }

        shareViaInstagramButton.snp.makeConstraints { (make) in
            make.top.equalTo(shareDescriptionLabel.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-83)
        }

        shareViaInstagramLabel.snp.makeConstraints { (make) in
            make.top.equalTo(shareViaInstagramButton.snp.bottom).offset(10)
            make.centerX.equalTo(shareViaInstagramButton)
        }

        didntLikeSwitchToTextualToastAnywayButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(continueButton.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }

        continueButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(UIComponentConstants.bigButtonHeight)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didTapShareViaFacebook(sender: UIButton!) {
        guard let delegate = self.delegate
            else {
                Logger.error("Delegate not set")
                return
        }
        
        delegate.didTapShareViaFacebook()
    }
    
    @objc private func didTapShareViaInstagram(sender: UIButton!) {
        guard let delegate = self.delegate
            else {
                Logger.error("Delegate not set")
                return
        }
        
        delegate.didTapShareViaInstagram()
    }

    
    @objc private func didTapDidntLikeSwitchToTextualToastAnyway(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapDidntLikeSwitchToTextualToastAnyway()
    }

    @objc private func didTapContinue(sender: UIButton!) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didTapContinue()
    }

}
