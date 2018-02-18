//
//  GHSScrollPositionFix.swift
//  iPad Scroll Position Fix
//
//  Created by John Brayton on 2/18/18.
//  Copyright © 2018 John Brayton. All rights reserved.
//

import UIKit

class GHSScrollPositionFix: NSObject {

    let scrollView: UIScrollView
    var scrollPositionInfoBySizeHash: [String:ScrollPositionInfo]
    
    @objc
    init( scrollView: UIScrollView ) {
        self.scrollView = scrollView
        self.scrollPositionInfoBySizeHash = [String:ScrollPositionInfo]()
    }
    
    @objc
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let applicationState = UIApplication.shared.applicationState
        if (applicationState != .background) {
            self.scrollPositionInfoBySizeHash.removeAll()
        } else {
            let newSizeString = self.hashableString(forSize: size)
            if let scrollPositionInfo = self.scrollPositionInfoBySizeHash[newSizeString] {
                coordinator.animate(alongsideTransition: { (context) in
                    //
                }, completion: { [weak self] (context) in
                    if let table = self?.scrollView as? UITableView, let indexPath = scrollPositionInfo.indexPathOfLastVisibleRow, let relative = scrollPositionInfo.relativeYOffsetOfLastVisibleRow {
                        if indexPath.section < table.numberOfSections, indexPath.row < table.numberOfRows(inSection: indexPath.section) {
                            table.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: false)
                        }
                        var newOffset = table.contentOffset;
                        if let cell = table.cellForRow(at: indexPath) {
                            newOffset.y = cell.frame.origin.y + relative;
                            self?.scroll(toContentOffset: newOffset)
                        }
                    } else {
                        self?.scroll(toContentOffset: scrollPositionInfo.contentOffset)
                    }
                })
            } else {
                // According to second answer from: https://stackoverflow.com/questions/42782594/ios-wrong-uiscreen-bounds-in-viewwilltransition-for-ipad
                // size should be compared to coordinator.containerView.bounds.size
                let previousSizeString = self.hashableString(forSize: coordinator.containerView.bounds.size)
                if let table = self.scrollView as? UITableView, let lastIndexPath = table.indexPathsForVisibleRows?.last, let lastCell = table.cellForRow(at: lastIndexPath) {
                    let relativeYOffsetOfLastVisibleRow = table.contentOffset.y - lastCell.frame.origin.y
                    self.scrollPositionInfoBySizeHash[previousSizeString] = ScrollPositionInfo(contentOffset: self.scrollView.contentOffset, indexPathOfLastVisibleRow: lastIndexPath, relativeYOffsetOfLastVisibleRow: relativeYOffsetOfLastVisibleRow)
                } else {
                    let offset = self.scrollView.contentOffset
                    self.scrollPositionInfoBySizeHash[previousSizeString] = ScrollPositionInfo(contentOffset: offset, indexPathOfLastVisibleRow: nil, relativeYOffsetOfLastVisibleRow: nil)
                }
                
            }
        }
    }
    
    private func hashableString( forSize size: CGSize ) -> String {
        return String(format: "%fx%f", arguments: [size.width, size.height])
    }
    
    private func scroll( toContentOffset contentOffset: CGPoint ) {
        var scrollTo = contentOffset
        let maxX = self.scrollView.contentSize.width - self.scrollView.bounds.width + self.scrollView.contentInset.right
        let maxY = self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom
        
        let minX = 0 - self.scrollView.contentInset.left
        let minY = 0 - self.scrollView.contentInset.top
        if (scrollTo.x > maxX) {
            scrollTo.x = maxX
        }
        if (scrollTo.y > maxY) {
            scrollTo.y = maxY
        }
        if (scrollTo.x < minX) {
            scrollTo.x = minX
        }
        if (scrollTo.y < minY) {
            scrollTo.y = minY
        }
        self.scrollView.contentOffset = scrollTo
    }
    
    struct ScrollPositionInfo {
        let contentOffset: CGPoint
        let indexPathOfLastVisibleRow: IndexPath?
        let relativeYOffsetOfLastVisibleRow: CGFloat?
    }
    
}
