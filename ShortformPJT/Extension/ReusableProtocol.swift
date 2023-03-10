//
//  ReusableProtocol.swift
//  ShortformPJT
//
//  Created by κΉνν on 2023/02/10.
//

import UIKit

protocol ReusableProtocol {
    static var reuseIdentifier: String { get }
}

extension UICollectionViewCell: ReusableProtocol {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

