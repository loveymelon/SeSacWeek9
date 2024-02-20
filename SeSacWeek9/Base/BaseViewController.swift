//
//  BaseViewController.swift
//  SeSacWeek9
//
//  Created by 김진수 on 2/14/24.
//

import UIKit
import Toast

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureHierarchy()
        configureContraints()

    }
    
    func configureView() {
        view.backgroundColor = .white
        print(#function)
    }
    
    func configureHierarchy() {
        print(#function)
    }
    
    func configureContraints() {
        print(#function)
    }
    
//    func showAlert(title: String, message: String, ok: String, handler: @escaping ((UIAlertAction) -> Void)) {
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let ok = UIAlertAction(title: ok, style: .default, handler: handler)
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//        
//        alert.addAction(ok)
//        alert.addAction(cancel)
//        
//        present(alert, animated: true)
//    }
    
    // 위에랑 동일한 형태
    func showAlert(title: String, message: String, ok: String, handler: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: ok, style: .default) { _ in
            handler()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showToast(message: String) {
        view.makeToast(message)
    }

}
