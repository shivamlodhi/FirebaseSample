//
//  BaseClass.swift
//  FirebaseSample
//
//  Created by Admin on 14/02/24.
//
import UIKit

class MABaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkNetworkIsAvailable() -> Bool{
        if !Reachability.isConnectedToNetwork() {
            self.showNetWorkError()
            return true
        }
        return false
    }
    
    func showNetWorkError(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Devices is not connected with Internet!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.)+[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.)+[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func showAlertWithOk(title:String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: false)
    }
    func showAlertWithOkAction(title:String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: false)
    }
    
    // Loading Alert
    func getDataLoadingAlert(){
        DispatchQueue.main.async { [self] in
            let alert = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 60
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    func dismissLoadingAlert(completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.dismiss(animated: false, completion: nil)
            completion?()
        }
    }
}
