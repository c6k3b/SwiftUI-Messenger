//  SignUpView.swift
//  Created by aa on 12/24/22.

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var model: AppStateModel
    @State var username: String
    @State var password: String
    @State var email: String

    var body: some View {
        VStack(spacing: 16.0) {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 128)

            Text("Messenger")
                .bold()
                .font(.system(size: 34))
                .opacity(0.8)

            Spacer()

            VStack(spacing: 16.0) {
                TextField("Email", text: $email)
                    .modifier(CustomField())

                TextField("Username", text: $username)
                    .modifier(CustomField())

                SecureField("Password", text: $password)
                    .modifier(CustomField())

                Button { signUp() } label: {
                    Text("Create Account")
                        .foregroundColor(.black).opacity(0.8)
                        .frame(width: 220, height: 50)
                        .background(Color(red: 198 / 255, green: 218 / 255, blue: 111 / 255))
                        .cornerRadius(6)
                }
                .padding()
                Spacer()
            }
            .autocorrectionDisabled(true)
            .autocapitalization(.none)

            HStack {
                Text("Already have account?")

                Button { presentationMode.wrappedValue.dismiss() } label: {
                    Text("Login")
                        .foregroundColor(Color(red: 198 / 255, green: 218 / 255, blue: 111 / 255))
                }
            }
        }
        .padding()
    }

    private func signUp() {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count > 5
        else { return }

        model.signUp(email: email, username: username, password: password)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(username: "", password: "", email: "")
    }
}
