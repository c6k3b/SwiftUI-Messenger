//  ViewModifiers.swift
//  Created by aa on 12/24/22.

import SwiftUI

struct CustomField: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(6)
    }
}
