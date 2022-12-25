//  SignInView.swift
//  Created by aa on 12/24/22.

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var model: AppStateModel
    @State var username: String
    @State var password: String

    var body: some View {
        NavigationView {
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
                    TextField("Username", text: $username)
                        .modifier(CustomField())

                    SecureField("Password", text: $password)
                        .modifier(CustomField())

                    Button { signIn() } label: {
                        Text("Sign In")
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
                    Text("New to Messenger?")
                    NavigationLink("Create Account", destination: SignUpView(username: "", password: "", email: ""))
                        .foregroundColor(Color(red: 198 / 255, green: 218 / 255, blue: 111 / 255))
                }
            }
            .padding()
        }
    }

    private func signIn() {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count > 5
        else { return }

        model.signIn(username: username, password: password)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(username: "", password: "")
    }
}
