FROM bitnami/git AS downloader
WORKDIR /
RUN mkdir hugo && git clone https://github.com/gohugoio/hugo && cd hugo && git clone https://github.com/alemorcuq/hugo-sample-site \
&& mv hugo-sample-site/* . && rm -rf hugo-sample-site

FROM bitnami/golang:1.13 AS builder
COPY --from=downloader /hugo /hugo
WORKDIR /hugo
RUN  go build

FROM bitnami/minideb AS generator
COPY --from=builder /hugo /hugo
WORKDIR /hugo
RUN ./hugo

FROM bitnami/nginx:1.16
LABEL maintainer "Fernando Fernández - ferferga"
COPY --from=generator /hugo/public /app
