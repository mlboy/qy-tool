#!/bin/bash
function echo2(){
    if  [ ! -n "$2" ] ;then
        ecolor="30;0"
    else
        ecolor=$2
    fi
    case `uname` in
        Darwin)
            echo -e "\033[${ecolor}m$1\033[0m";;
        Linux)
   	    echo -e "\033[$ecolorm$1\033[0m";;
    	MINGW64_NT-6.1)
	    #echo "$1";;
		echo -e "\033[$ecolorm$1\033[0m";;
    esac
}
if  [ ! -n "$1" ] ;then
    echo2 "使用方法:";
    echo2 "        sh ./qy-tool.sh 源目录";
    echo2 "        源目录 要查找替换的代码目录";
    echo2 "注意: 操作过程中 可能要对 源代码 目录中的文件进行替换操作，建议提前备份源代码，或者切换到新的分支 并且保证以可以读写权限的用户运行本脚本";
    exit 0
fi
ROOT_CODE=$1
if [ ! -d "$ROOT_CODE" ]; then
   echo2 "目录不存在"
   exit 1
fi
DomainList="10.30.10.227    shop-monitor.haproxy.internal.chuchujie.com
10.30.10.241    s5000.mysql.internal.chuchujie.com
10.30.11.111    swoole-crontab.haproxy.internal.chuchujie.com
10.30.11.175    m5000.mysql.internal.chuchujie.com
10.30.11.198    shop-swoole.haproxy.internal.chuchujie.com
10.30.11.199    shop-swoole.haproxy.internal.chuchujie.com
10.30.8.205    shop-swoole.haproxy.internal.chuchujie.com
10.30.11.7    s15388.redis.internal.chuchujie.com
10.30.8.214    m15388.redis.internal.chuchujie.com
10.30.27.28    shopjava-snswenda.haproxy.internal.chuchujie.com
10.30.28.160    shop-service-monitor.haproxy.internal.chuchujie.com
10.30.28.165    houyi-autooperate.haproxy.internal.chuchujie.com
10.30.28.22    dwxk-monitor.haproxy.internal.chuchujie.com
10.30.37.205    dwxk-swoole.haproxy.internal.chuchujie.com
10.30.37.225    dwxk-swoole.haproxy.internal.chuchujie.com
10.30.37.58    dwxk-swoole.haproxy.internal.chuchujie.com
10.30.37.79    ants.chuchutong.com
10.30.38.5    shop-seller-swoole.haproxy.internal.chuchujie.com
10.30.38.6    shop-seller-swoole.haproxy.internal.chuchujie.com
10.30.8.11    shop-auth.haproxy.internal.chuchujie.com
10.30.8.253    shop-monitor-mongo.haproxy.internal.chuchujie.com
10.30.8.86    shop-stworker.haproxy.internal.chuchujie.com
10.30.8.87    shop-stworker.haproxy.internal.chuchujie.com
10.30.9.163    s5000.mysql.internal.chuchujie.com
10.30.9.20    dwxk-monitor-mongo.haproxy.internal.chuchujie.com
xb.chuchujie.com    ads-xb.haproxy.internal.chuchujie.com
choose.chuchujie.com    ads-choose.haproxy.internal.chuchujie.com
inactive.chuchujie.com    shop-inactive.haproxy.internal.chuchujie.com
shangcheng-s0.cvdcrhews6fj.rds.cn-north-1.amazonaws.com.cn    s4000c.mysql.internal.chuchujie.com
shangcheng-statistic.cvdcrhews6fj.rds.cn-north-1.amazonaws.com.cn    m6000.mysql.internal.chuchujie.com
balance.api.daweixinke.com    dwxk-balance-api.haproxy.internal.chuchujie.com
image-go.chuchujie.com    dwxk-go-image.haproxy.internal.chuchujie.com
internal-advert-ad-599286067.cn-north-1.elb.amazonaws.com.cn    advert-ad.haproxy.internal.chuchujie.com
internal-dub-web-1967393240.cn-north-1.elb.amazonaws.com.cn    java-dub-web.haproxy.internal.chuchujie.com
internal-DwxkOrderActivity-1563466252.cn-north-1.elb.amazonaws.com.cn    dwxk-java-orderactivity.haproxy.internal.chuchujie.com
internal-DwxkOrderRead-9280369.cn-north-1.elb.amazonaws.com.cn    dwxk-java-orderread.haproxy.internal.chuchujie.com
internal-DwxkPayLog-737326690.cn-north-1.elb.amazonaws.com.cn    dwxk-java-paylog.haproxy.internal.chuchujie.com
internal-es-shop-262871665.cn-north-1.elb.amazonaws.com.cn    shop-es.haproxy.internal.chuchujie.com
internal-kefu-web-admin-1768750977.cn-north-1.elb.amazonaws.com.cn    kefu-java-webadmin.haproxy.internal.chuchujie.com
internal-logocean-1308581912.cn-north-1.elb.amazonaws.com.cn    bd-logocean.haproxy.internal.chuchujie.com
internal-mall-comment-admin-317247261.cn-north-1.elb.amazonaws.com.cn    shop-java-mallcommentadmin.haproxy.internal.chuchujie.com
internal-mall-coupon-product-1532313167.cn-north-1.elb.amazonaws.com.cn    shop-java-mallcouponproduct.haproxy.internal.chuchujie.com
internal-mall-coupon-user-1518405202.cn-north-1.elb.amazonaws.com.cn    shop-java-mallcouponuser.haproxy.internal.chuchujie.com
internal-mall-user-center-1485886207.cn-north-1.elb.amazonaws.com.cn    shop-java-mallusercenter.haproxy.internal.chuchujie.com
internal-search-wxk-1497556823.cn-north-1.elb.amazonaws.com.cn    dwxk-search.haproxy.internal.chuchujie.com
internal-sellactweb-1903688388.cn-north-1.elb.amazonaws.com.cn    shop-java-sellactweb.haproxy.internal.chuchujie.com
internal-sellCommodityWeb-232802651.cn-north-1.elb.amazonaws.com.cn    shop-java-sellCommodityWeb.haproxy.internal.chuchujie.com
internal-seller.chuchujie.com    shop-seller.haproxy.internal.chuchujie.com
internal-sellquaweb-334578659.cn-north-1.elb.amazonaws.com.cn    shop-java-sellQuaWeb.haproxy.internal.chuchujie.com
internal-shopActivity-1616677077.cn-north-1.elb.amazonaws.com.cn    shop-java-Activity.haproxy.internal.chuchujie.com
internal-shop-dp-internal-1679419227.cn-north-1.elb.amazonaws.com.cn    shop-dp.haproxy.internal.chuchujie.com
internal-shop-java-log-26984870.cn-north-1.elb.amazonaws.com.cn    shop-java-log.haproxy.internal.chuchujie.com
internal-shop-java-orderread-1440286267.cn-north-1.elb.amazonaws.com.cn    shop-java-orderread.haproxy.internal.chuchujie.com
internal-shop-java-orderread-seller-373283853.cn-north-1.elb.amazonaws.com.cn    shop-java-orderread-seller.haproxy.internal.chuchujie.com
internal-shop-java-orderwrite-1192901580.cn-north-1.elb.amazonaws.com.cn    shop-java-orderwrite.haproxy.internal.chuchujie.com
internal-shop-java-watemark-40231783.cn-north-1.elb.amazonaws.com.cn    shop-java-watemark.haproxy.internal.chuchujie.com
internal-shop-mall-comment-1212151782.cn-north-1.elb.amazonaws.com.cn    shop-java-mallcomment.haproxy.internal.chuchujie.com
internal-shop-mall-user-1095226796.cn-north-1.elb.amazonaws.com.cn    shop-java-malluser.haproxy.internal.chuchujie.com
internal-shop-static-978577546.cn-north-1.elb.amazonaws.com.cn    shop-static.haproxy.internal.chuchujie.com
inwaiter.chuchujie.com    shop-inwaiter.haproxy.internal.chuchujie.com
jd-service.chuchujie.com    houyi-jd-service.haproxy.internal.chuchujie.com
parter.chuchujie.com    shop-parter.haproxy.internal.chuchujie.com
que-wechat.chuchujie.com    dwxk-que-wechat-service.haproxy.internal.chuchujie.com
settlement.chuchujie.com    shop-settlement.haproxy.internal.chuchujie.com
waiter.chuchutong.com    cct-waiter.haproxy.internal.chuchujie.com
10.30.31.220    m11218-03.mc.internal.chuchujie.com
10.30.31.221    m11218-01.mc.internal.chuchujie.com
10.30.31.222    m11218-02.mc.internal.chuchujie.com
10.30.31.241    m11233-01.mc.internal.chuchujie.com
10.30.31.29    m11216-02.mc.internal.chuchujie.com
10.30.31.72    m11239-01.mc.internal.chuchujie.com
10.30.31.80    m11220-01.mc.internal.chuchujie.com
10.30.31.936    m11216-01.mc.internal.chuchujie.com
10.30.11.105    m11217-01.mc.internal.chuchujie.com
dp-orders.wapzv2.0001.cnn1.cache.amazonaws.com.cn    m11217-01.mc.internal.chuchujie.com
10.30.10.151    m11221-01.mc.internal.chuchujie.com
shangcheng-mem.wapzv2.0001.cnn1.cache.amazonaws.com.cn    m11221-01.mc.internal.chuchujie.com"
DominListBlack="internal-message-1776641128.cn-north-1.elb.amazonaws.com.cn shop-message-queadmin.haproxy.internal.chuchujie.com(queadmin:8080)与shop-message-quemsg.haproxy.internal.chuchujie.com(quemsg:8082)"
FilesStr=`find $ROOT_CODE -type f -name "*.*" ! -name "qy-tool.sh" -print | grep -v ".git/" |grep -v ".DS_Store"`
process=0
cnt_find=0;
cnt_replace_acc=0;
cnt_skip=0;

domainArray=${DomainList// /_}
for line in  ${DomainList// /_}
do
    let process++
    data=(${line//_/ })
    searchTmp=`grep -i ${data[0]} -rn $FilesStr`
    echo2 "${process} 查找:${data[0]}" "30;41"
    if [ -n "$searchTmp" ]; then
    	next=0
        IFSO=$IFS
        IFS=$'\n';
        for file in ${searchTmp}
        do
            p1=`echo $file | cut -d ":" -f 1`
            p2=`echo $file | cut -d ":" -f 2`
            p3=`echo $file | cut -d ":" -f 3-`
            echo2 "找到\033[0m ${p1} （${p2}行) : \033[36m${p3}" "32"
            let cnt_find++
            rep=`sed -n -e "${p2} s#${data[0]}#${data[1]}#gp" ${p1}`
            if [ $? -eq 0 ]; then
                echo2 "替换为\033[0m \033[35m${rep}" "33"
                read -p "是否替换以上找到?（Y/n):" flag
                if [ "$flag" = "y" -o "$flag" = "Y" ] ; then
                    case `uname` in
                        Darwin)
                            sed -i "" "${p2} s#${data[0]}#${data[1]}#g" ${p1}
                            if [ $? -eq 0 ]; then
                                echo2 "成功替换" "30;42"
                                let cnt_replace_acc++
                            else
                                echo2 "替换失败" "31;43"
                            fi
                            ;;
                        Linux)
                            sed -i "${p2} s#${data[0]}#${data[1]}#g" ${p1}
                            if [ $? -eq 0 ]; then
                                echo2 "成功替换" "30;42"
                                let cnt_replace_acc++
                            else
                                echo2 "替换失败" "31;43"
                            fi
                            ;;
						MINGW64_NT-6.1)
							sed -i "${p2} s#${data[0]}#${data[1]}#g" ${p1}
                            if [ $? -eq 0 ]; then
                                echo2 "成功替换" "30;42"
                                let cnt_replace_acc++
                            else
                                echo2 "替换失败" "31;43"
                            fi
                            ;;
                    esac
                else
                    let cnt_skip++
                    echo2 "跳过" "30;42"
                fi
            else
                echo2 "失败的规则" "31;43"
            fi
        done
        IFS=$IFSO
    else
        echo2 "未找到" "33"
    fi
done
echo "============================================"
echo2 "功夫不负有心人终于完成了，快去喝点水压压惊" "31"
echo2 "共找到${cnt_find}处 成功替换:${cnt_replace_acc}处 跳过:${cnt_skip}处"
echo2 "本次替换不包括${DominListBlack}"
echo "============================================"
