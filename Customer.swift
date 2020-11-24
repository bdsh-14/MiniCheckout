import Foundation

struct Customer: Equatable, Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let selfieImageUrl: URL
    
    var name: String {
        return "\(firstName) \(lastName)"
    }
}
