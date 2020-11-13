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
			echo -e "\033[${ecolor}m$1\033[0m";;
    	MINGW64_NT-6.1)
			echo -e "\033[${ecolor}m$1\033[0m";;
	MINGW64_NT-10.0)
			echo -e "\033[${ecolor}m$1\033[0m";;
        MINGW32_NT-6.1)
            echo -e "\033[${ecolor}m$1\033[0m";;
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
DomainList="10.0.0.1    aaa.dev.com
10.0.0.2    bbb.dev.com
ccc.dev.com    ddd.dev.com"
DominListBlack="abc.dev.com 123.dev.com"
FilesStr=`find $ROOT_CODE -type f -name "*.*" ! -name "qy-tool.sh" -print | grep -v ".git/" |grep -v ".DS_Store" |grep -v ".jpg" |grep -v ".jpeg"|grep -v ".gif"`
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
			MINGW64_NT-10.0)
			    sed -i "${p2} s#${data[0]}#${data[1]}#g" ${p1}
                            if [ $? -eq 0 ]; then
                                echo2 "成功替换" "30;42"
                                let cnt_replace_acc++
                            else
                                echo2 "替换失败" "31;43"
                            fi
                            ;;
                        MINGW32_NT-6.1)
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
