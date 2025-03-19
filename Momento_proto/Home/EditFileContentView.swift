//
//  EditFileContentView.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/15/25.
//

import SwiftUI
import UniformTypeIdentifiers
import QuickLook
import PDFKit

struct EditFileContentView: View {
    @Binding var selectedFile: URL?
    @Binding var fileDescription: String
    @Binding var showDocumentPicker: Bool
    
    @State private var fileName: String = ""
    @State private var fileType: String = ""
    @State private var fileSize: String = ""
    @State private var showPreview = false
    @State private var previewImage: UIImage?
    @State private var isLoadingPreview = false
    
    var body: some View {
        VStack(spacing: 20) {
            if let selectedFile {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        fileIcon
                        
                        VStack(alignment: .leading) {
                            Text(fileName)
                                .font(.headline)
                            
                            Text("\(fileType) • \(fileSize)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            self.selectedFile = nil
                            self.fileName = ""
                            self.fileType = ""
                            self.fileSize = ""
                            self.previewImage = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // 파일 미리보기 영역
                    filePreviewView
                    
                    Text("파일 설명")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    TextEditor(text: $fileDescription)
                        .frame(minHeight: 100)
                        .padding(4)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding()
            } else {
                Button {
                    showDocumentPicker = true
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: "doc")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("파일 가져오기")
                            .font(.headline)
                        
                        Text("PDF, 이미지, 문서 파일을 선택하세요")
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
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker(
                        selectedFile: $selectedFile,
                        fileName: $fileName,
                        fileType: $fileType,
                        fileSize: $fileSize,
                        previewImage: $previewImage,
                        isLoadingPreview: $isLoadingPreview
                    )
                }
            }
        }
        .sheet(isPresented: $showPreview) {
            if let selectedFile {
                QuickLookPreview(url: selectedFile)
            }
        }
    }
    
    private var filePreviewView: some View {
        VStack {
            if isLoadingPreview {
                ProgressView("미리보기 로딩 중...")
                    .frame(height: 200)
            } else if let previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.vertical, 8)
            } else if let selectedFile, isPDF(fileType: fileType) {
                PDFPreviewView(url: selectedFile)
                    .frame(height: 200)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.vertical, 8)
            } else {
                Button {
                    if let selectedFile {
                        showPreview = true
                    }
                } label: {
                    VStack {
                        Image(systemName: "eye")
                            .font(.system(size: 30))
                        Text("파일 미리보기")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    private var fileIcon: some View {
        Group {
            if fileType.contains("pdf") {
                Image(systemName: "doc.fill")
                    .foregroundColor(.red)
            } else if fileType.contains("image") {
                Image(systemName: "photo.fill")
                    .foregroundColor(.blue)
            } else if fileType.contains("text") || fileType.contains("markdown") {
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "doc.fill")
                    .foregroundColor(.gray)
            }
        }
        .font(.system(size: 30))
    }
    
    private func isPDF(fileType: String) -> Bool {
        return fileType.lowercased().contains("pdf")
    }
}

struct PDFPreviewView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        if let document = PDFDocument(url: url) {
            uiView.document = document
        }
    }
}

struct QuickLookPreview: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: QuickLookPreview
        
        init(_ parent: QuickLookPreview) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.url as QLPreviewItem
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedFile: URL?
    @Binding var fileName: String
    @Binding var fileType: String
    @Binding var fileSize: String
    @Binding var previewImage: UIImage?
    @Binding var isLoadingPreview: Bool
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [
            .pdf,
            .image,
            .png,
            .jpeg,
            .webP,
            .text,
            .plainText,
//            .markdown
        ]
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            // 파일 접근 권한 획득
            let shouldStopAccessing = url.startAccessingSecurityScopedResource()
            defer {
                if shouldStopAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            // 파일 정보 설정
            parent.selectedFile = url
            parent.fileName = url.lastPathComponent
            
            // 파일 타입 확인
            if let uti = try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier,
               let utType = UTType(uti) {
                parent.fileType = utType.localizedDescription ?? "Unknown"
            } else {
                parent.fileType = url.pathExtension.uppercased()
            }
            
            // 파일 크기 계산
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
                if let size = attributes[.size] as? NSNumber {
                    let formatter = ByteCountFormatter()
                    formatter.allowedUnits = [.useKB, .useMB]
                    formatter.countStyle = .file
                    parent.fileSize = formatter.string(fromByteCount: size.int64Value)
                }
            } catch {
                parent.fileSize = "Unknown size"
            }
            
            // 이미지 파일인 경우 미리보기 생성
            self.generatePreview(for: url)
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        private func generatePreview(for url: URL) {
            let pathExtension = url.pathExtension.lowercased()
            
            // 이미지 파일인 경우
            if ["jpg", "jpeg", "png", "gif", "webp", "heic"].contains(pathExtension) {
                parent.isLoadingPreview = true
                
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async { [weak self] in
                            self?.parent.previewImage = image
                            self?.parent.isLoadingPreview = false
                        }
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            self?.parent.isLoadingPreview = false
                        }
                    }
                }
            }
            // PDF 파일인 경우 첫 페이지 미리보기 생성
            else if pathExtension == "pdf" {
                parent.isLoadingPreview = true
                
                DispatchQueue.global(qos: .userInitiated).async {
                    if let pdfDocument = CGPDFDocument(url as CFURL),
                       let page = pdfDocument.page(at: 1) {
                        let pageRect = page.getBoxRect(.mediaBox)
                        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
                        
                        let image = renderer.image { ctx in
                            UIColor.white.set()
                            ctx.fill(CGRect(origin: .zero, size: pageRect.size))
                            
                            ctx.cgContext.translateBy(x: 0, y: pageRect.size.height)
                            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                            
                            ctx.cgContext.drawPDFPage(page)
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.parent.previewImage = image
                            self?.parent.isLoadingPreview = false
                        }
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            self?.parent.isLoadingPreview = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EditFileContentView(
        selectedFile: .constant(nil),
        fileDescription: .constant(""),
        showDocumentPicker: .constant(false)
    )
} 
