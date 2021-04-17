#!/bin/sh
# Legacy WebOS Youtube Service startup script

# Update config.php keys based on environmental variables 
if [ $YOUTUBE_API_KEY ]; then sed -i "/api_key/c\\\t'api_key' => '$YOUTUBE_API_KEY'," /var/www/html/config.php; fi
if [ $YOUTUBE_CLIENT_KEY ]; then sed -i "/client_key/c\\\t'client_key' => '$YOUTUBE_CLIENT_KEY'," /var/www/html/config.php; fi
if [ $YOUTUBE_DEBUG_KEY ]; then sed -i "/debug_key/c\\\t'debug_key' => '$YOUTUBE_DEBUG_KEY'," /var/www/html/config.php; fi
if [ $YOUTUBE_SERVER_ID ]; then sed -i "/server_id/c\\\t'server_id' => '$YOUTUBE_SERVER_ID'" /var/www/html/config.php; fi

# Start Apache
rm -f /var/run/apache2/apache2.pid
apachectl -DFOREGROUND
