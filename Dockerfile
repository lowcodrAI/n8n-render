# Use the latest Node.js LTS version (e.g., Node.js 18 or 20)
FROM node:20-alpine

# Update everything and install needed dependencies
RUN apk add --update --no-cache \
    graphicsmagick \
    tzdata \
    git \
    tini \
    su-exec

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk add --virtual build-dependencies python3 build-base ca-certificates && \
    npm config set python "$(which python3)" && \
    npm_config_user=root npm install -g full-icu n8n && \
    apk del build-dependencies && \
    rm -rf /root /tmp/* /var/cache/apk/* && mkdir /root

# Installs latest Chromium package.
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont \
    yarn

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install Puppeteer, Puppeteer Extra, and Stealth Plugin (latest versions)
RUN npm install -g puppeteer@latest puppeteer-extra@latest puppeteer-extra-plugin-stealth@latest

# Install community nodes
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install n8n-nodes-puppeteer@latest && \
    npm install n8n-nodes-deepseek@latest

# Install fonts
RUN apk add --no-cache --virtual fonts msttcorefonts-installer fontconfig && \
    update-ms-fonts && \
    fc-cache -f && \
    apk del fonts && \
    find /usr/share/fonts/truetype/msttcorefonts/ -type l -exec unlink {} \; && \
    rm -rf /root /tmp/* /var/cache/apk/* && mkdir /root

ENV NODE_ICU_DATA /usr/local/lib/node_modules/full-icu

WORKDIR /data

# Copy the entrypoint script and make it executable
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

EXPOSE 5678/tcp
