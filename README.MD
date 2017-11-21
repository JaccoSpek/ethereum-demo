# TNO Ethereum demonstrator
## System requirements
- [docker](https://www.docker.com/)
- [ethereum wallet](https://github.com/ethereum/mist/releases)
- network connectivity

## Setup the demo:
Pull the ethereum image from docker hub:
```bash
$ docker pull ethereum/client-go 
```
Initiate new chain using genesis block:
```bash
$ docker run -it -v $(pwd)/chaindata:/chaindata -v $(pwd)/bootstrap:/bootstrap ethereum/client-go --datadir /chaindata init /bootstrap/TNOGenesis.json 
```
Create new account:
```bash
$ docker run -it -v $(pwd)/chaindata:/chaindata -v $(pwd)/bootstrap:/bootstrap ethereum/client-go --datadir /chaindata --password /bootstrap/pass account new 
```
Start the node:
```bash
$ docker run -it -p 8080:8080 -p 30303:30303 -v $(pwd)/chaindata:/chaindata -v $(pwd)/bootstrap:/bootstrap -v $(pwd)/ethash:/root/.ethash --name geth_client ethereum/client-go --datadir /chaindata --nodiscover --rpc --rpcapi "db,eth,net,web3,personal" --rpcaddr "0.0.0.0" --rpcport "8080" --rpccorsdomain "*" --port "30303" --networkid 1234 --identity "TNONODE" --etherbase 0 --mine 
```
Get node IP:
```bash
$ docker inspect geth_client | grep IPAddress
```
Open new terminal and attach to the node:
```bash
$ docker exec -it geth_client geth attach ipc:chaindata/geth.ipc
```
Get enode (`enode://[HASH]@[::]:30303`):
```javascript
admin.nodeInfo.enode
```
To connect to a node:
```javascript
admin.addPeer("enode://[HASH]@[IP]:30303")
```
Verify if peer is connected:
```javascript
admin.peers
```
## Access the chain using ethereum wallet:
Start the ethereum wallet:
```bash
$ ethereumwallet --rpc http://[IP]:[PORT]
```