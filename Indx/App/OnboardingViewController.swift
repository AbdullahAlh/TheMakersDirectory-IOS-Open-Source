//
//  OnboardingViewController.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/28/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    
    private let messages = [
        NSLocalizedString("ONBOARDING_MSG_1", comment: ""),
        NSLocalizedString("ONBOARDING_MSG_2", comment: ""),
        NSLocalizedString("ONBOARDING_MSG_3", comment: ""),
    ]
    
    private var currentLabel = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        proceedButton.backgroundColor = App.tint
        proceedButton.setTitle(NSLocalizedString("ONBOARDING_PROCEED_BTN", comment: ""), for: .normal)
        messageLabel.text = messages[0]
        
        Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    func tick() {
        
        currentLabel += 1
        
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.3
        
        messageLabel.layer.add(animation, forKey: "fade-animation")
        messageLabel.text = messages[currentLabel % messages.count]
    }
}
