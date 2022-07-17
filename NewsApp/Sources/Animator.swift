//
//  Animator.swift
//  NewsApp
//
//  Created by Bohdan Pokhidnia on 15.07.2022.
//

import UIKit

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    enum PresentationType {
        case present
        case dismiss

        var isPresenting: Bool {
            return self == .present
        }
    }
    
    static let duration: TimeInterval = 0.6

    private let type: PresentationType
    private let fromViewController: FeedViewController
    private let toViewController: DetailsViewController
    private let window: UIWindow
    private var selectedCellImageViewSnapshot: UIView
    
    private let cellImageViewCoordinate: CGRect
    private let cellLabelCoordinate: CGRect
    private let cellAuthorLabelCoordinate: CGRect

    init?(type: PresentationType, fromViewController: FeedViewController, toViewController: DetailsViewController, selectedCell: NewsCollectionViewCell) {
        guard let window = fromViewController.contentView.window ?? toViewController.contentView.window,
              let selectedCellImageViewSnapshot = selectedCell.articleImageView.snapshotView(afterScreenUpdates: true)
        else { return nil }
        
        self.type = type
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.window = window
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        
        self.cellImageViewCoordinate = selectedCell.articleImageView.convert(selectedCell.articleImageView.bounds, to: window)
        self.cellLabelCoordinate = selectedCell.titleLabel.convert(selectedCell.titleLabel.bounds, to: window)
        self.cellAuthorLabelCoordinate = selectedCell.authorLabel.convert(selectedCell.authorLabel.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = toViewController.view else {
            transitionContext.completeTransition(false)
            return
        }
        
        let isPresenting = type.isPresenting
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        guard let selectedCell = fromViewController.selectedCell,
              let cellImageSnapshot = selectedCell.articleImageView.snapshotView(afterScreenUpdates: true),
              let controllerImageSnapshot = toViewController.contentView.articleImage.snapshotView(afterScreenUpdates: true),
              var cellTitleLabelSnapshot = selectedCell.titleLabel.snapshotView(afterScreenUpdates: true),
              var cellAuthorLabelSnapshot = selectedCell.authorLabel.snapshotView(afterScreenUpdates: true),
              let controllerDescriptionLabelSnapshot = toViewController.contentView.descriptionLabel.snapshotView(afterScreenUpdates: true),
              let controllerCloseButtonSnapshot = toViewController.contentView.closeButton.snapshotView(afterScreenUpdates: true),
              let controllerShareButtonSnapshot = toViewController.contentView.shareButton.snapshotView(afterScreenUpdates: true)
        else {
            transitionContext.completeTransition(true)
            return
        }

        let backgroundView: UIView
        let fadeView = UIView()
        fadeView.backgroundColor = toViewController.contentView.backgroundColor
        
        var cellFadeViewCoordinate = selectedCell.contentView.convert(selectedCell.contentView.bounds, to: window)
        cellFadeViewCoordinate.origin.x += selectedCell.leftCellOffset
        cellFadeViewCoordinate.origin.y += selectedCell.topCellOffset
        cellFadeViewCoordinate.size.width = selectedCell.bounds.width - (selectedCell.leftCellOffset + selectedCell.rightCellOffset)
        
        let controllerFadeViewCoordinate = toViewController.view.convert(toViewController.view.bounds, to: window)
        fadeView.frame = isPresenting ? cellFadeViewCoordinate : controllerFadeViewCoordinate

        if isPresenting {
            if let presentedCellLabelSnapshot = toViewController.contentView.titleLabel.snapshotView(afterScreenUpdates: true) {
                cellTitleLabelSnapshot = presentedCellLabelSnapshot
            }
            
            if let presentedCellAuthorLabelSnapshot = toViewController.contentView.authorLabel.snapshotView(afterScreenUpdates: true) {
                cellAuthorLabelSnapshot = presentedCellAuthorLabelSnapshot
            }
            
            selectedCellImageViewSnapshot = cellImageSnapshot
            backgroundView = UIView(frame: containerView.bounds)
        } else {
            backgroundView = fromViewController.contentView.snapshotView(afterScreenUpdates: true) ?? fadeView
        }
        
        backgroundView.addSubview(fadeView)
        toView.alpha = 0
        
        containerView.addSubviews(
            backgroundView,
            selectedCellImageViewSnapshot,
            controllerImageSnapshot,
            cellTitleLabelSnapshot,
            cellAuthorLabelSnapshot,
            controllerDescriptionLabelSnapshot,
            controllerCloseButtonSnapshot,
            controllerShareButtonSnapshot
        )

        let controllerImageViewCoordinate = toViewController.contentView.articleImage.convert(toViewController.contentView.articleImage.bounds, to: window)
        let controllerLabelCoordinate = toViewController.contentView.titleLabel.convert(toViewController.contentView.titleLabel.bounds, to: window)
        let controllerAuthorLabelCoordinate = toViewController.contentView.authorLabel.convert(toViewController.contentView.authorLabel.bounds, to: window)
        let controllerDescriptionLabelCoordinate = toViewController.contentView.descriptionLabel.convert(toViewController.contentView.descriptionLabel.bounds, to: window)
        let controllerCloseButtonCoordinate = toViewController.contentView.closeButton.convert(toViewController.contentView.closeButton.bounds, to: window)
        let controllerShareButtonCoordinate = toViewController.contentView.shareButton.convert(toViewController.contentView.shareButton.bounds, to: window)

        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            $0.frame = isPresenting ? cellImageViewCoordinate : controllerImageViewCoordinate
        }
        
        [fadeView, selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            $0.layer.cornerRadius = isPresenting ? 15 : 0
            $0.layer.masksToBounds = true
        }

        controllerImageSnapshot.alpha = isPresenting ? 0 : 1
        selectedCellImageViewSnapshot.alpha = isPresenting ? 1 : 0

        cellTitleLabelSnapshot.frame = isPresenting ? cellLabelCoordinate : controllerLabelCoordinate
        cellAuthorLabelSnapshot.frame = isPresenting ? cellAuthorLabelCoordinate : controllerAuthorLabelCoordinate
            
        controllerDescriptionLabelSnapshot.frame = isPresenting ? makeMoveToUpFrame(for: controllerDescriptionLabelSnapshot, isPresenting: isPresenting) :  controllerDescriptionLabelCoordinate
        controllerDescriptionLabelSnapshot.alpha = isPresenting ? 0 : 1

        controllerCloseButtonSnapshot.frame = controllerCloseButtonCoordinate
        controllerCloseButtonSnapshot.alpha = isPresenting ? 0 : 1
        
        controllerShareButtonSnapshot.frame = isPresenting ? makeMoveToDownFrame(for: controllerShareButtonSnapshot) : controllerShareButtonCoordinate

        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                fadeView.frame = isPresenting ? controllerFadeViewCoordinate : cellFadeViewCoordinate
                
                self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewCoordinate : self.cellImageViewCoordinate
                controllerImageSnapshot.frame = isPresenting ? controllerImageViewCoordinate : self.cellImageViewCoordinate

                cellTitleLabelSnapshot.frame = isPresenting ? controllerLabelCoordinate : self.cellLabelCoordinate
                cellAuthorLabelSnapshot.frame = isPresenting ? controllerAuthorLabelCoordinate : self.cellAuthorLabelCoordinate

                [fadeView, controllerImageSnapshot, self.selectedCellImageViewSnapshot].forEach {
                    $0.layer.cornerRadius = isPresenting ? 0 : 15
                }
            }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
                
                controllerShareButtonSnapshot.frame = isPresenting ? controllerShareButtonCoordinate : self.makeMoveToDownFrame(for: controllerShareButtonSnapshot)
            }

            UIView.addKeyframe(withRelativeStartTime: isPresenting ? 0.7 : 0, relativeDuration: isPresenting ? 0.3 : 0) {
                controllerDescriptionLabelSnapshot.frame = isPresenting ? controllerDescriptionLabelCoordinate : self.makeMoveToUpFrame(for: controllerDescriptionLabelSnapshot, isPresenting: isPresenting)
                controllerDescriptionLabelSnapshot.alpha = isPresenting ? 1 : 0
                
                controllerCloseButtonSnapshot.alpha = isPresenting ? 1 : 0
            }
        }, completion: { (isFinish) in
            [backgroundView,
             self.selectedCellImageViewSnapshot,
             controllerImageSnapshot,
             cellTitleLabelSnapshot,
             cellAuthorLabelSnapshot,
             controllerCloseButtonSnapshot,
             controllerShareButtonSnapshot
            ].forEach {
                $0.removeFromSuperview()
            }

            toView.alpha = 1
            transitionContext.completeTransition(isFinish)
        })
    }
}

// MARK: - Private

private extension Animator {
    
    func makeMoveToUpFrame(for view: UIView, isPresenting: Bool) -> CGRect {
        let x = (window.frame.width / 2) - (view.frame.width / 2)
        let y: CGFloat = isPresenting ? (window.frame.height / 2) : view.frame.origin.y + view.frame.height
        
        return .init(origin: .init(x: x, y: y), size: view.frame.size)
    }
    
    func makeMoveToDownFrame(for view: UIView) -> CGRect {
        let x = (window.frame.width / 2) - (view.frame.width / 2)
        let y = window.frame.height
        
        return .init(origin: .init(x: x, y: y), size: view.frame.size)
    }
    
}
