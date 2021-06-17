//
//  StoryboardGettable.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation
import UIKit

protocol StoryboardGettable where Self: UIViewController {}
   
extension StoryboardGettable {
    static func getVC() -> Self {
        let name = String(describing: Self.self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: Self.self))
        if let viewController = storyboard.instantiateViewController(identifier: name) as? Self {
            return viewController
        } else {
            // Log
            fatalError()
        }
    }
}
