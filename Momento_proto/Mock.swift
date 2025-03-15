//
//  Mock.swift
//  Momento_proto
//
//  Created by 김예훈 on 3/15/25.
//

import Foundation

// Mock 데이터 샘플
struct MockData {
    static let wisdomItems: [WisdomItem] = [
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
            description: "오늘의 깨달음",
            group: .one,
            content: .text(
                id: UUID(),
                text: "시간 관리의 핵심은 중요한 일에 우선순위를 두고 불필요한 일은 과감히 줄이는 것"
            ),
            tags: ["업무", "생산성"],
            summary: "효율적인 시간 관리에 대한 깨달음"
        ),
        
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            description: "인생을 바꾸는 5분 - 동기부여 영상",
            group: .two,
            content: .url(
                id: UUID(),
                urlCase: .youtube,
                imageURL: "https://example.com/thumbnail.jpg",
                description: "어려운 시간을 이겨내는 방법과 성공을 향한 긍정적인 마인드셋에 대한 영상",
                author: "성장하는 인생"
            ),
            tags: ["동기부여", "성장"],
            summary: "어려운 시간을 극복하는 방법에 관한 영상"
        ),
        
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            description: "명언 모음 인스타그램",
            group: .one,
            content: .url(
                id: UUID(),
                urlCase: .instagram,
                imageURL: "https://example.com/instagram_post.jpg",
                description: "오늘 하루도 감사함으로 시작하자. 작은 일에도 감사할 줄 알면 더 많은 감사할 일이 생긴다.",
                author: "@daily_wisdom"
            ),
            tags: ["명상", "감사"],
            summary: "일상 속 감사함의 중요성"
        ),
        
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            description: "어려웠던 일을 해결한 후",
            group: .two,
            content: .text(
                id: UUID(),
                text: "어려운 일일수록 첫 발을 내딛는 게 가장 중요하다. 시작이 반이라는 말이 정말 맞는 것 같다."
            ),
            tags: ["도전/극복", "성취감"],
            summary: "어려운 문제 해결에 대한 성찰"
        ),
        
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            description: "심리학 관련 논문 요약",
            group: .one,
            content: .file(
                id: UUID(),
                imageURL: "https://example.com/document_thumb.jpg",
                description: "인지행동치료의 효과성에 관한 최신 연구 결과 요약"
            ),
            tags: ["심리학", "연구", "학습"],
            summary: "인지행동치료 연구 결과"
        ),
        
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,
            description: "영감을 주는 인용구",
            group: .two,
            content: .text(
                id: UUID(),
                text: "당신이 상상할 수 있다면, 당신은 그것을 이룰 수 있다. - 월트 디즈니"
            ),
            tags: ["영감", "명언"],
            summary: "디즈니의 명언"
        ),
        
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
            description: "리더십에 관한 LinkedIn 게시물",
            group: .one,
            content: .url(
                id: UUID(),
                urlCase: .linkedin,
                imageURL: "https://example.com/linkedin_post.jpg",
                description: "효과적인 리더는 지시하는 사람이 아니라, 영감을 주고 지원하는 사람입니다.",
                author: "김성공 | 커리어 코치"
            ),
            tags: ["리더십", "커리어", "성장"],
            summary: "현대적 리더십의 특성"
        ),
        
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .day, value: -25, to: Date())!,
            description: "명상 수업에서 찍은 사진",
            group: .two,
            content: .image(
                id: UUID(),
                imageURL: "https://example.com/meditation_class.jpg"
            ),
            tags: ["명상", "마음챙김", "평화"],
            summary: "명상 수업 참여 기록"
        ),
        
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
            description: "트위터에서 발견한 통찰",
            group: .one,
            content: .url(
                id: UUID(),
                urlCase: .twitter,
                imageURL: "https://example.com/twitter_post.jpg",
                description: "배움에는 끝이 없다. 당신이 배움을 멈추는 순간, 당신은 성장을 멈추는 것이다.",
                author: "@wisdom_quotes"
            ),
            tags: ["배움", "성장", "통찰"],
            summary: "지속적 배움의 중요성"
        ),
        
        WisdomItem(
            id: UUID(),
            createdAt: Calendar.current.date(byAdding: .month, value: -2, to: Date())!,
            description: "여행 중 깨달은 점",
            group: .two,
            content: .text(
                id: UUID(),
                text: "익숙한 환경을 벗어나면 새로운 시각으로 세상을 볼 수 있게 된다. 여행은 단순한 휴식이 아니라 자신을 새롭게 발견하는 기회다."
            ),
            tags: ["여행", "자기발견", "성찰"],
            summary: "여행을 통한 자기 발견"
        )
    ]
}
