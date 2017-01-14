//
// Created by Matan Lachmish on 03/01/2017.
// Copyright (c) 2017 GiftApp. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import Async

private struct VideoToastCaptureStageConstants {
    static let startCounterSetup = 3
    static let durationCounterSetup = 15
    static let videoFileName = "videoFile.mov"
}

class VideoToastViewController: UIViewController, AVCaptureFileOutputRecordingDelegate, UITextFieldDelegate, VideoToastStartStageViewDelegate, VideoToastCaptureStageViewDelegate, VideoToastSubmitStageViewDelegate {

    // Injections
    private var appRoute: AppRoute
    private var identity: Identity
    private var toastService: ToastService
    private var fileService: FileService
    private var textualToastViewController: TextualToastViewController

    //Views
    private var videoToastMasterView: VideoToastMasterView!
    
    //Private Properties
    private var recaptureBarButtonItem: UIBarButtonItem?

    private var isStatusBarHidden: Bool = false

    private var session: AVCaptureSession?
    private var movieFileOutput: AVCaptureMovieFileOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var player: AVPlayer?

    private var capturedVideoUrl: URL?

    //VideoToastCaptureStageView
    private var videoToastCaptureStageStartCounter = VideoToastCaptureStageConstants.startCounterSetup
    private var videoToastCaptureStageDurationCounter = VideoToastCaptureStageConstants.durationCounterSetup

    private var videoToastCaptureStageStartCounterTimer: Timer?
    private var videoToastCaptureStageDurationCounterTimer: Timer?

    //Public Properties
    var selectedEvent: Event?

    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    internal dynamic init(appRoute: AppRoute,
                          identity: Identity,
                          toastService: ToastService,
                          fileService: FileService,
                          textualToastViewController: TextualToastViewController) {
        self.appRoute = appRoute
        self.identity = identity
        self.toastService = toastService
        self.fileService = fileService
        self.textualToastViewController = textualToastViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    //-------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addCustomViews()
        self.setupVideoSession()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        session?.startRunning()
        setupNavigationBar()
        updateCustomViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        session?.stopRunning()
    }

    override func viewDidLayoutSubviews() {
        videoToastMasterView.updateVideoPreviewLayerBounds()
    }

    private func setupNavigationBar() {
        self.title = "VideoToastViewController.Title.Toast".localized

        recaptureBarButtonItem = UIBarButtonItem(title: "VideoToastViewController.Recapture".localized, style: .plain, target: self, action: #selector(didTapRecaptureVideo))
        recaptureBarButtonItem?.tintColor = UIColor.gftWhiteColor()
        recaptureBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.gftNavigationItemFont()!, NSForegroundColorAttributeName: UIColor.gftWhiteColor()], for: .normal)
    }

    private func addCustomViews() {
        if videoToastMasterView == nil {
            videoToastMasterView = VideoToastMasterView()
            videoToastMasterView.videoToastStartStageView.delegate = self
            videoToastMasterView.videoToastCaptureStageView.delegate = self
            videoToastMasterView.videoToastSubmitStageView.delegate = self
            videoToastMasterView.videoToastSubmitStageView.textFieldDelegate = self
            self.view = videoToastMasterView
        }
    }

    private func updateCustomViews() {
        videoToastMasterView.videoPreviewLayer = videoPreviewLayer
        videoToastMasterView.videoToastSubmitStageView.presenterName = identity.user?.fullName
    }

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func displayStage(videoToastViewStage: VideoToastViewStage) {
        switch videoToastViewStage {
        case .start:
            //Animate navigation bar
            self.title = "VideoToastViewController.Title.Toast".localized
            navigationController?.setNavigationBarHidden(false, animated: true)
            isStatusBarHidden = false
            self.navigationItem.rightBarButtonItem = nil
            setNeedsStatusBarAppearanceUpdate()

            //Hide/Display views
            videoToastMasterView.videoToastStartStageView.isHidden = false
            videoToastMasterView.videoToastCaptureStageView.isHidden = true
            videoToastMasterView.videoToastSubmitStageView.isHidden = true

            //Play/Pause player
            player?.pause()
        case .capture:
            //Animate navigation bar
            navigationController?.setNavigationBarHidden(true, animated: true)
            isStatusBarHidden = true
            setNeedsStatusBarAppearanceUpdate()

            //Hide/Display views
            videoToastMasterView.videoToastStartStageView.isHidden = true
            videoToastMasterView.videoToastCaptureStageView.isHidden = false
            videoToastMasterView.videoToastSubmitStageView.isHidden = true

            //Play/Pause player
            player?.pause()
        case .submit:
            //Animate navigation bar
            self.title = "VideoToastViewController.Title.Edit and share".localized
            navigationController?.setNavigationBarHidden(false, animated: true)
            isStatusBarHidden = false
            self.navigationItem.rightBarButtonItem = recaptureBarButtonItem
            setNeedsStatusBarAppearanceUpdate()

            //Hide/Display views
            videoToastMasterView.videoToastStartStageView.isHidden = true
            videoToastMasterView.videoToastCaptureStageView.isHidden = true
            videoToastMasterView.videoToastSubmitStageView.isHidden = false

            //Play/Pause player
            player?.play()
        }
    }

    private func setupVideoSession() {
        session = AVCaptureSession()
        session?.beginConfiguration()
        session!.sessionPreset = AVCaptureSessionPresetMedium

        let backCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        let microphone = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)

        var backCameraInput: AVCaptureDeviceInput!
        var microphoneInput: AVCaptureDeviceInput!
        do {
            backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            microphoneInput = try AVCaptureDeviceInput(device: microphone)
        } catch let error as NSError {
            Logger.error("Failed to access device input: \(error)")
        }

        if backCameraInput != nil && session!.canAddInput(backCameraInput) &&
                   microphoneInput != nil && session!.canAddInput(microphoneInput) {
            session!.addInput(backCameraInput)
            session!.addInput(microphoneInput)

            movieFileOutput = AVCaptureMovieFileOutput()

            //TODO: decide if I need this limitation

//            let totalSeconds: Float64 = 15      //Total seconds
//            let preferredTimeScale: Int32 = 30;	//Frames per second
//            let maxDuration = CMTimeMakeWithSeconds(totalSeconds, preferredTimeScale)
//            movieFileOutput?.maxRecordedDuration = maxDuration
//
//            movieFileOutput?.minFreeDiskSpaceLimit = Int64(2 * 1024 * 1024) //2MB
            
            movieFileOutput?.movieFragmentInterval = kCMTimeInvalid //Otherwise no sound

            if session!.canAddOutput(movieFileOutput) {
                session!.addOutput(movieFileOutput)

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            }
        }
        session?.commitConfiguration()

    }

    private func startCaptureCountdown() {
        //Reset start counter
        videoToastCaptureStageStartCounter = VideoToastCaptureStageConstants.startCounterSetup
        videoToastMasterView.videoToastCaptureStageView.startCounter = "\(videoToastCaptureStageStartCounter)"

        //Reset duration counter
        videoToastCaptureStageDurationCounter = VideoToastCaptureStageConstants.durationCounterSetup
        videoToastMasterView.videoToastCaptureStageView.durationCounter = "\(videoToastCaptureStageDurationCounter)"

        //Reset capture view UI
        videoToastMasterView.videoToastCaptureStageView.resetUIComponents(duration: Double(VideoToastCaptureStageConstants.startCounterSetup))

        //Setup timer
        videoToastCaptureStageStartCounterTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if self.videoToastCaptureStageStartCounter > 1 {
                self.videoToastCaptureStageStartCounter -= 1
                self.videoToastMasterView.videoToastCaptureStageView.startCounter = "\(self.videoToastCaptureStageStartCounter)"
            } else {
                timer.invalidate()
                self.videoToastMasterView.videoToastCaptureStageView.hideStartCounterAndDescription()
                self.startVideoCapture()
            }
        })
    }

    private func startVideoCapture() {
        //Get temp video file path
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let tempVideoDirectory = paths.first?.appending("/\(VideoToastCaptureStageConstants.videoFileName)")

        //Delete old video file if exists
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: tempVideoDirectory!) {
            do {
                try fileManager.removeItem(atPath: tempVideoDirectory!)
                Logger.debug("Deleted local video file")
            } catch {
                Logger.error("Cannot delete local video file")
            }
        }
    
        //Start recording
        movieFileOutput?.startRecording(toOutputFileURL: URL(fileURLWithPath: tempVideoDirectory!), recordingDelegate: self)
    }
    
    private func playCapturedVideo(capturedVideoUrl: URL) {
        player = AVPlayer(url: capturedVideoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoToastMasterView.videoToastSubmitStageView.videoPreviewLayer = playerLayer

        //Play video in endless loop
        player?.isMuted = true
        player?.play()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            self.player?.seek(to: kCMTimeZero)
            self.player?.play()
        }
    }

    @objc private func didTapRecaptureVideo() {
        Logger.debug("Did tapped recapture video")

        displayStage(videoToastViewStage: .capture)
        startCaptureCountdown()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - VideoToastStartStageViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapTakeVideoNow() {
        Logger.debug("User tapped to take video now")

        displayStage(videoToastViewStage: .capture)
        startCaptureCountdown()
    }

    func didTapSkipToTextualToast() {
        Logger.debug("User tapped to skip to textual toast")
        textualToastViewController.selectedEvent = selectedEvent
        appRoute.pushViewController(controller: textualToastViewController, animated: true)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - VideoToastCaptureStageViewDelegate
    //-------------------------------------------------------------------------------------------
    func didTapExit() {
        Logger.debug("User tapped to exit video capture")
        videoToastCaptureStageStartCounterTimer?.invalidate()
        videoToastCaptureStageDurationCounterTimer?.invalidate()

        //Stop capturing
        movieFileOutput?.stopRecording()

        //Display view
        Async.main(after: 0.5) { //Dispatching after 0.5 seconds so AVCaptureMovieFileOutput will complete to call delegate after writing video to disk
            self.displayStage(videoToastViewStage: .start)
        }
    }

    func didTapAskForHint() {
        Logger.debug("User tapped ask for hint")
        //TODO: implement
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - VideoToastSubmitStageViewDelegate
    //-------------------------------------------------------------------------------------------
    func didLongPressedTintBackground(began: Bool) {
        Logger.debug("Did long pressed tint background")

        videoToastMasterView.videoToastSubmitStageView.shouldHideEverythingButVideo(shouldHide: began)
        player?.isMuted = !began
    }

    func didUpdatePresenterName() {
        Logger.debug("Did update presenter name")
        let shouldEnableContinueButton = !(videoToastMasterView.videoToastSubmitStageView.presenterName?.isEmpty)!
        videoToastMasterView.videoToastSubmitStageView.enableContinueButton(enabled: shouldEnableContinueButton)
    }

    func didTapShareViaFacebook() {
        Logger.debug("Did tapped share via facebook")
        //TODO: implement
    }

    func didTapShareViaInstagram() {
        Logger.debug("Did tapped share via Instagram")
        //TODO: implement
    }

    func didTapDidntLikeSwitchToTextualToastAnyway() {
        Logger.debug("Did tapped didn't Like switch to textual toast anyway")
        textualToastViewController.selectedEvent = selectedEvent
        appRoute.pushViewController(controller: textualToastViewController, animated: true)
    }


    func didTapContinue() { //TODO: activity indicator
        Logger.debug("Did tapped continue")

        do {
            let videoData = try Data(contentsOf: capturedVideoUrl!)

            videoToastMasterView.videoToastSubmitStageView.activityAnimation(shouldAnimate: true)
            fileService.uploadVideo(videoData: videoData, success: { (videoUrl) in
                Logger.debug("Successfully uploaded toast video")
                self.toastService.createToast(eventId: (self.selectedEvent?.id)!,
                        toastFlavor: .video,
                        giftPresenters: self.videoToastMasterView.videoToastSubmitStageView.presenterName!,
                        videoUrl: videoUrl,
                        success: { (toast) in
                            Logger.debug("Successfully created video toast")
                            self.videoToastMasterView.videoToastSubmitStageView.activityAnimation(shouldAnimate: false)
                        }, failure: { (error) in
                    Logger.error("Failed to create video toast \(error)")
                    self.videoToastMasterView.videoToastSubmitStageView.activityAnimation(shouldAnimate: false)
                })
            }, failure: { (error) in
                Logger.error("Failed to upload toast video \(error)")
                self.videoToastMasterView.videoToastSubmitStageView.activityAnimation(shouldAnimate: false)
            })
        } catch let error as NSError {
            Logger.error("Failed to get data of video: \(error)")
        }
        
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - AVCaptureFileOutputRecordingDelegate
    //-------------------------------------------------------------------------------------------
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        //Animate header shrink
        videoToastMasterView.videoToastCaptureStageView.animateHeaderView(duration: Double(VideoToastCaptureStageConstants.durationCounterSetup))

        //Reset duration counter
        videoToastCaptureStageDurationCounter = VideoToastCaptureStageConstants.durationCounterSetup
        videoToastMasterView.videoToastCaptureStageView.durationCounter = "\(videoToastCaptureStageDurationCounter)"

        //Setup timer
        videoToastCaptureStageDurationCounterTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if self.videoToastCaptureStageDurationCounter > 1 {
                self.videoToastCaptureStageDurationCounter -= 1
                self.videoToastMasterView.videoToastCaptureStageView.durationCounter = "\(self.videoToastCaptureStageDurationCounter)"
            } else  {
                //Invalidate timer
                timer.invalidate()
                
                //Stop capturing
                self.movieFileOutput?.stopRecording()
                
                //Display view
                Async.main(after: 0.5) { //Dispatching after 0.5 seconds so AVCaptureMovieFileOutput will complete to call delegate after writing video to disk
                    self.displayStage(videoToastViewStage: .submit)
                }
            }
        })
    }


    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if error != nil {
            Logger.error("Filed to record video. \(error)")
            //TODO: display error alert
            return
        }
        
        Logger.debug("Did captured video")
        capturedVideoUrl = outputFileURL
        playCapturedVideo(capturedVideoUrl: outputFileURL)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate
    //-------------------------------------------------------------------------------------------
    //Dismiss keyboard on return
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
