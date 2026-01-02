# ─────────────────────────────────────────
# Paths
# ─────────────────────────────────────────
ROOT_DIR := $(abspath ..)
IMAGE    := dietonez-fe:latest
CONTAINER:= dietonez-fe
PORT     := 5713

# ─────────────────────────────────────────
# Local (Vue)
# ─────────────────────────────────────────
build:
	npm install
	npm run build

run: build
	npm run dev -- --host

# ─────────────────────────────────────────
# Docker
# ─────────────────────────────────────────
docker-build:
	docker build \
		-t $(IMAGE) \
		-f Dockerfile \
		$(ROOT_DIR)

docker-run:
	docker run -d \
		-p $(PORT):80 \
		--name $(CONTAINER) \
		$(IMAGE)

docker-stop:
	docker stop $(CONTAINER) && docker rm $(CONTAINER)

docker-logs:
	docker logs -f $(CONTAINER)
