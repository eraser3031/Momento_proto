//
//  EditImageContentView.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/15/25.
//

import SwiftUI
import PhotosUI

struct EditImageContentView: View {
    @Binding var selectedImage: UIImage?
    @Binding var selectedItem: PhotosPickerItem?
    @State private var isImageLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding()
                
                Button("다른 이미지 선택하기") {
                    self.selectedImage = nil
                    self.selectedItem = nil
                }
                .buttonStyle(.bordered)
            } else if isImageLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                Text("이미지 로딩 중...")
                    .foregroundColor(.secondary)
            } else {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    VStack(spacing: 12) {
                        Image(systemName: "photo")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("이미지 가져오기")
                            .font(.headline)
                        
                        Text("갤러리에서 이미지를 선택하거나 카메라로 촬영하세요")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding()
                }
            }
        }
        .onChange(of: selectedItem) { _, newValue in
            if let newValue {
                isImageLoading = true
                Task {
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                    isImageLoading = false
                }
            }
        }
    }
}

#Preview {
    EditImageContentView(selectedImage: .constant(nil), selectedItem: .constant(nil))
} 