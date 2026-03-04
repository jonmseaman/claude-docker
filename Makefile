DOCKER_IMAGE_NAME = claude
DOCKER_CONTAINER_NAME = claude

.PHONY: build run stop shell restart clean logs status

build:
	docker build -t $(DOCKER_IMAGE_NAME) .

run:
	# Without this, Docker apparently creates a directory when the file doesn't
	# exist.
	touch $(PWD)/.claude.json
	docker run -d \
		--name $(DOCKER_CONTAINER_NAME) \
		-v ~/Workspace:/home/ubuntu/Workspace \
		-v $(PWD)/claude-config:/home/ubuntu/.claude \
		-v $(PWD)/.claude.json:/home/ubuntu/.claude.json \
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
	# Command to fix context errors.
	echo "Run `docker context use desktop-linux` to switch back to"
	echo "docker desktop."
	docker context show
	@docker ps -a --filter name=$(DOCKER_CONTAINER_NAME)
