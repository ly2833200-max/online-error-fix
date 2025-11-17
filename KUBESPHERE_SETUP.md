# KubeSphere 流水线配置指南

本文档说明如何在 KubeSphere 中导入 Jenkinsfile 并配置 CI/CD 流水线。

## 前置条件

- ✅ GitHub 仓库已创建并推送代码: https://github.com/ly2833200-max/online-error-fix
- ✅ Jenkinsfile 已准备好（位于仓库根目录）
- ✅ 有 KubeSphere 访问权限

## 🚀 在 KubeSphere 中创建流水线

### 第 1 步: 登录 KubeSphere

访问 KubeSphere 控制台并登录。

### 第 2 步: 进入 DevOps 项目

1. 在左侧菜单中，点击 **DevOps 项目**
2. 选择你的 DevOps 项目（如果没有，需要先创建一个）

### 第 3 步: 创建流水线

1. 点击 **流水线** → **创建**
2. 选择 **使用 Jenkinsfile 创建流水线**
3. 填写基本信息：

#### 基本信息
- **名称**: `online-error-fix`
- **描述**: `Online Error Fix Service - 自动化部署流水线`
- **代码仓库**: 选择 **GitHub**

### 第 4 步: 配置 GitHub 仓库

#### 4.1 添加 GitHub 凭据（首次使用需要）

如果还没有配置 GitHub 凭据：

1. 点击 **创建凭据**
2. 选择凭据类型：
   - **凭据 ID**: `github-token`
   - **类型**: `用户名和密码`
   - **用户名**: `ly2833200-max`
   - **密码/令牌**: 你的 GitHub Personal Access Token
   - **描述**: `GitHub Token for ly2833200-max`
3. 点击 **确定**

#### 4.2 配置仓库信息

- **代码仓库**: `https://github.com/ly2833200-max/online-error-fix.git`
- **凭据**: 选择 `github-token`
- **分支**: `main`（或使用变量 `${Branch}`）

### 第 5 步: 配置 Jenkinsfile 路径

- **Jenkinsfile 路径**: `Jenkinsfile`（默认即可，因为文件在根目录）

### 第 6 步: 配置流水线参数

添加构建参数：

#### Branch 参数
- **参数名**: `Branch`
- **参数类型**: `字符串`
- **默认值**: `main`
- **描述**: `Git 分支名称`

### 第 7 步: 高级设置（可选）

#### 构建触发器

可以配置自动触发：

- **定时构建**: 例如 `H 2 * * *`（每天凌晨 2 点）
- **GitHub Webhook**: 代码推送时自动触发（需要配置 GitHub Webhook）

#### 并发构建

- **丢弃旧的构建**: 勾选
- **保留构建的天数**: `7`
- **保留构建的最大个数**: `10`

### 第 8 步: 保存并运行

1. 点击 **创建**
2. 流水线创建成功后，点击 **运行**
3. 选择分支参数：`main`
4. 点击 **确定**

## 📋 必需的凭据配置

确保在 KubeSphere 的凭据管理中已配置以下凭据：

### 1. GitHub Token
- **ID**: `github-token`
- **类型**: 用户名和密码
- **用途**: 从 GitHub 克隆代码

### 2. 阿里云镜像仓库
- **ID**: `aliyun-harbor-username`
- **类型**: 用户名和密码
- **用途**: 推送 Docker 镜像到 ACR

### 3. Kubernetes 配置
- **ID**: `k8s-test-kubeconfig`
- **类型**: kubeconfig
- **用途**: 部署到 Test 环境

### 4. GitLab SSH 密钥
- **ID**: `gitlab-private-sshkey`
- **类型**: SSH 密钥
- **用途**: 访问 CICD 脚本仓库

## 🔧 配置凭据的步骤

### 在 KubeSphere 中添加凭据

1. 进入 **DevOps 项目**
2. 点击 **凭据** → **创建**
3. 选择对应的凭据类型
4. 填写凭据信息
5. **凭据 ID** 必须与 Jenkinsfile 中的一致
6. 点击 **确定**

## 🎯 流水线运行流程

创建并运行流水线后，将执行以下步骤：

### 阶段 1: Clone Code
- 从 GitHub 克隆代码
- 获取 Git commit 信息

### 阶段 2: Build & Push Image
- 构建 Docker 镜像
- 推送到阿里云镜像仓库
- 镜像标签格式: `v{BUILD_NUMBER}-{DATE}-{COMMIT_ID}`

### 阶段 3: Deploy to Test
- 克隆 CICD 脚本仓库
- 执行部署脚本
- 部署到 Test Kubernetes 集群

### 阶段 4: Notify Success
- 发送飞书通知
- 显示部署信息和镜像地址

## 📊 查看流水线状态

### 实时查看

1. 在流水线列表中，点击流水线名称
2. 点击具体的运行记录
3. 查看各阶段的执行状态和日志

### 日志查看

- 点击任意阶段可以查看详细日志
- 支持实时滚动查看日志输出

## 🔄 GitHub Webhook 配置（自动触发）

如果想在代码推送时自动触发流水线：

### 在 GitHub 上配置 Webhook

1. 访问仓库: https://github.com/ly2833200-max/online-error-fix
2. Settings → Webhooks → Add webhook
3. 填写信息：
   - **Payload URL**: `https://your-kubesphere-domain/webhook/github`
   - **Content type**: `application/json`
   - **Secret**: （从 KubeSphere 获取）
   - **Events**: 选择 `Just the push event`
4. 点击 **Add webhook**

### 在 KubeSphere 中获取 Webhook URL

1. 打开流水线
2. 点击 **编辑**
3. 在 **构建触发器** 中可以看到 Webhook URL

## 🛠️ 故障排查

### 问题 1: 凭据未找到

**错误**: `Credentials not found: github-token`

**解决**:
1. 检查凭据 ID 是否正确（必须是 `github-token`）
2. 确认凭据在正确的 DevOps 项目中
3. 验证凭据没有过期

### 问题 2: Docker 构建失败

**错误**: `Error building image`

**解决**:
1. 检查 Dockerfile 语法
2. 确认基础镜像可访问
3. 查看构建日志定位具体错误

### 问题 3: 部署失败

**错误**: `kubectl command failed`

**解决**:
1. 检查 kubeconfig 凭据是否正确
2. 确认 Kubernetes 集群可访问
3. 验证命名空间和资源配置

### 问题 4: 无法克隆代码

**错误**: `Authentication failed`

**解决**:
1. 验证 GitHub Token 是否有效
2. 确认 Token 有 `repo` 权限
3. 检查仓库地址是否正确

## 📖 相关文档

- **GitHub 仓库**: https://github.com/ly2833200-max/online-error-fix
- **Jenkinsfile**: 查看仓库根目录的 `Jenkinsfile`
- **Jenkins 配置**: [JENKINS_SETUP.md](JENKINS_SETUP.md)
- **快速开始**: [QUICKSTART_GUIDE.md](QUICKSTART_GUIDE.md)

## 💡 最佳实践

### 1. 使用参数化构建
- 支持不同分支的部署
- 便于回滚和测试

### 2. 配置构建保留策略
- 避免占用过多存储空间
- 保留重要的构建记录

### 3. 启用通知
- 及时了解构建状态
- 快速响应构建失败

### 4. 定期更新凭据
- GitHub Token 建议 90 天更新一次
- 使用强密码和安全的密钥

## 🎉 完成

配置完成后，你的流水线将：

- ✅ 自动从 GitHub 拉取代码
- ✅ 构建 Docker 镜像并推送到 ACR
- ✅ 自动部署到 Test 环境
- ✅ 发送飞书通知部署结果

现在你可以：
1. 提交代码到 GitHub
2. 手动运行流水线或等待自动触发
3. 在 KubeSphere 中查看部署状态

**Happy Deploying! 🚀**

