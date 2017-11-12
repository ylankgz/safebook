//
//  StartViewController.swift
//  Safebook
//
//  Created by Ulan on 10/16/17.
//  Copyright © 2017 SafebookApp. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func startTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "victSegue", sender: nil)
    }
    @IBAction func enterTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "specSegue", sender: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all //return the value as per the required orientation
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

}
