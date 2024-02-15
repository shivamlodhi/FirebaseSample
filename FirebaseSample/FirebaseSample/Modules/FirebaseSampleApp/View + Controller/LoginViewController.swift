
//  LoginScreenViewController.swift
//  FirebaseSample
//
//  Created by Admin on 13/02/24.
//

import UIKit

class LoginViewController: MABaseViewController {
    
    var window:UIWindow?
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return tf
        
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return tf
        
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return tf
        
    }()
    
    let signInButton : UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        return button
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        emailTextField.delegate = self
        passwordTextField.delegate = self
        signInButton.addTarget(self, action: #selector(LoginViewController.signInButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(LoginViewController.signUpButtonTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
        setupTextFields()
        title = "Login Page"
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
    }
    func setupTextFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton,signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //add stack view as subview to main view with AutoLayout
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 250),

        ])
    }
    
     @objc func signInButtonTapped(){
        
        if(emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false){
        
            self.getDataLoadingAlert()
            FirebaseManager.shared.signIn(email: emailTextField.text!, password: passwordTextField.text!, completion: {isSuccess,errorMessage in
                
                self.dismissLoadingAlert(){
                    if isSuccess{
                        
                        //Set tab bar as default view Controller
                        let secondVC = TabBarViewController()
                        self.navigationController?.pushViewController(secondVC, animated: true)
//                        let scene = UIApplication.shared.connectedScenes.first
//                        let window = UIWindow(windowScene: scene! as! UIWindowScene)
//                        let navigation = UINavigationController(rootViewController: secondVC )
//                        window.rootViewController = navigation
//                        self.window = window
//                        window.makeKeyAndVisible()
                        
                    }else{
                        self.showAlertWithOk(title: errorMessage ?? "An error occurred")
                    }
                }
            })
            
        }else{
            showAlertWithOk(title: "Please fill all field")
        }
    }
    
    @objc func signUpButtonTapped() {
        print("Button Tapped")
        guard let navigationController = self.navigationController else {
              print("Navigation controller is nil")
              return
          }
          
          let secondVC = SignUpViewController()
          navigationController.pushViewController(secondVC, animated: true)

    }
    

}

extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
