//
//  FileManager+Extension.swift
//  SeSacWeek9
//
//  Created by 김진수 on 2/19/24.
//

import UIKit

extension UIViewController {
    
    func loadImageToDocument(filename: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        print(documentDirectory)
        
        //
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 이 경로에 실제로 파일이 존재하는 지 확인
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star.fill")
        }
        
    }
    
    func saveImageToDocument(image: UIImage, filename: String) {
        // 앱 도큐먼트 위치 desktop/sesac/week9/a.jpg
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error")
        }
    }
    
}
