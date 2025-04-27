import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Registro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Image(systemName: "person.badge.plus")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.green)
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
            
            VStack(alignment: .leading) {
                Text("Confirmar Contraseña")
                    .font(.headline)
                SecureField("Confirma tu contraseña", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button(action: {
                register()
            }) {
                Text("Registrarse")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func register() {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Por favor llena todos los campos."
            showingAlert = true
        } else if password != confirmPassword {
            alertMessage = "Las contraseñas no coinciden."
            showingAlert = true
        } else {
            APIService.shared.register(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if let token = response.token {
                            print("Registro exitoso, token: \(token)")
                            presentationMode.wrappedValue.dismiss()
                        } else if let error = response.error {
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

#Preview {
    RegisterView()
}
