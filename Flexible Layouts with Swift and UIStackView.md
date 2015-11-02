#Flexible Layouts with Swift and UIStackview

##Introduction

In this article we will build a Sign In and Password Recovery form with a single flexible layout, using Swift and the [`UIStackView`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIStackView_Class_Reference/) class, available since the release of the iOS 9 SDK. By taking advantage of `UIStackView`'s properties, we will dynamically adapt to the device's orientation and show / hide different form components with animations. The source code for this article can the found [in this github repository](https://github.com/mgcm/FlexibleLayoutStackView).

![](https://raw.githubusercontent.com/mgcm/FlexibleLayoutStackView/master/Screenshots/Animation.gif)

###Auto Layout

[Auto Layout](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/index.html) has become a requirement for any application that wants to adhere to modern best practices of iOS development. When introduced in iOS 6, is was optional and full visual support in Interface Builder just wasn't there. With the release of iOS 8 and the introduction of [Size Classes](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/LayoutandAppearance.html), the tools and the API improved but you could still dodge and avoid Auto Layout. But now, we are at a point where, in order to fully support all device sizes and [split-screen multitasking](https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/AdoptingMultitaskingOniPad/index.html) on the iPad, you must embrace it and design your applications with a flexible UI in mind. 

###The problem with Auto Layout

Auto Layout basically works as an linear equation solver, taking all of the constraints defined in your views and subviews, and calculates the correct sizes and positioning for them. One disadvantage of this approach is that you are obligated to define, typically, between 2 to 6 constraints for each control you add to your view. With different constraint sets for different size classes, the total number of constraints increases considerably and the complexity of managing them increases as well.

###Enter the Stack View

In order to reduce this complexity, the iOS 9 SDK introduced the `UIStackView`, an interface control that serves the single purpose of laying out collections of views. An `UIStackView` will dynamically adapt its containing views' layout to the device's current orientation, screen sizes and other changes in its views. You should keep the following stack view properties in mind:

1. The views contained in a stack view can be arranged either Vertically or Horizontally, in the order they were added to the `arrangedSubviews` array
2. You can embed stack views within each other, recursively
3. The containing views are laid out according to the stack view's `[distribution](...)` and `[alignment](...)` types. These attributes specify how the view collection is laid out across the span of the stack view (distribution) and how to align all subviews within the stack view's container (alignment)
4. Most properties are animatable and inserting / deleting / hiding / showing views within an animation block will also be animated  
7. Even though you can use a stack view within an `UIScrollView`, don't try to replicate the behaviour of an `UITableView` or `UICollectionView`, as you'll soon regret it.

Apple recommends that you use `UIStackView` for all cases, as it will seriously reduce constraint overhead. Just be sure to judiciously use compression and content hugging priorities to solve possible layout ambiguities.

##A Flexible Sign In / Recover Form

The sample application we'll build features a simple Sign In form, with the option for recovering a forgotten password, all in a single screen. 

When tapping on the "Forgot your password?" button, the form will change, hiding the password text field and showing the new call-to-action buttons and message labels. By canceling the password recovery action, these new controls will be hidden once again and the form will return to it's initial state.

###1. Creating the form

This is what the form will look like when we're done. Let's start by creating a new iOS > Single View Application template.

![](https://raw.githubusercontent.com/mgcm/FlexibleLayoutStackView/master/Screenshots/%231.png)

Then, we add a new `UIStackView` to the ViewController and add some constraints for positioning it within its parent view. Since we want a full screen width vertical form, we set its axis to `.Vertical`, the alignment to `.Fill` and the distribution to `.FillProportionally`, so that individual views within the stack view can grow bigger or smaller, according to their content.

		class ViewController : UIViewController
		{
    		let formStackView = UIStackView()
			...
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
				...
			}
			...
		}

Next, we'll add all the fields and buttons that make up our form. We'll only present a couple of them here as the [rest of the code is boilerplate](https://github.com/mgcm/FlexibleLayoutStackView/blob/master/FlexibleLayoutStackView/ManualViewController.swift). In order to refrain `UIStackView` from growing the height of our inputs and buttons as needed to fill vertical space, we add height constraints to set the maximum value for their vertical size.

		class ViewController : UIViewController 
		{
			...
		    var passwordField: UITextField!
		    var signInButton: UIButton!
		    var signInLabel: UILabel!
		    var forgotButton: UIButton!
		    var backToSignIn: UIButton!
		    var recoverLabel: UILabel!
		    var recoverButton: UIButton!
			...
			
			override func viewDidLoad() {
				...
				
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
				...
			}
			...
		}

###2. Animating by showing / hiding specific views

By taking advantage of the previously mentioned properties of `UIStackView`, we can transition from the Sign In form to the Password Recovery form by showing and hiding specific field and buttons. We do this by setting the `hidden` property within a `UIView.animateWithDuration` block.

		class ViewController : UIViewController
		{
			...
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
			...
		}

###3. Handling different Size Classes

Because we have many vertical input fields and buttons, space can become an issue when presenting in a compact vertical size, like the iPhone in landscape. To overcome this, we add a stack view to the header section of the form and change its axis orientation between Vertical and Horizontal, according to the current active size class.

        override func viewDidLoad() {
			...
			// Initialize the header stack view, that will change orientation type according to the current size class
        	headerStackView.axis = .Vertical
        	headerStackView.alignment = .Fill
        	headerStackView.distribution = .Fill
        	headerStackView.spacing = 8
        	headerStackView.translatesAutoresizingMaskIntoConstraints = false
			...
		}
		
	    // If we are presenting in a Compact Vertical Size Class, let's change the header stack view axis orientation
	    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
	        if newCollection.verticalSizeClass == .Compact  {
	            headerStackView.axis = .Horizontal
	        } else {
	            headerStackView.axis = .Vertical
	        }
	    }

###4. The flexible form layout

So, with a couple of `UIStackView`s, we've built a flexible form only by defining a few height constraints for our input fields and buttons, with all the remaining constraints magically managed by the stack views. Here is the end result:

![](https://raw.githubusercontent.com/mgcm/FlexibleLayoutStackView/master/Screenshots/Final.gif)

##Conclusion

We have included in the [sample source code](https://github.com/mgcm/FlexibleLayoutStackView) a view controller with this same example but designed with Interface Builder. There, you can clearly see that we have less than 10 constraints, on a layout that could easily have up to 40-50 constraints if we had not used `UIStackView`. Stack Views are here to stay and you should use them now if you are targeting iOS 9 and above.