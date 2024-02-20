//
//  AccountBookTableRepository.swift
//  SeSacWeek9
//
//  Created by 김진수 on 2/16/24.
//

import Foundation
import RealmSwift

final class AccountBookTableRepository {
    
    // 레포지터리 패턴
    
    //realm class처럼 동작?
    // Realm에 Record를 Create하기
    // 1. Find Realm
    private let realm = try! Realm() // 램을 못 찾았어요.
    
    
    
    
    func createItem(_ item: AccountBookTable) {
        print(realm.configuration.fileURL)
        do {
            // 3. 2번에서 만든 레코드를 Realm에 추가
            try realm.write {
                realm.add(item)
                print("Realm Create")
            }
        } catch {
            print(error)
        } // do안의 일을 끝내는 동안 아무 일도 하지 않는다 -> transaction
        
    } // 제네릭으로 할 수 있지 않을까?
    
    func fetch() -> Results<AccountBookTable> {
        // 2. Realm 중 특정 하나의 테이블 가지고 오기
        // 전체 데이터를 money 컬럼 기준으로 정렬
//        list = realm.objects(AccountBookTable.self).sorted(byKeyPath: "money", ascending: true)
        
        // Realm 추가가 안될때
        // Realm 데이터를 list로 잘 가지고 왔는지
        // list를 뷰에 잘 보이게 설정 했는지
        // realm 데이터가 변경이 되면 list에는 알아서 반영! 즉, 테이블 뷰의 갱신만 신경 쓰면 된다.
        return realm.objects(AccountBookTable.self)
    }
    
    func fetchCategoryFilter(_ category: String) -> Results<AccountBookTable> {
        realm.objects(AccountBookTable.self).where{
            $0.category == category
        }.sorted(byKeyPath: "money", ascending: true)
    }
    
    func updateMoney(id: ObjectId, money: Int, category: String) {
        do {
            try realm.write {
                // 3. 한 레코드에서 여러 컬럼 정보를 변경하고 싶을 때
                realm.create(AccountBookTable.self, value: ["id": id, "money": money, "category": category], update: .modified)
                
            }
        } catch {
            print(error)
        }
    }
    
    func updateMoneyAll(money: Int) {
        
        do {
            // 2. 테이블에서 전체 컬럼 정보를 변경하고 싶을 때
    //        for item in list {
    //
    //
    //                item.money = 100000
    //
    //
    //        } // DB에서 데이터가 많다면 오래 걸림
            
    //        try! realm.write {
    //            list.setValue(1000000, forKey: "money")
    //        } // 한 번에 수정 가능
            try realm.write {
                realm.objects(AccountBookTable.self).setValue(money, forKey: "money")
            }
        } catch {
            print(error)
        }
        
    }
    
    func updateFavorite(_ item: AccountBookTable) {
    
        do {
            // Realm Update
            // 1. 한 레코드에 특정 컬럼값을 수정하고 싶은 경우
            try realm.write {
    //            list[indexPath.row].category = "커피"
                item.favorite.toggle()
    //            list[indexPath.row].favorite = !list[indexPath.row].favorite
//                list[indexPath.row].money = Int.random(in: 100...1000)
            }

        } catch {
            print(error)
        }
    }
    
    func realmCount(date: Date) -> Int {
        var todoData = realm.objects(AccountBookTable.self)
        
        let start = date
        
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        
        let predicate = NSPredicate(format: "regDate >= %@ && regDate < %@", start as NSDate, end as NSDate)
        
        todoData = todoData.filter(predicate)
        
        return todoData.count
    }
}
