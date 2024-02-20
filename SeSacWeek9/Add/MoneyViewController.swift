//
//  MoneyViewController.swift
//  SeSacWeek9
//
//  Created by 김진수 on 2/14/24.
//

import UIKit
import Then
import SnapKit

class MoneyViewController: BaseViewController {
    
    let moneyTextField = UITextField().then {
        $0.placeholder = "금액을 입력해보세요"
        $0.keyboardType = .numberPad
    }
    
    var money: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 키보드 자동 올라오기
        moneyTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Responder Chain
        // 키보드 자동 내려가기
//        moneyTextField.resignFirstResponder()
        
    }
    
    // 화면이 조금이라도 사라지기 전에 실행
    // 만약 데이터를 저장한다면 유저가 화면을 잡고 옆으로 왔다갔다하면 계속 저장하는 상황이 벌어질 수도 있다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // 화면이 완전히 사라지고 실행
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print(moneyTextField.text!)
        money?(moneyTextField.text!)
    }

    override func configureHierarchy() {
        self.view.addSubview(moneyTextField)
    }
    
    override func configureContraints() {
        self.moneyTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
    }
    
}
