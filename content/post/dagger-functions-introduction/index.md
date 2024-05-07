---
title: Dagger Functions와 함께하는 CI/CD Pipeline as Code
date: 2024-05-07
lastmod: 2024-05-08
categories:
- Tools
tags:
- Dagger
- Dagger Functions
- Daggerverse
- CI/CD Pipeline as Code
draft: false
hidden: false
image: cover.jpeg
slug: "dagger-functions-introduction"
links:
  - title: dagger-functions-introduction 예제
    website: https://github.com/seungyeop-lee/blog-example/tree/main/dagger-function-introduction
  - title: dagger docs
    website: https://docs.dagger.io/
---

[Dagger][1]란 Code로 CI/CD Pipeline을 만들고, 플렛폼에 종속적이지 않도록 Pipeline을 실행 할 수 있게 해주는 오픈소스 툴이다.
Dagger Engine이 DinD 방식으로 각 Pipeline을 Container로 격리시켜 플렛폼에 종속적이지 않으며, 캐싱이 가능한 것이 특징이다.
Benefit으로 'No More YAML Soup'과 'Eliminate Push And Pray'가 인상적이다.

프로젝트 초창기부터 관심을 가지고 있었으나, CUE를 사용했던 시절에는 CUE에 대한 허들이 너무 높아서 사용을 포기했었고,
Go SDK가 나온 다음에는 사용성이 좋아졌으나, Pipeline을 만들기 위해 작은것 하나하나를 전부 스스로 만들어내야하는 불편함이 있었다.

최근에 Dagger Functions와 다른 사람들이 만든 Dagger Functions를 모듈로 설치해서 사용 할 수있는 [Daggerverse][2]가 출시되면서 사용성이 좋아졌다고 느꼈다.
동아리에서 만드는 서비스의 CI/CD를 Dagger를 이용해 구축해보면서 이제는 확실히 사용 할 만하다고 느껴졌고, 구축에 필요했지만 없던 몇몇 모듈은 Daggerverse에 배포도 해보았다. ([ssh][3], [scp][4], [private-git][5])

좀 더 많은 사람들이 Dagger를 사용했으면 하는 바람으로 Dagger와 Dagger Functions를 소개하는 글을 작성한다.

## Dagger 소개

- [Outsider님의 소개글][6]을 참고하길 바란다.
- 현재는 CUE를 버리고, Go, Python, Typescript SDK를 제공한다.

### Dagger 사용 예시

- 빌드, 테스트, 배포, 보안 검사 등 다양한 CI/CD 작업을 자동화하는 데 사용할 수 있다.
- 예를 들어
  - Go 프로젝트 빌드 및 테스트
  - Docker 이미지 빌드 및 배포
  - Kubernetes 클러스터에 애플리케이션 배포
  - 취약성 검사
  - 그외, 컨테이너를 통해 구동 할 수 있는 모든 것

## Dagger Functions 소개

Dagger Functions는 CI/CD Pipeline을 구성하는 기본 요소다. 
즉, CI/CD Pipeline은 Dagger Function(이하 Function)을 조립하여 만들 수 있다. 

### Dagger Functions 장점

- 작은 작업을 캡슐화하여 Pipeline의 복잡도를 낮추고, 재사용이 가능해진다.
- 서로 다른 언어에서 만든 Function을 사용하는 것이 가능하다.
  - ex. Go SDK로 만든 Function을 Typescript SDK로 만든 Pipeline에 사용 가능
- Daggerverse를 통해 미리 만들어진 Function을 사용하는 것이 가능하여 Pipeline 구축이 용이하다.

## Dagger Functions 시작하기

본 실습은 MacOS, Docker Desktop 환경에서 진행하는 것을 가정합니다. 
Windows 사용시에는 그에 맞는 명령어로 변환해서 실습해주세요.

Go SDK를 사용하여 Function을 작성합니다.

### Dagger 설치

[Dagger Installation][7] 문서를 참고하여 설치한다.

### Dagger Module 만들기

1. 폴더를 만든다.
   - `mkdir my-module`
2. 폴더로 이동한다.
   - `cd my-module`
3. 모듈을 초기화 한다.
   - `dagger init --sdk go --source . --name my-module`

### Dagger Function 작성

1. `main.go` 파일의 내용을 모두 지우고, 아래의 코드를 붙여 넣는다.

```go
package main

import (
	"fmt"
)

type MyModule struct{}

func (m *MyModule) Hello(name string) string {
	return fmt.Sprintf("Hello, %s!", name)
}

func (m *MyModule) GitClone(url string) *Directory {
	return dag.Git(url).Branch("main").Tree()
}
```

2. 실행 가능한 Function을 확인한다.
   - `dagger functions`
3. `hello` Function을 실행하고 결과를 확인한다.
   - `dagger call hello --name "World"`
   - `Hello, World!` 가 출력
4. `git-clone` Function을 실행하고 결과를 확인한다.
   - `dagger call git-clone --url=https://github.com/seungyeop-lee/daggerverse.git -o daggerverse`
   - `daggerverse` 폴더에 Clone된 파일들을 확인 할 수 있음

### Daggerverse 활용

ssh 모듈을 설치하고, ssh를 이용해 원격의 서버에 명령어를 실행하도록 한다.

1. ssh 모듈을 설치한다.
   - `dagger install github.com/seungyeop-lee/daggerverse/ssh`
2. `main.go` 파일에 아래의 코드를 추가한다.

```go
func (m *MyModule) SshCommand(
	ctx context.Context,
	address string,
	password string,
	command string,
) (string, error) {
	output, err := dag.SSH().
		Config(address).
		WithPassword(dag.SetSecret("password", password)).
		Command(command).
		Stdout(ctx)
	if err != nil {
		return "", err
	}

	return output, nil
}
```

3. 실행 가능한 Function에 `ssh-command`가 추가 되었는지 확인한다.
   - `dagger functions`
4. `ssh-command` Function을 실행하고 결과를 확인한다.
   - `dagger call -v ssh-command --address="user@your_server_address" --password="user_password" --command="ls -al"`
   - `ls -al`의 결과가 출력된다.

Note 1. 본 실습에서는 password를 단순 입력했으나, 실제로는 secret을 사용해야 한다. 자세한 사항은 [Dagger Docs/Secrets 문서][8] 참조

Note 2. 본 실습은 [git repository][9]에 동일하게 올라와있으니 참고

## 마무리

Dagger와 Dagger Functions를 간단히 알아보았다. 
더 자세히 알고 싶으면 Dagger 공식 문서의 [Quickstart][10] 및 [User Manual][11], [Developer Manual][12]을 참고하길 바란다. 

## ref.

- [Dagger][1]
- [Daggerverse][2]
  - [ssh][3]
  - [scp][4]
  - [private-git][5]
- [Outsider's Dev Story - CI/CD 파이프라인 엔진 Dagger][6]
- Dagger Docs
  - [Install][7]
  - [Secrets][8]
  - [Quickstart][10]
  - [User Manual][11]
  - [Developer Manual][12]
- [dagger-functions-introduction 예제][9]

[1]: <https://dagger.io/> "Dagger"
[2]: <https://daggerverse.dev/> "Daggerverse"
[3]: <https://daggerverse.dev/mod/github.com/seungyeop-lee/daggerverse/ssh> "Daggerverse - ssh"
[4]: <https://daggerverse.dev/mod/github.com/seungyeop-lee/daggerverse/scp> "Daggerverse - scp"
[5]: <https://daggerverse.dev/mod/github.com/seungyeop-lee/daggerverse/private-git> "Daggerverse - private-git"
[6]: <https://blog.outsider.ne.kr/1642> "CI/CD 파이프라인 엔진 Dagger"
[7]: <https://docs.dagger.io/install> "Dagger Installation"
[8]: <https://docs.dagger.io/manuals/developer/go/203021/secrets> "Dagger docs - Secrets"
[9]: <https://github.com/seungyeop-lee/blog-example/tree/main/dagger-function-introduction> "dagger-functions-introduction 예제"
[10]: <https://docs.dagger.io/quickstart> "Dagger docs - Quickstart"
[11]: <https://docs.dagger.io/manuals/user> "Dagger docs - User Manual"
[12]: <https://docs.dagger.io/manuals/developer> "Dagger docs - Developer Manual"
