#! /bin/bash

# Setup smtp on debian based OS

# Settings
DOMAIN_NAME="example.com"
USERNAME="tom"
PASSWORD="password"
RCPT="susan@customer.com" # For testing

# Installation
DEBIAN_FRONTEND=noninteractive apt install -y libsasl2-modules postfix mailutils
echo "$DOMAIN_NAME" > /etc/mailname
postconf -e "myhostname = "$DOMAIN_NAME""
postconf -e "myorigin = /etc/mailname"
postconf -e "relayhost = ["$DOMAIN_NAME"]:587"
postconf -e "smtp_sasl_auth_enable = yes"
postconf -e "smtp_sasl_security_options = noanonymous"
postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
postconf -e "smtp_use_tls = yes"
postconf -e "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt"

echo "["$DOMAIN_NAME"]:587 "$USERNAME":"$PASSWORD"" > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
service postfix restart

echo "Successfully setup email alert" | mail -s "Alert" -a "From: "$USERNAME"@"$DOMAIN_NAME"" "$RCPT"
