# Use the official n8n image
FROM n8nio/n8n:latest

# Switch to root user to install dependencies
USER root

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

# Copy community nodes from your repository
COPY custom /home/node/.n8n/custom

# Install dependencies for each community node
RUN cd /home/node/.n8n/custom/n8n-nodes-puppeteer && npm install
RUN cd /home/node/.n8n/custom/n8n-nodes-deepseek && npm install

# Switch back to the non-root user (n8n user)
USER node

# Set the N8N_CUSTOM_EXTENSIONS environment variable
ENV N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom
