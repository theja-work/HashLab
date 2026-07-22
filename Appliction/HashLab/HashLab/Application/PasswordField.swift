//
//  PasswordField.swift
//  HashLab
//
//  Created by Thejas Kasaba on 22/07/26.
//

import SwiftUI

struct PasswordField: View {

    let title: String
    @Binding var text: String

    @State private var isSecure = true

    var body: some View {

        HStack {

            Group {

                if isSecure {

                    SecureField(title, text: $text)

                } else {

                    TextField(title, text: $text)
                        .autocapitalization(.none)
                }
            }

            Button {

                isSecure.toggle()

            } label: {

                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundStyle(.secondary)
            }
        }
        .textFieldStyle(.roundedBorder)
    }
}
