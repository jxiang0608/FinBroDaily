//
//  GoBarView.swift
//  XChange
//
//  Created by Arthur Roolfs on 11/12/24.
//

import SwiftUI


struct GoBarView: View {
    
    @Binding var goString: String
    @FocusState var focus: Bool
    var title: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.heavy)
                .foregroundColor(.secondary)
            TextField(title, text: $goString)
                .autocapitalization(.allCharacters)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .focused($focus)
                .onSubmit {
                    if let doIt = action { doIt() }
                }
                .onChange(of: goString) { _, new in
                    goString = String(new.prefix(4))
                }
            Button {
                if let doIt = action { doIt() }
            } label: {
                Label("", systemImage: "arrow.clockwise")
            }
            .clipShape(Rectangle())
            .disabled(goString.isEmpty)
        }
        .padding(.horizontal)
    }
}

#Preview {
    GoBarView(goString: .constant(""), title: "Exchange Rates for: ")
}
