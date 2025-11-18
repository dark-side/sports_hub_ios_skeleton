//
//  SignInView.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        ZStack {
            // Background
            Color.backgroundPage
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: .spacingLarge) {
                    Spacer(minLength: .spacingXLarge)

                    signInFormView

                    Spacer(minLength: .spacingXLarge)
                }
                .padding(.horizontal, .spacingLarge)
                .padding(.top, .spacingXXLarge)
            }
        }
        .navigationBarHidden(true)
    }


    private var signInFormView: some View {
        VStack(spacing: .spacingMedium) {
            // Email Field
            VStack(alignment: .leading, spacing: .spacingXSmall) {
                Text("Email")
                    .font(.subtitle)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                TextField("Enter your email", text: $viewModel.email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
            }

            // Password Field
            VStack(alignment: .leading, spacing: .spacingXSmall) {
                Text("Password")
                    .font(.subtitle)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                SecureField("Enter your password", text: $viewModel.password)
                    .textFieldStyle(CustomTextFieldStyle())
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        Task {
                            await viewModel.signIn()
                        }
                    }
            }

            // Error Message
            if let errorMessage = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.appError)
                    Text(errorMessage)
                        .font(.subtitle)
                        .foregroundColor(.appError)
                    Spacer()
                }
                .padding()
                .background(Color.backgroundError)
                .cornerRadius(.cornerRadiusSmall)
            }

            // Sign In Button
            Button {
                Task {
                    await viewModel.signIn()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .frame(height: .buttonHeight)
                } else {
                    Text("Sign In")
                        .font(.cardTitle)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: .buttonHeight)
                }
            }
            .background(viewModel.isFormValid && !viewModel.isLoading ? Color.appPrimary : Color.appDisabled)
            .cornerRadius(.cornerRadiusLarge)
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            .padding(.top, .spacingXSmall)
        }
    }
}

#Preview {
    SignInView(
        viewModel: SignInViewModel(
            signInUseCase: SignInUseCase(
                repository: DefaultAuthRepository(
                    remoteDataSource: MockAuthRemoteDataSource()
                )
            )
        )
    )
}
