//
//  GetListDataRepository.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

protocol GetListDataRepositoryInterface {
    func getListData() async throws -> Result<[ListModel], Error>
}

struct GetListDataRepository: GetListDataRepositoryInterface {
    init() { }
    
    func getListData() async throws -> Result<[ListModel], any Error> {
        try await withCheckedThrowingContinuation { continuation in
            continuation.resume(returning: .success([.init(data: "",
                                                           url: "")]))
        }
    }
}

extension GetListDataRepository {
    func toDomain(data: ListDataResponse) -> [ListModel] {
        return data.data.map { .init(data: $0,
                                    url: "") }
    }
}
