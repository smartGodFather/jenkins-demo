CURRENT_PATH=`pwd`                            #目录
PUSH_IP="192.168.1.1"                         #服务器IP
EXCUTE_PATH="/server/www/"                    #服务器上传位置路径
BACK_UP="/backup/www/textProject/"            #备份文件夹路径
PROJECT_PATH="textProject"                    #打包文件夹名称（项目名）
PROJECT_NAME="textProject.tar.gz"             #打包tar名称

#输出版本（构建错误后，排查版本）
node -v
npm -v

#更新库（预防有新增的库）
npm install

#打包demo环境（我这是demo环境，所以直接-demo环境了）
npm run build -demo

#进入目录
cd $CURRENT_PATH

#删除可能存在的旧tar包
rm -rf $PROJECT_NAME

#压缩成New的tar包
tar -zcvf $PROJECT_NAME $PROJECT_PATH/

#将tar包上传到服务器
scp -r $CURRENT_PATH/$PROJECT_NAME root@$PUSH_IP:$EXCUTE_PATH

#登录服务器
ssh root@$PUSH_IP << eeooff

#进入服务器目录
cd $EXCUTE_PATH

#备份服务器存在的项目（新的文件出问题，立即回滚到原来的，及时止损）
cp -r $PROJECT_PATH $BACK_UP/`date +%Y%m%d%H%M%S`

#解压上传tar包
tar -xzvf $PROJECT_NAME

#删除tar包
rm -rf $PROJECT_NAME

#退出
exit
eeooff