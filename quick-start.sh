#!/bin/bash
# 快速启动脚本

echo "🚀 Online Error Fix Service - 快速启动"
echo ""
echo "请选择启动方式:"
echo "1) 本地运行 (需要安装依赖)"
echo "2) Docker 运行"
echo "3) Docker Compose 运行"
echo ""
read -p "请输入选项 (1/2/3): " choice

case $choice in
  1)
    echo ""
    echo "📦 安装依赖..."
    pip install -r requirements.txt
    echo ""
    echo "🎯 启动服务..."
    python src/main.py
    ;;
  2)
    echo ""
    echo "🐳 构建 Docker 镜像..."
    docker build -t online-error-fix:latest .
    echo ""
    echo "🎯 运行容器..."
    docker run -d -p 8000:8000 --name online-error-fix online-error-fix:latest
    echo ""
    echo "✅ 服务已启动！"
    echo "📝 查看日志: docker logs -f online-error-fix"
    echo "🛑 停止服务: docker stop online-error-fix && docker rm online-error-fix"
    ;;
  3)
    echo ""
    echo "🐳 使用 Docker Compose 启动..."
    docker-compose up -d
    echo ""
    echo "✅ 服务已启动！"
    echo "📝 查看日志: docker-compose logs -f"
    echo "🛑 停止服务: docker-compose down"
    ;;
  *)
    echo "❌ 无效选项"
    exit 1
    ;;
esac

echo ""
echo "🌐 服务访问地址:"
echo "   - 根路径: http://localhost:8000/"
echo "   - API 文档: http://localhost:8000/docs"
echo "   - 健康检查: http://localhost:8000/health"
echo "   - Hello API: http://localhost:8000/api/hello"
echo ""
echo "🧪 运行测试: ./test_service.sh"

