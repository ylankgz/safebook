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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

}
