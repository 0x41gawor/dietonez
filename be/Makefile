build: 
	@cd cmd/; \
	go build -o ../bin/dietonez
run: build
	@./bin/dietonez
docker-build: 
	docker build -t dietonez:latest .
docker-run: 
	docker run -d --name be \
		--add-host=host.docker.internal:host-gateway \
		-p 8080:8080 \
		--env NOME \
		--env AGANDSKODE \
		--env HAVN \
		--env DB_HOST=host.docker.internal \
		dietonez:latest