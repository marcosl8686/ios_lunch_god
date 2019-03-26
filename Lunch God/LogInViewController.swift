//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD
import LocalAuthentication
import KeychainAccess

class LogInViewController: UIViewController {
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet weak var touchFaceIdBtn: UIButton!
    let keychain = Keychain(service: "com.marcoslee.lunch-God")
    override func viewDidLoad() {
        super.viewDidLoad()
        touchFaceIdBtn.isHidden = true
        getCredentials()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    var secretEmail: String = ""
    var secretPassword: String = ""
    
    @IBAction func touchIdBtn(_ sender: Any) {
        let context: LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Login with Face/Touch ID") { (wasSuccessful, error) in
                if wasSuccessful {
                    print("Face Touch ID successful")
                    self.loginWithFB(userEmail: self.secretEmail, userPassword: self.secretPassword)
                } else {
                    print("Face/TouchID login Failed")
                    let alert = UIAlertController(title: "Failed To Login with Touch/FaceId credentials", message: "Please Try Again!", preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                }
            }
        } else {
            print("FACE/Touch ID not set")
        }
        
    }
    @IBAction func logInPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        loginWithFB(userEmail: emailTextfield.text!, userPassword: passwordTextfield.text!)
    }
    
    func saveCredentials() {
        print("Saving")
        let username:String = emailTextfield.text!
        let password:String = passwordTextfield.text!
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "username")
        defaults.set(password, forKey: "password")
    }
    
    func getCredentials() {
        print("loading")
        let defaults = UserDefaults.standard
        
        if let userPassword = defaults.string(forKey: "password") {
            self.secretEmail = defaults.string(forKey: "username")!
            self.secretPassword = userPassword
            self.emailTextfield.text = self.secretEmail
            touchFaceIdBtn.isHidden = false
        }
    }
    
    func loginWithFB(userEmail: String, userPassword: String) {
        //Log in the user
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Log in succesful!")
                self.saveCredentials()
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToFirstPage", sender: self)
            }
            
        }
    }
    
    
    
}  
