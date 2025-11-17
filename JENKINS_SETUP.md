# Jenkins 配置指南

本文档说明如何在 Jenkins 中配置 Online Error Fix 项目的 CI/CD 流水线。

## 前置条件

### 1. 在 GitHub 创建仓库

在 GitHub 上创建仓库：https://github.com/ly2833200-max/online-error-fix

（如果还未创建，请先在 GitHub 网页上创建）

### 2. 配置 GitHub Token 凭据

#### 步骤 1：在 Jenkins 中添加凭据

1. 登录 Jenkins
2. 进入 **Manage Jenkins** → **Manage Credentials**
3. 选择合适的 domain（通常是 "Global"）
4. 点击 **Add Credentials**
5. 填写以下信息：
   - **Kind**: `Username with password`
   - **Username**: `ly2833200-max`
   - **Password**: `你的 GitHub Personal Access Token（以 ghp_ 开头）`
   - **ID**: `github-token` （重要！必须与 Jenkinsfile 中的 credentialsId 一致）
   - **Description**: `GitHub Personal Access Token for ly2833200-max`
6. 点击 **Create**

#### 步骤 2：验证凭据

确保凭据 ID 为 `github-token`，这与 Jenkinsfile 中配置的一致：

```groovy
git(
  url: 'https://github.com/ly2833200-max/online-error-fix.git',
  credentialsId: 'github-token',  // <-- 这个 ID 必须匹配
  ...
)
```

## Jenkins 流水线配置

### 创建流水线任务

1. 在 Jenkins 中点击 **New Item**
2. 输入任务名称：`online-error-fix`
3. 选择 **Pipeline**
4. 点击 **OK**

### 配置参数化构建

在 **General** 部分：

1. 勾选 **This project is parameterized**
2. 添加两个参数：

#### 参数 1: Branch（字符串参数）
- **Name**: `Branch`
- **Default Value**: `main`
- **Description**: `Git 分支名称`

#### 参数 2: DeployType（选项参数）
- **Name**: `DeployType`
- **Choices**:
  ```
  dev
  test
  prod
  ```
- **Description**: `部署环境选择`

### 配置 Pipeline

在 **Pipeline** 部分：

1. **Definition**: 选择 `Pipeline script from SCM`
2. **SCM**: 选择 `Git`
3. **Repository URL**: `https://github.com/ly2833200-max/online-error-fix.git`
4. **Credentials**: 选择 `github-token`
5. **Branch Specifier**: `${Branch}`
6. **Script Path**: `Jenkinsfile`

### 构建触发器（可选）

可以配置以下触发器：

- **GitHub hook trigger for GITScm polling** - GitHub Webhook 自动触发
- **Poll SCM** - 定时轮询（例如：`H/5 * * * *` 每 5 分钟检查一次）

## 其他必需的 Jenkins 凭据

确保 Jenkins 中已配置以下凭据（这些应该已经存在于你的 Jenkins 中）：

1. **aliyun-harbor-username** - 阿里云镜像仓库用户名和密码
2. **k8s-test-kubeconfig** - Kubernetes Test 环境配置
3. **k8s-dev-kubeconfig** - Kubernetes Dev 环境配置  
4. **k8s-prod-kubeconfig** - Kubernetes Prod 环境配置

## 首次构建

1. 保存流水线配置
2. 点击 **Build with Parameters**
3. 选择参数：
   - **Branch**: `main`
   - **DeployType**: `dev` 或 `test`（建议先用 dev 测试）
4. 点击 **Build**

## 构建流程

流水线将执行以下步骤：

1. **Clone Code** - 从 GitHub 克隆代码
2. **Build & Push Image** - 构建 Docker 镜像并推送到 ACR
3. **Deploy** - 根据 DeployType 部署到对应环境
   - dev: 部署到开发环境
   - test: 部署到测试环境
   - prod: 部署到生产环境
4. **Notify Success** - 通过飞书通知部署结果

## 部署后验证

### 健康检查

```bash
# 根据部署环境访问对应的健康检查接口
curl http://<service-url>/health
```

期望返回：
```json
{
  "status": "healthy",
  "service": "online-error-fix"
}
```

### 测试接口

```bash
# Hello World 接口
curl http://<service-url>/

# Hello API
curl http://<service-url>/api/hello

# 版本信息
curl http://<service-url>/api/version
```

## 故障排查

### 问题 1: 认证失败

**错误信息**: `Authentication failed` 或 `Permission denied`

**解决方法**:
1. 检查 GitHub Token 是否正确
2. 确认 Token 有 `repo` 权限
3. 验证 Jenkins 凭据 ID 为 `github-token`

### 问题 2: 无法推送镜像

**错误信息**: `unauthorized: authentication required`

**解决方法**:
1. 检查阿里云镜像仓库凭据是否正确
2. 确认镜像仓库地址配置正确

### 问题 3: 部署失败

**错误信息**: K8s 相关错误

**解决方法**:
1. 检查 kubeconfig 凭据是否配置
2. 确认目标集群可访问
3. 查看 Jenkins 日志获取详细错误信息

## 安全建议

1. **定期更换 Token**: 建议每 90 天更换一次 GitHub Token
2. **最小权限原则**: GitHub Token 只授予必要的权限
3. **访问控制**: 限制能够访问 Jenkins 流水线的人员

## 相关链接

- **GitHub 仓库**: https://github.com/ly2833200-max/online-error-fix
- **项目文档**: README.md
- **Dockerfile**: Dockerfile
- **流水线配置**: Jenkinsfile

