---
title: "CSS Tips"
date: 2022-09-23
lastmod: 2022-09-27
categories:
- FrontEnd
tags:
- CSS
- Tips
draft: false
hidden: false
image: cover.png
---

## 상속

부모로부터 상속받은 속성은 브라우저의 디폴트 CSS 속성보다 우선순위가 낮다.

## 여백 상쇄

여백 상쇄(margin collapsing)로 인해 margin이 설정한 것과 다르게 보이는 경우가 있다. ([참조](https://developer.mozilla.org/ko/docs/Web/CSS/CSS_Box_Model/Mastering_margin_collapsing))
    
1. 둘 다 margin을 가진 인접 형제 요소
2. 첫째 및/또는 마지막 (혹은 유일한)의 자식 요소에 margin이 설정된 하나 또는 둘 이상의 자식 요소를 가진 부모 요소 (자식의 margin이 부모의 margin보다 클 경우 발생)

## 줄바꿈 문자

줄바꿈 문자도 문자로 판단하여, 그만큼의 공간을 차지한다.

### 예시

두 태그를 한 줄에 놓는 html 예제

```html
<html>
    <head>
        <style>
            * {
                box-sizing: border-box;
            }
            .main-div {
                display: inline-block;
                width: 50px;
            }
            .main-nav {
                display: inline-block;
                /* main-div 50px + 줄 바꿈 기호(공백) 5px */
                width: calc(100% - 55px);
            }
        </style>
    </head>
    <body>
        <div class="main-div">
            내용1
        </div>
        <nav class="main-nav">
            내용2
        <nav>
    </body>
</html>
```

## 2개 이상의 클래스

2개 이상의 클래스가 1개의 태그에 설정 된 경우 클래스를 선택자로 하여 정의한 CSS 적용 룰

- 태그에 선언된 클래스의 선언 순서는 영향을 미치지 않는다.
- 태그에 선언된 클래스를 선택자로 한 CSS의 정의 순서만이 적용에 영향을 미친다.
    - 나중에 정의된 CSS가 먼저 정의된 CSS를 덮어쓴다.

## border vs. outline

border는 box model의 일부이며, outline은 box model에 속하지 않는다. outline은 border를 포함해서 요소를 완전히 둘러싼다. outline의 경우 해당 요소를 특별히 강조하기 위해 사용된다. ([참고](https://cssdeck.com/blog/css-tips-outline-vs-border/))

## `margin: auto`

`margin: auto`로 할 경우, 해당 태그가 width나 height 기준으로 100%에 맞도록 자동으로 margin을 추가해준다. 
일반적으로는 width를 % 단위로 줄이고, `margin: auto`를 사용하여 중앙 정렬을 할 때 많이 사용된다.

## 동일 z-index

`position: fixed`인 2개 이상의 태그가 동일한 z-index를 가진경우에는 나중에 정의된 태그가 더 위에 위치한다.
