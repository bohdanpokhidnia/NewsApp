//
//  DetailsView.swift
//  NewsApp
//
//  Created by Bogdan Pohidnya on 16.04.2021.
//

import UIKit

final class DetailsView: View {
    
    struct State {
        var articleImageUrl: String?
        var title: String
        var author: String?
        var publishedAt: String
        var description: String?
        var sourceName: String
    }
    
    // MARK: - UI
    
    private let articleImage = KFImageView()
        .backgroundColor(color: .gray)
        .setContentMode(.scaleToFill)
        .maskToBounds(true)
    
    private(set) var closeButton = Button()
        .setImage(R.image.icNavBarClose())
    
    private lazy var contentStack = makeStackView(axis: .vertical, spacing: 10) (
        titleLabel,
        authorLabel,
        descriptionLabel,
        emptyView,
        openButton
    )
    .make { $0.setCustomSpacing(15, after: authorLabel) }
    
    private let titleLabel = Label()
        .enableMultilines()
    
    private let authorLabel = Label()
    
    private let descriptionLabel = Label()
        .enableMultilines()
    
    private let emptyView = View()
    
    private(set) var openButton = Button()
        .setImage(R.image.icExternalLink())
        .title(hAlignment: .center)
        .setCornerRadius(20)
        .maskToBounds(true)
        .make {
            $0.titleEdgeInsets = .init(aLeft: 8)
        }
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubviews(articleImage, closeButton, contentStack)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(layoutMarginsGuide).inset(UIEdgeInsets(aTop: 8))
            $0.trailing.equalToSuperview().inset(UIEdgeInsets(aRight: 18))
            $0.width.height.equalTo(36)
        }
        
        articleImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        contentStack.snp.makeConstraints {
            $0.top.equalTo(articleImage.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 18))
            $0.bottom.equalTo(layoutMarginsGuide).inset(UIEdgeInsets(aBottom: 10))
        }
        
        openButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
    }
    
    // MARK: - Override methods
    
    override func apply(theme: AppTheme) {
        super.apply(theme: theme)
        
        backgroundColor(color: theme.components.backgroundColor)
        
        let detailsStyle = theme.components.details
        
        titleLabel
            .textColor(detailsStyle.title.color)
            .text(font: detailsStyle.title.font)
        
        authorLabel
            .textColor(detailsStyle.author.color)
            .text(font: detailsStyle.author.font)
        
        descriptionLabel
            .textColor(detailsStyle.description.color)
            .text(font: detailsStyle.description.font)
        
        openButton
            .titleColor(detailsStyle.button.text.color)
            .titleColor(detailsStyle.button.text.color.withAlphaComponent(0.6), for: .highlighted)
            .text(font: detailsStyle.button.text.font)
            .background(color: detailsStyle.button.background.color)
    }
    
}

// MARK: - Set

extension DetailsView {
    
    @discardableResult
    func set(state: State) -> Self {
        articleImage.setImage(path: state.articleImageUrl, placeholder: R.image.newsPlaceholder())
        titleLabel.text(state.title)
        authorLabel.text(state.author ?? R.string.localizable.feedWithoutAuthor())
        descriptionLabel.text(state.description ?? R.string.localizable.detailsWithoutDescription())
        openButton.title(R.string.localizable.detailsOpen(state.sourceName.lowercased()))
        return self
    }
    
    @discardableResult
    func set(publishAt: String) -> Self {
        authorLabel.make {
            $0.text? += " | " + publishAt
        }
        return self
    }
    
}
