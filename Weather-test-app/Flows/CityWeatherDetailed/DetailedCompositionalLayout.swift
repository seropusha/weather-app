//
//  DetailedCompositionalLayout.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 11.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import UIKit

protocol DetailedCompositionalLayoutDelegate: AnyObject {
    func layout(_ layout: DetailedCompositionalLayout, sectionAt index: Int) -> DetailedCompositionalLayout.Section?
    func layout(
        _ layout: DetailedCompositionalLayout,
        shouldAddHeaderFor section: DetailedCompositionalLayout.Section,
        sectionIndex: Int
    ) -> Bool
}

extension DetailedCompositionalLayout {
    public enum Section: Hashable {
        case topInfo
        case forecast
    }
}

final class DetailedCompositionalLayout {
    
    weak var delegate: DetailedCompositionalLayoutDelegate?
    
    func build() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionNumber, layoutEnvironment in
            guard let self = self,
                    let section = self.delegate?.layout(self, sectionAt: sectionNumber)
            else { return nil }
            
            switch section {
            case .topInfo:
                return self.topInfoSection(with: layoutEnvironment)
                
            case .forecast:
                let shouldAddHeader = self.delegate?.layout(self, shouldAddHeaderFor: section, sectionIndex: sectionNumber) ?? false
                return self.weatherItemSection(with: layoutEnvironment, shouldAddHeader: shouldAddHeader)
            }
        }
    }
}

// MARK: - Private

extension DetailedCompositionalLayout {
    private func topInfoSection(with layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(230.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func weatherItemSection(with layoutEnvironment: NSCollectionLayoutEnvironment, shouldAddHeader: Bool) -> NSCollectionLayoutSection {
        let sideInset: CGFloat = 8.0
                
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140.0),
            heightDimension: .absolute(140.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sideInset, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: sideInset)
        
        if shouldAddHeader {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44.0)
            )
            let topicHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            topicHeaderItem.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [topicHeaderItem]
        }
        
        return section
    }
}
