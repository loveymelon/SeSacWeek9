//
//  RealmModel.swift
//  SeSacWeek9
//
//  Created by 김진수 on 2/15/24.
//

import Foundation
import RealmSwift

// Realm에서 제공해주는 타입 종류 중 하나가 ObjectId.
// 겹치지 않는 값을 만들어줄게. -> PK는 겹치면 안되니까 이 타입을 씀 근데 반드시 고유키라고 해서 이 타입만 써야되는건 아니다.

class AccountBookTable: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var money: Int // 금액
    @Persisted var category: String // 카테고리
    @Persisted var memo: String? // 한 줄 메모
    @Persisted var regDate: Date // 등록일
    @Persisted var userDate: Date // 소비 날짜
    @Persisted var type: Bool // 입금(true) 출금(false) 여부
    @Persisted var favorite: Bool // 즐겨찾기
    
    // 편의 생성자 convenience init
    convenience init(money: Int, category: String, memo: String? = nil, regDate: Date, userDate: Date, type: Bool) {
        self.init()
        self.money = money
        self.category = category
        self.memo = memo
        self.regDate = regDate
        self.userDate = userDate
        self.type = type
        self.favorite = false
    }

}
