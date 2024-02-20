//
//  CategoryViewController.swift
//  SeSacWeek9
//
//  Created by 김진수 on 2/14/24.
//

import UIKit
import SnapKit
import Then

class CategoryViewController: BaseViewController {
    
    let categoryTextField = UITextField().then {
        $0.placeholder = "카테고리를 입력해보세요."
        $0.keyboardType = .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // post
        NotificationCenter.default.post(name: NSNotification.Name("CategoryReceived"), object: nil, userInfo: ["nickname": "jack", "category": categoryTextField.text!])
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print(categoryTextField.text!)
    }

    override func configureHierarchy() {
        self.view.addSubview(categoryTextField)
    }
    
    override func configureContraints() {
        self.categoryTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
    }

}
