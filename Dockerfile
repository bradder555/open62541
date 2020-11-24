FROM alpine:3.12.1 as builder 

RUN apk add git cmake gcc g++ musl-dev python2 py-pip make mbedtls-dev graphviz texlive check subunit-dev openssl

RUN pip install sphinx

RUN pip install sphinx_rtd_theme

WORKDIR /tmp/
RUN git clone --depth 1  --recurse-submodules --branch v1.1.3 https://github.com/open62541/open62541.git /tmp/open62541

WORKDIR /tmp/open62541/build

RUN cmake -DCMAKE_BUILD_TYPE=Debug \
          -DUA_ENABLE_ENCRYPTION=ON \
          -DUA_MULTITHREADING=199 \
          -DUA_ENABLE_AMALGAMATION=OFF \
          -DBUILD_SHARED_LIBS=ON \ 
          -DUA_BUILD_EXAMPLES=ON \ 
          -DUA_BUILD_SELFSIGNED_CERTIFICATE=ON \ 
          -DUA_ENABLE_SUBSCRIPTIONS=ON \
          -DUA_ENABLE_DISCOVERY=ON \
          -DUA_ENABLE_DISCOVERY_MULTICAST=ON \ 
          -DUA_NAMESPACE_ZERO=FULL \
          /tmp/open62541

RUN make

WORKDIR /tmp/cert

RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=AU/ST=WA/L=Perth/O=open62541/CN=open62541" \
    -addext "subjectAltName=URI:urn:open62541.server.application" \
    -keyout /tmp/cert/open62541.key -out /tmp/cert/open62541.cert

FROM alpine:3.12.1 as target 

COPY --from=builder /tmp/open62541/build/bin/*.so* /lib/
COPY --from=builder /tmp/open62541/build/bin/examples/server_ctt /home/open62541/server_ctt
COPY --from=builder /tmp/cert/* /home/open62541/cert/
COPY --from=builder /usr/lib/libmbedx509.so* /lib/
COPY --from=builder /usr/lib/libmbedcrypto.so* /lib/
RUN mkdir /home/open62541/trusted
RUN mkdir /home/open62541/issuers
RUN mkdir /home/open62541/revoked
WORKDIR /home/open62541
CMD ["/home/open62541/server_ctt", \
     "/home/open62541/cert/open62541.cert", \
     "/home/open62541/cert/open62541.key", \
     "--trustlistFolder","/home/open62541/trusted/", \
     "--issuerlistFolder","/home/open62541/issuers/", \
     "--revocationlistFolder","/home/open62541/revoked/", \
     "--enableAnonymous" ]