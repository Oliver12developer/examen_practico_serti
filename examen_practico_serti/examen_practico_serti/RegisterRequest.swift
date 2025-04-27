// Models.swift

struct RegisterRequest: Codable {
    let email: String
    let password: String
}

struct RegisterResponse: Codable {
    let id: Int?
    let token: String?
    let error: String?
}
