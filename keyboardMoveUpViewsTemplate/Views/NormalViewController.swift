//
//  NormalViewController.swift
//  keyboardMoveUpViewsTemplate
//
//  Created by Giovanne Bressam on 19/12/21.
//

import UIKit

class NormalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // just gesture to dismiss keyboard
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
