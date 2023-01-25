---
title: "Spring Boot 3에서 QueryDSL 사용 시 build 실패 문제 해결"
date: 2022-11-07
lastmod: 2022-11-07
categories:
- Backend
tags:
- Spring Boot 3
- QueryDSL
- Hibernate 6
- jakarta.persistence
draft: false
hidden: false
image: cover.png
aliases: [/blog/post/spring-boot-3에서-querydsl-사용-시-build-실패-문제-해결/]
---

## Spring Boot 3에 기존 QueryDSL 설정을 사용하면 벌어지는 일

기존 Spring Boot 2.6.7 버전에서 사용하던 QueryDSL 설정은 아래와 같다.

```gradle
dependencies {
    implementation 'com.querydsl:querydsl-jpa'
    annotationProcessor "com.querydsl:querydsl-apt:${dependencyManagement.importedProperties['querydsl.version']}:jpa"
    annotationProcessor 'jakarta.persistence:jakarta.persistence-api'
    annotationProcessor 'jakarta.annotation:jakarta.annotation-api'
}
```

동일 설정을 유지한 상태에서 Spring Boot 3.0.0-SNAPSHOT (RC2 + RC3)로 올려서 빌드를 시도하였으나 아래와 같은 에러 메세지가 발생하면서 실패하였다.

```
org.gradle.api.tasks.TaskExecutionException: Execution failed for task ':compileJava'.
Caused by: java.lang.RuntimeException: java.lang.NoClassDefFoundError: javax/persistence/Entity
	at jdk.compiler/com.sun.tools.javac.api.JavacTaskImpl.invocationHelper(JavacTaskImpl.java:168)
	at jdk.compiler/com.sun.tools.javac.api.JavacTaskImpl.doCall(JavacTaskImpl.java:100)
	at jdk.compiler/com.sun.tools.javac.api.JavacTaskImpl.call(JavacTaskImpl.java:94)
        ...
Caused by: java.lang.NoClassDefFoundError: javax/persistence/Entity
	at com.querydsl.apt.jpa.JPAAnnotationProcessor.createConfiguration(JPAAnnotationProcessor.java:37)
	at com.querydsl.apt.AbstractQuerydslProcessor.process(AbstractQuerydslProcessor.java:82)
        ...
Caused by: java.lang.ClassNotFoundException: javax.persistence.Entity
        ...
```

## 해결책

QueryDSL 설정은 아래와 같이 변경하여 해결하였다.

```gradle
dependencies {
    implementation "com.querydsl:querydsl-jpa:${dependencyManagement.importedProperties['querydsl.version']}:jakarta"
    annotationProcessor "com.querydsl:querydsl-apt:${dependencyManagement.importedProperties['querydsl.version']}:jakarta"
    annotationProcessor 'jakarta.persistence:jakarta.persistence-api'
    annotationProcessor 'jakarta.annotation:jakarta.annotation-api'
}
```

## 원인 및 해결 과정

빌드 실패의 원인은 기존 `javax.persistence` 패키지가 `jakarta.persistence`로 변경되면서 발생한 문제로 확인되었다.

QueryDSL의 github repository issue를 살펴보면 querydsl-apt에 대해서만 classifier로 jakarta를 설정하면 문제가 해결된다는 comment를 발견하였고, 실제로 적용하면 build 실패 문제가 해결되었으나, `QuerydslPredicateExecutor`를 이용하여 query를 실행 할 경우, runtime에서 아래와 같은 예외가 발생 함을 확인 할 수 있었다.

```
java.lang.ClassNotFoundException: javax.persistence.NoResultException
	at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:641) ~[na:na]
	at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:188) ~[na:na]
	at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:520) ~[na:na]
	at org.springframework.data.jpa.repository.support.Querydsl.createQuery(Querydsl.java:85) ~[spring-data-jpa-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.jpa.repository.support.Querydsl.createQuery(Querydsl.java:102) ~[spring-data-jpa-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.jpa.repository.support.QuerydslJpaPredicateExecutor.doCreateQuery(QuerydslJpaPredicateExecutor.java:256) ~[spring-data-jpa-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.jpa.repository.support.QuerydslJpaPredicateExecutor.createCountQuery(QuerydslJpaPredicateExecutor.java:225) ~[spring-data-jpa-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.jpa.repository.support.QuerydslJpaPredicateExecutor.findAll(QuerydslJpaPredicateExecutor.java:140) ~[spring-data-jpa-3.0.0-RC2.jar:3.0.0-RC2]
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[na:na]
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:77) ~[na:na]
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[na:na]
	at java.base/java.lang.reflect.Method.invoke(Method.java:568) ~[na:na]
	at org.springframework.data.repository.core.support.RepositoryMethodInvoker$RepositoryFragmentMethodInvoker.lambda$new$0(RepositoryMethodInvoker.java:288) ~[spring-data-commons-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.repository.core.support.RepositoryMethodInvoker.doInvoke(RepositoryMethodInvoker.java:136) ~[spring-data-commons-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.repository.core.support.RepositoryMethodInvoker.invoke(RepositoryMethodInvoker.java:120) ~[spring-data-commons-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.repository.core.support.RepositoryComposition$RepositoryFragments.invoke(RepositoryComposition.java:516) ~[spring-data-commons-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.repository.core.support.RepositoryComposition.invoke(RepositoryComposition.java:285) ~[spring-data-commons-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.repository.core.support.RepositoryFactorySupport$ImplementationMethodExecutionInterceptor.invoke(RepositoryFactorySupport.java:628) ~[spring-data-commons-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:184) ~[spring-aop-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.data.repository.core.support.QueryExecutorMethodInterceptor.doInvoke(QueryExecutorMethodInterceptor.java:168) ~[spring-data-commons-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.data.repository.core.support.QueryExecutorMethodInterceptor.invoke(QueryExecutorMethodInterceptor.java:143) ~[spring-data-commons-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:184) ~[spring-aop-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.data.projection.DefaultMethodInvokingMethodInterceptor.invoke(DefaultMethodInvokingMethodInterceptor.java:77) ~[spring-data-commons-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:184) ~[spring-aop-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.transaction.interceptor.TransactionInterceptor$1.proceedWithInvocation(TransactionInterceptor.java:123) ~[spring-tx-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.transaction.interceptor.TransactionAspectSupport.invokeWithinTransaction(TransactionAspectSupport.java:388) ~[spring-tx-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.transaction.interceptor.TransactionInterceptor.invoke(TransactionInterceptor.java:119) ~[spring-tx-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:184) ~[spring-aop-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.dao.support.PersistenceExceptionTranslationInterceptor.invoke(PersistenceExceptionTranslationInterceptor.java:137) ~[spring-tx-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:184) ~[spring-aop-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.data.jpa.repository.support.CrudMethodMetadataPostProcessor$CrudMethodMetadataPopulatingMethodInterceptor.invoke(CrudMethodMetadataPostProcessor.java:163) ~[spring-data-jpa-3.0.0-RC2.jar:3.0.0-RC2]
	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:184) ~[spring-aop-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97) ~[spring-aop-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:184) ~[spring-aop-6.0.0-RC3.jar:6.0.0-RC3]
	at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:218) ~[spring-aop-6.0.0-RC3.jar:6.0.0-RC3]
	at jdk.proxy4/jdk.proxy4.$Proxy120.findAll(Unknown Source) ~[na:na]
	...
```

```gradle
// 예외가 발생했을 때의 QueryDSL 설정
dependencies {
    implementation 'com.querydsl:querydsl-jpa'
    annotationProcessor "com.querydsl:querydsl-apt:${dependencyManagement.importedProperties['querydsl.version']}:jakarta"
    annotationProcessor 'jakarta.persistence:jakarta.persistence-api'
    annotationProcessor 'jakarta.annotation:jakarta.annotation-api'
}
```

코드를 확인해보니 `org.springframework.data.jpa.repository.support.Querydsl`에서 `com.querydsl.jpa.impl.JPAQuery`를 사용하고 있으나, data.jpa에서는 `jakarta.persistence.EntityManager`를 querydsl.jap에서는 `javax.persistence.EntityManager`를 사용하고 있어서 발생한 문제였다.

`com.querydsl.jpa.impl.JPAQuery`는 `com.querydsl:querydsl-jpa`의존성에 속해 있으므로, `com.querydsl:querydsl-jpa`에도 jakarta classifier를 추가하여 문제를 해결하였다.

현재 (2022년 11월 7일) 위의 내용은 공식 문서를 포함하여 어디에도 제대로 기재되어 있는 곳이 없고, 다른 분들은 나와 같은 삽질을 하지 않길 바라는 마음에 블로깅을 해본다. 많은 분들의 시간이 절약되기를...

## ref.

- [With SpringBoot 3.0.0-RC1 build failed.](https://github.com/querydsl/querydsl/issues/3421)
- [Q classes are not generated by AP where using jakarta.persistence.* instead of javax.persistence.*](https://github.com/querydsl/querydsl/issues/3371)
- [[Feature Request] Hibernate 6 support](https://github.com/querydsl/querydsl/issues/3233)
