#!/bin/bash
# ============================================================
# 企业背调系统 - 一键推送到 GitHub
# ============================================================
#
# 使用前提：
#   1. 已安装 GitHub CLI (gh): https://cli.github.com
#   2. 已登录: gh auth login
#
# 使用方式：
#   chmod +x push-to-github.sh
#   ./push-to-github.sh [你的GitHub用户名]
#
# 如果不传参数，脚本会自动获取你的 GitHub 用户名
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=========================================="
echo "  企业背调系统 - GitHub 推送工具"
echo -e "==========================================${NC}"

# 检查 gh CLI 是否安装
if ! command -v gh &> /dev/null; then
    echo -e "${RED}错误: 未安装 GitHub CLI (gh)${NC}"
    echo ""
    echo "请先安装 gh CLI:"
    echo "  macOS:  brew install gh"
    echo "  Linux:  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
    echo "          echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
    echo "          sudo apt update && sudo apt install gh"
    echo "  Windows: winget install --id GitHub.cli"
    echo ""
    echo "安装后运行: gh auth login"
    exit 1
fi

# 检查是否已登录
if ! gh auth status &> /dev/null; then
    echo -e "${RED}错误: 未登录 GitHub，请先运行: gh auth login${NC}"
    exit 1
fi

# 获取用户名
GITHUB_USER="${1:-$(gh api user --jq '.login')}"
if [ -z "$GITHUB_USER" ]; then
    echo -e "${RED}错误: 无法获取 GitHub 用户名，请手动传入: ./push-to-github.sh 你的用户名${NC}"
    exit 1
fi

REPO_NAME="enterprise-background-check"
FULL_REPO="${GITHUB_USER}/${REPO_NAME}"

echo -e "${GREEN}GitHub 用户: ${GITHUB_USER}${NC}"
echo -e "${GREEN}仓库名称:   ${REPO_NAME}${NC}"
echo -e "${GREEN}完整路径:   ${FULL_REPO}${NC}"
echo ""

# 确认创建
read -p "$(echo -e ${YELLOW}是否创建公开仓库并推送? [Y/n]: ${NC})" confirm
confirm="${confirm:-Y}"
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo "已取消"
    exit 0
fi

echo ""
echo -e "${CYAN}[1/4] 创建 GitHub 仓库...${NC}"

gh repo create "${FULL_REPO}" \
    --public \
    --description "企业背调系统 - Enterprise Background Check Platform | 10大调查维度，求职前必做的公司背景调查" \
    --homepage "https://github.com/${GITHUB_USER}/${REPO_NAME}" \
    --source "." \
    --push \
    --enable-issues \
    --enable-discussions

echo ""
echo -e "${CYAN}[2/4] 设置仓库 Topics...${NC}"

gh api "repos/${FULL_REPO}/topics" \
    --method PUT \
    --field "names[]=background-check" \
    --field "names[]=enterprise" \
    --field "names[]=hr" \
    --field "names[]=job-search" \
    --field "names[]=company-research" \
    --field "names[]=china" \
    --field "names[]=vercel" \
    --field "names[]=railway" \
    --field "names[]=chartjs" \
    --field "names[]=nodejs" \
    --field "names[]=javascript" \
    --field "names[]=html" \
    --field "names[]=css" \
    --silent

echo ""
echo -e "${CYAN}[3/4] 创建初始标签...${NC}"

# 功能模块标签
gh label create "模块-年报分析" --color "0075ca" --description "公司年报和财务数据分析" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "模块-劳动仲裁" --color "d73a4a" --description "劳动仲裁案件查询" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "模块-司法判决" --color "b60205" --description "司法判决文书查询" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "模块-员工评价" --color "fbca04" --description "加班情况和员工评价" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "模块-招聘活跃" --color "0e8a16" --description "BOSS直聘活跃度分析" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "模块-求职建议" --color "1d76db" --description "综合求职建议" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "模块-投资情况" --color "5319e7" --description "公司投资和融资情况" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "模块-社保缴纳" --color "e99695" --description "社保五险一金缴纳情况" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "模块-股票投资" --color "c5def5" --description "港股美股A股投资情况" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "模块-企业文化" --color "d4c5f9" --description "企业文化和福利待遇" --repo "${FULL_REPO}" 2>/dev/null || true

# 通用标签
gh label create "enhancement" --color "a2eeef" --description "新功能建议" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "bug" --color "d73a4a" --description "Bug报告" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "good first issue" --color "7057ff" --description "适合新手的问题" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "help wanted" --color "008672" --description "需要帮助" --repo "${FULL_REPO}" 2>/dev/null || true
gh label create "deployment" --color "c9d1d9" --description "部署相关" --repo "${FULL_REPO}" 2>/dev/null || true

echo ""
echo -e "${CYAN}[4/4] 创建 Welcome Issue...${NC}"

gh issue create \
    --repo "${FULL_REPO}" \
    --title "Welcome to 企业背调系统" \
    --body "## 企业背调系统 (Enterprise Background Check Platform)

### 项目简介

企业背调系统是一个综合性的企业背景调查平台，帮助求职者在入职前全面了解目标公司。

### 10大调查模块

| 模块 | 说明 |
|------|------|
| 年报分析 | 公司基本信息、营收利润趋势、关键财务指标 |
| 劳动仲裁 | 仲裁案件统计、类型分布、典型案例 |
| 司法判决 | 涉诉案件统计、原告/被告分析、判决文书 |
| 加班及评价 | 加班指数、员工满意度、正负面评价 |
| BOSS直聘活跃度 | 在招职位、活跃度评分、招聘趋势 |
| 求职建议 | 综合评分、风险等级、入职建议 |
| 投资情况 | 融资历史、投资方、被投企业 |
| 社保缴纳 | 缴纳人数趋势、五险比例、行业对比 |
| 股票投资 | 股价走势、市值变化、财务指标 |
| 企业文化 | 文化维度评分、福利待遇、员工活动 |

### 技术栈

- 前端: HTML5 + CSS3 + JavaScript (原生)
- 图表: Chart.js
- 后端: Node.js (原生 http 模块，零第三方依赖)
- 部署: Vercel / Railway

### 快速开始

\`\`\`bash
# 克隆项目
git clone https://github.com/${FULL_REPO}.git
cd enterprise-background-check

# 本地启动
node server/server.js
# 访问 http://localhost:3000
\`\`\`

### 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建功能分支 (\`git checkout -b feature/amazing-feature\`)
3. 提交更改 (\`git commit -m 'feat: add amazing feature'\`)
4. 推送到分支 (\`git push origin feature/amazing-feature\`)
5. 创建 Pull Request

### License

MIT License" \
    --label "good first issue" \
    --label "enhancement"

echo ""
echo -e "${GREEN}=========================================="
echo "  推送完成!"
echo "==========================================${NC}"
echo ""
echo -e "  仓库地址: ${CYAN}https://github.com/${FULL_REPO}${NC}"
echo ""
echo -e "  后续操作:"
echo -e "  ${YELLOW}1. 在 Vercel 导入此仓库即可一键部署${NC}"
echo -e "  ${YELLOW}2. 或在 Railway 导入此仓库${NC}"
echo ""
