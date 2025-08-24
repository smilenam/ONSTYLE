//
//  GetListDataRepository.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import Foundation

enum ErrorType: Error {
    case notFile
    case decodeFailed
    
    var errorDescription: String? {
        switch self {
        case .notFile:
            return "파일을 찾을 수 없습니다"
        case .decodeFailed:
            return "JSON 디코딩 실패"
        }
    }
}

protocol GetListDataRepositoryInterface {
    func getListData() async throws -> Result<[ListModel], ErrorType>
}

struct GetListDataRepository: GetListDataRepositoryInterface {
    init() { }
    
    func getListData() async throws -> Result<[ListModel], ErrorType> {
        try await withCheckedThrowingContinuation { continuation in
            guard let json = Bundle.main.url(forResource: "products", withExtension: "json") else {
                return continuation.resume(returning: .failure(.notFile))
            }

            do {
                let data = try Data(contentsOf: json)
                let response = try JSONDecoder().decode([ListDataResponse].self, from: data)
                return continuation.resume(returning: .success(toDomain(data: response)))
            } catch {
                return continuation.resume(throwing: error)
            }
        }
    }
}

extension GetListDataRepository {
    func toDomain(data: [ListDataResponse]) -> [ListModel] {
        return data.enumerated().map {
            .init(id: $0.element.id + "\($0.offset)",
                  name: $0.element.name,
                  brand: $0.element.brand,
                  price: $0.element.price,
                  discountPrice: $0.element.discountPrice,
                  discountRate: $0.element.discountRate,
                  image: $0.element.image,
                  link: $0.element.link,
                  tags: $0.element.tags,
                  benefits: $0.element.benefits,
                  rating: $0.element.rating,
                  reviewCount: $0.element.reviewCount)
        }
    }
}
