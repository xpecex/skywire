#!/bin/bash

# IMAGE VARIABLES
IMAGE_NAME="xpecex/skywire"
IMAGE_VER=""
IMAGE_AUTHOR="xPeCex <xpecex@outlook.com>"
IMAGE_VENDOR=$IMAGE_AUTHOR
IMAGE_REF="$(git rev-parse --short HEAD)"
IMAGE_DESC="Skywire Node implementation (unofficial)"
IMAGE_BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
IMAGE_URL="https://github.com/xpecex/skywire"
IMAGE_LICENSE="GPL-3.0+"
IMAGE_ALT_REF="$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 7 | head -n 1)"

CGO_ENABLED=0
GOOS=linux
GOARCH=
GO111MODULE=on

# RELEASES LIST
RELEASES=(
    "0.4.0"
    "0.4.1"
    "0.4.2"
)
# LATEST RELEASE
LATEST_RELEASE=$(curl -s "https://github.com/skycoin/skywire/releases/latest" | cut -d'/' -f 8 | cut -d'"' -f 1)

# ARCHITECTURE LIST
ARCHS=(
    "linux/amd64"
    "linux/arm/v7"
    "linux/arm64"
    "linux/386"
)

# CHECK IF DOCKER IS LOGGED
DOCKER_AUTH_TOKEN=$(cat ~/.docker/config.json | grep \"auth\": | xargs | cut -d ':' -f 2 | xargs)
if [ -z "$DOCKER_AUTH_TOKEN" ]; then

    # NOT LOGGED IN
    # Check if $DOCKER_USER is empty
    if [ -z "$DOCKER_USER" ]; then
        # login via command line
        docker login
    else
        # login via command line using --password-stdin
        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin &>/dev/null
    fi

else
    # LOGGED
    echo "Docker appears to be logged in, step skipped."
fi

# ========================= BUILD =========================

# SEARCH RELEASES FOR BUILD
for RELEASE in "${RELEASES[@]}"; do

    # PRINT BUILD INFO
    echo " ========= BUILDING RELEASE: $RELEASE ========= "

    # PRINT DOWNLOAD docker-entrypoint.sh AND prepare-run-env.sh
    echo "DOWNLOAD entrypoint.sh update.sh"

    # DOWNLOAD docker-entrypoint.sh AND prepare-run-env.sh
    wget -q -O entrypoint.sh https://raw.githubusercontent.com/skycoin/skywire/v${RELEASE}/docker/images/visor/entrypoint.sh
    wget -q -O update.sh -c https://github.com/skycoin/skywire/blob/v${RELEASE}/docker/images/visor/update.sh
    chmod +x entrypoint.sh update.sh

    for ARCH in "${ARCHS[@]}"; do

        mkdir -p "$ARCH"

        # CHECK ARCH
        case "$ARCH" in
        linux/amd64)
            echo "amd64" > "$ARCH/arch"
            ;;
        linux/arm/v7)
            echo "arm" > "$ARCH/arch"
            ;;
        linux/arm64)
            echo "arm64" > "$ARCH/arch"
            ;;
        linux/386)
            echo "386" > "$ARCH/arch"
            ;;
        esac
    done

    # PRINT BUILD INFO
    echo "STARTING THE BUILD"

    # Build using BUILDX
    # ADD TAG LATEST IF $RELEASE = $LATEST_RELEASE
    if [ "$RELEASE" = "$LATEST_RELEASE" ]; then
        docker buildx build \
            --push \
            --build-arg IMAGE_NAME="$IMAGE_NAME" \
            --build-arg IMAGE_VER="${IMAGE_VER:-$RELEASE}" \
            --build-arg IMAGE_AUTHOR="$IMAGE_AUTHOR" \
            --build-arg IMAGE_VENDOR="$IMAGE_VENDOR" \
            --build-arg IMAGE_REF="${IMAGE_REF:-$IMAGE_ALT_REF}" \
            --build-arg IMAGE_DESC="$IMAGE_DESC" \
            --build-arg IMAGE_BUILD_DATE="$IMAGE_BUILD_DATE" \
            --build-arg IMAGE_URL="$IMAGE_URL" \
            --build-arg IMAGE_LICENSE="$IMAGE_LICENSE" \
            --build-arg CGO_ENABLED="$CGO_ENABLED" \
            --build-arg GOOS="$GOOS" \
            --build-arg GOARCH="$GOARCH" \
            --build-arg GO111MODULE="$GO111MODULE" \
            --cache-from "${IMAGE_NAME}:latest" \
            --platform "$(echo ${ARCHS[@]} | sed 's/ /,/g')" \
            -t "${IMAGE_NAME}:${IMAGE_VER:-$RELEASE}" \
            -t "${IMAGE_NAME}:latest" \
            .
    else
        docker buildx build \
            --push \
            --build-arg IMAGE_NAME="$IMAGE_NAME" \
            --build-arg IMAGE_VER="${IMAGE_VER:-$RELEASE}" \
            --build-arg IMAGE_AUTHOR="$IMAGE_AUTHOR" \
            --build-arg IMAGE_VENDOR="$IMAGE_VENDOR" \
            --build-arg IMAGE_REF="${IMAGE_REF:-$IMAGE_ALT_REF}" \
            --build-arg IMAGE_DESC="$IMAGE_DESC" \
            --build-arg IMAGE_BUILD_DATE="$IMAGE_BUILD_DATE" \
            --build-arg IMAGE_URL="$IMAGE_URL" \
            --build-arg IMAGE_LICENSE="$IMAGE_LICENSE" \
            --build-arg CGO_ENABLED="$CGO_ENABLED" \
            --build-arg GOOS="$GOOS" \
            --build-arg GOARCH="$GOARCH" \
            --build-arg GO111MODULE="$GO111MODULE" \
            --cache-from "${IMAGE_NAME}:latest" \
            --platform "$(echo ${ARCHS[@]} | sed 's/ /,/g')" \
            -t "${IMAGE_NAME}:${IMAGE_VER:-$RELEASE}" \
            .
    fi

    # PRINT DEL INFO
    echo "Removing files used in build"

    # Remove Files
    rm -rf linux entrypoint.sh update.sh

done

# PRINT BUILD INFO
echo " ========= build completed successfully ========= "
