//
//  ViewController.swift
//  MyPostRequest
//
//  Created by Alibek Kozhambekov on 11.12.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var birthTextField: UITextField!
    
    var birth: Int = 0
    var occupation: String = ""
    var name: String = ""
    var lastName: String = ""
    var country: String = ""
    
    var jsonDict: [Json4Swift_Base] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthTextField.delegate = self
        birthTextField.keyboardType = .numberPad
    }
    
    //MARK: - RequestWithURLSession
    
    private func requestWithURLSession() {
        
        let jsonVar = Json4Swift_Base(birth: birth.self, occupation: occupation.self, name: name.self, lastname: lastName.self, country: country.self)
        
        jsonDict.append(jsonVar)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonVar.dictionaryRepresentation())
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let safeData = data, error == nil else {
                DispatchQueue.main.async {
                    self!.displayFailure()
                }
                return
            }
            
            DispatchQueue.main.async {
                self!.displaySuccess()
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: safeData, options: [])
            
            if let safeResponseJSON = responseJSON as? [String: Any] {
                print(safeResponseJSON)
            }
        }.resume()
    }
    
    //MARK: - RequestWithAlamofire
    
    private func requestWithAlamofire() {
        let item = Item(birth: birth, occupation: occupation, name: name, lastname: lastName, country: country)
        
        AF.request(
            "https://jsonplaceholder.typicode.com/posts",
            method: .post,
            parameters: item,
            encoder: JSONParameterEncoder.default
        ).response { [weak self] response in
            guard response.error == nil else {
                self?.displayFailure()
                return
            }
            self?.displaySuccess()
            debugPrint(response)
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func birthDidEndEditing(_ sender: UITextField) {
        let birthString = sender.text ?? ""
        birth = Int(birthString) ?? 0
    }
    
    @IBAction func occupationDidEndEditing(_ sender: UITextField) {
        occupation = sender.text ?? ""
    }
    
    @IBAction func nameDidEndEditing(_ sender: UITextField) {
        name = sender.text ?? ""
    }
    
    @IBAction func lastnameDidEndEditing(_ sender: UITextField) {
        lastName = sender.text ?? ""
    }
    
    @IBAction func countryDidEndEditing(_ sender: UITextField) {
        country = sender.text ?? ""
    }
    
    @IBAction func sendWirhURLRequest(_sender: UIButton) {
        requestWithURLSession()
    }
    
    @IBAction func sendWithAlamofire(_sender: UIButton) {
        requestWithAlamofire()
    }
    
    //MARK: - UIAlert
    
    private func displaySuccess() {
        resultLabel.text = "Success"
        resultLabel.textColor = .systemGreen
    }
    
    private func displayFailure() {
        resultLabel.text = "Failure"
        resultLabel.textColor = .systemRed
    }
    
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

