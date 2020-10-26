FROM iontorrent/tsbuild:bionic-5.12 AS builder
# Download and extract TorrentSuite v5.12.1sp1
RUN curl --silent -L https://github.com/iontorrent/TS/archive/TorrentSuite_5.12.1.sp1.tar.gz | tar --strip-components=1 -xvzf -
# Build Analysis modules including tmap and tvc
RUN MODULES=Analysis buildTools/build.sh

FROM ubuntu:18.04

COPY --from=builder /src/build/Analysis/tvc /usr/local/bin
COPY --from=builder /src/build/Analysis/tvcutils /usr/local/bin
COPY --from=builder /src/build/Analysis/tvcassembly /usr/local/bin
COPY --from=builder /src/build/Analysis/TMAP/tmap /usr/local/bin


# Install OpenBLAS for tvc
RUN apt update && \
    apt install -y libopenblas-dev libopenblas-base && \
    apt clean
