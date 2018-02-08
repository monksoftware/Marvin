//
//  UIViewController+Marvin.swift
//  Marvin-iOS
//
//  Created by Alessio Arsuffi on 08/02/2018.
//  Copyright © 2018 Monk Srl. All rights reserved.
//

import UIKit

extension UIViewController {
	
	/// Add child viewController to current ViewController
	///
	/// - note: title property will be set if viewController has any
	/// - Parameters:
	///   - viewController: UIViewController the viewController to add as child
	///   - toView: optional, a view to add view controller as subview
	///   - autoresizeMask: Bool, if true autoresizingMask of viewController will be set to flexibleWidth & flexibleHeight
	public func addChild(viewController: UIViewController, toView: UIView? = nil, autoresizeMask: Bool = false) {
		addChildViewController(viewController)
		
		if autoresizeMask {
			viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		}
		
		if let toView = toView {
			viewController.view.frame = toView.frame
			toView.addSubview(viewController.view)
		} else {
			viewController.view.frame = view.frame
			view.addSubview(viewController.view)
		}
		
		viewController.didMove(toParentViewController: self)
		title = viewController.title
	}
	
	/// Remove child viewController from current
	///
	/// - parameter viewController: the ViewController to remove as child
	public func removeChild(viewController: UIViewController) {
		viewController.view.removeFromSuperview()
		viewController.removeFromParentViewController()
	}
	
	/// Set backButtonItem of navigationBar text to ""
	public func removeBackButtonTitle () {
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target:nil, action:nil)
	}
	
	/// Set backButtonItem of navigationBar text
	///
	/// - Parameter title: value to set
	public func setBackButtonItem(title: String) {
		navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style:.plain, target:nil, action:nil)
	}
}
