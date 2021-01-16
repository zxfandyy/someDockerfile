#!/bin/sh
set -e

#获取配置的自定义参数
if [ $1 ]; then
    run_cmd=$1
else
    run_cmd="crond"
fi

echo "设定远程仓库地址..."
git remote set-url origin $REPO_URL
echo "git pull拉取最新代码..."
git -C /scripts pull
echo "npm install 安装最新依赖"
npm install --prefix /scripts

#任务脚本shell仓库
cd /jds
git pull origin master

echo "------------------------------------------------执行定时任务任务shell脚本------------------------------------------------"
sh -x /jds/jd_scripts/task_shell_script.sh
echo "--------------------------------------------------默认定时任务执行完成---------------------------------------------------"

if [ $run_cmd == 'jd_bot' ]; then
    echo "Start crontab task main process..."
    echo "启动crondtab定时任务主进程..."
    crond
    echo "Start crontab task main process..."
    echo "启动jd_bot..."
    jd_bot
else
    echo "Start crontab task main process..."
    echo "启动crondtab定时任务主进程..."
    crond
    jd_bot
fi
