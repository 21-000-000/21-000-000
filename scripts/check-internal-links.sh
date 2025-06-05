#!/bin/bash

# Simple Internal Link Checker for 21.000.000
# This script checks for broken internal file references without external dependencies

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
total_checks=0
broken_links=0

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

# Check if a file exists relative to the repository root
check_file_exists() {
    local file_path="$1"
    local source_file="$2"
    
    total_checks=$((total_checks + 1))
    
    # Remove ./ prefix if present
    file_path=${file_path#./}
    
    if [ -f "$file_path" ]; then
        log_success "✅ $source_file: $file_path exists"
    else
        log_error "❌ $source_file: $file_path NOT FOUND"
        broken_links=$((broken_links + 1))
    fi
}

# Extract and check internal file links from a markdown file
check_markdown_file() {
    local md_file="$1"
    
    if [ ! -f "$md_file" ]; then
        log_warning "Markdown file not found: $md_file"
        return
    fi
    
    log_info "Checking internal links in: $md_file"
    
    # Extract relative file links (not starting with http:// or https://)
    grep -n '\[.*\]([^)]*\.md)' "$md_file" | while read -r line; do
        # Extract the file path from [text](path)
        link_path=$(echo "$line" | sed -n 's/.*\[.*\](\([^)]*\)).*/\1/p')
        
        # Skip if it's an external link
        if [[ "$link_path" =~ ^https?:// ]]; then
            continue
        fi
        
        # Resolve relative paths
        if [[ "$link_path" == ../* ]]; then
            # Handle ../ paths
            resolved_path=$(cd "$(dirname "$md_file")" && realpath "$link_path" 2>/dev/null || echo "INVALID")
            if [ "$resolved_path" != "INVALID" ]; then
                # Convert back to relative path from repo root
                repo_root=$(pwd)
                link_path=${resolved_path#$repo_root/}
            fi
        elif [[ "$link_path" == ./* ]]; then
            # Handle ./ paths
            dir_path=$(dirname "$md_file")
            link_path="$dir_path/${link_path#./}"
        elif [[ "$link_path" != /* ]]; then
            # Handle relative paths
            dir_path=$(dirname "$md_file")
            if [ "$dir_path" != "." ]; then
                link_path="$dir_path/$link_path"
            fi
        fi
        
        check_file_exists "$link_path" "$md_file"
    done
}

# Main execution
main() {
    log_info "21.000.000 Internal Link Checker"
    log_info "=================================="
    echo
    
    # Key files to check
    key_files=(
        "README.md"
        "CONTRIBUTING.md"
        "CODE_OF_CONDUCT.md"
        "SECURITY.md"
        "docs/README.md"
        "docs/ONBOARDING.md"
        "docs/ARCHITECTURE.md"
        "docs/DEVELOPMENT_GUIDE.md"
        "projects/README.md"
    )
    
    # Check each markdown file
    for file in "${key_files[@]}"; do
        if [ -f "$file" ]; then
            check_markdown_file "$file"
        else
            log_warning "Key file not found: $file"
        fi
    done
    
    echo
    log_info "=================================="
    log_info "Manual checks for common issues:"
    echo
    
    # Check for required files mentioned in README
    log_info "Checking required files mentioned in README..."
    check_file_exists "CONTRIBUTING.md" "README.md"
    check_file_exists "CODE_OF_CONDUCT.md" "README.md"
    check_file_exists "SECURITY.md" "README.md"
    check_file_exists "LICENSE" "README.md"
    
    # Check docs structure
    log_info "Checking documentation structure..."
    if [ -d "docs" ]; then
        log_success "✅ docs/ directory exists"
        check_file_exists "docs/README.md" "directory structure"
        check_file_exists "docs/ONBOARDING.md" "directory structure"
        check_file_exists "docs/ARCHITECTURE.md" "directory structure"
        check_file_exists "docs/DEVELOPMENT_GUIDE.md" "directory structure"
    else
        log_error "❌ docs/ directory missing"
        broken_links=$((broken_links + 1))
    fi
    
    # Check scripts structure
    log_info "Checking scripts structure..."
    if [ -d "scripts" ]; then
        log_success "✅ scripts/ directory exists"
        check_file_exists "scripts/setup-dev-environment.sh" "directory structure"
        check_file_exists "scripts/check-links.py" "directory structure"
        check_file_exists "scripts/organize-repos.sh" "directory structure"
    else
        log_error "❌ scripts/ directory missing"
        broken_links=$((broken_links + 1))
    fi
    
    # Check projects structure
    log_info "Checking projects structure..."
    if [ -d "projects" ]; then
        log_success "✅ projects/ directory exists"
        check_file_exists "projects/README.md" "directory structure"
    else
        log_error "❌ projects/ directory missing"
        broken_links=$((broken_links + 1))
    fi
    
    # Summary
    echo
    log_info "=================================="
    log_info "Summary:"
    echo "  Total checks: $total_checks"
    echo "  Broken links: $broken_links"
    
    if [ $broken_links -eq 0 ]; then
        log_success "🎉 All internal links are working!"
        exit 0
    else
        log_error "❌ Found $broken_links broken internal links"
        echo
        log_info "To fix broken links:"
        echo "  1. Check if referenced files exist"
        echo "  2. Verify file paths are correct"
        echo "  3. Update links or create missing files"
        exit 1
    fi
}

# Run main function
main "$@"

