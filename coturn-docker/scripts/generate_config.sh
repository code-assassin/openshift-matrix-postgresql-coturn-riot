#!/bin/sh
# generates a config file for a coturn server; hopefully secure enough

SERVER_NAME=${1}
DATA_DIR=${2}
KEY_NAME=${3}
CERT_NAME=${4}
CONFIG_FILE=${5}

secret=$(pwgen -s 64 1)

# output the secret in stdout
echo "The automatically generated secret is: ${secret}"
echo "Please paste it into the synapse server's configuration file."

# create the self-signed certificate
openssl req -newkey rsa:4096 -new -nodes -x509 -days 3650 -keyout $DATA_DIR/$KEY_NAME -out $DATA_DIR/$CERT_NAME -subj "/C=FR/ST=BarbedLand/O=BarbedGroup/CN=$SERVER_NAME"

# create the config file
touch $DATA_DIR/$CONFIG_FILE

# fill in the config file
echo "lt-cred-mech" > "$DATA_DIR/$CONFIG_FILE"
echo "syslog" >> "$DATA_DIR/$CONFIG_FILE"
echo "verbose" >> "$DATA_DIR/$CONFIG_FILE"
echo "listening-port=3478" >> "$DATA_DIR/$CONFIG_FILE"
echo "tls-listening-port=5349">> "$DATA_DIR/$CONFIG_FILE"
echo "external-ip=202.158.13.157" >> "$DATA_DIR/$CONFIG_FILE"
echo "cli-ip=127.0.0.1" >> "$DATA_DIR/$CONFIG_FILE"
echo "cli-port=5766" >> "$DATA_DIR/$CONFIG_FILE"
echo "cli-password=qwerty" >> "$DATA_DIR/$CONFIG_FILE"
echo "use-auth-secret" >> "$DATA_DIR/$CONFIG_FILE"
echo "static-auth-secret=${secret}" >> "$DATA_DIR/$CONFIG_FILE"
echo "realm=${SERVER_NAME}" >> "$DATA_DIR/$CONFIG_FILE"
echo "cert=$DATA_DIR/$CERT_NAME" >> "$DATA_DIR/$CONFIG_FILE"
echo "pkey=$DATA_DIR/$KEY_NAME" >> "$DATA_DIR/$CONFIG_FILE"
echo "pidfile=$DATA_DIR/turnserver.pid" >> "$DATA_DIR/$CONFIG_FILE"
echo "min-port=60000" >> "$DATA_DIR/$CONFIG_FILE"
echo "max-port=60015" >> "$DATA_DIR/$CONFIG_FILE"
echo 'psql-userdb="host=postgres dbname=coturn user=postgres password=postgres connect_timeout=30"' >> "$DATA_DIR/$CONFIG_FILE"
