---
title: "좋은 코드, 나쁜 코드 북스터디 - chap11. 단위 테스트의 실제"
date: 2024-02-18
lastmod: 2024-02-18
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
slug: "chap11"
---

# 11. 단위 테스트의 실제

좋은 단위 테스트의 특징

- 코드의 문제를 정확하게 감지한다
- 구현 세부 정보에 구애받지 않는다
- 실패는 잘 설명된다
- 테스트 코드가 이해하기 쉽다
- 테스트를 쉽고 빠르게 실행할 수 있다

하지만 위의 특징을 가진 테스트는 그냥 작성되는 것이 아니다. 즉, 비효율적이고 유지보수하기 어려운 테스트 코드를 작성하기가 쉽다.

## 11.1. 기능뿐만 아니라 동작을 시험하라

함수당 하나의 테스트 케이스만 있다면 중요한 동작에 대한 테스트가 없을 가능성이 높다.

함수가 가지고 있어야 할 사양을 확인하는 각각의 테스트 케이스가 필요하다. 또한 오류 시나리오에 대해 테스트 되었는지 확인하는 것이 중요하다.

## 11.2. 테스트만을 위해 퍼블릭으로 만들지 말라

> 프라이빗 함수는 구현 세부 사항이며 클래스 외부의 코드가 인지하거나 직접 사용하는 것이 아니다. (중략) 구현 세부 사항과 밀접하게 연관된 테스트가 될 수 있고 궁극적으로 우리가 신경 써야 하는 코드의 동작을 테스트하지 않을 수 있기 때문이다.

그러므로 퍼블릭 API를 통해서만 확인 할 수있는 테스트를 하거나, 프라이빗 함수를 명확한 역할을 가진 별도의 퍼블릭 API로 만들어서 테스트 코드를 작성한다.

## 11.3. 한 번에 하나의 동작만 테스트하라

하나의 테스트 케이스에서 여러 동작을 확인하게 될 경우, 테스트코드의 유지보수성이 낮아진다.

그러므로 테스트 케이스는 최대한 하나의 동작에 대해서만 테스트하여하하고, 여러 값에 대한 테스트를 진행해야 할 경우 매개변수를 사용한 테스트를 진행한다.

## 11.4. 공유 설정을 적절하게 사용하라

- 상태 공유(sharing state)
  - 모든 테스트 케이스 실행 전에 한번 실행되어 설정되는 데이터
  - 변할 수 있는 상태 공유로 인해 테스트 케이스 끼리 결과에 영향을 미칠 수 있다. 그러므로 상태 공유는 원칙적으로 하지 않거나, 불가피하게 사용해야 한다면 사용 전에 초기화해서 사용하라.
- 설정 공유(sharing configuration)
  - 각 테스트 케이스 실행 전에 실행되어 설정되는 데이터
  - 상태 공유보다는 덜 위험하나, 오용 될 수 있다. 그러므로 중요한 설정은 테스트 케이스 내에서 수행하라.
    - ex. 공유된 설정의 지식을 기반으로 테스트 케이스를 작성하는 경우, 다른 테스트 케이스로 인해 공유된 설정이 변경되면 기존의 테스트 케이스에 영향을 줄 수 있다.
  - 물론 테스트 케이스의 결과에 직접적인 영향을 주지는 않되, 테스트를 위해 공통으로 필요한 설정의 경우에는 설정 공유를 사용해도 좋다.

## 11.5. 적절한 어서션 확인자를 사용하라

적절한 어서션 확인자를 사용하여, 테스트 실패 시 가독성을 향상시키는 것이 좋다.

## 11.6. 테스트 용이성을 위해 의존성 주입을 사용하라

하드 코딩 된 의존성은 의존성의 대상 객체에 따라서 테스트를 불가능하게 만드는 요인이 될 수 있다.

그러므로 의존성 주입을 이용해 테스트 시 의존성을 교체 할 수 있는 여지를 만들어 주자.

## 11.7. 테스트에 대한 몇 가지 결론

> 단위 테스트가 가장 흔한 테스트 유형이지만, 단위 테스트만으로는 테스트의 모든 요구 사항을 충족 할 수 없기 때문에 다양한 테스트 유형과 수준에 대해 알아보고 새로운 툴과 기술에 대한 최신 정보를 유지하는것이 좋다.
