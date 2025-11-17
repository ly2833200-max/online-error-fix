# Online Error Fix Service

一个简单的 Python HTTP 服务，用于在线错误修复功能。

[![GitHub](https://img.shields.io/badge/github-ly2833200--max-blue)](https://github.com/ly2833200-max/online-error-fix)
[![Python](https://img.shields.io/badge/python-3.10.9-blue)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.116.2-green)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/docker-ready-blue)](https://www.docker.com/)

## 功能特性

- ✅ FastAPI 框架
- ✅ Hello World API
- ✅ 健康检查接口
- ✅ Docker 容器化支持
- ✅ Jenkins CI/CD 流水线
- ✅ GitHub 集成

## 快速开始

### 本地运行

1. **安装依赖**
```bash
pip install -r requirements.txt
```

2. **启动服务**
```bash
python src/main.py
```

3. **访问服务**
- 根路径: http://localhost:8000/
- API 文档: http://localhost:8000/docs
- 健康检查: http://localhost:8000/health
- Hello API: http://localhost:8000/api/hello
- 版本信息: http://localhost:8000/api/version

### Docker 运行

1. **构建镜像**
```bash
docker build -t online-error-fix:latest .
```

2. **运行容器**
```bash
docker run -d -p 8000:8000 --name online-error-fix online-error-fix:latest
```

3. **查看日志**
```bash
docker logs -f online-error-fix
```

## API 接口

### 1. 根路径
```
GET /
```
返回: `{"message": "Hello World", "service": "Online Error Fix"}`

### 2. 健康检查
```
GET /health
```
返回: `{"status": "healthy", "service": "online-error-fix"}`

### 3. Hello API
```
GET /api/hello
```
返回: `{"message": "Hello World from Online Error Fix!", "status": "success"}`

### 4. 版本信息
```
GET /api/version
```
返回: `{"version": "1.0.0", "service": "online-error-fix"}`

## 项目结构

```
online-error-fix/
├── src/
│   ├── __init__.py       # Python 包初始化
│   └── main.py           # 主应用程序
├── Dockerfile            # Docker 镜像构建文件
├── Jenkinsfile           # Jenkins CI/CD 流水线配置（GitHub 版本）
├── JENKINS_SETUP.md      # Jenkins 详细配置指南
├── requirements.txt      # Python 依赖
├── docker-compose.yml    # Docker Compose 配置
├── quick-start.sh        # 快速启动脚本
├── test_service.sh       # 服务测试脚本
├── push-to-github.sh     # GitHub 推送脚本
├── .gitignore           # Git 忽略文件
└── README.md            # 项目说明文档
```

## GitHub 仓库

**仓库地址**: https://github.com/ly2833200-max/online-error-fix

### 推送代码到 GitHub

```bash
# 方法 1: 使用推送脚本（推荐）
./push-to-github.sh

# 方法 2: 手动推送
git push -u origin main
# 用户名: ly2833200-max
# 密码: 使用 Personal Access Token
```

## 部署流程

### Jenkins 流水线

详细配置请参考：[JENKINS_SETUP.md](JENKINS_SETUP.md)

**快速步骤：**

1. **在 Jenkins 中创建流水线任务**
2. **配置 GitHub Token 凭据**（ID 必须为 `github-token`）
3. **配置流水线参数:**
   - `Branch`: 代码分支（如 `main`, `develop`）
4. **选择 "Pipeline script from SCM"**
5. **填写 Git 仓库地址**: `https://github.com/ly2833200-max/online-error-fix.git`
6. **Credentials 选择**: `github-token`
7. **Script Path 填写**: `Jenkinsfile`
8. **保存并构建**

> 💡 **注意**: 流水线已简化，仅部署到 **Test 环境**

### 部署环境

- **Test**: 测试环境（默认且唯一）

## 健康检查

Docker 容器内置健康检查机制:
- 检查间隔: 30秒
- 超时时间: 10秒
- 启动宽限期: 40秒
- 重试次数: 3次

## 技术栈

- **Python**: 3.10.9
- **Web 框架**: FastAPI
- **ASGI 服务器**: Uvicorn
- **容器化**: Docker
- **CI/CD**: Jenkins

## 开发说明

### 添加新接口

在 `src/main.py` 中添加新的路由:

```python
@app.get("/api/new-endpoint")
async def new_endpoint():
    return {"message": "New endpoint"}
```

### 修改端口

在 `Dockerfile` 和 `src/main.py` 中修改端口号（默认 8000）。

## 维护者

- 百川智能团队

## License

MIT

