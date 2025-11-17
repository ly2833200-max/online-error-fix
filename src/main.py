"""
Online Error Fix Service - 简单的 HTTP 服务
提供健康检查和基本的问候接口
"""
from fastapi import FastAPI
from fastapi.responses import JSONResponse
import logging

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# 创建 FastAPI 应用
app = FastAPI(
    title="Online Error Fix Service",
    description="在线错误修复服务 - Hello World 示例",
    version="1.0.0"
)


@app.get("/")
async def root():
    """根路径 - 返回欢迎信息"""
    logger.info("访问根路径")
    return {"message": "Hello World", "service": "Online Error Fix"}


@app.get("/health")
async def health_check():
    """健康检查接口"""
    logger.info("健康检查")
    return JSONResponse(
        status_code=200,
        content={"status": "healthy", "service": "online-error-fix"}
    )


@app.get("/api/hello")
async def hello():
    """Hello World API"""
    return {
        "message": "Hello World from Online Error Fix!",
        "status": "success"
    }


@app.get("/api/version")
async def version():
    """获取服务版本"""
    return {
        "version": "1.0.0",
        "service": "online-error-fix"
    }


if __name__ == "__main__":
    import uvicorn
    logger.info("启动 Online Error Fix 服务: 0.0.0.0:8000")
    uvicorn.run(app, host="0.0.0.0", port=8000)

