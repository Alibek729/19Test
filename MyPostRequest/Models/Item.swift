//
//  Item.swift
//  MyPostRequest
//
//  Created by Alibek Kozhambekov on 11.12.2022.
//

import Foundation

struct Item: Codable {
    let birth: Int?
    let occupation: String?
    let name: String?
    let lastname: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case birth = "birth"
        case occupation = "occupation"
        case name = "name"
        case lastname = "lastname"
        case country = "country"
    }
    
    init(birth: Int?, occupation: String?, name: String?, lastname: String?, country: String?){
        self.birth = birth
        self.occupation = occupation
        self.name = name
        self.lastname = lastname
        self.country = country
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.birth = try container.decodeIfPresent(Int.self, forKey: .birth)
        self.occupation = try container.decodeIfPresent(String.self, forKey: .occupation)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
    }
}
