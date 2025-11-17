# 使用公司镜像仓库的 Python 3.10.9 镜像
FROM baichuan-cr-registry-vpc.cn-beijing.cr.aliyuncs.com/commercial/python:3.10.9

# 构建参数（从 Jenkins 传入）
ARG ENV=test

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    ENV=${ENV}

# 复制依赖文件
COPY requirements.txt ./

# 安装 Python 依赖（使用阿里云镜像源加速）
RUN pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt

# 复制项目源代码
COPY src/ ./src/

# 创建日志目录
RUN mkdir -p /app/logs

# 暴露端口
EXPOSE 8000

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health').read()"

# 启动命令
CMD ["python", "-m", "uvicorn", "src.main:app", \
     "--host", "0.0.0.0", \
     "--port", "8000"]

