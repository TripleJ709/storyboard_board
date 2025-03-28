//
//  ViewController.swift
//  storyboard_board
//
//  Created by 장주진 on 3/27/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addDBBtn(_ sender: UIButton) {
        addUserToDatabase()
    }
    
    func addUserToDatabase() {
        guard let url = URL(string: "http://127.0.0.1:5000/users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userData: [String: String] = [
            "name": "TripleJ709",
            "email": "TripleJ709@gmail.com"
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("에러:", error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("서버 응답 코드: ", httpResponse.statusCode)
            }
            
            if let data {
                let result = String(data: data, encoding: .utf8)
                print("응답 내용: ", result ?? "")
            }
        }.resume()
    }
}

