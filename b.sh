#!/bin/bash
# one key v2ray
rm -rf v2ray cloudflared-linux-amd64 v2ray-linux-64.zip
wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared-linux-amd64
unzip -d v2ray v2ray-linux-64.zip
rm -rf v2ray-linux-64.zip
cat>v2ray/config.json<<EOF
{
	"log": {
		"loglevel": "none"
		},
		"inbounds": [
		{
			"port": 8888,
			"listen": "localhost",
			"protocol": "vmess",
			"settings": {
				"clients": [
					{
						"id": "f67c2691-0fc8-437d-a2d0-bc0efd13eded",
						"alterId": 0
					}
				],
					"disableInsecureEncryption": true
			},
			"streamSettings": {
				"network": "ws",
				"allowInsecure": false,
				"wsSettings": {
					"path": "/"
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom",
			"settings": {}
		}
	],
"policy": {
		"levels": {
			"0": {
	"handshake": 3,
											"connIdle": 60,
											"uplinkOnly": 0,
											"downlinkOnly": 0,
																					"bufferSize": 0
																								}
																								}
																								}
}
EOF
kill -9 $(ps -ef | grep v2ray | grep -v grep | awk '{print $2}')
kill -9 $(ps -ef | grep cloudflared-linux-amd64 | grep -v grep | awk '{print $2}')
./v2ray/v2ray run &
./cloudflared-linux-amd64 tunnel --url http://localhost:8888 --no-autoupdate --protocol h2mux --edge-ip-version auto>argo.log 2>&1 &
sleep 3
clear
echo 等待cloudflare argo生成地址
sleep 12
argo=$(cat argo.log | grep trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
clear
echo vmess链接已经生成,IP地址可替换为CF优选IP
echo 'vmess://'$(echo '{"add":"172.67.167.45","aid":"0","host":"'$argo'","id":"f67c2691-0fc8-437d-a2d0-bc0efd13eded","net":"ws","path":"","port":"443","ps":"cfargovme","tls":"tls","type":"none","v":"2"}' | base64 -w 0)
