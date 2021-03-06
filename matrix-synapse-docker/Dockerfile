FROM pajak/synapse-base:latest

# install runtime and build-time dependencies
ENV CHECKOUT_DIR=synapse
ARG SYNAPSE_VERSION

COPY scripts/ensure_user_and_group.sh /build/ensure_user_and_group.sh
COPY scripts/alter_config.sh /build/alter_config.sh
COPY scripts/generate_config.sh /build/generate_config.sh

ARG SYNAPSE_USERNAME=matrix-synapse
ARG SYNAPSE_GROUPNAME=matrix-synapse
# create the unprivileged user and group matrix-synapse
RUN /build/ensure_user_and_group.sh $SYNAPSE_USERNAME $SYNAPSE_GROUPNAME

ARG SERVER_NAME
ARG CONFIG_FILE="synapse.config.yaml"
ARG REPORT_STATS="no"
# create initial config file
RUN /build/generate_config.sh $SERVER_NAME $DATA_DIR/$CONFIG_FILE $REPORT_STATS
COPY $CONFIG_FILE $DATA_DIR/$CONFIG_FILE
# configure log files to be in the /data folder
RUN /build/alter_config.sh $DATA_DIR $CONFIG_FILE $SERVER_NAME

USER $SYNAPSE_USERNAME:$SYNAPSE_GROUPNAME

# this is a shell form entrypoint to enable var expansion
ENTRYPOINT exec python3 -m synapse.app.homeserver -c $DATA_DIR/$CONFIG_FILE
EXPOSE 8448
EXPOSE 8008
VOLUME ["$DATA_DIR", "/media_store", "/uploads"]
