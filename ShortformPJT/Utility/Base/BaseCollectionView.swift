//
//  BaseCollectionView.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/14.
//

import UIKit

class BaseCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Error was caused at BaseCollectionView.")
    }
}
