//
//  TabBarController.swift
//  map
//
//  Created by 코드잉 on 2021/03/18.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    private var tabBarHeight = CGFloat()
    private var tabBarY = CGFloat()
    private var smartAroundViewController: SmartAroundViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        getTabBarSize()
        tabViewStyling()
        setForGestureRecognizer()
        modifyViewSize(to: .mid)
        smartAroundViewController = viewControllers?[safe: 0] as? SmartAroundViewController
        delegate = self
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass {
            modifyViewSize(to: .mid)
        }
    }

    private func getTabBarSize() {
        tabBarHeight = tabBar.frame.height
        tabBarY = UIScreen.main.bounds.height - tabBarHeight
    }

    private func setForGestureRecognizer() {
        let panSwipeGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.handlePanGesture))
        view.addGestureRecognizer(panSwipeGestureRecognizer)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if view.frame.height < ScreenSize.mid.getPortraitFrame().height {
            animateView(toSize: .mid)
        }
        let tabbarTitle = tabBarController.tabBar.selectedItem?.title
        if tabbarTitle == Setting.TabType.smartAround.rawValue {
            (parent as? DefaultViewController)?.updateSmartAroundTabInfo()
        }
    }

    private func tabViewStyling() {
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        tabBar.unselectedItemTintColor = .black
        tabBar.barTintColor = UIColor.init(cgColor: UIColor.white.cgColor)
    }

    private func getCurrentScreenSize(_ size: ScreenSize) -> TabViewFrame {
        if traitCollection.verticalSizeClass == .regular {
            return size.getPortraitFrame()
        } else {
            return size.getLandscapeFrame()
        }
    }

    private func modifyViewSize (to size: ScreenSize) {
        getTabBarSize()
        let newFrame = getCurrentScreenSize(size)

        if newFrame.height != 0 {
            view.frame = CGRect(x: newFrame.originX,
                                y: newFrame.originY,
                                width: newFrame.width,
                                height: newFrame.height)
        } else {
            view.frame = CGRect(x: newFrame.originX,
                                y: tabBarY,
                                width: newFrame.width,
                                height: tabBarHeight)
        }
    }

    func animateView(toSize size: ScreenSize) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 2.0,
                       initialSpringVelocity: 2.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.modifyViewSize(to: size)
                       }, completion: nil)
    }

    private func handleChangedState(value: CGFloat) {
        getTabBarSize()

        if value <= getCurrentScreenSize(.full).originY {
            modifyViewSize(to: .full)
        } else if value >= UIScreen.main.bounds.height - tabBarHeight {
            modifyViewSize(to: .low)
        } else {
            view?.frame = CGRect(x: view.frame.minX,
                                 y: value,
                                 width: view.frame.width,
                                 height: UIScreen.main.bounds.height - value)
        }
    }

    private func handleEndedState(direction: CGFloat, value: CGFloat) {
        let fullScreenY = getCurrentScreenSize(.full).originY
        let midScreenY = getCurrentScreenSize(.mid).originY

        if direction >= 0 {
            if value <= midScreenY && value >= fullScreenY {
                animateView(toSize: .mid)
            } else if value > midScreenY {
                animateView(toSize: .low)
            }
            smartAroundViewController?.isScrollEnabled(false)
        } else {
            if value >= midScreenY {
                animateView(toSize: .mid)
            } else {
                animateView(toSize: .full)
                smartAroundViewController?.isScrollEnabled(true)
            }
        }
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let currentY = view.frame.origin.y
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: view)
            handleChangedState(value: currentY + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        case .ended, .cancelled:
            handleEndedState(direction: sender.velocity(in: view).y, value: currentY)
        default:
            break
        }
    }
}
