---
title: "hugo와 github pages로 간단히 블로그 만들기 - 기본 설정"
date: 2021-02-13
categories:
  - hugo
tags:
  - hugo
  - github pages
  - github actions
  - 블로그 만들기
draft: false
hidden: false
slug: "3"
---

[목차](../index) / [이전글](../2)

## 기본 설정

config.toml 파일에 내용을 수정, 추가하여 블로그의 형태를 만듭니다.

### 블로그 제목 변경

title가 블로그 제목입니다. 원하는 이름으로 변경해주세요.

```toml
title = "펭귄의 테스트 블로그"
```

- `hugo server`를 통해 블로그 제목을 확인합니다.

![](1.png)

### 사이드바 추가하기

사이드 바에 프로필 이미지와 서브 타이틀을 추가해보겠습니다.

- config.toml 파일에 아래의 내용을 추가합니다.

```toml
[params.sidebar]
subtitle = "서브 타이틀 입니다."

[params.sidebar.avatar]
local = true
src = "img/avatar.png"
```

- assets/img 폴더를 만들고, avatar.png라는 파일이름으로 프로필 이미지를 저장해 주세요.

- `hugo server`를 통해 로컬에서 hugo를 실행시켜주시면 사이드 바가 생성된 것을 확인 할 수 있습니다.
  - assets폴더에 jsconfig.json 파일이 자동 생성되는 것은 신경쓰지 않으셔도 됩니다.

![](2.png)

![](3.png)

### 메뉴 추가하기

'홈으로 이동' 메뉴와 테마에서 기본 제공하는 아카이브, 검색 메뉴를 추가해보겠습니다.

- config.toml 파일에 아래의 내용을 추가합니다.

```toml
[[menu.main]]
identifier = "home"
name = "Home"
weight = -100
pre = "home"

[[menu.main]]
identifier = "archives"
name = "Archives"
url = "archives"
weight = -90
pre = "archives"

[[menu.main]]
identifier = "search"
name = "Search"
url = "search"
weight = -70
pre = "search"
```

- `hugo server`를 통해 생성된 메뉴를 확인합니다.

![](4.png)

현재는 Archives와 Search 페이지가 만들어져 있지 않아서, 클릭하면 `404 page not found`가 페이지에 표시됩니다. Archives와 Search 페이지 추가는 다음글에서 수행하겠습니다.

[목차](../index) / [다음글](../4)
