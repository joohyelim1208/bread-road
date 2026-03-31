🍞 Bread Road (빵으로 잇는 일상의 지도)
"전국 빵순이, 빵돌이들을 위한 빵지순례 기록 및 공유 플랫폼"

📌 Project Overview (프로젝트 개요)
서비스명: Bread Road (브레드 로드)

개발 기간: 2025.12 ~ 2026.04 (진행 중)

주요 기능: 지도 기반 빵집 검색, 방문 빵집 및 먹은 빵 기록(이미지/평점), 개인 빵지순례 아카이브 관리

🛠 Tech Stack (기술 스택)
Framework: Flutter (Dart)

Backend: Firebase (Authentication, Cloud Firestore, Storage)

State Management: Riverpod(전역 상태 관리 및 의존성 주입 최적화) / 초반 statefulWidget으로 구현 ~3/31

Design Strategy: Minimalist Grey Scale UI, Semantic Color System

✨  로드맵 & 리팩토링 계획

State Management: Riverpod으로의 마이그레이션을 통해 전역 상태 관리 체계 강화.

Navigation: GoRouter 도입을 통한 선언적 라우팅 구현 및 딥링크(Deep Link) 대응 구조 마련.

Architecture: Clean Architecture 적용으로 비즈니스 로직과 UI 분리 및 코드 재사용성 극대화.

Features: image_picker를 활용한 레시피 업로드, 지역 빵집 API 연동 및 즐겨찾기 기능.

✨ Key Features (핵심 기능)
Interactive Map: Google Maps API를 활용한 직관적인 빵집 위치 확인 및 핀 고정 기능

Bread Log Archive: 방문한 빵집에서 먹은 빵 종류를 카테고리별로 기록하고 관리하는 히스토리 기능

Optimized UX: WebP 포맷 에셋 최적화 및 AnimationController를 활용한 몰입형 스플래시 애니메이션

Search & Filter: 지역별, 빵 종류별(소금빵, 단팥빵 등) 필터링 시스템

🎨 Design Concept (디자인 컨셉)
Main Theme: '심플 & 직관'을 목표로 한 Grey Tone 테마

Point Color: 별점 및 경고 알림에 **Semantic Color(Amber, Red)**를 적용하여 정보 전달력 강화

Splash Screen: 9:19.5 고해상도 WebP 이미지를 활용한 패럴랙스 애니메이션 구현
