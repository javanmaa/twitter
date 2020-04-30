//
//  LoginViewController.swift
//  Twitter
//
//  Created by aria javanmard on 4/29/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func Login_Button(_ sender: Any) {
        let TWURL = "https://api.twitter.com/oauth/request_token"
        UserDefaults.standard.set(true, forKey: "User Logged in")
        TwitterAPICaller.client?.login(url: TWURL, success: {
        self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { Error in
        print("couldn't login")
        
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "User Logged in") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
