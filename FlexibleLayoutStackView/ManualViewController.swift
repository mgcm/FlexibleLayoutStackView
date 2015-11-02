//
//  ManualViewController.swift
//  FlexibleLayoutStackView
//
//  Created by Milton Moura on 02/11/15.
//  Copyright © 2015 mgcm. All rights reserved.
//

import Foundation
import UIKit

class ManualViewController : UIViewController
{
    let formStackView = UIStackView()
    let headerStackView = UIStackView()
    let logoStackView = UIStackView()

    var passwordField: UITextField!
    var signInButton: UIButton!
    var signInLabel: UILabel!
    var forgotButton: UIButton!
    var backToSignIn: UIButton!
    var recoverLabel: UILabel!
    var recoverButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the top-level form stack view
        formStackView.axis = .Vertical
        formStackView.alignment = .Fill
        formStackView.distribution = .FillProportionally
        formStackView.spacing = 8
        formStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(formStackView)

        // Anchor it to the parent view
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[formStackView]-20-|", options: [.AlignAllRight,.AlignAllLeft], metrics: nil, views: ["formStackView": formStackView])
        )
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[formStackView]-8-|", options: [.AlignAllTop,.AlignAllBottom], metrics: nil, views: ["formStackView": formStackView])
        )

        // Initialize the header stack view, that will change orientation type according to the current size class
        headerStackView.axis = .Vertical
        headerStackView.alignment = .Fill
        headerStackView.distribution = .Fill
        headerStackView.spacing = 8
        headerStackView.translatesAutoresizingMaskIntoConstraints = false

        // A stack view for the logo and name of the app
        logoStackView.axis = .Vertical
        logoStackView.alignment = .Center
        logoStackView.distribution = .FillProportionally
        logoStackView.spacing = 8
        logoStackView.translatesAutoresizingMaskIntoConstraints = false

        // The app logo image
        let appLogoImageView = UIImageView(image: UIImage(named: "App")!)
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false

        // Add an 1:1 aspect ration constraint
        appLogoImageView.addConstraint(
            NSLayoutConstraint(item: appLogoImageView, attribute: .Width, relatedBy: .Equal, toItem: appLogoImageView, attribute: .Height, multiplier: 1, constant: 0)
        )
        logoStackView.addArrangedSubview(appLogoImageView)

        // The app name label
        let appNameLabel = UILabel()
        appNameLabel.numberOfLines = 0
        appNameLabel.textAlignment = .Center
        appNameLabel.text = "UIStackView Sample App"
        logoStackView.addArrangedSubview(appNameLabel)

        // Add the header to the header stack view
        headerStackView.addArrangedSubview(logoStackView)

        // Some helpful text labels according to the current form action, only one will be visible at a time
        signInLabel = UILabel()
        signInLabel.numberOfLines = 0
        signInLabel.textAlignment = .Center
        signInLabel.text = "Please sign in below using your username and password"
        headerStackView.addArrangedSubview(signInLabel)

        recoverLabel = UILabel()
        recoverLabel.numberOfLines = 0
        recoverLabel.textAlignment = .Center
        recoverLabel.text = "Please type your email below in order to recover your password"
        headerStackView.addArrangedSubview(recoverLabel)

        formStackView.addArrangedSubview(headerStackView)

        // Add the email field
        let emailField = UITextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.borderStyle = .RoundedRect
        emailField.placeholder = "Email Address"
        formStackView.addArrangedSubview(emailField)

        // Make sure we have a height constraint, so it doesn't change according to the stackview auto-layout
        emailField.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[emailField(<=30)]", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: ["emailField": emailField])
        )

        // Add the password field
        passwordField = UITextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.borderStyle = .RoundedRect
        passwordField.placeholder = "Password"
        formStackView.addArrangedSubview(passwordField)

        // Make sure we have a height constraint, so it doesn't change according to the stackview auto-layout
        passwordField.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[passwordField(<=30)]", options: .AlignAllCenterY, metrics: nil, views: ["passwordField": passwordField])
        )

        // Recover password button
        recoverButton = UIButton(type: .System)
        recoverButton.translatesAutoresizingMaskIntoConstraints = false
        recoverButton.backgroundColor = UIColor.purpleColor()
        recoverButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        recoverButton.setTitle("Recover password", forState: UIControlState.Normal)
        formStackView.addArrangedSubview(recoverButton)
        recoverButton.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[recoverButton(<=44)]", options: .AlignAllCenterY, metrics: nil, views: ["recoverButton": recoverButton])
        )

        // Back to sign in button
        backToSignIn = UIButton(type: .System)
        backToSignIn.translatesAutoresizingMaskIntoConstraints = false
        backToSignIn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        backToSignIn.setTitle("Back to Sign In", forState: UIControlState.Normal)
        formStackView.addArrangedSubview(backToSignIn)

        backToSignIn.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[backToSignIn(<=44)]", options: .AlignAllCenterY, metrics: nil, views: ["backToSignIn": backToSignIn])
        )

        backToSignIn.addTarget(self, action: "backToSignInTapped:", forControlEvents: UIControlEvents.TouchUpInside)

        // Sign In button
        signInButton = UIButton(type: .System)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.backgroundColor = UIColor.purpleColor()
        signInButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        signInButton.setTitle("Sign In", forState: UIControlState.Normal)
        formStackView.addArrangedSubview(signInButton)

        signInButton.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[signInButton(<=44)]", options: .AlignAllCenterY, metrics: nil, views: ["signInButton": signInButton])
        )

        // Forgot my password button
        forgotButton = UIButton(type: .System)
        forgotButton.translatesAutoresizingMaskIntoConstraints = false
        forgotButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        forgotButton.setTitle("Forgot your password?", forState: UIControlState.Normal)
        formStackView.addArrangedSubview(forgotButton)

        forgotButton.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[forgotButton(<=44)]", options: .AlignAllCenterY, metrics: nil, views: ["forgotButton": forgotButton])
        )

        forgotButton.addTarget(self, action: "forgotTapped:", forControlEvents: UIControlEvents.TouchUpInside)

        // Setup default controls state
        self.hideRecoverControls()
    }

    // If we are presenting in a Compact Vertical Size Class, let's change the header stack view axis orientation
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if newCollection.verticalSizeClass == .Compact  {
            headerStackView.axis = .Horizontal
        } else {
            headerStackView.axis = .Vertical
        }
    }

    // Callback target for the Forgot my password button, animates old and new controls in / out
    func forgotTapped(sender: AnyObject) {
        UIView.animateWithDuration(0.2) { [weak self] () -> Void in
            self?.signInButton.hidden = true
            self?.signInLabel.hidden = true
            self?.forgotButton.hidden = true
            self?.passwordField.hidden = true
            self?.recoverButton.hidden = false
            self?.recoverLabel.hidden = false
            self?.backToSignIn.hidden = false
        }
    }

    // Callback target for the Back to Sign In button, animates old and new controls in / out
    func backToSignInTapped(sender: AnyObject) {
        UIView.animateWithDuration(0.2) { [weak self] () -> Void in
            self?.signInButton.hidden = false
            self?.signInLabel.hidden = false
            self?.forgotButton.hidden = false
            self?.passwordField.hidden = false
            self?.recoverButton.hidden = true
            self?.recoverLabel.hidden = true
            self?.backToSignIn.hidden = true
        }
    }

    // Hide controls for default form state
    func hideRecoverControls() {
        self.signInButton.hidden = false
        self.forgotButton.hidden = false
        self.passwordField.hidden = false
        self.recoverButton.hidden = true
        self.recoverLabel.hidden = true
        self.backToSignIn.hidden = true
    }
}