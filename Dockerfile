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


# Install node
SHELL ["/bin/bash", "--login" , "-c"]
ENV NVM_DIR="/usr/local/nvm"
RUN mkdir $NVM_DIR
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
