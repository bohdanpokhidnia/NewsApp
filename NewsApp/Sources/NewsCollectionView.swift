//
//  NewsTableView.swift
//  NewsApp
//
//  Created by Bogdan Pohidnya on 15.04.2021.
//

import UIKit

final class NewsCollectionView: View {
    
    // MARK: - UI
    
    private(set) var refreshControl = UIRefreshControl()
    
//    private(set) lazy var tableView = UICollectionView()
//        .make {
//            $0.register(class: NewsCollectionViewCell.self)
//            $0.setEmptyFooter()
//            $0.refreshControl = refreshControl
//            $0.separatorStyle = .none
//            $0.setRowHeight(310)
//        }
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(class: NewsCollectionViewCell.self)
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(collectionView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Override methods
    
    override func apply(theme: AppTheme) {
        super.apply(theme: theme)
        
        collectionView.backgroundColor(color: theme.components.backgroundColor)
    }
    
}