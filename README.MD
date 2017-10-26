```bash
$ docker pull ethereum/client-go 
$ docker run -it -v $(pwd)/chaindata:/chaindata -v 
$(pwd)/bootstrap:/bootstrap ethereum/client-go --datadir /chaindata init /bootstrap/TNOGenesis.json 
$ docker run -it -v $(pwd)/chaindata:/chaindata -v 
$(pwd)/bootstrap:/bootstrap ethereum/client-go --datadir /chaindata --password /bootstrap/pass account new 
$ docker run -it -p 8080:8080 -p 30303:30303 -v $(pwd)/chaindata:/chaindata -v $(pwd)/bootstrap:/bootstrap -v $(pwd)/ethash:/root/.ethash --name geth_client ethereum/client-go --datadir /chaindata --nodiscover --rpc --rpcapi "db,eth,net,web3,personal" --rpcaddr "0.0.0.0" --rpcport "8080" --rpccorsdomain "*" --port "30303" --networkid 1234 --identity "TNONODE" --etherbase 0 --mine 
$ docker exec -it geth_client geth attach ipc:chaindata/geth.ipc
```