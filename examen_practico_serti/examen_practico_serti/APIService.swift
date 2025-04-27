import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    // Función para hacer login
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "https://reqres.in/api/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataNilError", code: -10001, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Función para registrar un usuario
    func register(email: String, password: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        guard let url = URL(string: "https://reqres.in/api/register") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")

        let registerRequest = RegisterRequest(email: email, password: password)

        do {
            request.httpBody = try JSONEncoder().encode(registerRequest)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "DataNilError", code: -10001, userInfo: nil)))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Extensión para obtener los usuarios
extension APIService {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: "https://reqres.in/api/users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // request.addValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error con la respuesta de la API: \(httpResponse.statusCode)"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataNilError", code: -10001, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(UsersResponse.self, from: data)
                let users = decodedResponse.data.map { userData in
                    User(id: userData.id, email: userData.email, firstName: userData.first_name, lastName: userData.last_name, avatar: userData.avatar)
                }
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}



// Estructura de la respuesta de la API
struct UsersResponse: Codable {
    let data: [UserData]
}

// Estructura de UserData de la API
struct UserData: Codable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}

// Estructura de User (para el uso en la vista)
struct User: Identifiable, Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
}
