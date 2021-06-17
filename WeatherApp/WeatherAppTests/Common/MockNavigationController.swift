//
//  MockNavigationController.swift
//  WeatherAppTests
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation
import UIKit

class MockNavigationController: UINavigationController {
    var pushedVC: UIViewController?
    
    override func show(_ vc: UIViewController, sender: Any?) {
        self.pushedVC = vc
        super.show(vc, sender: sender)
    }
}
