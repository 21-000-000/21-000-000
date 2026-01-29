#!/bin/bash

# 21.000.000 Development Environment Setup Script
# This script sets up a consistent development environment for all projects

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check system requirements
check_requirements() {
    log_info "Checking system requirements..."

    # Check operating system
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        log_info "Detected Linux system"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        log_info "Detected macOS system"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        OS="windows"
        log_info "Detected Windows system"
    else
        log_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi

    # Check Git
    if command_exists git; then
        GIT_VERSION=$(git --version | cut -d' ' -f3)
        log_success "Git $GIT_VERSION is installed"
    else
        log_error "Git is not installed. Please install Git first."
        exit 1
    fi
}

# Install Node.js and npm
install_nodejs() {
    log_info "Checking Node.js installation..."

    if command_exists node; then
        NODE_VERSION=$(node --version)
        NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')

        if [ "$NODE_MAJOR" -ge 18 ]; then
            log_success "Node.js $NODE_VERSION is installed and compatible"
            return
        else
            log_warning "Node.js $NODE_VERSION is installed but version 18+ is recommended"
        fi
    fi

    log_info "Installing Node.js..."

    if [[ "$OS" == "macos" ]]; then
        if command_exists brew; then
            brew install node
        else
            log_error "Homebrew is not installed. Please install it first: https://brew.sh"
            exit 1
        fi
    elif [[ "$OS" == "linux" ]]; then
        # Install Node.js via NodeSource repository
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        log_error "Please install Node.js manually from https://nodejs.org"
        exit 1
    fi

    log_success "Node.js installed successfully"
}

# Install Python (for some projects)
install_python() {
    log_info "Checking Python installation..."

    if command_exists python3; then
        PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
        log_success "Python $PYTHON_VERSION is installed"

        # Install pip if not available
        if ! command_exists pip3; then
            log_info "Installing pip..."
            python3 -m ensurepip --upgrade
        fi

        # Install pipenv for virtual environments
        if ! command_exists pipenv; then
            log_info "Installing pipenv..."
            pip3 install --user pipenv
        fi
    else
        log_info "Installing Python..."

        if [[ "$OS" == "macos" ]]; then
            if command_exists brew; then
                brew install python
            else
                log_error "Homebrew is not installed. Please install it first: https://brew.sh"
                exit 1
            fi
        elif [[ "$OS" == "linux" ]]; then
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip python3-venv
        else
            log_error "Please install Python manually from https://python.org"
            exit 1
        fi

        log_success "Python installed successfully"
    fi
}

# Install essential development tools
install_dev_tools() {
    log_info "Installing essential development tools..."

    # Install global npm packages
    npm install -g yarn pnpm

    # Development tools
    if [[ "$OS" == "macos" ]]; then
        if command_exists brew; then
            # Essential tools for macOS
            brew install jq curl wget tree httpie
        fi
    elif [[ "$OS" == "linux" ]]; then
        # Essential tools for Linux
        sudo apt-get install -y jq curl wget tree httpie build-essential
    fi

    log_success "Development tools installed"
}

# Setup Git configuration
setup_git() {
    log_info "Setting up Git configuration..."

    # Check if Git is already configured
    if git config --global user.name >/dev/null 2>&1 && git config --global user.email >/dev/null 2>&1; then
        GIT_NAME=$(git config --global user.name)
        GIT_EMAIL=$(git config --global user.email)
        log_success "Git is already configured for $GIT_NAME ($GIT_EMAIL)"
        return
    fi

    # Interactive Git setup
    echo
    log_info "Let's configure Git for your first commit:"
    read -p "Enter your full name: " git_name
    read -p "Enter your email address: " git_email

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"

    # Set up some useful Git aliases
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global alias.lg "log --oneline --graph --decorate --all"

    # Set default branch name
    git config --global init.defaultBranch main

    # Set up better diff and merge tools
    git config --global core.editor "code --wait" 2>/dev/null || true

    log_success "Git configured successfully"
}

# Setup project-specific environment
setup_project_env() {
    log_info "Setting up project-specific environment..."

    # Create .env.example if it doesn't exist
    if [ ! -f ".env.example" ]; then
        cat > .env.example << 'EOF'
# Bitcoin API Configuration
BITCOIN_API_KEY=your_api_key_here
BITCOIN_NETWORK=mainnet

# Database Configuration
DATABASE_URL=postgresql://localhost:5432/bitcoin_dev

# Security
JWT_SECRET=your_jwt_secret_here
ENCRYPTION_KEY=your_encryption_key_here

# External Services
EMAIL_SERVICE_API_KEY=your_email_service_key
MONITORING_API_KEY=your_monitoring_key

# Development
NODE_ENV=development
PORT=3000
LOG_LEVEL=debug
EOF
        log_success "Created .env.example file"
    fi

    # Copy .env.example to .env if .env doesn't exist
    if [ ! -f ".env" ]; then
        cp .env.example .env
        log_success "Created .env file from example"
        log_warning "Please update .env file with your actual configuration values"
    fi

    # Install project dependencies
    if [ -f "package.json" ]; then
        log_info "Installing Node.js dependencies..."
        npm install
        log_success "Node.js dependencies installed"
    fi

    if [ -f "requirements.txt" ]; then
        log_info "Installing Python dependencies..."
        if command_exists pipenv; then
            pipenv install --dev
        else
            pip3 install -r requirements.txt
        fi
        log_success "Python dependencies installed"
    fi

    if [ -f "Cargo.toml" ]; then
        log_info "Installing Rust dependencies..."
        if command_exists cargo; then
            cargo build
        else
            log_warning "Rust is not installed. Install from https://rustup.rs"
        fi
    fi
}

# Setup VS Code configuration
setup_vscode() {
    log_info "Setting up VS Code configuration..."

    if command_exists code; then
        # Create .vscode directory
        mkdir -p .vscode

        # Create settings.json
        cat > .vscode/settings.json << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "quickfix.biome": "explicit",
    "source.organizeImports.biome": "explicit"
  },
  "javascript.preferences.importModuleSpecifier": "relative",
  "typescript.preferences.importModuleSpecifier": "relative",
  "python.defaultInterpreterPath": "./venv/bin/python",
  "python.formatting.provider": "black",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "files.exclude": {
    "**/node_modules": true,
    "**/.git": true,
    "**/.DS_Store": true,
    "**/venv": true,
    "**/__pycache__": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/venv": true
  }
}
EOF

        # Create extensions.json
        cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "biomejs.biome",
    "ms-python.python",
    "ms-python.black-formatter",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-json",
    "redhat.vscode-yaml",
    "github.copilot",
    "github.copilot-chat",
    "ms-vscode.vscode-typescript-next"
  ]
}
EOF

        log_success "VS Code configuration created"
        log_info "Consider installing recommended extensions"
    else
        log_warning "VS Code is not installed. Download from https://code.visualstudio.com"
    fi
}

# Main execution
main() {
    echo
    log_info "21.000.000 Development Environment Setup"
    log_info "========================================"
    echo

    check_requirements
    install_nodejs
    install_python
    install_dev_tools
    setup_git
    setup_project_env
    setup_vscode

    echo
    log_success "🎉 Development environment setup complete!"
    echo
    log_info "Next steps:"
    echo "  1. Update .env file with your configuration"
    echo "  2. Read the project README.md for specific instructions"
    echo "  3. Check docs/ONBOARDING.md for contribution guidelines"
    echo "  4. Join our GitHub Discussions for community support"
    echo
    log_info "Happy coding! 🚀"
}

# Run main function
main "$@"

