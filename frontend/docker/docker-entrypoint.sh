#!/bin/sh

# Replace the API URL placeholder in nginx config
envsubst '${REACT_APP_API_URL}' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf.tmp
mv /etc/nginx/conf.d/default.conf.tmp /etc/nginx/conf.d/default.conf

# Start nginx
nginx -g 'daemon off;'