//
// Created by Matan Lachmish on 04/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation

protocol VideoToastSubmitStageViewDelegate {
    func didLongPressedTintBackground(began: Bool)
    func didUpdatePresenterName()
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

    private var activityIndicatorView: ActivityIndicatorView!

    //Public Properties
    var delegate: VideoToastSubmitStageViewDelegate!

    var presenterName: String? {
        get {
            return presenterNameTextField.text
        }
        set {
            presenterNameTextField.text = newValue
            didUpdatePresenterName(sender: presenterNameTextField)
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

            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressedTintBackground(sender:)))
            longPressRecognizer.minimumPressDuration = 0.5
            tintLayer.addGestureRecognizer(longPressRecognizer)

            self.addSubview(tintLayer)
        }

        if presenterNameLabel == nil {
            presenterNameLabel = UILabel()
            presenterNameLabel.text = "VideoToastSubmitStageView.Presenter name".localized
            presenterNameLabel.textAlignment = NSTextAlignment.center
            presenterNameLabel.font = UIFont.gftHeader2Font()
            presenterNameLabel.textColor = UIColor.gftWaterBlueColor()
            tintLayer.addSubview(presenterNameLabel)
        }

        if presenterNameTextField == nil {
            presenterNameTextField = UITextField()
            presenterNameTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            presenterNameTextField.addTopBottomBorders()
            presenterNameTextField.textAlignment = NSTextAlignment.center
            presenterNameTextField.font = UIFont(name: "Rubik-Light", size: 25.0)
            presenterNameTextField.textColor = UIColor.gftWhiteColor()
            presenterNameTextField.addTarget(self, action: #selector(didUpdatePresenterName(sender:)), for: .editingChanged)
            tintLayer.addSubview(presenterNameTextField)
        }

        if shareTitleLabel == nil {
            shareTitleLabel = UILabel()
            shareTitleLabel.text = "VideoToastSubmitStageView.Share.Title".localized
            shareTitleLabel.textAlignment = NSTextAlignment.center
            shareTitleLabel.font = UIFont.gftHeader2Font()
            shareTitleLabel.textColor = UIColor.gftWaterBlueColor()
            tintLayer.addSubview(shareTitleLabel)
        }

        if shareDescriptionLabel == nil {
            shareDescriptionLabel = UILabel()
            shareDescriptionLabel.text = "VideoToastSubmitStageView.Share.Description".localized
            shareDescriptionLabel.textAlignment = NSTextAlignment.center
            shareDescriptionLabel.font = UIFont.gftText1Font()
            shareDescriptionLabel.textColor = UIColor.gftWhiteColor()
            tintLayer.addSubview(shareDescriptionLabel)
        }

        if shareViaFacebookButton == nil {
            shareViaFacebookButton = UIButton()
            shareViaFacebookButton.setImage(UIImage(named: "shareViaFacebook"), for: .normal)
            shareViaFacebookButton.addTarget(self, action: #selector(didTapShareViaFacebook(sender:)), for: UIControlEvents.touchUpInside)
            tintLayer.addSubview(shareViaFacebookButton)
        }

        if shareViaFacebookLabel == nil {
            shareViaFacebookLabel = UILabel()
            shareViaFacebookLabel.text = "VideoToastSubmitStageView.Share.Facebook".localized
            shareViaFacebookLabel.textAlignment = NSTextAlignment.center
            shareViaFacebookLabel.font = UIFont.gftText1Font()
            shareViaFacebookLabel.textColor = UIColor.gftWhiteColor()
            tintLayer.addSubview(shareViaFacebookLabel)
        }

        if shareViaInstagramButton == nil {
            shareViaInstagramButton = UIButton()
            shareViaInstagramButton.setImage(UIImage(named: "shareViaInstagram"), for: .normal)
            shareViaInstagramButton.addTarget(self, action: #selector(didTapShareViaInstagram(sender:)), for: UIControlEvents.touchUpInside)
            tintLayer.addSubview(shareViaInstagramButton)
        }

        if shareViaInstagramLabel == nil {
            shareViaInstagramLabel = UILabel()
            shareViaInstagramLabel.text = "VideoToastSubmitStageView.Share.Instagram".localized
            shareViaInstagramLabel.textAlignment = NSTextAlignment.center
            shareViaInstagramLabel.font = UIFont.gftText1Font()
            shareViaInstagramLabel.textColor = UIColor.gftWhiteColor()
            tintLayer.addSubview(shareViaInstagramLabel)
        }

        if didntLikeSwitchToTextualToastAnywayButton == nil {
            didntLikeSwitchToTextualToastAnywayButton = UIButton()
            didntLikeSwitchToTextualToastAnywayButton.setTitle("VideoToastSubmitStageView.Switch ToTextual Toast Anyway".localized, for: .normal)
            didntLikeSwitchToTextualToastAnywayButton.titleLabel!.font = UIFont(name: "Rubik-Light", size: 15.0)
            didntLikeSwitchToTextualToastAnywayButton.setTitleColor(UIColor.gftAzureColor(), for: .normal)
            didntLikeSwitchToTextualToastAnywayButton.backgroundColor = UIColor.gftWhiteColor()
            didntLikeSwitchToTextualToastAnywayButton.addTarget(self, action: #selector(didTapDidntLikeSwitchToTextualToastAnyway(sender:)), for: UIControlEvents.touchUpInside)
            tintLayer.addSubview(didntLikeSwitchToTextualToastAnywayButton)
        }

        if continueButton == nil {
            continueButton = BigButton()
            continueButton.style = .rightAlignedWithChevron
            continueButton.setTitle("VideoToastSubmitStageView.Save and continue".localized, for: UIControlState())
            continueButton.addTarget(self, action: #selector(didTapContinue(sender:)), for: UIControlEvents.touchUpInside)
            tintLayer.addSubview(continueButton)
        }

        if activityIndicatorView == nil {
            activityIndicatorView = ActivityIndicatorView()
            self.addSubview(activityIndicatorView)
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

        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(activityIndicatorView.superview!)
            make.size.equalTo(ActivityIndicatorSize.medium)
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func shouldHideEverythingButVideo(shouldHide: Bool) {
        if shouldHide {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.tintLayer.alpha = 0.0
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.tintLayer.alpha = 1.0
            }, completion: nil)
        }

    }

    func enableContinueButton(enabled: Bool) {
        continueButton.enable(enabled: enabled)
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

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    @objc private func didLongPressedTintBackground(sender: UILongPressGestureRecognizer) {
        guard let delegate = self.delegate
                else {
            Logger.error("Delegate not set")
            return
        }

        delegate.didLongPressedTintBackground(began: sender.state == .began)
    }

    @objc private func didUpdatePresenterName(sender: UITextField!) {
        guard let delegate = self.delegate
            else {
                Logger.error("Delegate not set")
                return
        }
        
        delegate.didUpdatePresenterName()
    }

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
