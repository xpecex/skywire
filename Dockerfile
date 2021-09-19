FROM golang:alpine AS builder

ARG CGO_ENABLED
ARG GO111MODULE
ARG IMAGE_VER

ENV CGO_ENABLED=${CGO_ENABLED} \
    GO111MODULE=$GO111MODULE

WORKDIR /go/skywire

RUN apk update --no-cache && apk upgrade --no-cache && \
    apk add --no-cache git && \
    git clone -q -b v$IMAGE_VER https://github.com/skycoin/skywire.git /go/skywire && \
    go build -mod=vendor -tags netgo -ldflags="-w -s" \
      -o skywire-visor cmd/skywire-visor/skywire-visor.go &&\
    go build -mod=vendor -ldflags="-w -s" -o skywire-cli ./cmd/skywire-cli	&&\
    go build -mod=vendor -ldflags="-w -s" -o ./apps/skychat ./cmd/apps/skychat	&&\
	  go build -mod=vendor -ldflags="-w -s" -o ./apps/skysocks ./cmd/apps/skysocks &&\
	  go build -mod=vendor -ldflags="-w -s" -o ./apps/skysocks-client  ./cmd/apps/skysocks-client && \
	  go build -mod=vendor -ldflags="-w -s" -o ./apps/vpn-server ./cmd/apps/vpn-server && \
	  go build -mod=vendor -ldflags="-w -s" -o ./apps/vpn-client ./cmd/apps/vpn-client


FROM alpine:3.12.7 AS visor-runner

COPY --from=builder /go/skywire/skywire-visor skywire-visor
COPY --from=builder /go/skywire/apps /apps
COPY --from=builder /go/skywire/docker/images/visor/update.sh update.sh
COPY --from=builder /go/skywire/skywire-cli bin/skywire-cli
COPY --from=builder /go/skywire/docker/images/visor/entrypoint.sh entrypoint.sh

RUN ./update.sh

ENTRYPOINT [ "./entrypoint.sh" ]


FROM visor-runner

EXPOSE 514 1080 3435 6060 7033 8000     