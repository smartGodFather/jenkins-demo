CURRENT_PATH=`pwd`                     #目录
# CURRENT_PATH="./"                    #目录
PUSH_IP="47.98.59.156"                 #服务器IP
EXCUTE_PATH="/www/wwwroot/"            #服务器上传位置路径
WEB_PATH = "/www/wwwroot/http/"
PEM_PATH="/longma.pem"                 #服务器登录秘钥
BACK_UP="/backup/www/dist/"            #备份文件夹路径
PROJECT_PATH="dist"                    #打包文件夹名称（项目名）
PROJECT_NAME="dist.tar.gz"             #打包tar名称

#输出版本（构建错误后，排查版本）
node -v
npm -v
pnpm -v

#更新库（预防有新增的库）
npm install pnpm -g
pnpm install

#打包
pnpm run build

echo $CURRENT_PATH
#进入目录
#cd $CURRENT_PATH

#删除可能存在的旧tar包
rm -rf $PROJECT_NAME

#压缩成New的tar包
tar -zcvf $PROJECT_NAME $PROJECT_PATH/

#将tar包上传到服务器
scp -i $PEM_PATH $CURRENT_PATH/$PROJECT_NAME root@$PUSH_IP:$EXCUTE_PATH

#登录服务器
ssh -i $PEM_PATH -t root@$PUSH_IP << eeooff

#进入服务器目录
cd $EXCUTE_PATH

#备份服务器存在的项目（新的文件出问题，立即回滚到原来的，及时止损）
cp -r $PROJECT_PATH $BACK_UP/`date +%Y%m%d%H%M%S`

#解压上传tar包
tar -xzvf $PROJECT_NAME

#删除tar包
rm -rf $PROJECT_NAME

#删除http目录下所有东西
rm -rf $WEB_PATH/*

# 复制dist目录下的所有内容到http目录
cp -r $PROJECT_PATH/* $WEB_PATH

# 删除dist目录
rm -rf $EXCUTE_PATH/dist

#退出
exit
eeooff