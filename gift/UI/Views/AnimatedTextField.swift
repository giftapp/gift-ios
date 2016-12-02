//
// Created by Matan Lachmish on 27/11/2016.
// Copyright (c) 2016 GiftApp. All rights reserved.
//

import Foundation
import UIKit

struct AnimatedTextFieldConstants {
    static let sidePadding: CGFloat = 10
    static let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    static let activePlaceholderInsets = CGPoint(x: sidePadding, y: 6)
    static let textFieldPadding = UIEdgeInsets(top: 22, left: sidePadding, bottom: 0, right: sidePadding)
}

/**
 An AnimatedTextField is a subclass of the UITextField object, is a control that displays an UITextField with a customizable visual effect around the lower edge of the control.
 */
class AnimatedTextField: UITextField {

    //-------------------------------------------------------------------------------------------
    // MARK: - Public Properties
    //-------------------------------------------------------------------------------------------
    /**
     The color of the border when it has no content.
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    var borderInactiveColor: UIColor = .gftSeparatorColor() {
        didSet {
            updateBorder()
        }
    }

    /**
     The color of the border when it has content.
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    var borderActiveColor: UIColor = .gftAzureColor() {
        didSet {
            updateBorder()
        }
    }

    /**
     The color of the placeholder text when it has no content.
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    var placeholderInActiveColor: UIColor = .gftTextPlaceHolderColor() {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The color of the placeholder text when it has content.
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    var placeholderActiveColor: UIColor = .gftAzureColor() {
        didSet {
            updatePlaceholder()
        }
    }

    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    override var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private Properties
    //-------------------------------------------------------------------------------------------
    private let placeholderLabel = UILabel()
    private let inactiveBorderLayer = CAShapeLayer()
    private let activeBorderLayer = CAShapeLayer()
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        //Set default values
        backgroundColor = UIColor.gftWhiteColor()
        font = UIFont.gftText1Font()
        textAlignment = .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private
    //-------------------------------------------------------------------------------------------
    private func updateBorder() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width - AnimatedTextFieldConstants.sidePadding, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        
        inactiveBorderLayer.frame = CGRect(origin: CGPoint(x: 0,
                                                           y: frame.height - (AnimatedTextFieldConstants.borderThickness.inactive / 2)),
                                           size: CGSize(width: frame.width,
                                                        height: AnimatedTextFieldConstants.borderThickness.inactive))
        inactiveBorderLayer.path = path.cgPath
        inactiveBorderLayer.strokeColor = borderInactiveColor.cgColor
        inactiveBorderLayer.lineWidth = AnimatedTextFieldConstants.borderThickness.inactive
        
        
        activeBorderLayer.frame = CGRect(origin: CGPoint(x: 0,
                                                         y: frame.height - (AnimatedTextFieldConstants.borderThickness.active / 2)),
                                           size: CGSize(width: frame.width,
                                                        height: AnimatedTextFieldConstants.borderThickness.active))
        activeBorderLayer.path = path.cgPath
        activeBorderLayer.strokeColor = borderActiveColor.cgColor
        activeBorderLayer.lineWidth = AnimatedTextFieldConstants.borderThickness.active
    }

    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.font = font
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()

        if isFirstResponder || !(text!.isEmpty) {
            animateViewsForTextEntry()
        }
    }

    private func layoutPlaceholderInTextRect() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.origin.y,
                width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)

    }
    
    func drawViewsForRect(rect: CGRect) {
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
    }

    /**
     Creates all the animations that are used to leave the textfield in the "entering text" state.
     */
    func animateViewsForTextEntry() {
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 2.0,
                       options: [.beginFromCurrentState, .transitionCrossDissolve],
                       animations: ({
            
            //Scale placeholder label down
            let scale = CGAffineTransform(scaleX: 0.75, y: 0.75)
            self.placeholderLabel.transform = scale
            
            //Move placeholder label up
            self.placeholderLabel.frame = CGRect(x: self.frame.width - self.placeholderLabel.frame.width - AnimatedTextFieldConstants.activePlaceholderInsets.x , y: AnimatedTextFieldConstants.activePlaceholderInsets.y, width: self.placeholderLabel.frame.width, height: self.placeholderLabel.frame.height)
            
        }))
        
        //Paint placeholder label
        self.placeholderLabel.textColor = self.placeholderActiveColor
        
        //Show active border
        self.activeBorderLayer.strokeEnd = 1.0
    }
    
    /**
     Creates all the animations that are used to leave the textfield in the "display input text" state.
     */

    func animateViewsForTextDisplay() {
        if text!.isEmpty {
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 2.0,
                       options: [.beginFromCurrentState, .transitionCrossDissolve],
                       animations: ({
            
            //Scale placeholder label up
            self.placeholderLabel.transform = CGAffineTransform.identity
            
            //Move placeholder label down
            self.layoutPlaceholderInTextRect()
            
            }))
        }

        //Paint placeholder label
        self.placeholderLabel.textColor = self.placeholderInActiveColor
        
        //Hide active border
        self.activeBorderLayer.strokeEnd = 0.0
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextField Overrides
    //-------------------------------------------------------------------------------------------
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, AnimatedTextFieldConstants.textFieldPadding)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, AnimatedTextFieldConstants.textFieldPadding)
    }

    override func draw(_ rect: CGRect) {
        drawViewsForRect(rect: rect)
    }

    override func drawPlaceholder(in rect: CGRect) {
        // Don't draw any placeholders
    }

    override var text: String? {
        didSet {
            if let text = text, !text.isEmpty {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - UITextField Observing
    //-------------------------------------------------------------------------------------------
    override func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)

            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }

    /**
    The textfield has started an editing session.
    */
    func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }

    /**
    The textfield has ended an editing session.
    */
    func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }

}