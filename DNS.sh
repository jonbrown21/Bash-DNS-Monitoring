#!/bin/bash

#
# What should we monitor
#

DNS=TXT
DOMAIN=_dmarc.jonbrown.org
KEYWORD=reject
NS=cash.cloudflare.net
OUTPUT=$(dig ${DNS} ${DOMAIN} @${NS} +short 2>&1)

#
# EMAIL variables
#

SENDGRIDAPI='G.-_Y5LgAUSkOaLapD6ze1OA.OAAKRv6aLZGuevnqgm0CKwqJ8kvNllRpGqFTazD8' # Your SendGrid API Key
TO=jon@jonbrown.org 
FROM=jon@jonbrown.org
CC=someemail@testdomain.com
SUBJECT='Please check this DNS Monitor ${DOMAIN}'
MESSAGE='The DNS Monitor for ${DOMAIN} is having issues based on the keyword ${KEYWORD} you set.'

#
# Enable this for testing if needed
# echo ${OUTPUT}
#
# Do Not Edit Below this line
#

if [[ $OUTPUT =~ .*${KEYWORD}.* ]];

then

echo "match"

else 

curl --request POST \
  --url https:#api.sendgrid.com/v3/mail/send \
  --header 'authorization: Bearer ${SENDGRIDAPI}' \
  --header 'Content-Type: application/json' \
  --data '{"personalizations": [{"to": [{"email": "${TO}"}],"cc": [{"email":"${CC}"}]}], "from": {"email": "${FROM}"},"subject":"${SUBJECT}", "content": [{"type": "text/plain", "value": "${MESSAGE}"}]}'

echo "fail"

fi