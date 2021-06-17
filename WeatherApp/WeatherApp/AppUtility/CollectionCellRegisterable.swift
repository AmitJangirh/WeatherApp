//
//  CollectionCellRegisterable.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 18/06/21.
//

import Foundation
import UIKit

protocol CollectionCellRegisterable where Self: UICollectionViewCell {
    associatedtype CellData
    static var reusableIdentifier: String { get }
    static func register(for collectionView: UICollectionView)
    static func dequeueCell(for collectionView: UICollectionView, indexPath: IndexPath) -> Self?
    
    func configure(with data: CellData, for indexPath: IndexPath)
}

extension CollectionCellRegisterable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }

    static func register(for collectionView: UICollectionView) {
        let nib = UINib(nibName: reusableIdentifier, bundle: Bundle(for: Self.self))
        collectionView.register(nib, forCellWithReuseIdentifier: reusableIdentifier)
    }
    
    static func dequeueCell(for collectionView: UICollectionView, indexPath: IndexPath) -> Self? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as? Self
    }
}
