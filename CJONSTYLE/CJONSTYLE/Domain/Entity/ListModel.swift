//
//  ListModel.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

struct ListDataResponse: Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case brand = "brand"
        case price = "price"
        case discountPrice = "discountPrice"
        case discountRate = "discountRate"
        case image = "image"
        case link = "link"
        case tags = "tags"
        case benefits = "benefits"
        case rating = "rating"
        case reviewCount = "reviewCount"
    }
    
    let id: String
    let name: String
    let brand: String
    let price: Int
    let discountPrice: Int
    let discountRate: Int
    let image: String
    let link: String
    let tags: [String]
    let benefits: [String]
    let rating: Double
    let reviewCount: Int
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        brand = (try? container.decode(String.self, forKey: .brand)) ?? ""
        price = (try? container.decode(Int.self, forKey: .price)) ?? 0
        discountPrice = (try? container.decode(Int.self, forKey: .discountPrice)) ?? 0
        discountRate = (try? container.decode(Int.self, forKey: .discountRate)) ?? 0
        image = (try? container.decode(String.self, forKey: .image)) ?? ""
        link = (try? container.decode(String.self, forKey: .link)) ?? ""
        tags = (try? container.decode([String].self, forKey: .tags)) ?? [""]
        benefits = (try? container.decode([String].self, forKey: .benefits)) ?? [""]
        rating = (try? container.decode(Double.self, forKey: .rating)) ?? 0
        reviewCount = (try? container.decode(Int.self, forKey: .reviewCount)) ?? 0
    }
}

struct ListModel: Hashable {
    let id: String
    let name: String
    let brand: String
    let price: Int
    let discountPrice: Int
    let discountRate: Int
    let image: String
    let link: String
    let tags: [String]
    let benefits: [String]
    let rating: Double
    let reviewCount: Int
}
