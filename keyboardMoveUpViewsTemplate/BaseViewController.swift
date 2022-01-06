////
////  BaseViewController.swift
////  keyboardMoveUpViewsTemplate
////
////  Created by Giovanne Bressam on 19/12/21.
////
//
///*
// * View should not move when TextField is above the keyboard
// * No need to set constant value to NSLayoutConstraint
// * No third party library required
// * No animation code required
// * Works on tableview as well
// * This works on Auto layout / auto resize
// */
//
//import UIKit
//
//
//// BUG:
//// If textField's constraints are set to safe area the field jumps after typing
//// Workaround: Set textField position to superview
//// Looks like happens to devices with notches
//// https://github.com/hackiftekhar/IQKeyboardManager/issues/1733
//
//// Bug explained?
//// Cause mentioned briefily here  https://stackoverflow.com/a/43353165
//// That leads to fully explanation here:
//// https://stackoverflow.com/a/32989676
//class BaseViewController: UIViewController {
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.setupTapToDismissKeyboard()
//        self.addKeyboardObserver()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.removeKeyboardObserver()
//    }
//    
////    // MARK: View Lifecycle
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        setupKeyboardListeners()
////        setupTapToDismissKeyboard()
////    }
////
////    override func viewWillDisappear(_ animated: Bool) {
////        super.viewWillDisappear(animated)
////        // As of iOS 9 (and OS X 10.11), you don't need to remove observers yourself, if you're not using block based observers though. The system will do it for you, since it uses zeroing-weak references for observers, where it can.
////        // If using block based observers, remember to capture self weakly
////        removeNotifications()
////    }
////
////   // MARK: Listeners
////    func setupKeyboardListeners() {
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
////    }
////
////    func removeNotifications() {
////        NotificationCenter.default.removeObserver(self)
////    }
////
////    @objc func keyboardWillShow(notification: Notification) {
////        if self.view.frame.origin.y == 0 {
////            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
////                let keyboardRectangle = keyboardFrame.cgRectValue
////                let keyboardHeight = keyboardRectangle.height
////
////                self.view.frame.origin.y -= keyboardHeight
////            }
////        }
////    }
////
////    @objc func keyboardWillHide(notification: Notification) {
////        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
////            let keyboardRectangle = keyboardFrame.cgRectValue
////            let keyboardHeight = keyboardRectangle.height
////
////            self.view.frame.origin.y += keyboardHeight
////        }
////
////    }
////
////
////    //MARK: Gestures
//    func setupTapToDismissKeyboard() {
//        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        tapToDismiss.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapToDismiss)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}
//
//extension UIViewController {
//    func addKeyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotifications(notification:)),
//                                               name: UIResponder.keyboardWillChangeFrameNotification,
//                                               object: nil)
//    }
//
//    func removeKeyboardObserver(){
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//
//    // This method will notify when keyboard appears/ dissapears
//    @objc func keyboardNotifications(notification: NSNotification) {
//
//        var txtFieldY : CGFloat = 0.0  //Using this we will calculate the selected textFields Y Position
//        let spaceBetweenTxtFieldAndKeyboard : CGFloat = 8 //Specify the space between textfield and keyboard
//
//
//        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        if let activeTextField = UIResponder.currentFirst() as? UITextField ?? UIResponder.currentFirst() as? UITextView {
//            // Here we will get accurate frame of textField which is selected if there are multiple textfields
//            activeTextField.layoutIfNeeded()
////            frame = self.view.convert(activeTextField.frame, from: activeTextField.superview)
//            txtFieldY = frame.maxY// + frame.size.height
//            print("txtFieldY frame: \(frame)")
//        }
//
//        if let userInfo = notification.userInfo {
//            // here we will get frame of keyBoard (i.e. x, y, width, height)
//            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            let keyBoardFrameY = keyBoardFrame!.origin.y
//            let keyBoardFrameHeight = keyBoardFrame!.size.height
//            print("frame: \(keyBoardFrame)")
//            var viewOriginY: CGFloat = 0.0
//            //Check keyboards Y position and according to that move view up and down
//            if keyBoardFrameY >= UIScreen.main.bounds.size.height {
//                viewOriginY = 0.0
//            } else {
//                // if textfields y is greater than keyboards y then only move View to up
//                if txtFieldY >= keyBoardFrameY {
//
//                    viewOriginY = (txtFieldY - keyBoardFrameY) + spaceBetweenTxtFieldAndKeyboard
//
//                    //This condition is just to check viewOriginY should not be greator than keyboard height
//                    // if its more than keyboard height then there will be black space on the top of keyboard.
//                    if viewOriginY > keyBoardFrameHeight { viewOriginY = keyBoardFrameHeight }
//                }
//            }
//
//            //set the Y position of view
//            self.view.frame.origin.y = -viewOriginY
////            self.view.setNeedsLayout()
//        }
//    }
//}
//
//// Used to identify selected text field
//extension UIResponder {
//
//    static weak var responder: UIResponder?
//
//    static func currentFirst() -> UIResponder? {
//        responder = nil
//        UIApplication.shared.sendAction(#selector(trap), to: nil, from: nil, for: nil)
//        return responder
//    }
//
//    @objc private func trap() {
//        UIResponder.responder = self
//    }
//}
