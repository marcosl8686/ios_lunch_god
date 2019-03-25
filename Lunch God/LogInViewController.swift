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
    let keychain = Keychain(service: "com.marcoslee.lunch-God")
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBAction func touchIdBtn(_ sender: Any) {
        let context: LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Login with Face/Touch ID") { (wasSuccessful, error) in
                if wasSuccessful {
                    print("Face Touch ID successful")
//                    self.performSegue(withIdentifier: "goToFirstPage", sender: self)
                    self.getCredentials()
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
        DispatchQueue.global().async {
            do {
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .set(self.passwordTextfield.text!, key: "userPassword")
            } catch let error {
                print(error)
            }
            
            do {
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .set(self.emailTextfield.text!, key: "userEmail")
            } catch let error {
                print(error)
            }
        }
    }
    
    func getCredentials() {
        print("loading")
        DispatchQueue.global().async {
            do {
                let secretEmail = try self.keychain.authenticationPrompt("Authenticate to find out the userEmail")
                    .get("userEmail")
                let secretPassword = try self.keychain.authenticationPrompt("Authenticate to find out the userPassword")
                    .get("userPassword")
               self.loginWithFB(userEmail: secretEmail!, userPassword: secretPassword!)
            } catch let error {
                print(error)
            }
            
            do {
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .set(self.emailTextfield.text!, key: "userEmail")
            } catch let error {
                print(error)
            }
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
