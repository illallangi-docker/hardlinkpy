FROM illallangi/ansible:latest as build
ENV HARDLINKPY_COMMIT=dfa617529b6fbffb0baafa311130b81005f99dd1
ENV HARDLINKPY_SHA256=533774b0e4474051e92fd16b2ab20194b2799defac73325774cbec59e329936e
COPY build/* /etc/ansible.d/build/
RUN /usr/local/bin/ansible-runner.sh build

FROM illallangi/ansible:latest as image
COPY --from=build /usr/local/src/*.tar.gz /usr/local/src/
COPY --from=build /usr/local/src/hardlinkpy-dfa617529b6fbffb0baafa311130b81005f99dd1/hardlink.py /usr/local/bin/
COPY image/* /etc/ansible.d/image/
RUN /usr/local/bin/ansible-runner.sh image

COPY container/* /etc/ansible.d/container/
ENV HARDLINKPY_PATH=/hardlinkpy
ENV HARDLINKPY_MINSIZE=10485760
ENV HARDLINKPY_SLEEP=60
ENV USER=hardlinkpy
ENV UID=1024
CMD ["/usr/local/bin/hardlinkpy-entrypoint.sh"]
