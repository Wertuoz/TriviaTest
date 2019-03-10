//
//  BaseViewController.swift
//  TriviaTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import SVProgressHUD
import CoreData

extension UIViewController {
    
    func showAlertBar(with text: String, subText: String, style: BannerStyle = .danger) {
        let banner = GrowingNotificationBanner(title: "", subtitle: subText, style: style)
        banner.bannerHeight = 50
        banner.applyStyling(titleTextAlign: NSTextAlignment.center, subtitleTextAlign: NSTextAlignment.center)
        banner.show(on: self)
    }
    
    func showActivityIndicator() {
        SVProgressHUD.show()
    }
    
    func hideActivityIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func showSuccess(message: String, success: Bool = true) {
        if success {
            SVProgressHUD.setSuccessImage(UIImage(named: "correct")!)
            SVProgressHUD.setMinimumDismissTimeInterval(TimeInterval(exactly: 1)!)
            SVProgressHUD.showSuccess(withStatus: message)
        } else {
            SVProgressHUD.setDefaultStyle(.light)
            SVProgressHUD.setErrorImage(UIImage(named: "banned")!)
            SVProgressHUD.setMinimumDismissTimeInterval(TimeInterval(exactly: 1)!)
            SVProgressHUD.showError(withStatus: message)
        }
    }
    
    func hideSuccess() {
        SVProgressHUD.dismiss()
    }
}

extension UIButton {
    
    func animatePulsation() {
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 2.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 10
        layer.add(pulseAnimation, forKey: "animateScale")
    }
    
    func removePulsation() {
        layer.removeAllAnimations()
    }
}
