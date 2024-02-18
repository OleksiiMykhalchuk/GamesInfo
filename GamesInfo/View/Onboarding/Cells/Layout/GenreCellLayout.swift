//
//  GenreCellLayout.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/16/24.
//

import UIKit

final class GenreCellLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return [] }

        var x: CGFloat = sectionInset.left
        var y: CGFloat = -1.0

        for attribute in attributes {
            if attribute.representedElementCategory != .cell { continue }

            if attribute.frame.origin.y >= y {
                x = sectionInset.left
            }

            attribute.frame.origin.x = x
            x += attribute.frame.width + minimumLineSpacing
            y = attribute.frame.maxY
        }
        return attributes
    }
}
