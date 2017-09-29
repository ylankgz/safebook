import UIKit
import FirebaseAuth

class SignupVC: UIViewController {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var userSwitch: UISwitch!
    @IBOutlet weak var specLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    var signupMode = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        if signupMode {
            signupButton.setTitle("Login", for: .normal)
            loginButton.setTitle("Switch to Sign up", for: .normal)
            specLabel.isHidden = true
            userLabel.isHidden = true
            userSwitch.isHidden = true
            signupMode = false
        } else {
            signupButton.setTitle("Sign up", for: .normal)
            loginButton.setTitle("Login", for: .normal)
            specLabel.isHidden = false
            userLabel.isHidden = false
            userSwitch.isHidden = false
            signupMode = true
        }
    }
    @IBAction func signupTapped(_ sender: Any) {
        if emailTextField.text! == "" || pwTextField.text! == "" {
            displayAlert(title: "Missing information", message: "You must provide both email and password!")
        } else {
            if signupMode {
                FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: pwTextField.text!, completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        print("Signed up")
                    }
                })
            } else {
                FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: pwTextField.text!, completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        print("Logged in")
                    }
                })
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}



