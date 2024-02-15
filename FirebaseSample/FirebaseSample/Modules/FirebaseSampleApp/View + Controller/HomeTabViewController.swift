//
//  HomeTabViewController.swift
//  FirebaseSample
//
//  Created by Admin on 14/02/24.
//

import UIKit

class HomeTabViewController: MABaseViewController {
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var postData = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "Home"
        
        // Set up the table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "imageCell")
        
        // Add the table view to the view hierarchy
        view.addSubview(tableView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        //Fetch data from firebase
        self.getPostData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getPostData()
    }
    
    func getPostData(){
        
        self.getDataLoadingAlert()
        FirebaseManager.shared.retrieveAllPostsFromFirestore(completion: {postData,error in
            self.dismissLoadingAlert(){
                if error == nil{
                    print(postData as Any)
                    if let data = postData{
                        if data.isEmpty{
                            print("List is empty")
                        }else{
                            DispatchQueue.main.async {
                                self.postData = data
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        })
    }
    
    
}

extension HomeTabViewController :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! PostTableViewCell
        
        cell.configureCell(title: postData[indexPath.row].title, description: postData[indexPath.row].description, date: postData[indexPath.row].creationDate, imageName: postData[indexPath.row].imageUrl)
        
        return cell
    }
}
