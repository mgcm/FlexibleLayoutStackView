//
//  ViewController.swift
//  FlexibleLayoutStackView
//
//  Created by Milton Moura on 01/11/15.
//  Copyright © 2015 mgcm. All rights reserved.
//

import UIKit

class VisualViewController: UIViewController
{
    @IBOutlet weak var headerStackView: UIStackView!

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var recoverButton: UIButton!
    @IBOutlet weak var recoverLabel: UILabel!
    @IBOutlet weak var cancelRecoverButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.signInButton.hidden = false
        self.forgotButton.hidden = false
        self.passwordField.hidden = false
        self.recoverButton.hidden = true
        self.recoverLabel.hidden = true
        self.cancelRecoverButton.hidden = true
    }

    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if newCollection.verticalSizeClass == .Compact  {
                headerStackView.axis = .Horizontal
        } else {
            headerStackView.axis = .Vertical
        }
    }

    @IBAction func forgotTapped(sender: AnyObject) {
        UIView.animateWithDuration(0.2) { [weak self] () -> Void in
            self?.signInButton.hidden = true
            self?.signInLabel.hidden = true
            self?.forgotButton.hidden = true
            self?.passwordField.hidden = true
            self?.recoverButton.hidden = false
            self?.recoverLabel.hidden = false
            self?.cancelRecoverButton.hidden = false
        }
    }

    @IBAction func cancelRecoverTapped(sender: AnyObject) {
        UIView.animateWithDuration(0.2) { [weak self] () -> Void in
            self?.signInButton.hidden = false
            self?.signInLabel.hidden = false
            self?.forgotButton.hidden = false
            self?.passwordField.hidden = false
            self?.recoverButton.hidden = true
            self?.recoverLabel.hidden = true
            self?.cancelRecoverButton.hidden = true
        }
    }
}

