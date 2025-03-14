//
//  HomeView.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/14/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showAddSheet = false
    var body: some View {
        VStack {
            HStack {
                Text(Date(), style: .date)
                Spacer()
                Button {
                } label: {
                    Text("정렬순")
                }
            }
            ScrollView {
                ForEach(0..<10, id: \.self) { id in
                    Rectangle()
                        .fill(.quinary)
                        .frame(height: 120)
                        .overlay {
                            Text("Content")
                        }
                }
            }
        }
        .safeAreaPadding(20)
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
            .background(.black)
            .padding()
        }
        .sheet(isPresented: $showAddSheet) {
            
        }
    }
}

#Preview {
    HomeView()
}
