//
//  AddWisdomView.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/15/25.
//

import SwiftUI

struct AddWisdomView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var contentType: WisdomContent? = nil
    
    @State private var text = ""
    @State private var url = ""

    var body: some View {
        NavigationView {
            VStack {
                switch contentType {
                case .text:
                    EditTextContentView(text: $text)
                case .image:
                    Button {
                        
                    } label: {
                        Text("이미지 가져오기")
                    }
                case .url:
                    EditURLContentView(url: $url)
                case .file:
                    Button {

                    } label: {
                        Text("파일 가져오기")
                    }
                case nil:
                    Text("지혜를 가져올 방식을 선택해주세요.")
                    selectContentTypeButtons
                }
            }
            .navigationTitle("Add Wisdom")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if contentType == nil {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    } else {
                        Button {
                            contentType = nil
                        } label: {
                            Text("이전")
                        }
                    }
                }
            }
        }
    }
    
    private var selectContentTypeButtons: some View {
        Group {
            selectContentTypeButton(label: "text") {
                contentType = .text(id: UUID(), text: "")
            }
            selectContentTypeButton(label: "image") {
                contentType = .image(id: UUID(), imageURL: "")
            }
            selectContentTypeButton(label: "url") {
                contentType = .url(id: UUID(), urlCase: .extra, imageURL: "", description: "", author: "")
            }
            selectContentTypeButton(label: "file") {
                contentType = .file(id: UUID(), imageURL: "", description: "")
            }
        }
    }
    
    private func selectContentTypeButton(label: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(label)
                .frame(width: 120)
                .padding()
                .background(.quinary, in: .rect(cornerRadius: 12))
        }
    }
}

#Preview {
    AddWisdomView()
}
