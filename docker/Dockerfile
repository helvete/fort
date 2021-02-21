FROM alpine:3.12 as builder

RUN apk upgrade -U && \
	apk --update add --no-cache \
	musl-dev \
	gfortran \
	make \
	fcgi-dev

COPY ./src/hello.f90 hello.f90
COPY ./docker/makefile makefile
COPY ./lib lib

RUN	make && \
	chmod a+x ./hello


FROM httpd:2.4-alpine

COPY ./docker/addition.conf /usr/local/apache2/conf/addition.conf

RUN apk upgrade -U && \
	apk --update add --no-cache \
	libgfortran \
	apache-mod-fcgid \
	fcgi && \
	echo 'Include conf/addition.conf' >> /usr/local/apache2/conf/httpd.conf && \
	mkdir /application

COPY --from=builder /hello /application/hello
