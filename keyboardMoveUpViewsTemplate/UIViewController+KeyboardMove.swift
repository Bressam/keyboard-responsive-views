//
//  UIViewController+KeyboardMove.swift
//  keyboardMoveUpViewsTemplate
//
//  Created by Giovanne Bressam on 05/01/21.
//

// swiftlint:disable line_length

// Constraint Warnings - Constraint of "TUISystemInputAssistantView" breaking when changing from
// keyboard with custom view to system's keyboard:
/// This warning can be ignored, it  is not related to this class layout adjust.
/// It is caused by the Assistant View with "auto complete suggestions" breaking an internal constraint and causes no visual/UI effect.

import UIKit

open class UIViewControllerWithKeyboardMove: UIViewController {
// MARK: Animation and Layout constants
    /// Constant used to adjust the distance from keyboard to the textField/TextView
    private let spaceBetweenTxtFieldAndKeyboard : CGFloat = 8

    /// Duration of view's animation to move up after keyboard shows
    private let viewAnimationDuration : TimeInterval = 0.4

// MARK: Variables
    /// Used to enable/disable screen moving when keyboard shows
    var enableMoveKeyboard: Bool = true {
        didSet {
            enableMoveKeyboard ? self.addKeyboardObserver() : self.removeKeyboardObserver()
        }
    }

    /// Used to store view's original Y position, that may change if view is contained into navigation controller and also in other cases
    private var originalYPosition: CGFloat = 0

// MARK: View Lifecycle
    open override func viewWillAppear(_ animated: Bool) {
        self.setupTapToDismissKeyboard()
        self.addKeyboardObserver()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Be sure it is related to parentVC if has one, just getting the view.frame wasn't reliable since in random/intermittent scenarios the view.frame was returning y not related to parent
        let viewFrameOnScreen = self.getParentViewCoordinates(of: self.view.frame)
        originalYPosition = viewFrameOnScreen.origin.y
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }

// MARK: Dismiss keyboard gesture
    private func setupTapToDismissKeyboard() {
        let tapToDismiss = UITapGestureRecognizer(target: self,
                                                  action: #selector(UIInputViewController.dismissKeyboard))
        tapToDismiss.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismiss)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

// MARK: Layout related functions
    /// Convert the frame to a position on  "phyical window" coordinate system.
    /// Use if need a coordinate that will be always the same despite how many superviews or parents ViewControllers the current view has
    private func getScreenCoordinates(of viewToConvert: UIView) -> CGRect {
        guard let superView = viewToConvert.superview else {
            return self.view.convert(viewToConvert.frame, to: nil)
        }
        return superView.convert(viewToConvert.frame, to: nil)
    }

    /// Convert the frame to a position on superView coordinate system
    /// View's frame is always in relation to its superview. Use if you need to convert back some coordinate calculated in relation to other coordinate system
    private func getSuperViewCoordinates(of frameToConvert: CGRect) -> CGRect {
        guard let superView = self.view.superview else {
            return self.view.frame
        }
        return self.view.convert(frameToConvert, from: superView)
    }

    /// Convert the frame to a position on parent's VC  coordinate system
    /// Use if you need to convert back some coordinate calculated in relation to other coordinate system
    private func getParentViewCoordinates(of frameToConvert: CGRect) -> CGRect {
        guard let parentView = self.parent?.view else {
            return self.view.frame
        }
        return parentView.convert(frameToConvert, to: parentView)
    }

// MARK: Keyboard & View's Layout functions
    /// Add needed observer to be notified of keyboard frame changing
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotifications(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    /**
     Remove the added observers used to notify of keyboard frame changing

     - Note: Unregistering isn't always needed, but is good to remove observers from every view that is still in memory but not appearing, so all animations and calculations are done only to the view user is actually viewing.
     This is only mandatory for observers with completionHandlers registered with "non weak" capture of self, that would cause issues with ARC freeing reference. After iOS 9 the following behavior was implemented:

     _"If the observer is able to be stored as a zeroing-weak reference the underlying storage will store the observer as a zeroing weak reference.
     The next notification that would be routed to that observer will detect the zeroed reference and automatically un-register the observer"_
     */
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }

    /// Used to notify when keyboard appears/dissapears or change its frame
    @objc private func keyboardNotifications(notification: NSNotification) {
        self.moveViewIfKeyboardCoversField(notification)
    }

    /// Get the TextField or TextView that user is editing and returns it Y position on screen coordinates return
    /// - Returns: Field's Y position on screen coordinates.
    private func getYPositionOfFieldInUse() -> CGFloat? {
        // Check if first responder is a TextField or TextView and get its frame and Y position
        var textFieldFrameOnSuperView = CGRect(x: 0, y: 0, width: 0, height: 0)
        if let activeTextField = UIResponder.currentFirst() as? UITextField ?? UIResponder.currentFirst() as? UITextView {
            textFieldFrameOnSuperView = self.getScreenCoordinates(of: activeTextField)
            var selectedFieldY = textFieldFrameOnSuperView.maxY // or Y + frame.size.height

            // if view is currently out of original position, add the difference to check if would cover
            // the input field when getting back to normal position
            let viewFrame = self.getParentViewCoordinates(of: self.view.frame)
            if (originalYPosition != viewFrame.origin.y) {
                selectedFieldY += abs(originalYPosition - viewFrame.origin.y)
            }
            return selectedFieldY
        }
        return nil
    }

    /// Calculate and move view to keep the ``spaceBetweenTxtFieldAndKeyboard`` configured on this class
    private func moveViewIfKeyboardCoversField(_ notification: NSNotification) {
        // Used to store text fields Y position to calculate how much the view will move
        guard let selectedTextFieldY = getYPositionOfFieldInUse() else { return }

        // Get keyboard frame, its frame is on screen coordinates so no need to convert
        if let userInfo = notification.userInfo,
           let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var viewNewOriginY: CGFloat = 0.0

            // If keyboard is moving away from the view or won't cover/keep space from the field
            if (keyBoardFrame.origin.y >= UIScreen.main.bounds.size.height)
                || (selectedTextFieldY < (keyBoardFrame.origin.y - spaceBetweenTxtFieldAndKeyboard)) {
                viewNewOriginY = self.originalYPosition
            } else {
                // Calculate how much need to move and keep set space
                var amountToMove = (selectedTextFieldY - keyBoardFrame.origin.y) + spaceBetweenTxtFieldAndKeyboard

                // For safety, check if won't move more than keyboard height, to avoid
                // blank/dark space between keyboard and view
                if amountToMove > keyBoardFrame.size.height { amountToMove = keyBoardFrame.size.height }

                // Calculate new Y position
                viewNewOriginY = self.originalYPosition - amountToMove
            }

            // Check if calculated position is different from current to avoid unnecessary animations
            let viewFrameOnSuperView = self.getParentViewCoordinates(of: self.view.frame)
            let viewNeedToMoveWithKeyboard = (viewNewOriginY != viewFrameOnSuperView.origin.y)

            // Animate and move the view Y to the calculated new value
            if viewNeedToMoveWithKeyboard {
                UIView.animate(withDuration: viewAnimationDuration) {
                    self.view.frame.origin.y = viewNewOriginY
                }
            }
        }
    }
}

// MARK: UIResponder Extensions
extension UIResponder {
    /// Stores a reference to currently first responder
    static private weak var firstResponder: UIResponder?

    /// Returns first UIResponder. Used to identify selected TextField/TextView and get its frame for UI adjustments
    static func currentFirst() -> UIResponder? {
        firstResponder = nil
        // The trick here is that, following the official documentation of "SendAction",
        // sending an action with "nil" causes it to send to the first responder.
        UIApplication.shared.sendAction(#selector(trap), to: nil, from: nil, for: nil)
        return firstResponder
    }

    /// "Traps"/Hold the reference to  first responder
    @objc private func trap() {
        UIResponder.firstResponder = self
    }
}
