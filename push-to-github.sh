#!/bin/bash
# 推送代码到 GitHub 的脚本

echo "🚀 准备推送 Online Error Fix 到 GitHub..."
echo ""

# GitHub 配置
GITHUB_USER="ly2833200-max"
GITHUB_REPO="online-error-fix"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"  # 从环境变量读取 Token

# 如果没有设置环境变量，提示用户输入
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  环境变量 GITHUB_TOKEN 未设置"
    echo ""
    read -sp "请输入 GitHub Personal Access Token: " GITHUB_TOKEN
    echo ""
fi

echo "📋 检查 Git 状态..."
git status

echo ""
echo "🔍 当前远程仓库："
git remote -v

echo ""
echo "⚠️  注意：即将推送到 GitHub"
echo "   仓库: https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git"
echo ""
read -p "是否继续？(y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "❌ 取消推送"
    exit 0
fi

echo ""
echo "📤 推送代码到 GitHub..."

# 使用 token 推送（临时设置 credential helper）
git -c credential.helper='!f() { echo "username=${GITHUB_USER}"; echo "password=${GITHUB_TOKEN}"; }; f' \
    push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 代码推送成功！"
    echo ""
    echo "🔗 GitHub 仓库地址:"
    echo "   https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
    echo ""
    echo "📝 下一步："
    echo "   1. 访问 GitHub 仓库查看代码"
    echo "   2. 按照 JENKINS_SETUP.md 配置 Jenkins 流水线"
    echo ""
else
    echo ""
    echo "❌ 推送失败！"
    echo ""
    echo "💡 可能的原因："
    echo "   1. GitHub 仓库尚未创建"
    echo "   2. Token 权限不足或已过期"
    echo "   3. 网络连接问题"
    echo ""
    echo "🔧 解决方法："
    echo "   1. 确保在 GitHub 创建了仓库: https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
    echo "   2. 检查 Token 是否有 'repo' 权限"
    echo "   3. 手动推送: git push -u origin main"
    echo ""
    exit 1
fi

