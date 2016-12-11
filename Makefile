build:
	docker build -t napnap75/rpi-alpine-base:3.4 .

push: build
	docker push napnap75/rpi-alpine-base:3.4
	docker tag napnap75/rpi-alpine-base:3.4 napnap75/rpi-alpine-base:latest
	docker push napnap75/rpi-alpine-base:latest
