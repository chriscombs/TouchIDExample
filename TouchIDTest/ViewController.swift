//
//  ViewController.swift
//  TouchIDTest
//
//  Created by Chris Combs on 20/11/15.
//  Copyright © 2015 Nodes. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
	
	@IBOutlet weak var approvedLabel: UILabel!


	@IBAction func requestApprovalPressed(sender: AnyObject) {
		let context = LAContext()
		context.localizedFallbackTitle = "Custom fallback error message"
		let reason = "Custom reason for requesting Touch ID"
		
		var error: NSError?
		if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
			context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) -> Void in
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
				if success {
					self.approvedLabel.text = "Approved!"
				}
				else {
					if let error = error {
						switch LAError(rawValue: error.code)! {
						case .UserFallback:
							print("User fallback")
							self.approvedLabel.text = "User fallback"
						case .UserCancel:
							print("user cancelled")
							self.approvedLabel.text = "User cancelled"
						case .AuthenticationFailed:
							self.approvedLabel.text = "Authorization failed"
						default:
							self.approvedLabel.text = "Other error"
							
						}
					}
				}
				})

			})
		}
	}
}

