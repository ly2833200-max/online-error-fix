# GitHub 仓库创建指南

在推送代码之前，需要先在 GitHub 上创建仓库。

## 方法 1: 通过 GitHub 网页创建（推荐）

### 步骤 1: 访问 GitHub 创建仓库页面

访问: https://github.com/new

### 步骤 2: 填写仓库信息

- **Repository name**: `online-error-fix`
- **Description** (可选): `Online Error Fix Service - A simple Python HTTP service with FastAPI`
- **Visibility**: 
  - **Public** - 如果希望开源
  - **Private** - 如果希望私有
- **Initialize this repository with**:
  - ❌ **不要勾选** "Add a README file"
  - ❌ **不要勾选** "Add .gitignore"
  - ❌ **不要勾选** "Choose a license"
  
  （因为我们已经有本地代码了）

### 步骤 3: 点击 "Create repository"

创建完成后，你会看到一个快速设置页面。

## 方法 2: 使用 GitHub CLI (gh)

如果你安装了 GitHub CLI，可以用命令行创建：

```bash
# 登录 GitHub CLI
gh auth login

# 创建仓库
gh repo create online-error-fix --public --source=. --remote=origin --push
```

## 推送代码到 GitHub

仓库创建完成后，推送代码：

### 使用推送脚本（推荐）

```bash
./push-to-github.sh
```

### 手动推送

```bash
git push -u origin main
```

当提示输入凭据时：
- **Username**: `ly2833200-max`
- **Password**: 使用你的 Personal Access Token（以 `ghp_` 开头）

## 验证推送成功

推送成功后，访问以下地址查看代码：

https://github.com/ly2833200-max/online-error-fix

你应该能看到所有项目文件。

## 下一步

1. ✅ 创建 GitHub 仓库
2. ✅ 推送代码到 GitHub  
3. 📝 配置 Jenkins 流水线 - 参考 [JENKINS_SETUP.md](JENKINS_SETUP.md)

## 故障排查

### 问题: "Repository not found"

**原因**: GitHub 仓库还未创建

**解决**: 按照上述步骤在 GitHub 上创建仓库

### 问题: "Authentication failed"

**原因**: Token 无效或过期

**解决**: 
1. 访问 https://github.com/settings/tokens
2. 检查 Token 是否过期
3. 如果过期，重新生成新的 Token
4. 更新 `push-to-github.sh` 中的 GITHUB_TOKEN 变量

### 问题: "Permission denied"

**原因**: Token 没有 `repo` 权限

**解决**:
1. 访问 https://github.com/settings/tokens
2. 生成新的 Token 或编辑现有 Token
3. 确保勾选了 `repo` 权限
4. 保存并使用新的 Token

### 使用环境变量推送（推荐）

```bash
export GITHUB_TOKEN="your_token_here"
./push-to-github.sh
```

## 相关链接

- **GitHub Personal Access Tokens**: https://github.com/settings/tokens
- **GitHub 文档**: https://docs.github.com/
- **项目仓库**: https://github.com/ly2833200-max/online-error-fix

