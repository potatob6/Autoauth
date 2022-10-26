# Autoauth H3C 校园网自动登录脚本

**必要依赖**
- ```apt install curl udhcpc cron -y```
---

**使用方法**
- 手动认证
> 1. 编辑autoauth.sh内3~6行的个人认证信息
> 2. ```chmod +x ./autoauth.sh```
> 3. ```./autoauth.sh```

- 自动认证
> 1. 编辑autoauth.sh内前3~6行的信息
> 2. ```chmod +x ./autoauth.sh```
> 3. ```cp ./autoauth.sh /usr/bin/autoauth.sh```
> 4. ```crontab -e```新增一行```30-55/5 7 * * * bash /usr/bin/autoauth.sh```意为每天早上7点30-7点55每5分钟进行一次检测或认证
