echo 'runapp [bundle/install rake node/rails noproxy bash]'
echo '-d daemon'
echo '-q mysql'
echo '-m mongo'
echo '--image=image'


paramArray=( "$@" )
if [[ ${#paramArray[@]} -gt 0 ]]; then
  ports=$(netstat -lptun | awk '{printf $4"\n"}' | grep -Eo '[0-9]+$' | grep -E '^300[0-9]$')
  ports_internal_candidate=(3000 3001 3002 3003 3004 3005)
  ports_external_candidate=(10000 10001 10002 10003 10004 10005)
  # appport="3000"
  # proxyport="10000"
  for ((i=0; i < ${#ports_internal_candidate[@]}; ++i)); do
    echo $ports | grep -Eo "\\b${ports_internal_candidate[$i]}\\b"
    if [[ $? -ne 0 ]]; then
      appport=${ports_internal_candidate[$i]}
      proxyport=${ports_external_candidate[$i]}
      break
    fi
  done
  if [[ $(echo ${paramArray[@]} | grep -Eao 'noproxy' -q; echo $?) -eq 0 ]]; then
      proxyport='noproxy'
  fi
  if [[ $appport == "" || $proxyport == "" ]]; then
    echo "No port available."
    exit
  fi
  paramForServe="bundle"
  cartridgePort="3000"
  appdir=`pwd`
  cartridge="labs-rails"
  ir=" -it "
  usingProxy=1
  appname=`basename "$appdir"`
  env=`env | grep "LABS_APP_ENV" | grep ci -o`

  dbContainerName="$appname-mysql-$appport-$proxyport"
  for param in ${paramArray[@]}; do
    IFS== ports=($param) IFS=
    key=${ports[0]}
    value=${ports[1]}
    case $key in
      "install" )        
          paramForServe=$paramForServe' install'
        ;;
      # "bundle" )        
      #     paramForServe=$paramForServe' bundle'
      # ;;
      "rake" )        
          paramForServe=$paramForServe' rake'
        ;;
      "node" )
          cartridge="labs-nodejs"
          # proxyType="https"
          # paramForServe=$appport
          # cartridgePort="1337"
          cartridgePort="9000"
        ;;
      "bash" )
          runBash=true
          ir=" -it "
        ;;
      "-d" )
          ir=" -d "
        ;;
      "--image" )
          cartridge=$value
        ;;
      "noproxy" )
          usingProxy=0
          proxyport='noproxy'
          dbContainerName="$appname-mysql-$appport-$proxyport"
        ;;
      "-q" )
          paramForServe=$paramForServe' db'
          echo $paramForServe
          dbContainerName="$appname-mysql-$appport-$proxyport"
          dblink="--link $dbContainerName:mysql"
          docker ps | grep "$dbContainerName"    
          # echo $?
          if [ $? -ne 0 ];
          then
              docker rm -f "$dbContainerName" 
              docker run --name "$dbContainerName" -e MYSQL_ROOT_PASSWORD=my-secret-pw -d labs-mysql 
              $?=1
              while [ $? -ne 0 ]; do
                echo "run -it --link $dbContainerName:mysql -v /data/db/$appname:/var/lib/mysql --rm labs-mysql sh -c 'exec mysql -h$MYSQL_PORT_3306_TCP_ADDR -P$MYSQL_PORT_3306_TCP_PORT -uroot -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD < /tmp/labs_schema.sql'"
                docker run -it --link "$dbContainerName":mysql -v "/data/db/$appname":/var/lib/mysql --rm labs-mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /tmp/labs_schema.sql'
              done
          fi
        ;;
      "-m" )
          paramForServe=$paramForServe' db'
          dbContainerName="$appname-mongo-$appport-$proxyport"
          dblink="--link $dbContainerName:mongo"
          docker ps | grep "$dbContainerName"
          # echo $?
          if [ $? -ne 0 ];
          then
              docker rm -f "$dbContainerName" 
              docker run --name "$dbContainerName" -d labs-mongo
              echo "docker run --name $dbContainerName -d labs-mongo"
              $?=1
              while [ $? -ne 0 ]; do
                echo "docker run -it --link $dbContainerName:mongo -v /data/db/$appname:/data/db --rm labs-mongo sh -c 'exec mongo $MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT < /tmp/labs_app_schema.js'"
                docker run -it --link "$dbContainerName":mongo -v "/data/db/$appname":/data/db --rm labs-mongo sh -c 'exec mongo $MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT < /tmp/labs_app_schema.js'
              done
          fi
        ;;
    esac
  done

  appContainerName="$appname-app-$appport-$proxyport"
  proxyContainerName="$appname-proxy-$appport-$proxyport"


  if [[ $(echo $paramForServe | grep -Eao 'rake' -q; echo $?) -ne 0 ]]; then      
    paramForServe=$paramForServe' norake'
  fi

  # run-httpd
  if [[ usingProxy -eq 1 ]]; then
    docker rm -f "$proxyContainerName" 
    cmd="docker run --name "$proxyContainerName" -d -p $proxyport:$proxyport labs-proxy-embed sh -c 'create-conf $appport $proxyport $env $proxyType && httpd -DFOREGROUND'"
    echo $cmd
    eval $cmd
  fi


  # # run-app
  docker rm -f "$appContainerName" 
  echo $paramForServe
  # for docker-1.6+, mount with :Z to solve volumes and SELinux issue.
  if [[ $runBash ]]; then
    cmd="docker run --name "$appContainerName" $dblink $ir -p $appport:$cartridgePort -v "$appdir":/labsapp:Z $cartridge /bin/bash"
  else
    cmd="docker run --name "$appContainerName" $dblink $ir -p $appport:$cartridgePort -v "$appdir":/labsapp:Z $cartridge sh -c 'serve $paramForServe'"
  fi
  # cmd="docker run --name "$appContainerName" $dblink $ir -p $appport:$cartridgePort -v "$appdir":"$appdir" $cartridge /bin/bash"
  echo $cmd
  eval $cmd
  function finish {
    echo $ir | grep 'it' -q
    if [ $? -eq 0 ]; then
      docker rm -f "$appContainerName" "$proxyContainerName"
      docker rm -fv "$dbContainerName"
    fi
  }
  trap finish EXIT

fi
