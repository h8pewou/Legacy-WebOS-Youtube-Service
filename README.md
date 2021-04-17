# Legacy WebOS Youtube Service

## Introduction
This is a Docker image containing Apache, PHP, ffmpeg, youtube-dl, and [codepoet80's Legacy WebOS Youtube Service code](https://github.com/codepoet80/metube-php-servicewrapper). The resulting container can be used to play Youtube videos on legacy WebOS devices:

 - Palm Pre 1-2
 - HP Pre 3
 - HP Veer
 - HP Touchpad

## Usage

### Configuration

If you want to use the Youtube Search feature, you will need a Google API Key ([get your own for free here](https://developers.google.com/youtube/v3/getting-started)).


### Docker run (x64)

#### Using environmental variables
You can simply run the following command to set the service up. 

```bash
docker run -d --name webos-legacy-youtube \
--restart=unless-stopped \
-p 8083:80 \
-e YOUTUBE_API_KEY=your_youtube_api_key \
-e YOUTUBE_CLIENT_KEY=your_secure_key \
-e YOUTUBE_DEBUG_KEY=your_secure_key \
-e YOUTUBE_SERVER_ID=your_secure_key \
h8pewou/legacy-webos-youtube-service:latest
```

Note that the secure keys are optional. See the WebOS app settings for more details on configuration.


#### Using persistent volumes

You can also use volumes to configure the application. Download a sample config.php from [here](https://raw.githubusercontent.com/h8pewou/legacy_webos/main/metube-webos-config.php) or [here](https://raw.githubusercontent.com/codepoet80/metube-php-servicewrapper/main/config-sample.php). Ensure that the file_dir is set to /downloads/ (as seen in the first option).


Example:
```bash
wget https://raw.githubusercontent.com/h8pewou/legacy_webos/main/metube-webos-config.php
```

Ensure that /path/to is replaced with the actual path:

```bash
docker run -d --name webos-legacy-youtube \
--restart=unless-stopped \
-p 8083:80 \
-v /path/to/config.php:/var/www/html/config.php \
h8pewou/legacy-webos-youtube-service:latest
```

Optionally, you can add the following argument to specify a persistent /downloads volume:
```
-v /path/to/downloads:/downloads
```

### Docker-compose (x64)

Alternatively you can use the following docker-compose.yml:

```yaml
version: '3.9'

networks:
  bridge:
    driver: bridge

services:
  wrapper:
    image: h8pewou/legacy-webos-youtube-service:latest
    networks:
      - bridge
    ports:
      - "8083:80"
    restart: unless-stopped
    environment:
      - YOUTUBE_API_KEY=your_youtube_api_key # Not required if config.php volume is configured
      - YOUTUBE_CLIENT_KEY=your_secure_key # Not required if config.php volume is configured
      - YOUTUBE_DEBUG_KEY=your_secure_key # Not required if config.php volume is configured
      - YOUTUBE_SERVER_ID=your_secure_key # Not required if config.php volume is configured
    volumes:
      - /path/to/config.php:/var/www/html/config.php # Optional if environment variables are configured above
      - /path/to/downloads:/downloads # Optional
```

Ensure that /path/to is replaced with the actual path. Issue ```docker-compose up``` to start the service.


### Are you on arm64 (e.g., Raspberry Pi)?

Replace ```h8pewou/legacy-webos-youtube-service:latest``` with ```h8pewou/legacy-webos-youtube-service:arm64```.
