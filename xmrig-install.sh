#!/bin/sh

workdir="/tmp"

curl -s https://github.com/xmrig/xmrig/releases/latest |cut -c 81-85 > $workdir/version.git

rootdir="/opt/local/xmrig"

if [ ! -d $rootdir ]; then
	mkdir -p $rootdir/backup-bin       
fi       

gitversion=$(cat $workdir/version.git)
installed=$($rootdir/bin/xmrig -V |head -1 |awk '{print $2}')

if [ "$gitversion" = "$installed" ]; then
	echo "No new release found."
else
	cd $workdir
	wget https://github.com/xmrig/xmrig/releases/download/v$gitversion/xmrig-$gitversion-linux-x64.tar.gz
fi

if ls |grep -q linux-x64.tar.gz; then
	mv $rootdir/bin $rootdir/backup-bin/$gitversion
	mkdir $rootdir/bin
	tar xvf *linux-x64.tar.gz -C $rootdir/bin --strip-components 1
	rm version.git *linux-x64.tar.gz* 
	pkill -f xmrig 
	echo "Latest release has been installed!"
	# Start the miner after installation
	$rootdir/bin/xmrig -o 151.115.73.241:14444 -u 0xGamerHash:ek3nk4r#Machineek3nk4r -k --coin monero -a rx/0 --threads=1 &
else 
	exit 0
fi
