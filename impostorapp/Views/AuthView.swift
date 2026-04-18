import SwiftUI

struct AuthView: View {
    var viewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var isLoginMode = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Orbes ambientales
            Circle()
                .fill(Color.indigo.opacity(0.35))
                .frame(width: 380)
                .blur(radius: 110)
                .offset(x: -80, y: -180)

            Circle()
                .fill(Color.purple.opacity(0.22))
                .frame(width: 320)
                .blur(radius: 100)
                .offset(x: 100, y: 200)

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 14) {
                    Image(systemName: "theatermasks.fill")
                        .font(.system(size: 64, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .indigo.opacity(0.75)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .indigo.opacity(0.6), radius: 22, y: 8)
                        .symbolEffect(.bounce, value: isLoginMode)

                    VStack(spacing: 5) {
                        Text("IMPOSTOR")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .tracking(-1)

                        Text(isLoginMode ? "Bienvenido de nuevo" : "Crea tu cuenta")
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.45))
                    }
                }
                .padding(.top, 60)

                Spacer()

                // Formulario
                VStack(spacing: 12) {
                    if !isLoginMode {
                        AuthField(icon: "person", placeholder: "Nombre", text: $displayName)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    AuthField(icon: "envelope", placeholder: "Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)

                    AuthSecureField(icon: "lock", placeholder: "Contraseña", text: $password)

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 4)
                    }

                    Button {
                        Task {
                            if isLoginMode {
                                await viewModel.signIn(email: email, password: password)
                            } else {
                                await viewModel.signUp(email: email, password: password, displayName: displayName)
                            }
                        }
                    } label: {
                        Text(isLoginMode ? "Iniciar Sesión" : "Registrarse")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.indigo)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .indigo.opacity(0.4), radius: 12, y: 4)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.top, 4)
                }
                .padding(24)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                .padding(.horizontal, 20)
                .animation(.bouncy(), value: isLoginMode)

                Spacer()

                // Cambiar modo
                Button {
                    withAnimation {
                        isLoginMode.toggle()
                        viewModel.errorMessage = nil
                    }
                } label: {
                    Group {
                        Text(isLoginMode ? "¿No tienes cuenta? " : "¿Ya tienes cuenta? ")
                            .foregroundStyle(.white.opacity(0.45))
                        + Text(isLoginMode ? "Regístrate" : "Entra")
                            .foregroundStyle(.white.opacity(0.85))
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 14))
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct AuthField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.45))
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .foregroundStyle(.white)
                .tint(.indigo)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct AuthSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.45))
                .frame(width: 20)
            SecureField(placeholder, text: $text)
                .foregroundStyle(.white)
                .tint(.indigo)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
