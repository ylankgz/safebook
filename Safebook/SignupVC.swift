import UIKit
import FirebaseAuth

class SignupVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    var signupMode = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        if signupMode {
            signupButton.setTitle("Login".localize, for: .normal)
            loginButton.setTitle("switch to signup".localize, for: .normal)
            nameTextField.isHidden = true
            signupMode = false
        } else {
            signupButton.setTitle("Sign Up".localize, for: .normal)
            loginButton.setTitle("switch to login".localize, for: .normal)
            nameTextField.isHidden = false
            signupMode = true
        }
    }
    @IBAction func signupTapped(_ sender: Any) {
        if emailTextField.text! == "" || pwTextField.text! == "" {
            if signupMode && nameTextField.text! == "" {
                displayAlert(title: "Missing information".localize, message: "You must provide name, email and password!".localize)
            } else {
                displayAlert(title: "Missing information".localize, message: "You must provide both email and password!".localize)
            }
        } else {
            if signupMode {
                FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: pwTextField.text!, completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error".localize, message: error!.localizedDescription)
                    } else {
                            // User
                        let req = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                        req?.displayName = self.nameTextField.text!
                        req?.commitChanges(completion: nil)
                        self.performSegue(withIdentifier: "userSegue", sender: nil)
                    }
                })
            } else {
                FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: pwTextField.text!, completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error".localize, message: error!.localizedDescription)
                    } else {
//                        if (user?.displayName?.starts(with: "Victim"))! {
//                            // Victim
//                            self.performSegue(withIdentifier: "specSegue", sender: nil)
//                        } else {
                            // User
                            self.performSegue(withIdentifier: "userSegue", sender: nil)
//                        }
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
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all //return the value as per the required orientation
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}



