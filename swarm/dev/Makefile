.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/NodezCrypto/go-nodez/cmd/swarm
	go build -o bin/ndz-masternode github.com/NodezCrypto/go-nodez/cmd/masternode
	go build -o bin/ndz-node     github.com/NodezCrypto/go-nodez/cmd/ndz
	go build -o bin/ndz-bootnode github.com/NodezCrypto/go-nodez/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/NodezCrypto/go-nodez/swarm/...
