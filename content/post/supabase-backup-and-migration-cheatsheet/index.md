---
title: "Supabase Backup & Migration CheetSheet"
date: 2025-03-16
lastmod: 2025-03-16
categories:
  - Tools
tags:
  - supabase
  - cli
  - backup
  - migration
draft: false
hidden: false
image: cover.jpeg
links:
  - title: Supabase Local Development & CLI Docs
    website: https://supabase.com/docs/guides/local-development
---

## setting local env

```bash
supabase init

supabase start
```

## From remote To local

### Schema

```bash
# 1. Remote DB Schema 복사
# schema_migration 이력이 없는 경우
supabase db pull
# schema_migration 이력이 있는 경우
supabase migration fetch

# 2. local DB 리셋
supabase db reset
```

### Data

```bash
# 1. Remote DB 데이터 복사
supabase db dump --data-only -s public > supabase/seed.sql

# 2. local DB 리셋
supabase db reset
```

## From local To remote

### Schema

```bash
# 1. Remote DB Schema 복사 (migration)
# schema_migration 이력이 없는 경우
supabase db pull
# schema_migration 이력이 있는 경우
supabase migration fetch

# 2. Remote DB Schema 복사 (dump)
mkdir -p supabase/schemas
supabase db dump > supabase/schemas/prod.sql

# 3. supabase/schemas 폴더에 적용 할 DDL sql 파일 추가

# 4. migration과 schemas의 ddl을 비교하여 새로운 migration 파일 생성
supabase db diff -f [name]

# 5. migration 반영
supabase db push
```

### Data

From remote To local / Data 응용 (--db-url or --linked 사용)
