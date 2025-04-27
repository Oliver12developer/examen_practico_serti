import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false  // Bandera para la navegación
    @State private var token: String? = nil  // Guardar el token para validación
    
    var body: some View {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Bienvenido")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)

                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.blue)
                        .padding()

                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.headline)
                        TextField("Ingresa tu email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                    }

                    VStack(alignment: .leading) {
                        Text("Contraseña")
                            .font(.headline)
                        SecureField("Ingresa tu contraseña", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    Button(action: {
                        login()
                    }) {
                        Text("Iniciar Sesión")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)

                    NavigationLink("¿No tienes cuenta? Regístrate aquí", destination: RegisterView())
                        .foregroundColor(.blue)
                        .padding(.top, 10)

                    Spacer()
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                // Aquí agregamos un NavigationLink condicional para navegar a UsersView
                NavigationLink(destination: UsersView(), isActive: $isLoggedIn) {
                    EmptyView()  // No mostramos un link visualmente, solo lo activamos cuando el login es exitoso
                }
            }
        }
    
    func login() {
        if email.isEmpty || password.isEmpty {
            alertMessage = "Por favor llena todos los campos."
            showingAlert = true
        } else {
            APIService.shared.login(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if let token = response.token {
                            print("Login exitoso, token: \(token)")
                            self.token = token  // Guardar el token en la vista
                            UserDefaults.standard.set(token, forKey: "userToken") // <--- NUEVO
                            UserDefaults.standard.set(email, forKey: "userEmail") // <--- NUEVO
                            self.isLoggedIn = true  // Cambiar la bandera para navegar
                        }else if let error = response.error {
                            alertMessage = error
                            showingAlert = true
                        }
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        showingAlert = true
                    }
                }
            }
        }
    }
}
