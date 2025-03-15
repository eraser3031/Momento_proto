//
//  HomeView.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/14/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showAddSheet = false
    @State private var selectedWisdomGroup: [WisdomGroup] = []
    @State private var useFilter: Bool = false
    
    // 필터링된 지혜 항목을 계산하는 속성 추가
    private var filteredWisdomItems: [WisdomItem] {
        if !useFilter || selectedWisdomGroup.isEmpty {
            // 필터가 사용되지 않거나 선택된 그룹이 없으면 모든 항목 표시
            return MockData.wisdomItems
        } else {
            // 선택된 그룹에 속하는 항목만 필터링
            return MockData.wisdomItems.filter { item in
                if let group = item.group {
                    return selectedWisdomGroup.contains(group)
                }
                return false // 그룹이 없는 항목은 필터링에서 제외
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                filterButton
                LazyVStack(spacing: 12) {
                    ForEach(filteredWisdomItems) { item in
                        WisdomCardView(item: item)
                    }
                }
                .safeAreaPadding(.horizontal, 12)
            }
            .navigationTitle("Timeline")
            .safeAreaInset(edge: .bottom) {
                Button {
                    withAnimation {
                        showAddSheet.toggle()
                    }
                } label: {
                    Label {
                        Text("Add")
                    } icon: {
                        Image(systemName: "plus")
                    }
                }
                .padding()
                .background(.white, in: .capsule)
                .shadow(radius: 1)
                .padding()
            }

        }
        .sheet(isPresented: $showAddSheet) {
        }
    }
    
    private var filterButton: some View {
        Menu {
            Button {
                withAnimation {
                    useFilter = false
                    selectedWisdomGroup = []
                }
            } label: {
                LabeledContent {
                    Text("모든 항목")
                } label: {
                    if useFilter == false {
                        Image(systemName: "checkmark")
                    }
                }

            }
            ForEach(WisdomGroup.allCases) { group in
                Button {
                    withAnimation {
                        useFilter = true
                        if selectedWisdomGroup.contains(group) {
                            selectedWisdomGroup.removeAll(where: { group == $0 })
                        } else {
                            selectedWisdomGroup.append(group)
                        }
                    }
                } label: {
                    LabeledContent {
                        Text(group.id)
                    } label: {
                        if selectedWisdomGroup.contains(group) {
                            Image(systemName: "checkmark")
                        }
                    }
                }

            }
        } label: {
            Text("필터")
        }
    }
}

struct WisdomCardView: View {
    var item: WisdomItem
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.createdAt, style: .date)
                .font(.caption)
            switch item.content {
            case .text(_, let text):
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            case .file(_, let imageURL, let description):
                VStack(alignment: .leading) {
                    Rectangle()
                        .fill(.quinary)
                        .frame(height: 120)
                        .scaledToFit()
                    Text(description)
                }
            case .url(_, let urlCase, let imageURL, let description, let author):
                VStack(alignment: .leading) {
                    Rectangle()
                        .fill(.quinary)
                        .frame(height: 120)
                        .scaledToFit()
                    Text(author)
                        .font(.footnote)
                    Text(description)
                }
            case .image(_, let imageURL):
                Rectangle()
                    .fill(.quinary)
                    .frame(height: 120)
                    .scaledToFit()
            }
            HStack {
                ForEach(item.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.footnote)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(.quinary, in: .capsule)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.background, in: .rect(cornerRadius: 12))
        .shadow(radius: 1)
    }
}

#Preview {
    HomeView()
}
