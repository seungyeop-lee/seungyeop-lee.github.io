# 펭귄의 외부 저장소

개인 블로그 소스 저장소. Hugo + GitHub Pages로 운영.

- 블로그: https://blog.seungyeop-lee.com
- 테마: [Hugo Theme Stack v3](https://github.com/CaiJimmy/hugo-theme-stack)

## 로컬 실행

```bash
# 개발 서버 실행 (http://localhost:1313)
make dev

# 빌드만
make build

# 테마 업데이트
make update-theme
```

## 프로젝트 구조

```
├── content/
│   ├── post/           # 블로그 포스트
│   └── page/           # 특수 페이지 (archives, search, links)
├── layouts/            # 테마 오버라이드 레이아웃
├── assets/             # 이미지, SCSS 등
├── static/             # 정적 파일 (favicon 등)
├── config.yml          # Hugo 설정
└── Makefile            # 개발 명령어
```

## 새 글 작성

### 1. 폴더 생성

```bash
mkdir content/post/{slug}/
```

### 2. index.md 작성

```markdown
---
title: "포스트 제목"
description: "포스트 요약 (한글 기준 80–150자 권장)"
date: 2025-01-01
categories:
  - Backend
tags:
  - spring-boot
draft: false
image: cover.png
---

본문 내용...
```

> `description`은 필수다. 누락 시 본문 요약이 통째로 `<meta name="description">`에 들어가 길이가 비정상적으로 길어진다.

### 3. 이미지 추가 (선택)

- `cover.png` 또는 `cover.jpeg`: 썸네일
- 본문 이미지는 같은 폴더에 추가 후 상대경로로 참조

### 4. 확인 및 발행

```bash
# 로컬에서 확인
make dev

# main 브랜치에 push하면 자동 배포
git add . && git commit -m "Add: 포스트 제목" && git push
```

## Frontmatter 옵션

| 필드 | 필수 | 설명 |
|------|------|------|
| `title` | O | 포스트 제목 |
| `description` | O | 포스트 요약 (한글 80–150자 권장, meta description으로 사용) |
| `date` | O | 발행 날짜 (YYYY-MM-DD) |
| `draft` | O | `false`여야 발행됨 |
| `categories` | - | 카테고리 목록 |
| `tags` | - | 태그 목록 |
| `image` | - | 썸네일 이미지 파일명 |
| `lastmod` | - | 마지막 수정 날짜 |
| `hidden` | - | `true`면 목록에서 숨김 |
| `aliases` | - | 이전 URL 리다이렉트 |

## 배포

GitHub Actions로 자동 배포.

1. `main` 브랜치에 push
2. `.github/workflows/gh-pages.yml` 실행
3. `public/` 빌드 후 `gh-pages` 브랜치로 배포
4. GitHub Pages에서 서빙

## 카테고리 예시

- Backend: Spring Boot, QueryDSL, 테스트 등
- Frontend: React, CSS 등
- Tools: Supabase, k6, Dagger 등
