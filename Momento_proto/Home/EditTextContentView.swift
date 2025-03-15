//
//  EditTextContentView.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/15/25.
//

import SwiftUI

struct EditTextContentView: View {
    @Binding var text: String
    @State private var expand = false
    @FocusState private var isFocused: String?
    var body: some View {
        VStack {
            Group {
                if expand {
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                        .padding()
                        .focused($isFocused, equals: "editor")
                } else {
                    TextField("", text: $text)
                        .padding()
                        .focused($isFocused, equals: "field")
                        .multilineTextAlignment(.center)
                }
            }
            .background(.quinary, in: .rect(cornerRadius: 8))
            .overlay(alignment: .bottom) {
                Button {
                    withAnimation {
                        expand.toggle()
                        if isFocused == "editor" { isFocused = "field" }
                        if isFocused == "field" { isFocused = "editor" }
                    }
                } label: {
                    Text(expand ? "Collapse" : "Expand")
                }
                .frame(height: 26)
                .padding(.horizontal, 16)
                .background(in: .capsule)
                .clipShape(.capsule)
                .shadow(radius: 1)
                .offset(y: 13)
            }
            .padding()
        }
        .onAppear {
            isFocused = "field"
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Text("다음")
                }
                .disabled(text.isEmpty)
            }
        }
    }
}
