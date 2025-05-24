build: 
	@cd cmd/; \
	go build -o ../bin/dietonez
run: build
	@./bin/dietonez