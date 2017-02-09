//
//  GWCollectionViewFloatCellLayout.swift
//  GWCollectionViewFloatCellLayout
//
//  Created by Will on 2/10/17.
//  Copyright © 2017 Will. All rights reserved.
//

import UIKit

class GWCollectionViewFloatCellLayout: UICollectionViewLayout {
    
    
    var itemAttributes: [[UICollectionViewLayoutAttributes]] = [[UICollectionViewLayoutAttributes]]()
    var supplementaryViewAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var contentSize: CGSize = .zero
    var itemSize: CGSize = .zero
    var floatItemSize: CGSize = .zero
    var headerReferenceSize: CGSize = .zero
    var footerReferenceSize: CGSize = .zero
    
    var minimumLineSpacing: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        if collectionView.numberOfSections == 0 {
            return
        }
        
        let collectionViewWidth = collectionView.bounds.width
        
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        var contentHeight: CGFloat = 0
        
        let section = 0
        
        // set frame for header
        let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
        headerAttributes.frame = CGRect(x: xOffset, y: yOffset, width: collectionViewWidth, height: headerReferenceSize.height)
        yOffset += headerReferenceSize.height
        contentHeight += headerReferenceSize.height
        self.supplementaryViewAttributes.append(headerAttributes)
        
        // set frame for each elements
        var sectionAttributes = [UICollectionViewLayoutAttributes]()
        
        let maxOfItemsInOneLine: Int = max(Int(floor((floatItemSize.width - sectionInset.left - sectionInset.right + minimumInteritemSpacing) / (itemSize.width + minimumInteritemSpacing))), 1)
        let interitemSpacing: CGFloat = (floatItemSize.width - (CGFloat(maxOfItemsInOneLine) * itemSize.width) - sectionInset.left - sectionInset.right) / CGFloat(maxOfItemsInOneLine - 1)
        
        for item in 0..<collectionView.numberOfItems(inSection: section) {
            let indexPath = IndexPath(item: item, section: section)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            if item == 1 {
                xOffset += sectionInset.left
                yOffset += sectionInset.top
            }
            
            
            if item == 0 {
                // float cell
                attributes.zIndex = 1024
                var frame = CGRect(x: xOffset, y: yOffset, width: collectionViewWidth, height: floatItemSize.height).integral
                if collectionView.contentOffset.y >= headerReferenceSize.height {
                    frame.origin.y = collectionView.contentOffset.y
                }
                attributes.frame = frame
                yOffset += floatItemSize.height
            } else {
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                if item % maxOfItemsInOneLine == 0 && item + 1 != collectionView.numberOfItems(inSection: section) {
                    xOffset = sectionInset.left
                    yOffset += itemSize.height + minimumLineSpacing
                } else {
                    xOffset += itemSize.width + interitemSpacing
                }
            }
            
            sectionAttributes.append(attributes)
        }
        
        self.itemAttributes.append(sectionAttributes)
        
        xOffset = sectionInset.left
        yOffset += itemSize.height
        yOffset += sectionInset.bottom
        
        // set frame for footer
        let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: IndexPath(item: 0, section: section))
        footerAttributes.frame = CGRect(x: 0, y: yOffset, width: collectionViewWidth, height: footerReferenceSize.height)
        yOffset += footerReferenceSize.height
        contentHeight += footerReferenceSize.height
        self.supplementaryViewAttributes.append(footerAttributes)
        
        
        if yOffset > contentHeight {
            contentHeight = yOffset
        }
        contentWidth = collectionViewWidth
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.itemAttributes[indexPath.section][indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.supplementaryViewAttributes[indexPath.section]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()
        
        for section in self.itemAttributes {
            
            let filteredArray = section.filter({ rect.intersects($0.frame) })
            attributes.append(contentsOf: filteredArray)
        }
        
        attributes.append(contentsOf: self.supplementaryViewAttributes.filter({ rect.intersects($0.frame) }))
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
