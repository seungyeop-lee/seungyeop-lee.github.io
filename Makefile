.PHONY:update-theme
update-theme:
	hugo mod get -u github.com/CaiJimmy/hugo-theme-stack/v3
	hugo mod tidy

.PHONY:dev
dev:
	hugo server

.PHONY:build
build:
	hugo build
