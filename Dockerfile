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

# Create the custom directory for community nodes
RUN mkdir -p /home/node/.n8n/custom

# Debug: Check the .n8n directory structure
RUN ls -la /home/node/.n8n/

# Debug: Check the custom directory structure
RUN ls -la /home/node/.n8n/custom/

# Remove existing Puppeteer node (if any)
RUN rm -rf /home/node/.n8n/custom/n8n-nodes-puppeteer

# Clone and install Puppeteer node
RUN cd /home/node/.n8n/custom && \
    git clone https://github.com/drudge/n8n-nodes-puppeteer.git && \
    cd /home/node/.n8n/custom/n8n-nodes-puppeteer && npm install

# Clone and install Deepseek node
RUN cd /home/node/.n8n/custom && \
    git clone https://github.com/rubickecho/n8n-deepseek.git && \
    cd /home/node/.n8n/custom/n8n-deepseek && npm install

# Switch back to the non-root user (n8n user)
USER node

# Set the N8N_CUSTOM_EXTENSIONS environment variable
ENV N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom
