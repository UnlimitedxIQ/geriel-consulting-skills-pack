#!/bin/bash
# Consulting Pro Skills Pack - Install Script
# Installs consulting-focused skills, agents, and rules into ~/.claude/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "   ____                      _ _   _               ____            "
echo "  / ___|___  _ __  ___ _   _| | |_(_)_ __   __ _  |  _ \ _ __ ___  "
echo " | |   / _ \|  _ \/ __| | | | | __| |  _ \ / _\` | | |_) | '__/ _ \ "
echo " | |__| (_) | | | \__ \ |_| | | |_| | | | | (_| | |  __/| | | (_) |"
echo "  \____\___/|_| |_|___/\__,_|_|\__|_|_| |_|\__, | |_|   |_|  \___/ "
echo "                                            |___/                   "
echo -e "                    ${GREEN}Skills Pack for Claude Code${NC}"
echo ""

usage() {
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all              Install everything (skills + agents + rules)"
    echo "  --skills           Install all skills"
    echo "  --agents           Install all agents"
    echo "  --rules            Install coding standards & rules"
    echo "  --skill <name>     Install a specific skill"
    echo "  --agent <name>     Install a specific agent"
    echo "  --list             List all available skills and agents"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./install.sh --all                          # Install everything"
    echo "  ./install.sh --skills --agents              # Skills + agents only"
    echo "  ./install.sh --skill market-research        # Just one skill"
    echo "  ./install.sh --skill humanize-writing --skill investor-materials"
}

list_available() {
    echo -e "${BLUE}Available Skills:${NC}"
    for skill_dir in "$SCRIPT_DIR"/skills/*/; do
        skill=$(basename "$skill_dir")
        desc=$(grep -m1 "^description:" "$skill_dir/SKILL.md" 2>/dev/null | sed 's/^description: //' | head -c 80)
        echo -e "  ${GREEN}$skill${NC} - $desc"
    done
    echo ""
    echo -e "${BLUE}Available Agents:${NC}"
    for agent_file in "$SCRIPT_DIR"/agents/*.md; do
        agent=$(basename "$agent_file" .md)
        desc=$(grep -m1 "^description:" "$agent_file" 2>/dev/null | sed 's/^description: //' | head -c 80)
        echo -e "  ${GREEN}$agent${NC} - $desc"
    done
}

install_skill() {
    local skill="$1"
    if [ ! -d "$SCRIPT_DIR/skills/$skill" ]; then
        echo -e "${YELLOW}Warning: Skill '$skill' not found, skipping${NC}"
        return
    fi
    mkdir -p "$CLAUDE_DIR/skills/$skill"
    cp -r "$SCRIPT_DIR/skills/$skill/"* "$CLAUDE_DIR/skills/$skill/"
    echo -e "  ${GREEN}+${NC} Skill: $skill"
}

install_agent() {
    local agent="$1"
    local file="$agent"
    [[ "$file" != *.md ]] && file="$agent.md"
    if [ ! -f "$SCRIPT_DIR/agents/$file" ]; then
        echo -e "${YELLOW}Warning: Agent '$agent' not found, skipping${NC}"
        return
    fi
    mkdir -p "$CLAUDE_DIR/agents"
    cp "$SCRIPT_DIR/agents/$file" "$CLAUDE_DIR/agents/"
    echo -e "  ${GREEN}+${NC} Agent: $(basename "$file" .md)"
}

install_rules() {
    mkdir -p "$CLAUDE_DIR/rules/common"
    cp "$SCRIPT_DIR/rules/common/"*.md "$CLAUDE_DIR/rules/common/"
    cp "$SCRIPT_DIR/rules/README.md" "$CLAUDE_DIR/rules/" 2>/dev/null || true
    echo -e "  ${GREEN}+${NC} Common rules ($(ls "$SCRIPT_DIR/rules/common/"*.md | wc -l) files)"
}

install_all_skills() {
    echo -e "\n${BLUE}Installing Skills...${NC}"
    for skill_dir in "$SCRIPT_DIR"/skills/*/; do
        install_skill "$(basename "$skill_dir")"
    done
}

install_all_agents() {
    echo -e "\n${BLUE}Installing Agents...${NC}"
    for agent_file in "$SCRIPT_DIR"/agents/*.md; do
        install_agent "$(basename "$agent_file")"
    done
}

# Parse arguments
if [ $# -eq 0 ]; then
    usage
    exit 0
fi

DO_SKILLS=false
DO_AGENTS=false
DO_RULES=false
SPECIFIC_SKILLS=()
SPECIFIC_AGENTS=()

while [ $# -gt 0 ]; do
    case "$1" in
        --all)
            DO_SKILLS=true
            DO_AGENTS=true
            DO_RULES=true
            ;;
        --skills)
            DO_SKILLS=true
            ;;
        --agents)
            DO_AGENTS=true
            ;;
        --rules)
            DO_RULES=true
            ;;
        --skill)
            shift
            SPECIFIC_SKILLS+=("$1")
            ;;
        --agent)
            shift
            SPECIFIC_AGENTS+=("$1")
            ;;
        --list)
            list_available
            exit 0
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
    shift
done

echo -e "${BLUE}Installing to ${CLAUDE_DIR}...${NC}"

# Install specific items
if [ ${#SPECIFIC_SKILLS[@]} -gt 0 ]; then
    echo -e "\n${BLUE}Installing Selected Skills...${NC}"
    for skill in "${SPECIFIC_SKILLS[@]}"; do
        install_skill "$skill"
    done
fi

if [ ${#SPECIFIC_AGENTS[@]} -gt 0 ]; then
    echo -e "\n${BLUE}Installing Selected Agents...${NC}"
    for agent in "${SPECIFIC_AGENTS[@]}"; do
        install_agent "$agent"
    done
fi

# Install categories
$DO_SKILLS && install_all_skills
$DO_AGENTS && install_all_agents
$DO_RULES && { echo -e "\n${BLUE}Installing Rules...${NC}"; install_rules; }

echo -e "\n${GREEN}Done! Restart Claude Code to pick up the new skills.${NC}"
echo ""
echo -e "${CYAN}Recommended: Also install these official plugins in Claude Code:${NC}"
echo "  /install-plugin superpowers        # Planning, debugging, code review workflows"
echo "  /install-plugin document-skills    # PDF, DOCX, XLSX, PPTX creation"
echo "  /install-plugin frontend-design    # Professional UI design"
echo "  /install-plugin firecrawl          # Web research & scraping"
echo "  /install-plugin context7           # Up-to-date library docs"
echo "  /install-plugin playwright         # Browser automation"
