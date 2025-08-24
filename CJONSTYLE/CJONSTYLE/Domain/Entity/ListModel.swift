//
//  ListModel.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

struct ListDataResponse: Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    let data: [String]
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = (try? container.decode([String].self, forKey: .data)) ?? [""]
    }
    
    
}

struct ListModel {
    let data: String
}

