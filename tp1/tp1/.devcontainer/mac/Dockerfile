# twint/sd is linux/amd64-only. On Apple Silicon, vscode-server extract uses
# GNU tar 1.35 under Rosetta, which hits ENOSYS (mkdirat/openat2).
# Native aarch64 busybox tar bypasses Rosetta for that one binary.
FROM --platform=linux/arm64 alpine:3.20 AS arm64busybox

FROM --platform=linux/amd64 docker.io/twint/sd:latest

COPY --from=arm64busybox /bin/busybox /opt/host-tar/busybox
COPY --from=arm64busybox /lib/ld-musl-aarch64.so.1 /lib/ld-musl-aarch64.so.1
COPY tar-wrapper.sh /usr/local/bin/gnu-tar-wrapper

RUN chmod +x /opt/host-tar/busybox /usr/local/bin/gnu-tar-wrapper \
 && dpkg-divert --local --rename --add /usr/bin/tar \
 && ln -sf /usr/local/bin/gnu-tar-wrapper /usr/bin/tar
