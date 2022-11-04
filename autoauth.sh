#!/bin/bash
#自动上网认证脚本（北理珠学生效果最好）
user="这里输入用户名(Input user name here)"                                                    #用户名(例:AAA123456)
password="这里输入密码(Input password here)"                                                   #密码(例:123456)
authserver="这里输入认证服务器的地址以及端口(Input authorization server host and port here)"   #认证服务器及端口(例:123.123.123.123:8080; 123.111.111.223)
authpath="这里输入认证路径(Input authorization path here)"                                     #认证路径(例:/Auth/auth)
maxtimes=5                             #最大重试次数
LEN=209                                #预置长度
CURL_TEST="http://4.ipw.cn"            #curl网络连通预测试地址
success_words="登录成功"               #登录成功检查字段
################################################################################

password_base64=$(printf $password | base64)    
extraLEN=$(printf $password_base64 | wc -m)
LEN=$((LEN+extraLEN))

date
echo "进行curl测试:${CURL_TEST}" 
r1=$(curl --connect-timeout 5 http://4.ipw.cn | grep -P '^([0-9]{1,3}\.){3}[0-9]{1,3}$' )
if [ $? -eq 0 ]; then
    echo "网络良好" 
    echo "=========================================" 
    exit 0
fi
echo "网络无法连通" 

udhcpc -i eth0 -n -t 10
echo '进行第1次尝试' 
result=$(curl -X POST http://${authserver}${authpath} \
              -H 'Content-Type: application/json' \
              -H "Content-Length: $LEN" \
              --data-raw "{\"userName\":\"${user}\",\"userPassword\":\"${password_base64}\",\"serviceSuffixId\":\"-1\",\"dynamicPwdAuth\":false,\"code\":\"\",\"codeTime\":\"\",\"validateCode\":\"\",\"licenseCode\":\"\",\"userGroupId\":-1,\"validationType\":2,\"guestManagerId\":-1}")
last=$?
echo $result | grep -o "${success_words}" > /dev/null
matchs=$?
echo $result 

retrytimes=1
while [[ $last -ne 0 && $retrytimes -le $maxtimes && $matchs ]]; do
	retrytimes=$((retrytimes+1))
	echo "进行第${retrytimes}次尝试" 
	result=$(curl -X POST http://${authserver}${authpath} \
	              -H 'Content-Type: application/json' \
	              -H "Content-Length: $LEN" \
	              --data-raw "{\"userName\":\"${user}\",\"userPassword\":\"${password_base64}\",\"serviceSuffixId\":\"-1\",\"dynamicPwdAuth\":false,\"code\":\"\",\"codeTime\":\"\",\"validateCode\":\"\",\"licenseCode\":\"\",\"userGroupId\":-1,\"validationType\":2,\"guestManagerId\":-1}")
	last=$?
    echo $result | grep -o "${success_words}" > /dev/null
    matchs=$?
	echo $result 
done
echo "=========================================" 
exit $last
