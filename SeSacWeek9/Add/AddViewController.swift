//
//  AddViewController.swift
//  SeSacWeek9
//
//  Created by 김진수 on 2/14/24.
//

import UIKit
import SnapKit
import Then

// Protocol as Type
protocol PassDataDelegate {
    func memoReceived(text: String)
}

class AddViewController: BaseViewController {

    let moneyButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("금액", for: .normal)
        $0.addTarget(self, action: #selector(moneyButtonClicked), for: .touchUpInside)
    }
    
    let categoryButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("카테고리", for: .normal)
        $0.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
    }
    
    let memoButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("메모", for: .normal)
        $0.addTarget(self, action: #selector(memoButtonClicked), for: .touchUpInside)
    }
    
    let photoImageView = UIImageView().then {
        $0.backgroundColor = .gray
    }
    
    let addButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("이미지 추가", for: .normal)
        $0.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    
    let repository = AccountBookTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(categoryReceivedNotification), name:  NSNotification.Name("CategoryReceived"), object: nil)
        
        
    }
    
    override func configureHierarchy() {
        self.view.addSubview(moneyButton)
        self.view.addSubview(categoryButton)
        self.view.addSubview(memoButton)
        self.view.addSubview(photoImageView)
        self.view.addSubview(addButton)
    }
    
    override func configureContraints() {
        self.moneyButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        self.categoryButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(self.moneyButton.snp.bottom).offset(20)
        }
        
        self.memoButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(self.categoryButton.snp.bottom).offset(20)
        }
        
        self.photoImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.centerX.equalTo(view)
            make.top.equalTo(memoButton.snp.bottom).offset(20)
        }
        
        self.addButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(self.photoImageView.snp.bottom).offset(20)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    // 카메라 촬영 갤러리 접근 기능 (*시뮬에서 카메라 불가)
    // UIImagePickerController(13버전 미만) -> PHPickerViewController(13버전 이후)
    // out of process
    // 앱에서 갤러리가 뜬다 해도 유저가 선택 전까지 사진의 정보를 알 수 없기 때문에
    // 유저가 선택한 사진에 대해서는 권한 설정을 하지 않아도 됨!
    // 갤러리 가져오기는 권한 필요없음
    // 단, 사진 메타 데이터(날짜, 위치 등) 등 추가 정보를 얻기 위해서는 권한이 필요
    @objc func addButtonClicked() {
        print(#function)
        
        let vc = UIImagePickerController()
        vc.allowsEditing = true // 편집할거라고 말하는 거임
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        // 왜냐하면 이미지의 데이터로 변환해서 다루면 고화질의 이미지는 용량이 많아지면 힘들다
        
        // 2. Record로 Create될 내용 구성
        let money = Int.random(in: 100...5000) * 10
        
        let data = AccountBookTable(money: money, category: "공부", memo: "Swift...", regDate: Date(), userDate: Date(), type: true)
        
        // Filemanager를 통해 이미지 파일 자체를 도큐먼트에 저장
        // 렘 레코드에는 이미지의 파일명을 저장, 도큐먼트 이미지 경로
        if let image = photoImageView.image {
            saveImageToDocument(image: image, filename: "\(data.id)")
        }
        
        repository.createItem(data)
    }
    
    @objc func moneyButtonClicked() {
        let vc = MoneyViewController()
        vc.money = { value in
            print(value)
            self.moneyButton.setTitle(value, for: .normal)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func categoryButtonClicked() {
        let vc = CategoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func categoryReceivedNotification(notification: NSNotification) {
        if let value = notification.userInfo?["category"] as? String {
            categoryButton.setTitle(value, for: .normal)
        }
    }
    
    @objc func memoButtonClicked() {
        let vc = MemoViewController()
        
        vc.delegate = self
        
        NotificationCenter.default.post(name: NSNotification.Name("memoTest"), object: nil, userInfo: ["sesac": "여기가 한 줄 메모 테스트 글자입니다."])
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AddViewController: PassDataDelegate {
    func memoReceived(text: String) {
        memoButton.setTitle(text, for: .normal)
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    } // 취소했을때 뭐할꺼야( 얼럿, 토스트등으로 "진짜 삭제 하겠습니까?"
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        // 편집된 이미지가 아니라 오직 오리지날 이미지를 갖고 싶을때
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            photoImageView.image = pickedImage
//        }
        
        // 편집된 이미지를 가져오고 싶을때
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoImageView.image = pickedImage
        }
        
        dismiss(animated: true)
    }
}
