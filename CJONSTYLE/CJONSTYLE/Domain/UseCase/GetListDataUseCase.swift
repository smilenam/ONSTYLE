//
//  GetListDataUseCase.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

protocol GetListDataUseCaseInterface {
    func getListData() async throws -> Result<[ListModel], Error>
}

struct GetListDataUseCase: GetListDataUseCaseInterface {
    private let repository: GetListDataRepositoryInterface
    
    init(repository: GetListDataRepositoryInterface) {
        self.repository = repository
    }
    
    func getListData() async throws -> Result<[ListModel], any Error> {
        do {
            return try await repository.getListData()
        } catch {
            throw error
        }
    }
}
