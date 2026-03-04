DOCKER_IMAGE_NAME = claude
DOCKER_CONTAINER_NAME = claude

.PHONY: build run stop shell restart clean logs status

build:
	docker build -t $(DOCKER_IMAGE_NAME) .

run:
	docker run -d \
		--name $(DOCKER_CONTAINER_NAME) \
		-v ~/Workspace:/home/ubuntu/Workspace \
		-it \
		$(DOCKER_IMAGE_NAME)
	@echo "Container started. Use 'make shell' to access it"

stop:
	docker stop $(DOCKER_CONTAINER_NAME) || true
	docker rm $(DOCKER_CONTAINER_NAME) || true

shell:
	docker exec -it -u ubuntu $(DOCKER_CONTAINER_NAME) bash

restart: stop run

clean: stop
	docker rmi $(DOCKER_IMAGE_NAME) || true

logs:
	docker logs -f $(DOCKER_CONTAINER_NAME)

status:
	docker context show
	@docker ps -a --filter name=$(DOCKER_CONTAINER_NAME)
