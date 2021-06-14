//
//  Theme.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation
import UIKit

struct Theme {
    struct Color {
        static var greyColor: UIColor {
            return UIColor(red: (101.0/255.0), green: (141.0/255.0), blue: (149.0/255.0), alpha: 1.0)
        }
        static var disableGreyColor: UIColor {
            return UIColor(white: 0.9, alpha: 1.0)
        }
        static var disableTintColor: UIColor {
            return UIColor(white: 0.5, alpha: 1.0)
        }
        static var tintColor: UIColor {
            return UIColor.white
        }
        static var redColor: UIColor {
            return UIColor.red
        }
    }
}
