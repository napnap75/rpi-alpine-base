build:
	curl -L -o qemu-arm-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/v2.6.0/qemu-arm-static.tar.gz && tar xzf qemu-arm-static.tar.gz
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
