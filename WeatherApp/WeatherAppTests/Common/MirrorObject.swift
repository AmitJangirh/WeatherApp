//
//  MirrorObject.swift
//  WeatherAppTests
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation
import UIKit

class MirrorObject {
    let mirror: Mirror
    init(reflecting: Any) {
        self.mirror = Mirror(reflecting: reflecting)
    }
    func extract<T>(variableName: StaticString = #function) -> T? {
        return mirror.descendant("\(variableName)") as? T
    }
}

class ViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(reflecting: viewController)
    }
}

class ViewMirror: MirrorObject {
    init(view: UIView) {
        super.init(reflecting: view)
    }
}

class TableViewCellMirror: MirrorObject {
    init(cell: UITableViewCell) {
        super.init(reflecting: cell)
    }
}

class CollectionViewCellMirror: MirrorObject {
    init(cell: UICollectionViewCell) {
        super.init(reflecting: cell)
    }
}

