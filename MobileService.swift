import Foundation
import Alamofire

protocol MobileService_Protocol {
    func customer(completion: @escaping (Result<Customer, Error>) -> Void)
}

class MobileService: MobileService_Protocol {
    private let httpClient: HTTPClient_Protocol
    private let jsonDecoder: JSONDecoder

    init(httpClient: HTTPClient_Protocol = HTTPClient()) {
        self.httpClient = httpClient
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func customer(completion: @escaping (Result<Customer, Error>) -> Void) {
        let request = HTTPRequest(url: URL(string: "https://fake-mobile-backend.production.stitchfix.com/api/customer")!)
        httpClient.send(request: request) { result in
            switch result {
            case let .success(value):
                completion(Result(catching: { try self.jsonDecoder.decode(CustomerResponseBody.self, from: value).customer }))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    struct CustomerResponseBody: Decodable, Equatable {
        let customer: Customer
    }
}
