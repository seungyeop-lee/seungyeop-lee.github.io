---
title: "좋은 코드, 나쁜 코드 북스터디 - chap02. 추상화 계층"
date: 2023-12-09
lastmod: 2023-12-27
categories:
  - 스터디
  - 책 요약
tags:
  - 스터디
  - 북스터디
  - 좋은 코드, 나쁜 코드
  - Good Code, Bad Code
draft: false
hidden: true
slug: "chap02"
---

# 2. 추상화 계층

> 코드 작성의 목적은 문제 해결이다. 그리고 문제는 상위 수준 문제와 하위 수준 문제로 나눌 수 있으며, 일반적으로 상위 수준 문제는 하위 수준 문제의 집합이다. 그렇기에 코드도 구성이 중요하다.

> 코드 구성은 코드 품질의 기본측면 중 하나이고, 좋은 코드 구성은 간결한 추상화 계층을 만드는 것으로 귀결될 때가 많다.

## 2.1. 널값 및 의사코드 규약

의사코드에 대한 이야기, 널 안전성에 대한 이야기를 한다.

## 2.2. 왜 추상화 계층을 만드는가?

일반적인 클라이언트-서버 통신을 예로 들면서, 상위 수준과 하위 수준에서 이 문제를 어떻게 바라볼수 있는지를 이야기하며 추상화 계층에 대해 설명한다. 그리고 추상화 계층이 왜 복잡한 문제를 단순하게 만들 수 있는지를 이야기한다.

### 2.2.1. 추상화 계층 및 코드 품질의 핵심 요소

추상화 계층과 코드 품질의 네 가지 핵심 요소와의 상관 관계를 서술하고 있다.

- 가독성: 상위 몇 계층과 몇 개의 개념만으로 코드를 이해 할 수 있음
- 모듈화: 계층을 나누면 계층 별 모듈화가 자연스럽게 진행 됨
- 재사용성 및 일반화성: 하위 계층은 자연스럽게 재사용하기 쉬움
- 테스트 용이성: 하위 문제에 대해 테스트가 쉬워짐으로 전체적인 프로그램 신뢰성 향상

## 2.3. 코드의 계층

> 추상화 계층을 생성하는 방법은 서로 다른 단위로 분할하여 단위 간의 의존 관계를 보여주는 의존성 그래프를 생성하는 것

> 단위로는 함수, 클래스, 인터페이스, 패키지 등이 있음

### 2.3.1. API 및 구현 세부 사항

일단 API라는 것은 서버의 REST API에 국한된 것이 아니다.
프로그램에서 다른 서버나 다른 코드를 호출 할 때 사용하는 모든 것을 API라 한다.
API에는 구현 세부 사항을 포함해서는 안되며, 이 것을 확인하는 방법은 코드의 일부를 작성하거나 수정 했을 때 API도 같이 수정되어야 하는지 여부로 알 수 있다.

### 2.3.2. 함수

> 코드 작성을 일단 마치고 코드 검토를 요청하기 전에 자신이 작성한 코드를 비판적으로 다시 한번 살펴보는 것이 좋다. 함수를 한 문장으로 표현하기 어렵게 구현했다면 로직의 일부를 잘 명명된 헬퍼 함수로 분리하는 것을 고려해봐야 한다.

### 2.3.3. 클래스

> 필자는 이런 경험칙을 전혀 알지 못하거나 ‘클래스는 응집력이 있어야 하고 한 가지 일에만 관심을 가져야 한다’와 같은 말에 동의하지 않는 개발자들은 별로 만나보지 못했다. 하지만 이 조언을 알고 있음에도 불구하고 많은 개발자가 여전히 너무 큰 클래스를 작성한다.

### 2.3.4. 인터페이스

구현이 1개만 있을 때, 인터페이스를 도입 함으로서 얻는 장단점

- 장점: 기능 수정 및 추가 용이, 테스트 코드 작성 용이
- 단점: 코드 양이 줄어 가독성 향상

지금 인터페이스를 붙이냐 마냐가 중요하기 보단, 어떤 함수를 노출 할지를 신중히 고민하는 것이 더 중요하다.

### 2.3.5. 층이 너무 얇아질 때

> 일반적으로 너무 많은 일을 하는 계층은 너무 적은 일을 하는 계층보다 더 문제가 될 수 있다. 따라서 어떤 것이 더 나을지 확실하지 않다면, 너무 많은 계층을 남용하는 결과를 가져오더라도 계층을 여러 개로 나누는 것이 한 계층 안에 모든 코드를 집어넣는 것보다는 낫다.

## 2.4. 마이크로서비스는 어떤가?
마이크로서비스의 각 모듈 안에서 해결해야 할 하위 문제는 여전히 존재한다.
하위 문제를 잘 해결하기위한 해결책으로서 추상화 및 코드 계층이 이용되므로 여전히 중요하다.