# 企业背调小程序

## 项目简介

企业背调小程序是一个综合性的企业背景调查平台，帮助求职者在入职前全面了解目标公司。涵盖10个核心调查维度，提供数据可视化和智能分析。

## 功能模块

| 序号 | 模块 | 说明 |
|------|------|------|
| 1 | 年报分析 | 公司基本信息、营收利润趋势、关键财务指标 |
| 2 | 劳动仲裁 | 仲裁案件统计、类型分布、典型案例 |
| 3 | 司法判决 | 涉诉案件统计、原告/被告分析、判决文书 |
| 4 | 加班及评价 | 加班指数、员工满意度、正负面评价 |
| 5 | BOSS直聘活跃度 | 在招职位、活跃度评分、招聘趋势 |
| 6 | 求职建议 | 综合评分、风险等级、入职建议 |
| 7 | 投资情况 | 融资历史、投资方、被投企业 |
| 8 | 社保缴纳 | 缴纳人数趋势、五险比例、行业对比 |
| 9 | 股票投资 | 股价走势、市值变化、财务指标 |
| 10 | 企业文化 | 文化维度评分、福利待遇、员工活动 |

## 技术栈

- **前端**: HTML5 + CSS3 + JavaScript (原生)
- **图表**: Chart.js
- **后端**: Node.js (原生 http 模块，零第三方依赖)
- **部署**: Vercel / Railway / 本地开发

## 项目结构

```
background-check/
├── index.html          # 主页面
├── css/
│   └── style.css       # 样式文件
├── js/
│   ├── app.js          # 主逻辑（路由、图表渲染、交互）
│   └── data.js         # 模拟数据生成
├── api/
│   └── index.js        # Vercel Serverless Function 入口
├── server/
│   ├── package.json    # 后端配置
│   └── server.js       # API服务（12个接口 + 静态文件托管）
├── package.json        # 根项目配置
├── vercel.json         # Vercel 部署配置
├── railway.json        # Railway 部署配置
├── nixpacks.toml       # Railway 构建配置
├── .gitignore
├── .env.example
├── start.sh            # 本地一键启动脚本
└── README.md           # 项目说明
```

---

## 部署指南

### 方式一：Vercel 部署（推荐，免费）

**前提条件：**
- 注册 [Vercel 账号](https://vercel.com)（支持 GitHub 登录）
- 将代码推送到 GitHub 仓库

**步骤：**

1. **创建 GitHub 仓库并推送代码**
   ```bash
   cd background-check
   git init
   git add .
   git commit -m "init: 企业背调系统"
   git remote add origin https://github.com/你的用户名/你的仓库名.git
   git push -u origin main
   ```

2. **在 Vercel 导入项目**
   - 登录 [Vercel Dashboard](https://vercel.com/dashboard)
   - 点击 "Add New" > "Project"
   - 选择你的 GitHub 仓库
   - 点击 "Import"
   - Framework Preset 选择 **Other**
   - 点击 "Deploy"

3. **等待部署完成**
   - 部署约需 1-2 分钟
   - 完成后 Vercel 会分配一个域名，如 `https://your-project.vercel.app`

4. **自定义域名（可选）**
   - 在 Vercel 项目 Settings > Domains 中添加自定义域名

**Vercel 部署原理：**
- `vercel.json` 配置了路由规则
- `/api/*` 请求由 `api/index.js` Serverless Function 处理
- 其他请求直接返回静态文件（HTML/CSS/JS）

---

### 方式二：Railway 部署（免费额度 $5/月）

**前提条件：**
- 注册 [Railway 账号](https://railway.app)（支持 GitHub 登录）

**步骤：**

1. **创建 GitHub 仓库并推送代码**（同上）

2. **在 Railway 导入项目**
   - 登录 [Railway Dashboard](https://railway.app/dashboard)
   - 点击 "New Project" > "Deploy from GitHub repo"
   - 选择你的 GitHub 仓库
   - Railway 会自动检测 `nixpacks.toml` 配置

3. **配置环境变量**
   - 在 Railway 项目 Settings > Variables 中设置：
     - `PORT` = `3000`（Railway 默认会设置，通常不需要手动配置）
     - `NODE_ENV` = `production`

4. **生成公开访问地址**
   - 在 Railway 项目 Settings > Networking 中
   - 点击 "Generate Domain" 获取公开 URL
   - 或绑定自定义域名

**Railway 部署原理：**
- `nixpacks.toml` 定义了构建和启动命令
- `server/server.js` 同时处理 API 请求和静态文件托管
- 单个服务同时提供前端页面和后端 API

---

### 方式三：本地开发

**一键启动：**
```bash
cd background-check
./start.sh
```

**分别启动：**
```bash
# 后端（同时托管静态文件和API，端口 3000）
cd background-check
node server/server.js

# 或者分开启动
cd background-check/server && node server.js  # API (端口3000)
cd background-check && python3 -m http.server 8080  # 前端 (端口8080)
```

**访问地址：**
- 一体化服务: http://localhost:3000
- 分离模式前端: http://localhost:8080
- 分离模式API: http://localhost:3000/api

---

## API 接口

| 接口 | 方法 | 说明 |
|------|------|------|
| `/api/search?q=xxx` | GET | 搜索公司 |
| `/api/company?name=xxx` | GET | 公司基本信息 |
| `/api/annual-report?name=xxx` | GET | 年报数据 |
| `/api/labor-arbitration?name=xxx` | GET | 劳动仲裁数据 |
| `/api/judicial?name=xxx` | GET | 司法判决数据 |
| `/api/overtime-review?name=xxx` | GET | 加班及员工评价 |
| `/api/boss-activity?name=xxx` | GET | BOSS直聘活跃度 |
| `/api/job-advice?name=xxx` | GET | 求职建议 |
| `/api/investment?name=xxx` | GET | 投资情况 |
| `/api/social-security?name=xxx` | GET | 社保缴纳 |
| `/api/stock?name=xxx` | GET | 股票投资 |
| `/api/culture?name=xxx` | GET | 企业文化 |

## 内置公司数据

- 字节跳动、腾讯、阿里巴巴、华为、小米（5家完整数据）
- 支持20家公司的模拟数据生成

## 配置说明

在 `js/app.js` 中可以切换数据源：

```javascript
const USE_API = true;  // true: 使用后端API  false: 使用本地模拟数据
```

API 地址会自动适配：
- 本地开发（localhost）: 使用 `http://localhost:3000`
- 线上部署: 使用相对路径（前后端同域）

## 设计特点

- 深色主题（#0a0e1a），科技蓝 + 金色强调
- 左侧导航 + 右侧内容区布局
- 搜索联想、渐入动画、卡片悬停效果
- 响应式设计，支持移动端
