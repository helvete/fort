FROM alpine:3.13 as builder

COPY ./src/hello.f90 hello.f90

RUN apk upgrade -U && \
	apk --update add --no-cache \
	musl-dev \
	gfortran && \
	gfortran -o hello hello.f90 && \
	chmod a+x ./hello


FROM alpine:3.13

RUN apk upgrade -U && \
	apk --update add --no-cache \
	libgfortran

COPY --from=builder /hello ./hello

CMD tail -f /dev/null
