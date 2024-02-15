//
//  SignUpViewController.swift
//  FirebaseSample
//
//  Created by Admin on 14/02/24.
//

import UIKit

class SignUpViewController: MABaseViewController {
    
    
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
        signUpButton.addTarget(self, action: #selector(SignUpViewController.signUpButtonTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
        setupTextFields()
        //title = ""
        
    }
    
    func setupTextFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,signUpButton])
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
            stackView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    @objc func signUpButtonTapped() {
        
        if(emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false){
            
            self.getDataLoadingAlert()
            FirebaseManager.shared.createUser(email: emailTextField.text!, password: passwordTextField.text!, completion: {isSuccess,errorMessage in
                self.dismissLoadingAlert(){
                    if isSuccess{
                        self.showAlertWithOkAction(title: "Registration successful")
                        
                    }else{
                        self.showAlertWithOk(title: errorMessage ?? "An error occurred")
                    }
                }
            })
        }else{
            showAlertWithOk(title: "Please fill all field")

        }
    
    }

}

extension SignUpViewController :UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
