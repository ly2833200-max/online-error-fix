pipeline {
  agent {
    node {
      label 'devops-base'
    }
  }
  
  stages {
    stage('Clone Code') {
      agent none
      steps {
        container('devops-base') {
          dir('service-code') {
            git(
              url: 'https://github.com/ly2833200-max/online-error-fix.git',
              credentialsId: 'github-token',
              branch: '$Branch',
              changelog: true,
              poll: false
            )
            sh '''location=`pwd`
git config --global --add safe.directory $location'''
            script {
              env.GIT_COMMIT_ID = sh(script: 'git log -1 --pretty=%H| cut -c 1-8', returnStdout: true).trim()
              env.GIT_COMMIT_MSG = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
              env.CURE_DATE = sh(script: 'echo $(date +%Y%m%d)', returnStdout: true).trim()
            }
          }
        }
      }
    }

    stage('Build & Push Image') {
      agent none
      steps {
        container('devops-base') {
          dir('service-code') {
            withCredentials([
              usernamePassword(
                credentialsId: 'aliyun-harbor-username',
                usernameVariable: 'DOCKER_USERNAME',
                passwordVariable: 'DOCKER_PASSWORD'
              )
            ]) {
              sh 'echo "$DOCKER_PASSWORD" | docker login $CrRegistry -u "$DOCKER_USERNAME" --password-stdin'
              script {
                try {
                  sh '''
echo "🔨 开始构建 Online Error Fix 镜像 [环境: ${DeployType}]..."
DockerfileName="Dockerfile"

docker build \
  --build-arg ENV=${DeployType} \
  -f $DockerfileName \
  -t $CrRegistry/$Workspace/$AppId:v${BUILD_NUMBER}-${CURE_DATE}-${GIT_COMMIT_ID} .

echo "✅ 镜像构建成功 [ENV=${DeployType}]"
'''
                } catch (Exception e) {
                  sh '''
messageBody='❌ Online Error Fix 镜像构建失败\\n服务：'"$AppId"'\\n分支：'"$Branch"'\\n请查看流水线日志'
BuildTriggerBy=$(curl -k -u admin:P@88w0rd --silent ${BUILD_URL}api/xml | tr '<' '\n' | egrep '^userId>|^userName>' | sed 's/.*>//g' | sed -e '1s#$# /#g' | tr '\n' ' '| tr -s '/' | cut -d'/' -f2 | sed -e 's/^ *//' -e 's/ *$//')
body='{"receiver":"'"$BuildTriggerBy"@baichuan-inc.com'", "content":"'"$messageBody"'", "channel":"feishu-person", "msgType":"text"}'
curl -s -i -X POST -H "'Content-type':'application/json'" -d "$body" http://tellus-api.ca7828cd0abcc4e3d8c14943846bcdd12.cn-beijing.alicontainer.com/message > /dev/null
exit 1
'''
                }
              }
              sh '''
echo "📤 推送镜像到 ACR..."
docker push $CrRegistry/$Workspace/$AppId:v${BUILD_NUMBER}-${CURE_DATE}-${GIT_COMMIT_ID}
echo "✅ 镜像推送成功: $CrRegistry/$Workspace/$AppId:v${BUILD_NUMBER}-${CURE_DATE}-${GIT_COMMIT_ID}"
'''
            }
          }
        }
      }
    }

    stage('Deploy') {
      parallel {
        stage('Deploy to Test') {
          agent none
          when {
            environment name: 'DeployType', value: 'test'
          }
          steps {
            container('devops-base') {
              dir('cicd-code') {
                git(
                  url: 'ssh://git@code.baichuan-inc.com:2224/wujincheng/jenkins-cicd-filxe.git',
                  credentialsId: 'gitlab-private-sshkey',
                  branch: 'main',
                  changelog: true,
                  poll: false
                )
                withCredentials([kubeconfigContent(
                  credentialsId: 'k8s-test-kubeconfig',
                  variable: 'KubeconfigContent'
                )]) {
                  sh '''
echo "🚀 部署 Online Error Fix 到 Test 环境..."
export ClusterName="ack-beijing-test"
export searchPath=""
export AppPort="8000"
sh ./kubesphere-cd.sh
echo "✅ 部署到 Test 环境成功"
'''
                }
              }
            }
          }
        }

        stage('Deploy to Dev') {
          agent none
          when {
            environment name: 'DeployType', value: 'dev'
          }
          steps {
            container('devops-base') {
              dir('cicd-code') {
                git(
                  url: 'ssh://git@code.baichuan-inc.com:2224/wujincheng/jenkins-cicd-filxe.git',
                  credentialsId: 'gitlab-private-sshkey',
                  branch: 'main',
                  changelog: true,
                  poll: false
                )
                withCredentials([kubeconfigContent(
                  credentialsId: 'k8s-dev-kubeconfig',
                  variable: 'KubeconfigContent'
                )]) {
                  sh '''
echo "🚀 部署 Online Error Fix 到 Dev 环境..."
export ClusterName="ack-beijing-test"
export searchPath=""
export AppPort="8000"
sh ./kubesphere-cd.sh
echo "✅ 部署到 Dev 环境成功"
'''
                }
              }
            }
          }
        }
      }
    }

    stage('Deploy to Prod') {
      agent none
      when {
        environment name: 'DeployType', value: 'prod'
      }
      steps {
        container('devops-base') {
          dir('cicd-code') {
            git(
              url: 'ssh://git@code.baichuan-inc.com:2224/wujincheng/jenkins-cicd-filxe.git',
              credentialsId: 'gitlab-private-sshkey',
              branch: 'main',
              changelog: true,
              poll: false
            )
            withCredentials([kubeconfigContent(
              credentialsId: 'k8s-prod-kubeconfig',
              variable: 'KubeconfigContent'
            )]) {
              sh '''
echo "🚀 部署 Online Error Fix 到 Prod 环境..."
export LogTTL="90"
export ClusterName="ack-beijing-prod"
export AppPort="8000"
sh ./kubesphere-cd.sh
echo "✅ 部署到 Prod 环境成功"
'''
            }
          }
        }
      }
    }

    stage('Notify Success') {
      agent none
      steps {
        container('devops-base') {
          script {
            sh '''
messageBody='✅ Online Error Fix 部署成功\\n\\n📋 部署信息:\\n- 环境: '"$DeployType"'\\n- 分支: '"$Branch"'\\n- 版本: v${BUILD_NUMBER}-${CURE_DATE}-${GIT_COMMIT_ID}\\n- Commit: '"${GIT_COMMIT_MSG}"'\\n\\n📦 镜像: '"${CrRegistry}/${Workspace}/${AppId}:v${BUILD_NUMBER}-${CURE_DATE}-${GIT_COMMIT_ID}"'\\n\\n🏥 健康检查: /health'

BuildTriggerBy=$(curl -k -u admin:P@88w0rd --silent ${BUILD_URL}api/xml | tr '<' '\n' | egrep '^userId>|^userName>' | sed 's/.*>//g' | sed -e '1s#$# /#g' | tr '\n' ' '| tr -s '/' | cut -d'/' -f2 | sed -e 's/^ *//' -e 's/ *$//')

body='{"receiver":"'"$BuildTriggerBy"@baichuan-inc.com'", "content":"'"$messageBody"'", "channel":"feishu-person", "msgType":"text"}'
curl -s -i -X POST -H "'Content-type':'application/json'" -d "$body" http://tellus-api.ca7828cd0abcc4e3d8c14943846bcdd12.cn-beijing.alicontainer.com/message > /dev/null
'''
            
            echo '✅ ========================================='
            echo '🎉 Online Error Fix 部署成功！'
            echo '========================================='
            echo "📦 镜像信息："
            echo "   版本: v${env.BUILD_NUMBER}-${env.CURE_DATE}-${env.GIT_COMMIT_ID}"
            echo "   镜像: ${env.CrRegistry}/${env.Workspace}/${env.AppId}:v${env.BUILD_NUMBER}-${env.CURE_DATE}-${env.GIT_COMMIT_ID}"
            echo ''
            echo "📝 Git信息："
            echo "   分支: ${env.Branch}"
            echo "   Commit: ${env.GIT_COMMIT_ID}"
            echo "   消息: ${env.GIT_COMMIT_MSG}"
            echo '========================================='
          }
        }
      }
    }
  }
  
  environment {
    Workspace = 'commercial'
    CrRegistry = 'baichuan-cr-registry-vpc.cn-beijing.cr.aliyuncs.com'
    AppId = 'online-error-fix'
    LogTTL = '7'
  }
}

