#!/bin/bash
# 测试服务是否正常运行

echo "🧪 测试 Online Error Fix 服务..."
echo ""

BASE_URL="http://localhost:8000"

# 测试根路径
echo "1️⃣ 测试根路径 GET /"
curl -s "$BASE_URL/" | jq '.'
echo ""

# 测试健康检查
echo "2️⃣ 测试健康检查 GET /health"
curl -s "$BASE_URL/health" | jq '.'
echo ""

# 测试 Hello API
echo "3️⃣ 测试 Hello API GET /api/hello"
curl -s "$BASE_URL/api/hello" | jq '.'
echo ""

# 测试版本信息
echo "4️⃣ 测试版本信息 GET /api/version"
curl -s "$BASE_URL/api/version" | jq '.'
echo ""

echo "✅ 所有测试完成！"

