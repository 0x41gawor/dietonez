build: 
	npm install
	npm run build
run: build
	npm run dev -- --host
docker-build: 
	docker build -t dietonez-fe:latest .
docker-run: 
	docker run -d -p 5713:80 --name dietonez-fe dietonez-fe:latest
docker-stop: 
	docker stop dietonez-fe && docker rm dietonez-fe
docker-logs: 
	docker logs -f dietonez-fe