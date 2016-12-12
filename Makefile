build:
	wget https://github.com/multiarch/qemu-user-static/releases/download/v2.6.0/x86_64_qemu-arm-static.tar.gz
	tar xvf x86_64_qemu-arm-static.tar.gz
	docker build -t napnap75/rpi-alpine-base:latest .

push: build
	docker push napnap75/rpi-alpine-base:latest
	docker tag napnap75/rpi-alpine-base:latest napnap75/rpi-alpine-base:3.4
	docker push napnap75/rpi-alpine-base:latest
