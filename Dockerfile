# Use the official n8n image
FROM n8nio/n8n:latest

# Install Puppeteer dependencies using apk (Alpine Linux package manager)
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

# Install Puppeteer and Puppeteer Extra packages
RUN npm install puppeteer puppeteer-extra puppeteer-extra-plugin-stealth

# Install community nodes
RUN npm install n8n-nodes-puppeteer
RUN npm install n8n-nodes-deepseek
