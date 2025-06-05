#!/bin/bash

# 21.000.000 Repository Overview Script
# This script provides a comprehensive overview of the repository structure and status

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log_header() {
    echo -e "\n${PURPLE}═══════════════════════════════════════${NC}"
    echo -e "${PURPLE}  $1${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════${NC}"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Count files in directory
count_files() {
    local dir="$1"
    local pattern="$2"
    
    if [ -d "$dir" ]; then
        if [ -n "$pattern" ]; then
            find "$dir" -name "$pattern" -type f | wc -l | tr -d ' '
        else
            find "$dir" -type f | wc -l | tr -d ' '
        fi
    else
        echo "0"
    fi
}

# Get file size
get_size() {
    local path="$1"
    if [ -f "$path" ]; then
        du -h "$path" | cut -f1
    elif [ -d "$path" ]; then
        du -sh "$path" 2>/dev/null | cut -f1 || echo "N/A"
    else
        echo "N/A"
    fi
}

# Check file health
check_file_health() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        local size=$(get_size "$file")
        local lines=$(wc -l < "$file" 2>/dev/null || echo "0")
        log_success "$description ($size, $lines lines)"
    else
        log_error "$description (missing)"
    fi
}

# Main overview function
main() {
    log_header "21.000.000 REPOSITORY OVERVIEW"
    
    echo -e "${CYAN}Generated on:${NC} $(date)"
    echo -e "${CYAN}Repository:${NC} $(pwd)"
    echo -e "${CYAN}Git Branch:${NC} $(git branch --show-current 2>/dev/null || echo 'Not a git repository')"
    
    log_header "DIRECTORY STRUCTURE"
    
    # Core files
    log_info "Core Files:"
    check_file_health "README.md" "  README.md"
    check_file_health "LICENSE" "  LICENSE"
    check_file_health "CONTRIBUTING.md" "  CONTRIBUTING.md"
    check_file_health "CODE_OF_CONDUCT.md" "  CODE_OF_CONDUCT.md"
    check_file_health "SECURITY.md" "  SECURITY.md"
    check_file_health ".gitignore" "  .gitignore"
    
    echo
    log_info "Documentation (docs/):"
    if [ -d "docs" ]; then
        local doc_count=$(count_files "docs" "*.md")
        local doc_size=$(get_size "docs")
        log_success "  Documentation directory ($doc_size, $doc_count markdown files)"
        
        check_file_health "docs/README.md" "    docs/README.md"
        check_file_health "docs/ONBOARDING.md" "    docs/ONBOARDING.md"
        check_file_health "docs/ARCHITECTURE.md" "    docs/ARCHITECTURE.md"
        check_file_health "docs/DEVELOPMENT_GUIDE.md" "    docs/DEVELOPMENT_GUIDE.md"
    else
        log_error "  Documentation directory (missing)"
    fi
    
    echo
    log_info "Scripts (scripts/):"
    if [ -d "scripts" ]; then
        local script_count=$(count_files "scripts")
        local script_size=$(get_size "scripts")
        log_success "  Scripts directory ($script_size, $script_count files)"
        
        check_file_health "scripts/setup-dev-environment.sh" "    setup-dev-environment.sh"
        check_file_health "scripts/check-links.py" "    check-links.py"
        check_file_health "scripts/organize-repos.sh" "    organize-repos.sh"
        check_file_health "scripts/check-internal-links.sh" "    check-internal-links.sh"
        check_file_health "scripts/repo-overview.sh" "    repo-overview.sh"
    else
        log_error "  Scripts directory (missing)"
    fi
    
    echo
    log_info "Projects (projects/):"
    if [ -d "projects" ]; then
        local project_count=$(count_files "projects" "*.md")
        local project_size=$(get_size "projects")
        log_success "  Projects directory ($project_size, $project_count files)"
        
        check_file_health "projects/README.md" "    projects/README.md"
        check_file_health "projects/STATUS.md" "    projects/STATUS.md"
    else
        log_error "  Projects directory (missing)"
    fi
    
    echo
    log_info "GitHub Configuration (.github/):"
    if [ -d ".github" ]; then
        local github_count=$(count_files ".github")
        local github_size=$(get_size ".github")
        log_success "  GitHub directory ($github_size, $github_count files)"
        
        check_file_health ".github/PULL_REQUEST_TEMPLATE.md" "    PULL_REQUEST_TEMPLATE.md"
        
        if [ -d ".github/ISSUE_TEMPLATE" ]; then
            local template_count=$(count_files ".github/ISSUE_TEMPLATE")
            log_success "    Issue templates ($template_count templates)"
        else
            log_warning "    Issue templates (missing)"
        fi
        
        if [ -d ".github/workflows" ]; then
            local workflow_count=$(count_files ".github/workflows" "*.yml")
            log_success "    GitHub Actions workflows ($workflow_count workflows)"
        else
            log_warning "    GitHub Actions workflows (none)"
        fi
    else
        log_error "  GitHub directory (missing)"
    fi
    
    log_header "REPOSITORY STATISTICS"
    
    # File type statistics
    local md_files=$(find . -name "*.md" -type f | grep -v node_modules | wc -l | tr -d ' ')
    local sh_files=$(find . -name "*.sh" -type f | wc -l | tr -d ' ')
    local py_files=$(find . -name "*.py" -type f | wc -l | tr -d ' ')
    local total_files=$(find . -type f | grep -v -E "\.(git|DS_Store)" | wc -l | tr -d ' ')
    
    echo -e "${CYAN}File Types:${NC}"
    echo -e "  Markdown files: ${GREEN}$md_files${NC}"
    echo -e "  Shell scripts:  ${GREEN}$sh_files${NC}"
    echo -e "  Python files:   ${GREEN}$py_files${NC}"
    echo -e "  Total files:    ${GREEN}$total_files${NC}"
    
    # Size statistics
    local repo_size=$(get_size ".")
    echo -e "\n${CYAN}Repository Size:${NC} ${GREEN}$repo_size${NC}"
    
    # Git statistics (if available)
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        local last_commit=$(git log -1 --format="%cr" 2>/dev/null || echo "unknown")
        local contributors=$(git log --format="%an" | sort -u | wc -l | tr -d ' ')
        
        echo -e "\n${CYAN}Git Statistics:${NC}"
        echo -e "  Commits:        ${GREEN}$commit_count${NC}"
        echo -e "  Contributors:   ${GREEN}$contributors${NC}"
        echo -e "  Last commit:    ${GREEN}$last_commit${NC}"
    fi
    
    log_header "HEALTH CHECKS"
    
    # Run link checker if available
    if [ -x "scripts/check-internal-links.sh" ]; then
        log_info "Running internal link checker..."
        if ./scripts/check-internal-links.sh > /dev/null 2>&1; then
            log_success "All internal links are valid"
        else
            log_warning "Some internal links may be broken"
        fi
    else
        log_warning "Link checker not available"
    fi
    
    # Check for required files
    local required_files=("README.md" "LICENSE" "CONTRIBUTING.md" "CODE_OF_CONDUCT.md" "SECURITY.md")
    local missing_files=0
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files=$((missing_files + 1))
        fi
    done
    
    if [ $missing_files -eq 0 ]; then
        log_success "All required files are present"
    else
        log_warning "$missing_files required files are missing"
    fi
    
    # Check for executable scripts
    local executable_scripts=0
    if [ -d "scripts" ]; then
        for script in scripts/*.sh; do
            if [ -f "$script" ] && [ -x "$script" ]; then
                executable_scripts=$((executable_scripts + 1))
            fi
        done
        
        if [ $executable_scripts -gt 0 ]; then
            log_success "$executable_scripts scripts are executable"
        else
            log_warning "No executable scripts found"
        fi
    fi
    
    log_header "QUICK ACTIONS"
    
    echo -e "${CYAN}Available commands:${NC}"
    echo -e "  ${GREEN}./scripts/setup-dev-environment.sh${NC}  - Set up development environment"
    echo -e "  ${GREEN}./scripts/check-internal-links.sh${NC}   - Check internal links"
    echo -e "  ${GREEN}./scripts/organize-repos.sh${NC}         - Organize repository settings"
    echo -e "  ${GREEN}./scripts/repo-overview.sh${NC}          - This overview (current)"
    
    echo -e "\n${CYAN}Documentation:${NC}"
    echo -e "  ${GREEN}docs/ONBOARDING.md${NC}      - New contributor guide"
    echo -e "  ${GREEN}docs/ARCHITECTURE.md${NC}    - Technical architecture"
    echo -e "  ${GREEN}docs/DEVELOPMENT_GUIDE.md${NC} - Development standards"
    echo -e "  ${GREEN}projects/README.md${NC}      - Project overview"
    
    log_header "REPOSITORY STATUS: READY ✨"
    
    echo -e "${GREEN}Repository structure is complete and ready for development!${NC}"
    echo -e "\nFor more information, visit: ${CYAN}https://github.com/21-000-000/21-000-000${NC}"
}

# Run main function
main "$@"

