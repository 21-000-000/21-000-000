#!/usr/bin/env python3
"""
21.000.000 Link Checker
This script checks all links in markdown files for 404 errors and invalid references.
"""

import os
import re
import sys
import requests
import argparse
from pathlib import Path
from urllib.parse import urljoin, urlparse
from typing import List, Dict, Set, Tuple
import time

# Configuration
TIMEOUT = 10
RETRY_COUNT = 2
DELAY_BETWEEN_REQUESTS = 0.5

# Colors for output
class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def log_info(message: str):
    print(f"{Colors.BLUE}[INFO]{Colors.ENDC} {message}")

def log_success(message: str):
    print(f"{Colors.GREEN}[SUCCESS]{Colors.ENDC} {message}")

def log_warning(message: str):
    print(f"{Colors.YELLOW}[WARNING]{Colors.ENDC} {message}")

def log_error(message: str):
    print(f"{Colors.RED}[ERROR]{Colors.ENDC} {message}")

def find_markdown_files(directory: Path) -> List[Path]:
    """Find all markdown files in the directory recursively."""
    markdown_files = []
    for file_path in directory.rglob("*.md"):
        if not any(part.startswith('.') for part in file_path.parts):
            markdown_files.append(file_path)
    return markdown_files

def extract_links(content: str, file_path: Path) -> List[Tuple[str, int]]:
    """Extract all links from markdown content with line numbers."""
    links = []
    lines = content.split('\n')
    
    # Regex patterns for different link types
    patterns = [
        r'\[([^\]]+)\]\(([^\)]+)\)',  # [text](url)
        r'\[([^\]]+)\]:\s*([^\s]+)',   # [text]: url
        r'<(https?://[^>]+)>',         # <url>
        r'https?://[^\s\)\]]+',        # bare URLs
    ]
    
    for line_num, line in enumerate(lines, 1):
        for pattern in patterns:
            matches = re.finditer(pattern, line)
            for match in matches:
                if len(match.groups()) >= 2:
                    url = match.group(2)
                elif len(match.groups()) == 1:
                    url = match.group(1)
                else:
                    url = match.group(0)
                
                # Clean up the URL
                url = url.strip()
                if url:
                    links.append((url, line_num))
    
    return links

def is_external_url(url: str) -> bool:
    """Check if URL is external (http/https)."""
    return url.startswith(('http://', 'https://'))

def is_relative_path(url: str) -> bool:
    """Check if URL is a relative file path."""
    return not url.startswith(('http://', 'https://', 'mailto:', 'tel:', '#'))

def check_external_url(url: str) -> Tuple[bool, str]:
    """Check if external URL is accessible."""
    try:
        # Add user agent to avoid being blocked
        headers = {
            'User-Agent': 'Mozilla/5.0 (21.000.000 Link Checker) AppleWebKit/537.36'
        }
        
        for attempt in range(RETRY_COUNT):
            response = requests.head(url, timeout=TIMEOUT, headers=headers, allow_redirects=True)
            
            if response.status_code == 405:  # Method not allowed, try GET
                response = requests.get(url, timeout=TIMEOUT, headers=headers, allow_redirects=True)
            
            if response.status_code < 400:
                return True, f"OK ({response.status_code})"
            elif response.status_code == 429:  # Rate limited
                time.sleep(2 ** attempt)  # Exponential backoff
                continue
            else:
                return False, f"HTTP {response.status_code}"
                
        return False, "Rate limited after retries"
        
    except requests.exceptions.Timeout:
        return False, "Timeout"
    except requests.exceptions.ConnectionError:
        return False, "Connection error"
    except requests.exceptions.RequestException as e:
        return False, f"Request error: {str(e)}"

def check_relative_path(url: str, base_path: Path) -> Tuple[bool, str]:
    """Check if relative file path exists."""
    # Remove URL fragments and query parameters
    clean_url = url.split('#')[0].split('?')[0]
    
    if not clean_url:  # Just a fragment
        return True, "Fragment link (not checked)"
    
    # Resolve relative path
    if clean_url.startswith('./'):
        target_path = base_path.parent / clean_url[2:]
    elif clean_url.startswith('../'):
        target_path = base_path.parent / clean_url
    else:
        target_path = base_path.parent / clean_url
    
    try:
        target_path = target_path.resolve()
        if target_path.exists():
            return True, "File exists"
        else:
            return False, "File not found"
    except Exception as e:
        return False, f"Path error: {str(e)}"

def check_github_specific_urls(url: str) -> Tuple[bool, str]:
    """Check GitHub-specific URLs like issues, discussions, etc."""
    github_patterns = [
        r'https://github\.com/21-000-000/[^/]+/issues',
        r'https://github\.com/21-000-000/[^/]+/discussions',
        r'https://github\.com/orgs/21-000-000/discussions',
        r'https://github\.com/orgs/21-000-000/repositories',
    ]
    
    for pattern in github_patterns:
        if re.match(pattern, url):
            # These are valid GitHub URLs, assume they work
            return True, "GitHub URL (assumed valid)"
    
    return None, "Not a special GitHub URL"

def main():
    parser = argparse.ArgumentParser(description='Check links in markdown files')
    parser.add_argument('directory', nargs='?', default='.', help='Directory to check (default: current)')
    parser.add_argument('--external-only', action='store_true', help='Check only external links')
    parser.add_argument('--internal-only', action='store_true', help='Check only internal links')
    parser.add_argument('--ignore-fragments', action='store_true', help='Ignore fragment-only links')
    args = parser.parse_args()
    
    directory = Path(args.directory).resolve()
    
    if not directory.exists():
        log_error(f"Directory does not exist: {directory}")
        sys.exit(1)
    
    log_info(f"Checking links in: {directory}")
    
    # Find all markdown files
    markdown_files = find_markdown_files(directory)
    log_info(f"Found {len(markdown_files)} markdown files")
    
    total_links = 0
    broken_links = 0
    checked_external_urls: Set[str] = set()
    
    for file_path in markdown_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            log_error(f"Cannot read {file_path}: {e}")
            continue
        
        links = extract_links(content, file_path)
        if not links:
            continue
            
        relative_path = file_path.relative_to(directory)
        print(f"\n{Colors.BOLD}Checking {relative_path}:{Colors.ENDC}")
        
        for url, line_num in links:
            total_links += 1
            
            # Skip certain URLs
            if url.startswith(('mailto:', 'tel:')):
                continue
            
            if args.ignore_fragments and url.startswith('#'):
                continue
            
            # Check GitHub-specific URLs first
            github_result, github_message = check_github_specific_urls(url)
            if github_result is not None:
                if github_result:
                    print(f"  ✅ Line {line_num}: {url} - {github_message}")
                else:
                    print(f"  ❌ Line {line_num}: {url} - {github_message}")
                    broken_links += 1
                continue
            
            # Check external URLs
            if is_external_url(url):
                if args.internal_only:
                    continue
                    
                # Avoid checking the same URL multiple times
                if url in checked_external_urls:
                    print(f"  ⏭️  Line {line_num}: {url} - Already checked")
                    continue
                
                checked_external_urls.add(url)
                is_valid, message = check_external_url(url)
                
                if is_valid:
                    print(f"  ✅ Line {line_num}: {url} - {message}")
                else:
                    print(f"  ❌ Line {line_num}: {url} - {message}")
                    broken_links += 1
                
                time.sleep(DELAY_BETWEEN_REQUESTS)  # Be nice to servers
            
            # Check relative paths
            elif is_relative_path(url):
                if args.external_only:
                    continue
                    
                is_valid, message = check_relative_path(url, file_path)
                
                if is_valid:
                    print(f"  ✅ Line {line_num}: {url} - {message}")
                else:
                    print(f"  ❌ Line {line_num}: {url} - {message}")
                    broken_links += 1
            
            # Fragment links or other types
            else:
                print(f"  ⏭️  Line {line_num}: {url} - Skipped (fragment or special URL)")
    
    # Summary
    print(f"\n{Colors.BOLD}Summary:{Colors.ENDC}")
    print(f"Total links checked: {total_links}")
    print(f"Broken links found: {broken_links}")
    
    if broken_links > 0:
        log_error(f"Found {broken_links} broken links")
        sys.exit(1)
    else:
        log_success("All links are working!")

if __name__ == '__main__':
    main()

