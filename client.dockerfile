# syntax=docker/dockerfile:1
FROM rust:1-alpine3.17 as builder
RUN apk add --no-cache musl-dev git
WORKDIR /usr/src
COPY wishlib ./wishlib
COPY client ./client

WORKDIR /usr/src/client
RUN rustup toolchain install nightly
RUN rustup default nightly
RUN rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cargo install --locked trunk
RUN trunk build --release

FROM alpine:3.17 as runtime
RUN apk add --no-cache lighttpd
COPY --from=builder /usr/src/client/dist/* /var/www/localhost/htdocs/

EXPOSE 80

CMD [ "lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf" ]
