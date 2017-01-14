build:
	docker build -t napnap75/rpi-alpine-base:3.4 -f 3.4/Dockerfile .
	docker build -t napnap75/rpi-alpine-base:edge -f edge/Dockerfile .

test:
	docker run --rm napnap75/rpi-alpine-base:3.4 uname -a
	docker run --rm napnap75/rpi-alpine-base:edge uname -a

push: build
	docker push napnap75/rpi-alpine-base:3.4
	docker push napnap75/rpi-alpine-base:edge
	docker tag napnap75/rpi-alpine-base:3.4 napnap75/rpi-alpine-base:latest
	docker push napnap75/rpi-alpine-base:latest
	docker push napnap75/rpi-alpine-base:3.4
	docker tag napnap75/rpi-alpine-base:3.4 napnap75/rpi-alpine-base:latest
	docker push napnap75/rpi-alpine-base:latest
