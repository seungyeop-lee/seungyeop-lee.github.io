---
title: "CSS Tips"
date: 2022-09-23
lastmod: 2022-09-23
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
