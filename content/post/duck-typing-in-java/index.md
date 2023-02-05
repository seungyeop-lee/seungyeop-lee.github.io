---
title: 자바에서 덕 타이핑하기
date: 2023-02-05
lastmod: 2023-02-05
categories:
- Backend
tags:
- Java 8
- Duck Typing
- Method References
draft: false
hidden: false 
image: cover.jpg
---

## TL;DR

- Java 8의 Method References를 이용하면 덕 타이핑이 가능하다.

## 덕 타이핑 이란

[위키피디아][1] 참고

## 자바에서 덕 타이핑이 가능하지 않았던 이유

자바는 상속(`extend`)이나 구현(`implement`)으로 타입을 명시해야지만 사용이 가능한 언어스팩을 가지고 있다.

```java
public class GeneralExample {
    public static void main(String[] args) throws InterruptedException {
        new Thread(new RunnableImpl()).start();
        sleep(100);
    }

    private static class RunnableImpl implements Runnable {
        @Override
        public void run() {
            System.out.println("RunnableImpl.run");
        }
    }
}
```

## Method References를 이용한 덕 타이핑

Java 8에서 추가된 Method References를 이용하면 타입을 명시하지 않아도 사용이 가능하다.

다만, 타입이 Functional Interface 를 만족해야 한다는 한계가 있다. (메서드 1개를 타입에 사용하는 것이므로)

```java
public class DuckTypingExample {
    public static void main(String[] args) throws InterruptedException {
        new Thread(new MethodReferencesExample()::method).start();
        new Thread(MethodReferencesExample::staticMethod).start();
        sleep(100);
    }

    private static class MethodReferencesExample {
        public void method() {
            System.out.println("MethodReferencesExample.method");
        }

        public static void staticMethod() {
            System.out.println("MethodReferencesExample.staticMethod");
        }
    }
}
```

## 프로그래밍 시 덕 타이핑의 장점과 단점

구현체를 특정 타입으로 사용하려 할 경우, 덕 타이핑 없이는 의존성이 생길 수 밖에 없다. 그에 비해 덕 타이핑이 가능하다면 의존성 없이 사용 가능하다.

의존성이 없다는 것은 좀 더 유연한 구조를 만들 수 있다는 것을 의미하지만, 명시적인 의존성이 없어서 프로젝트 파악은 더 힘들어 질 수 있다.

## ref.

- [덕 타이핑: 위키피디아][1]

[1]: <https://ko.wikipedia.org/wiki/%EB%8D%95_%ED%83%80%EC%9D%B4%ED%95%91> "덕 타이핑"
