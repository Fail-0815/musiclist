# syntax=docker/dockerfile:1
FROM rust:1-alpine3.17 as builder
WORKDIR /usr/src
RUN apk add --no-cache musl-dev libmagic libpq-dev openssl-libs-static
COPY server ./server
COPY wishlib ./wishlib

WORKDIR /usr/src/server
# Enforce most things to be statically linked.
# this is necessary for libpq on alpine with rust (see rust crate pq-sys)
ENV PQ_LIB_STATIC=true
ENV RUSTFLAGS="-Lnative=/usr/lib -Lnative=/usr/lib -lstatic=pq -lstatic=pgport -lstatic=pgcommon -lstatic=ssl -lstatic=crypto -lstatic=pthread -lstatic=m -lstatic=dl"
RUN rustup update nightly
RUN rustup default nightly
RUN cargo build --release

FROM alpine:3.17 as runtime
COPY --from=builder /usr/src/server/target/release/server /usr/local/bin
COPY --from=builder /usr/src/server/Rocket.toml /etc
ENV ROCKET_CONFIG /etc/Rocket.toml

EXPOSE 8000

# Run the application
CMD ["/usr/local/bin/server"]