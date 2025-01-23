# Use the Debian-based n8n image
FROM n8nio/n8n:latest-ubuntu

# Install Puppeteer dependencies
RUN apt-get update && apt-get install -y \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libxkbcommon0 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Puppeteer and Puppeteer Extra packages
RUN npm install puppeteer puppeteer-extra puppeteer-extra-plugin-stealth

# Install a community node
RUN npm install n8n-nodes-puppeteer
RUN npm install n8n-nodes-deepseek
