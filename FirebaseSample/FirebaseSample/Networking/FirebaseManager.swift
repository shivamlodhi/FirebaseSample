//
//  FirebaseManager.swift
//  FirebaseSample
//
//  Created by Admin on 13/02/24.
//


import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore



class FirebaseManager {
    static let shared = FirebaseManager()
    
    // Firebase reference
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()

    func createUser(email: String, password: String,completion: @escaping (Bool,String?) -> Void) {
        // [START create_user]
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // [START_EXCLUDE]
            guard let user = authResult?.user, error == nil else {
                print("user creation failed",error?.localizedDescription ?? "An error occurred")
                completion(false,error?.localizedDescription)
                return
            }
            print("\(user.email!) created")
            completion(true,nil)
        }
    }

    func signIn(email: String, password: String,completion: @escaping (Bool,String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("user sign-in failed")
                completion(false,error?.localizedDescription)
                return
            }
            print("\(user.email!) signed in")
            completion(true,nil)
        }
    }

    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        print("Upload Image")
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Error converting image to data.")
            completion(nil)
            return
        }
        
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Once the image is uploaded, get the download URL
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let imageUrl = url?.absoluteString else {
                    print("Error retrieving download URL.")
                    completion(nil)
                    return
                }
                completion(imageUrl)
            }
        }
    }

    func postDataToFirebase(title: String, description: String, uid: String, imageUrl: String, completion: @escaping (Bool) -> Void) {
        // Firestore reference
        let firestoreRef = Firestore.firestore().collection("Posts")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let creationDate = dateFormatter.string(from: Date())
        
        let postData: [String: Any] = [
            "title": title,
            "description": description,
            "uid": uid,
            "imageUrl": imageUrl,
            "creationDate": creationDate
        ]
        
        firestoreRef.addDocument(data: postData) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(false)
            } else {
                print("Document added successfully!")
                completion(true)
            }
        }
    }

    
    func retrieveAllPostsFromFirestore(completion: @escaping ([Post]?, Error?) -> Void) {
        // Firestore reference
        let firestoreRef = Firestore.firestore().collection("Posts")

        // Retrieve all documents from the "Posts" collection
        firestoreRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var posts: [Post] = []

                for document in querySnapshot!.documents {
                    // Mapping firebase data to Post
                    if let post = Post(documentData: document.data()) {
                        posts.append(post)
                    }
                }

                completion(posts, nil)
            }
        }
    }


}
