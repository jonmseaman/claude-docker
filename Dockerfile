FROM ubuntu:24.04

# Default to bash
SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    jq \
    python3 \
    python3-pip \
    neovim

# Create workspace and give ownership to ubuntu user
RUN mkdir -p /workspace && chown ubuntu:ubuntu /workspace

# Switch to ubuntu user for all user-space installs
USER ubuntu
SHELL ["/bin/bash", "--login", "-c"]
ENV NVM_DIR="/home/ubuntu/.nvm"

# Install node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install 24 \
    && node -v && npm -v

# Install Claude Code.
# It is required to run nvm.sh before npm, or npm will not be found.
RUN . "$NVM_DIR/nvm.sh" && npm install -g @anthropic-ai/claude-code
RUN echo 'alias clauded="claude --dangerously-skip-permissions"' >> ~/.bashrc

# Set up working directory
WORKDIR /workspace

# Default command - keep container running
CMD ["bash"]
