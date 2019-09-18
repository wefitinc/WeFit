//
//  ViewController.swift
//  WeFit
//
//  Created by Junior Alvarado on 9/16/19.
//  Copyright © 2019 WeFit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var LogoFrame: UIView!
    @IBOutlet private var LoginButton: SignUpButton!
    @IBOutlet private var SignupButton: SignUpButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        LogoFrame.layoutSubviews()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func LoginTapped(_ sender: SignUpButton) {
        LoginButton.shake()
    }
    @IBAction func SignupTapped(_ sender: SignUpButton) {
        SignupButton.shake()
    }
    
    
}

