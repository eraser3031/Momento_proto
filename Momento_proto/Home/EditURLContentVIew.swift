//
//  EditURLContentVIew.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/15/25.
//

import SwiftUI
import Combine
import LinkPresentation

struct EditURLContentView: View {
    @Binding var url: String
    @State var metadata: LPLinkMetadata?
    @State private var cancellables = Set<AnyCancellable>()
    @State private var urlSubject = PassthroughSubject<String, Never>()
    
    var body: some View {
        VStack(spacing: 16) {
            Text(metadata?.title ?? "")
            TextField("URL 입력", text: $url)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(8)
                // URL 변경 시 Publisher에 전송
                .onChange(of: url) { _, newValue in
                    urlSubject.send(newValue)
                }
                .onAppear {
                    // 디바운싱 파이프라인 설정: 1초 후에 값 발행, 빈 문자열은 무시
                    urlSubject
                        .debounce(for: .seconds(1), scheduler: RunLoop.main)
                        .filter { !$0.isEmpty }
                        .sink { debouncedValue in
                            print("Debounced URL: \(debouncedValue)")
                            Task { [url] in
                                let metadataProvider = LPMetadataProvider()
                                guard let url = URL(string: url) else { return }
                                let metadata = try await metadataProvider.startFetchingMetadata(for: url)
                                self.metadata = metadata
                            }
                            // 여기서 네트워크 요청 또는 추가 작업을 실행할 수 있음
                        }
                        .store(in: &cancellables)
                }
                .onDisappear {
                    // 뷰가 사라지면 모든 구독 취소
                    cancellables.removeAll()
                }
            
            // 클립보드에서 URL 붙여넣기 버튼
            Button("URL 붙여넣기") {
                if let pastedURL = UIPasteboard.general.string {
                    url = pastedURL
                } else {
                    print("클립보드에서 URL을 가져올 수 없습니다.")
                }
            }
        }
        .padding()
    }
}
