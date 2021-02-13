---
title: "hugo와 github pages로 간단히 블로그 만들기"
date: 2021-02-13
lastmod: 2021-02-13
categories:
  - hugo
tags:
  - hugo
  - github pages
  - github actions
  - 블로그 만들기
draft: false
layout: "single"
slug: "index"
image: "/blog/img/hugo/hugo와-github-pages로-간단히-블로그-만들기.png"
---

## 목차

1. [블로그 만들기](../1)
2. [github pages로 배포하기](../2)
3. 블로그 꾸미기 - 작성 중
4. utterances로 댓글기능 추가하기 - 작성 중

## 목표

- 블로그 진입점을 github pages의 루트가 아닌, 서브 path로 합니다.
  - ex. `https://seungyeop-lee.github.io/test-blog/`
- 하나의 repository에서 hugo의 소스파일과 생성된 html을 전부 관리합니다.
- github actions를 이용하여 push 할 경우, 자동으로 배포가 되게 합니다.
- utterances를 사용하여 댓글도 같은 repository에서 관리합니다.

## 실습전 확인 사항

### 주의

시간이 지남에 따라 내용이 정확하지 않을 수 있습니다. 화면이나 움직임이 다를경우 공식 문서를 참고해주세요.

- [hugo](https://gohugo.io/documentation/)
- [github pages](https://docs.github.com/en/github/working-with-github-pages)
- [utterances](https://utteranc.es/)

### 전제 조건

- git 설치
- github 계정 준비

### 실습 환경

- macOS 환경
- brew, vscode 사용
