FROM bitnami/golang AS builder
RUN mkdir /hugo && git clone https://github.com/gohugoio/hugo && cd hugo && go build -o /hugo/hugo.go && cd /hugo \
&& mv hugo.go hugo && git clone https://github.com/alemorcuq/hugo-sample-site && mv hugo-sample-site/* . && rm -rf hugo-sample-site


FROM bitnami/minideb AS generator
COPY --from=builder /hugo /hugo
WORKDIR /hugo
RUN ./hugo

FROM bitnami/nginx:1.16
LABEL maintainer "Fernando Fernández - ferferga"
COPY --from=generator /hugo/public /app
EXPOSE 80:8080