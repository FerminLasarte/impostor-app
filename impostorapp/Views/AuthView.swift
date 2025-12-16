import SwiftUI

struct AuthView: View {
    @State private var viewModel = AuthViewModel()
    
    // Estados locales para el formulario
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isLoginMode = true // Alternar entre Login y Registro
    
    var body: some View {
        ZStack {
            // 1. Fondo Degradado (Coherente con SetupView)
            LinearGradient(
                colors: [Color.blue.opacity(0.3), .purple.opacity(0.3), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // 2. Icono y Título
                VStack(spacing: 15) {
                    Image(systemName: "person.crop.circle.badge.questionmark") // Icono temático
                        .font(.system(size: 80))
                        .foregroundStyle(.indigo)
                        .symbolEffect(.bounce, value: isLoginMode) // Animación nativa de iOS 17
                    
                    Text(isLoginMode ? "Bienvenido de nuevo" : "Crear Cuenta")
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded) // Coherente con tu RevealView
                }
                .padding(.top, 40)
                
                // 3. Tarjeta de Formulario (Estilo Apple Glass)
                VStack(spacing: 20) {
                    if !isLoginMode {
                        CustomTextField(icon: "person", placeholder: "Nombre", text: $name)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    CustomTextField(icon: "envelope", placeholder: "Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    CustomSecureField(icon: "lock", placeholder: "Contraseña", text: $password)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        Task {
                            if isLoginMode {
                                await viewModel.signIn(email: email, password: password)
                            } else {
                                await viewModel.signUp(email: email, password: password, name: name)
                            }
                        }
                    } label: {
                        Text(isLoginMode ? "Iniciar Sesión" : "Registrarse")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .padding(.top, 10)
                }
                .padding(30)
                .background(.ultraThinMaterial) // Efecto cristal nativo
                .cornerRadius(25)
                .padding(.horizontal)
                .animation(.spring(), value: isLoginMode) // Animación suave al cambiar modo
                
                Spacer()
                
                // 4. Botón para alternar modo
                Button {
                    withAnimation {
                        isLoginMode.toggle()
                        viewModel.errorMessage = nil
                    }
                } label: {
                    Text(isLoginMode ? "¿No tienes cuenta? **Regístrate**" : "¿Ya tienes cuenta? **Entra**")
                        .foregroundStyle(.primary)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

// Componentes reutilizables para mantener el código limpio
struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.gray)
                .frame(width: 30)
            TextField(placeholder, text: $text)
        }
        .padding()
        .background(Color(uiColor: .systemBackground).opacity(0.5))
        .cornerRadius(12)
    }
}

struct CustomSecureField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.gray)
                .frame(width: 30)
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color(uiColor: .systemBackground).opacity(0.5))
        .cornerRadius(12)
    }
}
