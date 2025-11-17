# 🚀 快速开始指南

本指南将帮助你在 5 分钟内完成项目的 GitHub 托管和 Jenkins 部署配置。

## 📋 概览

- **项目**: Online Error Fix Service
- **GitHub 用户**: ly2833200-max
- **GitHub 仓库**: https://github.com/ly2833200-max/online-error-fix
- **技术栈**: Python 3.10.9 + FastAPI + Docker + KubeSphere/Jenkins
- **部署方式**: KubeSphere 流水线（推荐）或传统 Jenkins

## ✅ 完成情况

### 已完成

- ✅ 项目代码已创建
- ✅ Git 仓库已初始化
- ✅ GitHub 远程仓库已配置
- ✅ 所有代码已提交到本地 Git
- ✅ Jenkinsfile 已优化为从 GitHub 拉取代码
- ✅ Docker 和 Docker Compose 配置已就绪
- ✅ 完整的文档已生成

### 待完成

- ⏳ 在 GitHub 上创建仓库
- ⏳ 推送代码到 GitHub
- ⏳ 配置 KubeSphere/Jenkins 流水线

## 🎯 三步走战略

### 第 1 步: 创建 GitHub 仓库 (2 分钟)

#### 方法 A: 网页创建（推荐）

1. 访问: https://github.com/new
2. 填写信息:
   - **Repository name**: `online-error-fix`
   - **Description**: `Online Error Fix Service - Python FastAPI`
   - **Visibility**: 选择 Public 或 Private
   - ⚠️ **重要**: 不要勾选任何初始化选项（README、.gitignore、license）
3. 点击 **"Create repository"**

#### 方法 B: 使用 GitHub CLI

```bash
gh auth login
gh repo create online-error-fix --public --source=. --remote=origin --push
```

**详细说明**: [GITHUB_SETUP.md](GITHUB_SETUP.md)

---

### 第 2 步: 推送代码到 GitHub (1 分钟)

```bash
cd /Users/yanglei/baichuan/kuaiwenkuaida/online-error-fix

# 使用自动推送脚本
./push-to-github.sh
```

推送完成后，访问验证: https://github.com/ly2833200-max/online-error-fix

---

### 第 3 步: 配置 KubeSphere 流水线 (5 分钟) 【推荐】

#### 3.1 登录 KubeSphere 并创建流水线

1. 登录 KubeSphere 控制台
2. 进入 **DevOps 项目** → **流水线** → **创建**
3. 选择 **使用 Jenkinsfile 创建流水线**

#### 3.2 配置基本信息

- **名称**: `online-error-fix`
- **描述**: `Online Error Fix Service`
- **代码仓库**: `GitHub`

#### 3.3 配置 GitHub 凭据和仓库

1. 添加 GitHub 凭据（如果还没有）：
   - 凭据 ID: `github-token`
   - 类型: 用户名和密码
   - 用户名: `ly2833200-max`
   - 密码: 你的 GitHub Token
2. 配置仓库：
   - URL: `https://github.com/ly2833200-max/online-error-fix.git`
   - 凭据: `github-token`
   - 分支: `main`

#### 3.4 配置 Jenkinsfile

- **Jenkinsfile 路径**: `Jenkinsfile`（默认）

#### 3.5 添加构建参数

- 参数名: `Branch`
- 参数类型: 字符串
- 默认值: `main`

#### 3.6 保存并运行

1. 点击 **创建**
2. 点击 **运行** → 选择分支 `main`
3. 自动部署到 **Test 环境**

**详细文档**: [KUBESPHERE_SETUP.md](KUBESPHERE_SETUP.md)

---

### 备选方案: 传统 Jenkins 流水线

#### 3.1 在 Jenkins 中添加 GitHub Token 凭据

1. Jenkins → **Manage Jenkins** → **Manage Credentials**
2. 选择合适的 domain（通常是 "Global"）
3. 点击 **Add Credentials**
4. 填写:
   - **Kind**: `Username with password`
   - **Username**: `ly2833200-max`
   - **Password**: `你的 GitHub Personal Access Token（以 ghp_ 开头）`
   - **ID**: `github-token` ⚠️ **必须是这个 ID**
   - **Description**: `GitHub Personal Access Token`
5. 点击 **Create**

#### 3.2 创建 Jenkins 流水线任务

1. Jenkins → **New Item**
2. 输入名称: `online-error-fix`
3. 选择: **Pipeline**
4. 点击 **OK**

#### 3.3 配置参数化构建

在 **General** 部分，勾选 **"This project is parameterized"**，添加：

**Branch 参数**
- Name: `Branch`
- Default: `main`

> 💡 流水线已简化，固定部署到 Test 环境

#### 3.4 配置 Pipeline

在 **Pipeline** 部分：

- **Definition**: `Pipeline script from SCM`
- **SCM**: `Git`
- **Repository URL**: `https://github.com/ly2833200-max/online-error-fix.git`
- **Credentials**: 选择 `github-token`
- **Branch Specifier**: `${Branch}`
- **Script Path**: `Jenkinsfile`

#### 3.5 保存并构建

1. 点击 **Save**
2. 点击 **Build with Parameters**
3. 选择:
   - Branch: `main`
4. 点击 **Build**

自动部署到 **Test 环境**

**详细说明**: [JENKINS_SETUP.md](JENKINS_SETUP.md)

---

## 🧪 本地测试

在推送到 GitHub 之前，可以先本地测试：

### 测试 1: 本地运行

```bash
cd /Users/yanglei/baichuan/kuaiwenkuaida/online-error-fix
python src/main.py
```

访问: http://localhost:8000/docs

### 测试 2: Docker 运行

```bash
docker build -t online-error-fix:test .
docker run -d -p 8000:8000 --name test-oef online-error-fix:test
./test_service.sh
docker stop test-oef && docker rm test-oef
```

### 测试 3: Docker Compose 运行

```bash
docker-compose up -d
./test_service.sh
docker-compose down
```

---

## 📚 文档索引

| 文档 | 用途 |
|------|------|
| [README.md](README.md) | 项目总体说明 |
| [GITHUB_SETUP.md](GITHUB_SETUP.md) | GitHub 仓库创建详细步骤 |
| [KUBESPHERE_SETUP.md](KUBESPHERE_SETUP.md) | **KubeSphere 流水线配置（推荐）** |
| [JENKINS_SETUP.md](JENKINS_SETUP.md) | 传统 Jenkins 流水线配置 |
| [QUICKSTART_GUIDE.md](QUICKSTART_GUIDE.md) | 本文档 - 快速开始 |

---

## 🛠️ 脚本工具

| 脚本 | 用途 |
|------|------|
| `push-to-github.sh` | 推送代码到 GitHub |
| `quick-start.sh` | 快速启动服务（本地/Docker） |
| `test_service.sh` | 测试服务接口 |

---

## 📞 获取帮助

### 常见问题

**Q: 推送失败 "Repository not found"**
A: GitHub 仓库还未创建，请先完成第 1 步

**Q: Jenkins 构建失败 "Credentials not found"**
A: GitHub Token 凭据未配置或 ID 不是 `github-token`

**Q: Docker 镜像推送失败**
A: 检查阿里云镜像仓库凭据 `aliyun-harbor-username` 是否配置

### 查看日志

```bash
# Jenkins 构建日志
在 Jenkins 页面查看 Console Output

# Docker 容器日志
docker logs -f online-error-fix

# Docker Compose 日志
docker-compose logs -f
```

---

## 🎉 完成！

完成上述三步后，你的项目将：

- ✅ 托管在 GitHub 上
- ✅ 通过 Jenkins 自动构建和部署
- ✅ 支持 dev/test/prod 三环境部署
- ✅ 自动飞书通知部署结果

**下一步**: 开发新功能，提交代码，让 Jenkins 自动部署！🚀

