//
//  PostDataTabViewController.swift
//  FirebaseSample
//
//  Created by Admin on 14/02/24.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore



class PostDataTabViewController: MABaseViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "add-image")
        
        return imageView
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Description"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let uidTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "UID"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isSelected = false
        button.isEnabled = true
        button.tintColor = .clear
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = .systemGreen
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let imagePicker = UIImagePickerController()
    
    
    // Firebase reference
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    //FirestoreDatabase
    let firestoreRef = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.removeFromSuperview()
        
        setupUI()
        
        imagePicker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostDataTabViewController.addImageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
    }
    
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(imageView)
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(uidTextField)
        view.addSubview(postButton)
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        uidTextField.delegate = self
        
        
        //constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 40),
            
            uidTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            uidTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            uidTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            uidTextField.heightAnchor.constraint(equalToConstant: 40),
            
            postButton.topAnchor.constraint(equalTo: uidTextField.bottomAnchor, constant: 20),
            postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            postButton.heightAnchor.constraint(equalToConstant: 40),
            postButton.widthAnchor.constraint(equalToConstant: 120)
            
        ])
        
    }
    @objc func addImageTapped(){
        pickImage()
    }
    
    func pickImage() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @objc func postButtonTapped() {
        
        print("add post tapped")
        guard let title = titleTextField.text,
              let description = descriptionTextField.text,
              let uid = uidTextField.text,
              let image = imageView.image else {
            self.showAlertWithOk(title: "Please fill all field to continue")
            return
        }
        
        
        // Upload image to Firebase Storage
        
        self.getDataLoadingAlert()
        FirebaseManager.shared.uploadImage(image: image) { imageUrl in
            if let imageUrl = imageUrl {
                // Once the image is uploaded, post data to Firebase Database
                FirebaseManager.shared.postDataToFirebase(title: title, description: description, uid: uid, imageUrl: imageUrl, completion: { uploadStatus in
                    self.dismissLoadingAlert(){
                        if uploadStatus{
                            self.clearAllFilledData()
                            self.showAlertWithOk(title: "Data Successfully added")
                        }else{
                            self.showAlertWithOk(title: "Data upload failed")
                        }
                    }
                })
            } else {
                self.dismissLoadingAlert(){
                    self.showAlertWithOk(title: "Image upload failed")
                    print("Image upload failed.")
                }
            }
        }
    }
    func clearAllFilledData(){
        descriptionTextField.text?.removeAll()
        titleTextField.text?.removeAll()
        uidTextField.text?.removeAll()
        imageView.image = UIImage(named: "add-image")
    }
                                                          
                                                        
                                                          
    
}

extension PostDataTabViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension PostDataTabViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        uidTextField.resignFirstResponder()
        
        return true
            
    }
}
