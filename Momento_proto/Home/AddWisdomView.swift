//
//  AddWisdomView.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/15/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct AddWisdomView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var contentType: WisdomContent? = nil
    @State private var currentStep = 1
    
    // 컨텐츠 타입별 상태
    @State private var text = ""
    @State private var url = ""
    @State private var selectedImage: UIImage?
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedFile: URL?
    @State private var fileDescription = ""
    @State private var showFilePicker = false
    @State private var showDocumentPicker = false
    
    // 공통 정보
    @State private var description = ""
    @State private var tags = ""
    @State private var selectedGroup: WisdomGroup?
    
    // 이미지 저장 관련
    @State private var savedImageURL: String = ""
    @State private var isSavingImage = false
    
    var body: some View {
        NavigationView {
            VStack {
                if currentStep == 1 {
                    // 첫 번째 단계: 컨텐츠 타입 선택 및 내용 입력
                    if let contentType {
                        switch contentType {
                        case .text:
                            EditTextContentView(text: $text)
                                .toolbar {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button("다음") {
                                            moveToNextStep()
                                        }
                                        .disabled(text.isEmpty)
                                    }
                                }
                        case .image:
                            EditImageContentView(selectedImage: $selectedImage, selectedItem: $selectedImageItem)
                                .toolbar {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button("다음") {
                                            saveImageAndMoveToNextStep()
                                        }
                                        .disabled(selectedImage == nil || isSavingImage)
                                    }
                                }
                        case .url:
                            EditURLContentView(url: $url)
                                .toolbar {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button("다음") {
                                            moveToNextStep()
                                        }
                                        .disabled(url.isEmpty)
                                    }
                                }
                        case .file:
                            EditFileContentView(
                                selectedFile: $selectedFile, 
                                fileDescription: $fileDescription,
                                showDocumentPicker: $showDocumentPicker
                            )
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("다음") {
                                        saveFileAndMoveToNextStep()
                                    }
                                    .disabled(selectedFile == nil)
                                }
                            }
                        }
                    } else {
                        Text("지혜를 가져올 방식을 선택해주세요.")
                        selectContentTypeButtons
                    }
                } else if currentStep == 2 {
                    // 두 번째 단계: 추가 정보 입력
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("추가 정보")
                                .font(.headline)
                                .padding(.top)
                            
                            TextField("설명", text: $description)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            
                            TextField("태그 (쉼표로 구분)", text: $tags)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            
                            Text("그룹 선택")
                                .font(.headline)
                                .padding(.top, 8)
                            
                            HStack {
                                ForEach(WisdomGroup.allCases) { group in
                                    Button {
                                        selectedGroup = group
                                    } label: {
                                        Text(group.rawValue)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                            .background(selectedGroup == group ? Color.blue : Color(.systemGray6))
                                            .foregroundColor(selectedGroup == group ? .white : .primary)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("저장") {
                                saveWisdomItem()
                            }
                        }
                    }
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
                            if currentStep == 2 {
                                currentStep = 1
                            } else {
                                contentType = nil
                            }
                        } label: {
                            Text("이전")
                        }
                    }
                }
            }
            .overlay {
                if isSavingImage {
                    ProgressView("이미지 저장 중...")
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(8)
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
    
    private func moveToNextStep() {
        withAnimation {
            currentStep = 2
        }
    }
    
    private func saveImageAndMoveToNextStep() {
        guard let image = selectedImage else { return }
        
        isSavingImage = true
        
        // 실제 앱에서는 이미지를 파일 시스템이나 클라우드에 저장하는 로직이 필요합니다.
        // 여기서는 간단히 시뮬레이션만 합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 이미지 저장 로직 (실제로는 파일 시스템이나 클라우드에 저장)
            let imageId = UUID().uuidString
            savedImageURL = "local://images/\(imageId).jpg"
            
            isSavingImage = false
            moveToNextStep()
        }
    }
    
    private func saveFileAndMoveToNextStep() {
        guard let fileURL = selectedFile else { return }
        
        // 실제 앱에서는 파일을 앱 내부 저장소로 복사하는 로직이 필요합니다.
        // 여기서는 간단히 시뮬레이션만 합니다.
        let fileId = UUID().uuidString
        let savedFileURL = "local://files/\(fileId)_\(fileURL.lastPathComponent)"
        
        moveToNextStep()
    }
    
    private func saveWisdomItem() {
        // 태그 처리
        let tagArray = tags.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
        
        // 컨텐츠 타입에 따라 WisdomContent 생성
        var finalContent: WisdomContent
        
        switch contentType {
        case .text:
            finalContent = .text(id: UUID(), text: text)
        case .image:
            finalContent = .image(id: UUID(), imageURL: savedImageURL)
        case .url:
            finalContent = .url(id: UUID(), urlCase: .extra, imageURL: "", description: "", author: "")
        case .file:
            finalContent = .file(id: UUID(), imageURL: "", description: fileDescription)
        case nil:
            return
        }
        
        // WisdomItem 생성
        let newItem = WisdomItem(
            id: UUID(),
            createdAt: Date(),
            description: description,
            group: selectedGroup,
            content: finalContent,
            tags: tagArray,
            summary: ""
        )
        
        // 실제 앱에서는 여기서 데이터 저장 로직이 필요합니다.
        // 예: DataManager.shared.saveWisdomItem(newItem)
        
        // 저장 후 화면 닫기
        dismiss()
    }
}

#Preview {
    AddWisdomView()
}
