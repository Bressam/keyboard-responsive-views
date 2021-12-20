//
//  BaseViewController.swift
//  keyboardMoveUpViewsTemplate
//
//  Created by Giovanne Bressam on 19/12/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardListeners()
        setupTapToDismissKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // As of iOS 9 (and OS X 10.11), you don't need to remove observers yourself, if you're not using block based observers though. The system will do it for you, since it uses zeroing-weak references for observers, where it can.
        // If using block based observers, remember to capture self weakly
        removeNotifications()
    }
    
    //MARK: Listeners
    func setupKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if self.view.frame.origin.y == 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.view.frame.origin.y += keyboardHeight
        }
        
    }
    
    
    //MARK: Gestures
    func setupTapToDismissKeyboard() {
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapToDismiss)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
