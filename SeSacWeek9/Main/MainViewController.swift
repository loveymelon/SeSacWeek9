//
//  MainViewController.swift
//  SeSacWeek9
//
//  Created by 김진수 on 2/14/24.
//

import UIKit
import SnapKit
import RealmSwift
import Then
import FSCalendar

class MainViewController: BaseViewController {
    
    let tableView = UITableView()
    let calendar = FSCalendar()
    
    var list: Results<AccountBookTable>! // 데이터가 변경이 되면 알아서 Realm의 특성으로 자동으로 데이터를 가져와 바꿔준다.
    
    // 1. Realm 위치에 접근
    let realm = try! Realm()
    
    let repository = AccountBookTableRepository()

    let dateFormat = DateFormatter().then {
        $0.dateFormat = "yyyy년 MM월 dd일 hh시"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = repository.fetch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function, list.count)
        
        self.tableView.reloadData()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(tableView)
        self.view.addSubview(calendar)
    }
    
    override func configureView() {
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.tableView.rowHeight = 80
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
        self.tableView.backgroundColor = .lightGray
        
        navigationItem.title = "용돈기입장"
        let image = UIImage(systemName: "plus")
        let rightItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightBarButtonItemclicked))
        navigationItem.rightBarButtonItem = rightItem
        
        let today = UIBarButtonItem(title: "오늘", style: .plain, target: self, action: #selector(todayButtonClicked))
        let all = UIBarButtonItem(title: "전체", style: .plain, target: self, action: #selector(allButtonClicked))
        
        navigationItem.leftBarButtonItems = [today, all]
    }
    
    override func configureContraints() {
        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(calendar.snp.bottom)
        }
    }
    
    @objc func todayButtonClicked() {
        print(#function)
        // 램에서 오늘 날짜만 필터링해서 데이터 가지고 오고 이걸 list에 넣기
        // 2024.02. 19. 00:00:00 - 2024. 02. 19 23: 59: 59
        
        // 오늘 시작 날짜
        let start = Calendar.current.startOfDay(for: Date())
        
        // 내일 시작 날짜
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        
        // 쿼리 작성
        let predicate = NSPredicate(format: "regDate >= %@ && regDate < %@", start as NSDate, end as NSDate) // apple이 제공하는 필터 기능
        // %@ String값이 들어갈 자리 -> 문서 참고
        
        list = realm.objects(AccountBookTable.self).filter(predicate)
        
        tableView.reloadData()
    }
    
    @objc func allButtonClicked() {
        print(#function)
        list = repository.fetch()
        tableView.reloadData()
    }
    
    @objc func rightBarButtonItemclicked() {
        let vc = AddViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell")!
        let row = list?[indexPath.row]
        

        let result = dateFormat.string(from: row!.regDate)
        
        cell.textLabel?.text = "\(row!.money)원 | \(row!.category) | \(result)"
        
        // 도큐먼트 폴더에 있는 이미지를 셀에 보여주기
        // 도큐먼트 위치 찾기 > 경로 완성 > URL
        if let image = loadImageToDocument(filename: "\(row!.id)") {
            cell.imageView?.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Realm Delete:
        // 1. 렘 파일에서 제거!
//        try! realm.write {
//            realm.delete(list[indexPath.row])
//        }
        repository.updateFavorite(list[indexPath.row])

//        repository.updateMoneyAll(money: 20000)
        
        //3.
        repository.updateMoney(id: list[indexPath.row].id, money: 999, category: "공부")
        
        // 2. 이를 뷰에 반영
        tableView.reloadData()
        
    }
    
}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return repository.realmCount(date: date) > 3 ? 3 : repository.realmCount(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return "하하"
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(#function, date) // 모든 날짜는 영국 표준으로 나온다.
        // 2/1 _> 2024-01-31 15:00:00 +0000
        // 2/1 시작 날짜 이상 ~ 2/2 시작 날짜 미만
        
        // 오늘 시작 날짜
        let start = Calendar.current.startOfDay(for: date) // 기준
        
        // 내일 시작 날짜
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        
        // 쿼리 작성
        let predicate = NSPredicate(format: "regDate >= %@ && regDate < %@", start as NSDate, end as NSDate) // apple이 제공하는 필터 기능
        // %@ String값이 들어갈 자리 -> 문서 참고
        
        list = realm.objects(AccountBookTable.self).filter(predicate)
        
        tableView.reloadData()
    }
    
}
