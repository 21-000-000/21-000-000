#!/bin/bash

# 21.000.000 Repository Organization Script
# This script helps organize and maintain consistency across all repositories

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
ORG_NAME="21-000-000"
REPO_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
PROJECTS_DIR="${REPO_DIR}/projects"

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

# Check if GitHub CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) is not installed. Please install it first."
        log_info "Visit: https://cli.github.com/"
        exit 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        log_error "GitHub CLI is not authenticated. Please run 'gh auth login' first."
        exit 1
    fi
    
    log_success "GitHub CLI is installed and authenticated"
}

# Fetch repository information
fetch_repo_info() {
    local repo_name="$1"
    local repo_info
    
    log_info "Fetching information for $repo_name..."
    
    # Get repository information
    repo_info=$(gh repo view "$ORG_NAME/$repo_name" --json name,description,url,topics,language,stargazerCount,forkCount,isArchived,visibility,updatedAt 2>/dev/null || echo "{}")
    
    if [ "$repo_info" = "{}" ]; then
        log_warning "Could not fetch information for $repo_name"
        return 1
    fi
    
    echo "$repo_info"
}

# Generate repository status
generate_repo_status() {
    local repos=("21-000-000" "awesome-btc-cz" "awesome-btc-global" "21-000-000.github.io" "ai-tools" "dotfiles")
    local status_file="${PROJECTS_DIR}/STATUS.md"
    
    log_info "Generating repository status..."
    
    cat > "$status_file" << 'EOF'
# Project Status Overview

This document provides an overview of all repositories in the 21.000.000 organization, including their current status, activity, and maintenance information.

## Repository Status Legend

- 🟢 **Active**: Actively maintained and developed
- 🟡 **Maintenance**: Stable, receiving bug fixes and security updates
- 🔴 **Archived**: No longer actively maintained
- 🔵 **Experimental**: In development, not ready for production

## Repositories

EOF

    for repo in "${repos[@]}"; do
        local repo_info
        repo_info=$(fetch_repo_info "$repo")
        
        if [ $? -eq 0 ]; then
            local name=$(echo "$repo_info" | jq -r '.name // "Unknown"')
            local description=$(echo "$repo_info" | jq -r '.description // "No description"')
            local url=$(echo "$repo_info" | jq -r '.url // ""')
            local language=$(echo "$repo_info" | jq -r '.language // "N/A"')
            local stars=$(echo "$repo_info" | jq -r '.stargazerCount // 0')
            local forks=$(echo "$repo_info" | jq -r '.forkCount // 0')
            local updated=$(echo "$repo_info" | jq -r '.updatedAt // "Unknown"')
            local is_archived=$(echo "$repo_info" | jq -r '.isArchived // false')
            
            # Determine status
            local status="🟢 Active"
            if [ "$is_archived" = "true" ]; then
                status="🔴 Archived"
            elif [ "$repo" = "ai-tools" ]; then
                status="🔵 Experimental"
            elif [ "$repo" = "dotfiles" ]; then
                status="🟡 Maintenance"
            fi
            
            cat >> "$status_file" << EOF
### $name

**Status**: $status  
**Description**: $description  
**Language**: $language  
**URL**: [$url]($url)  
**Stats**: ⭐ $stars stars, 🍴 $forks forks  
**Last Updated**: $updated  

EOF
        else
            cat >> "$status_file" << EOF
### $repo

**Status**: 🔴 Information unavailable  
**Description**: Could not fetch repository information  
**URL**: [https://github.com/$ORG_NAME/$repo](https://github.com/$ORG_NAME/$repo)  

EOF
        fi
    done
    
    cat >> "$status_file" << 'EOF'
## Maintenance Schedule

### Weekly Tasks
- [ ] Check for security vulnerabilities in dependencies
- [ ] Review and merge community contributions
- [ ] Update documentation if needed
- [ ] Test critical functionality

### Monthly Tasks
- [ ] Update dependencies to latest stable versions
- [ ] Review and update project roadmaps
- [ ] Analyze repository metrics and community feedback
- [ ] Archive inactive repositories if necessary

### Quarterly Tasks
- [ ] Comprehensive security audit
- [ ] Performance optimization review
- [ ] Community feedback collection and analysis
- [ ] Strategic planning and roadmap updates

## Contributing

See individual repository CONTRIBUTING.md files for specific contribution guidelines.

---

**Last updated**: $(date '+%B %d, %Y')  
**Next review**: $(date -d '+1 month' '+%B %d, %Y')
EOF
    
    log_success "Repository status generated: $status_file"
}

# Update repository topics
update_repo_topics() {
    local repo_name="$1"
    shift
    local topics=("$@")
    
    log_info "Updating topics for $repo_name..."
    
    # Convert array to comma-separated string
    local topics_str=$(IFS=','; echo "${topics[*]}")
    
    if gh repo edit "$ORG_NAME/$repo_name" --add-topic "$topics_str" &> /dev/null; then
        log_success "Topics updated for $repo_name"
    else
        log_warning "Could not update topics for $repo_name"
    fi
}

# Check repository consistency
check_repo_consistency() {
    local repos=("21-000-000" "awesome-btc-cz" "awesome-btc-global" "21-000-000.github.io" "ai-tools" "dotfiles")
    
    log_info "Checking repository consistency..."
    
    for repo in "${repos[@]}"; do
        log_info "Checking $repo..."
        
        # Check if repository exists
        if ! gh repo view "$ORG_NAME/$repo" &> /dev/null; then
            log_error "Repository $repo does not exist or is not accessible"
            continue
        fi
        
        # Check for required files
        local required_files=("README.md" "LICENSE")
        
        for file in "${required_files[@]}"; do
            if gh api "repos/$ORG_NAME/$repo/contents/$file" &> /dev/null; then
                log_success "$repo has $file"
            else
                log_warning "$repo is missing $file"
            fi
        done
        
        # Check for recommended files
        local recommended_files=("CONTRIBUTING.md" "CODE_OF_CONDUCT.md" "SECURITY.md")
        
        for file in "${recommended_files[@]}"; do
            if gh api "repos/$ORG_NAME/$repo/contents/$file" &> /dev/null; then
                log_success "$repo has $file"
            else
                log_info "$repo could benefit from $file"
            fi
        done
    done
}

# Sync organization settings
sync_org_settings() {
    log_info "Synchronizing organization settings..."
    
    # Define standard topics for different repository types
    declare -A repo_topics
    repo_topics["21-000-000"]="bitcoin community opensource documentation"
    repo_topics["awesome-btc-cz"]="bitcoin awesome-list czech resources"
    repo_topics["awesome-btc-global"]="bitcoin awesome-list global resources"
    repo_topics["21-000-000.github.io"]="bitcoin website github-pages community"
    repo_topics["ai-tools"]="bitcoin ai tools development"
    repo_topics["dotfiles"]="dotfiles development-environment configuration"
    
    # Update topics for each repository
    for repo in "${!repo_topics[@]}"; do
        IFS=' ' read -ra topics <<< "${repo_topics[$repo]}"
        update_repo_topics "$repo" "${topics[@]}"
    done
}

# Generate organization metrics
generate_metrics() {
    local metrics_file="${PROJECTS_DIR}/METRICS.md"
    
    log_info "Generating organization metrics..."
    
    cat > "$metrics_file" << 'EOF'
# Organization Metrics

This document contains key metrics and statistics for the 21.000.000 organization.

## Repository Metrics

EOF

    local total_stars=0
    local total_forks=0
    local total_repos=0
    
    local repos=("21-000-000" "awesome-btc-cz" "awesome-btc-global" "21-000-000.github.io" "ai-tools" "dotfiles")
    
    for repo in "${repos[@]}"; do
        local repo_info
        repo_info=$(fetch_repo_info "$repo")
        
        if [ $? -eq 0 ]; then
            local stars=$(echo "$repo_info" | jq -r '.stargazerCount // 0')
            local forks=$(echo "$repo_info" | jq -r '.forkCount // 0')
            
            total_stars=$((total_stars + stars))
            total_forks=$((total_forks + forks))
            total_repos=$((total_repos + 1))
        fi
    done
    
    cat >> "$metrics_file" << EOF
- **Total Repositories**: $total_repos
- **Total Stars**: $total_stars ⭐
- **Total Forks**: $total_forks 🍴
- **Average Stars per Repository**: $((total_stars / total_repos))

## Recent Activity

<!-- TODO: Add GitHub Actions to automatically update this section -->

## Community Health

- **Open Issues**: [View all issues](https://github.com/search?q=org%3A21-000-000+is%3Aissue+is%3Aopen)
- **Open Pull Requests**: [View all PRs](https://github.com/search?q=org%3A21-000-000+is%3Apr+is%3Aopen)
- **Contributors**: [View contributors](https://github.com/orgs/21-000-000/people)

---

**Generated on**: $(date '+%B %d, %Y at %H:%M UTC')
EOF
    
    log_success "Organization metrics generated: $metrics_file"
}

# Main menu
show_menu() {
    echo
    echo "21.000.000 Repository Organization Tool"
    echo "====================================="
    echo
    echo "1. Check repository consistency"
    echo "2. Generate repository status"
    echo "3. Sync organization settings"
    echo "4. Generate organization metrics"
    echo "5. Run all tasks"
    echo "6. Exit"
    echo
    read -p "Select an option (1-6): " choice
    
    case $choice in
        1) check_repo_consistency ;;
        2) generate_repo_status ;;
        3) sync_org_settings ;;
        4) generate_metrics ;;
        5) 
            check_repo_consistency
            generate_repo_status
            sync_org_settings
            generate_metrics
            ;;
        6) log_info "Goodbye!"; exit 0 ;;
        *) log_error "Invalid option. Please try again."; show_menu ;;
    esac
}

# Main execution
main() {
    log_info "Starting repository organization script..."
    
    # Create projects directory if it doesn't exist
    mkdir -p "$PROJECTS_DIR"
    
    # Check prerequisites
    check_gh_cli
    
    # Check if jq is installed
    if ! command -v jq &> /dev/null; then
        log_error "jq is not installed. Please install it first."
        exit 1
    fi
    
    # Show menu if no arguments provided
    if [ $# -eq 0 ]; then
        show_menu
    else
        # Handle command line arguments
        case $1 in
            "check") check_repo_consistency ;;
            "status") generate_repo_status ;;
            "sync") sync_org_settings ;;
            "metrics") generate_metrics ;;
            "all") 
                check_repo_consistency
                generate_repo_status
                sync_org_settings
                generate_metrics
                ;;
            *) 
                echo "Usage: $0 [check|status|sync|metrics|all]"
                exit 1
                ;;
        esac
    fi
    
    log_success "Repository organization complete!"
}

# Run main function
main "$@"

