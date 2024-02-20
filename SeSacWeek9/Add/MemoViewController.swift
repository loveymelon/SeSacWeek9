//
//  MemoViewController.swift
//  SeSacWeek9
//
//  Created by 김진수 on 2/14/24.
//

import UIKit
import SnapKit
import Then

class MemoViewController: BaseViewController {
    
    let memoTextField = UITextField().then { 
        $0.placeholder = "메모를 입력해보세요"
        $0.keyboardType = .default
    }
    
    var sesac: String?
    var delegate: PassDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // addObserver보다 post가 먼저 신호를 보내면, addObserver가 미리 보낸 post 신호를 받지 못한다!!!
        NotificationCenter.default.addObserver(self, selector: #selector(memoTestNotification), name: NSNotification.Name("memoTest"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.delegate?.memoReceived(text: memoTextField.text!)
    }
    
    override func configureHierarchy() {
        self.view.addSubview(memoTextField)
    }
    
    override func configureContraints() {
        self.memoTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
    }

    @objc func memoTestNotification(notification: NSNotification) {
        print("memoTestNotification")
    }
}
