//
// Created by Matan Lachmish on 03/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation

enum VideoToastViewStage {
    case start
    case capture
    case submit
}

class VideoToastMasterView: UIView {

    //Views
    private var videoStreamView: UIView!

    var videoToastStartStageView: VideoToastStartStageView!
    var videoToastCaptureStageView: VideoToastCaptureStageView!
    var videoToastSubmitStageView: VideoToastSubmitStageView!

    //Public Properties
    var videoPreviewLayer: AVCaptureVideoPreviewLayer! {
        didSet {
            videoStreamView.layer.addSublayer(videoPreviewLayer)
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

        if videoStreamView == nil {
            videoStreamView = UIView()
            self.addSubview(videoStreamView)
        }

        if videoToastStartStageView == nil {
            videoToastStartStageView = VideoToastStartStageView()
            self.addSubview(videoToastStartStageView)
        }

        if videoToastCaptureStageView == nil {
            videoToastCaptureStageView = VideoToastCaptureStageView()
            videoToastCaptureStageView.isHidden = true
            self.addSubview(videoToastCaptureStageView)
        }

        if videoToastSubmitStageView == nil {
            videoToastSubmitStageView = VideoToastSubmitStageView()
            videoToastSubmitStageView.isHidden = true
            self.addSubview(videoToastSubmitStageView)
        }

    }

    private func setConstraints() {
        videoStreamView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        videoToastStartStageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        videoToastCaptureStageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        videoToastSubmitStageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Public
    //-------------------------------------------------------------------------------------------
    func updateVideoPreviewLayerBounds() {
        videoPreviewLayer!.frame = videoStreamView.bounds
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------

}
