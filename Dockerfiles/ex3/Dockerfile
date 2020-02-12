FROM bitnami/golang AS builder
RUN mkdir /hugo && git clone https://github.com/gohugoio/hugo && cd hugo && go build -o /hugo/hugo.go && cd /hugo \
    && mv hugo.go hugo && git clone https://github.com/alemorcuq/hugo-sample-site && mv hugo-sample-site/* . && rm -rf hugo-sample-site


FROM bitnami/minideb AS generator
COPY --from=builder /hugo /hugo
WORKDIR /hugo
RUN ./hugo

## EXERCISE 3 MODIFICATIONS
FROM bitnami/minideb AS nginx_builder
ARG NGINX_VERSION="nginx-1.16.1"
ARG ZLIB_VERSION="zlib-1.2.11"
ARG OPENSSL_VERSION="openssl-1.1.1d"
ARG PCRE_VERSION="pcre-8.43"
RUN install_packages build-essential wget ca-certificates && mkdir /nginx_build
WORKDIR /nginx_build
RUN wget https://nginx.org/download/${NGINX_VERSION}.tar.gz && tar -xvf ${NGINX_VERSION}.tar.gz && wget https://ftp.pcre.org/pub/pcre/${PCRE_VERSION}.tar.gz \
    && tar -xvf ${PCRE_VERSION}.tar.gz && wget https://www.openssl.org/source/${OPENSSL_VERSION}.tar.gz && tar -xvf ${OPENSSL_VERSION}.tar.gz \
    && wget https://www.zlib.net/${ZLIB_VERSION}.tar.gz && tar -xvf ${ZLIB_VERSION}.tar.gz && mkdir -p /app/nginx
RUN cd ${NGINX_VERSION} && ./configure --prefix=/app/nginx/data --with-pcre=../$PCRE_VERSION --with-pcre-jit --with-zlib=../$ZLIB_VERSION \
    --with-openssl=../$OPENSSL_VERSION --sbin-path=/app/nginx/bin/nginx --modules-path=/app/nginx/lib/modules --conf-path=/app/nginx/data/nginx.conf \
    --pid-path=/app/nginx/run/nginx.pid --lock-path=/app/nginx/run/nginx.lock --user=nginx --group=nginx --with-threads \
    --build=ferferga --with-debug && make -j$$$(nproc) && make install

FROM bitnami/minideb
ARG NGINX_PORT=8080
ENV NGINX_PORT "8080"
ENV PATH "/app/nginx/bin:$PATH"
COPY --from=nginx_builder /app /app
COPY ./*.sh /scripts/
RUN rm -rf /app/nginx/data/html/*
COPY --from=generator /hugo/public /app/nginx/data/html
RUN /scripts/postunpack.sh
EXPOSE ${NGINX_PORT}
WORKDIR /app/nginx/data
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
CMD [ "/scripts/run.sh" ]