GROUP := udacity
NAME := rubot-production
ORG := $(GROUP)
SERVICE ?= $(NAME)
VERSION ?= $(shell git rev-parse --short HEAD)
CONDUCTOR_API_KEY := $(shell echo $$CONDUCTOR_API_KEY)
export

.PHONY: all build test coveralls deploy

all: build

test:
	@echo "[Running tests...]"

coveralls: test

build: docker

docker: 
	docker build -t $(ORG)/$(NAME) .
	docker tag -f $(ORG)/$(NAME) $(ORG)/$(NAME):$(VERSION)
	docker push $(ORG)/$(NAME):$(VERSION)

deploy: docker
	eval echo `sed 's/"/\\\\"/g' conductor.json` | curl -i -s \
	https://conductor-api.udacity.com/v1/deployments -d @- \
	-H 'Content-Type: application/json'
