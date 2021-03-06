# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: ndz android ios ndz-cross swarm evm all test clean
.PHONY: ndz-linux ndz-linux-386 ndz-linux-amd64 ndz-linux-mips64 ndz-linux-mips64le
.PHONY: ndz-linux-arm ndz-linux-arm-5 ndz-linux-arm-6 ndz-linux-arm-7 ndz-linux-arm64
.PHONY: ndz-darwin ndz-darwin-386 ndz-darwin-amd64
.PHONY: ndz-windows ndz-windows-386 ndz-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

ndz:
	build/env.sh go run build/ci.go install ./cmd/ndz
	@echo "Done building."
	@echo "Run \"$(GOBIN)/ndz\" to launch ndz."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/ndz.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Nodez.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

ndz-cross: ndz-linux ndz-darwin ndz-windows ndz-android ndz-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/ndz-*

ndz-linux: ndz-linux-386 ndz-linux-amd64 ndz-linux-arm ndz-linux-mips64 ndz-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-*

ndz-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/ndz
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep 386

ndz-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/ndz
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep amd64

ndz-linux-arm: ndz-linux-arm-5 ndz-linux-arm-6 ndz-linux-arm-7 ndz-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep arm

ndz-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/ndz
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep arm-5

ndz-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/ndz
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep arm-6

ndz-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/ndz
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep arm-7

ndz-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/ndz
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep arm64

ndz-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/ndz
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep mips

ndz-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/ndz
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep mipsle

ndz-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/ndz
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep mips64

ndz-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/ndz
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/ndz-linux-* | grep mips64le

ndz-darwin: ndz-darwin-386 ndz-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/ndz-darwin-*

ndz-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/ndz
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-darwin-* | grep 386

ndz-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/ndz
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-darwin-* | grep amd64

ndz-windows: ndz-windows-386 ndz-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/ndz-windows-*

ndz-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/ndz
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-windows-* | grep 386

ndz-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/ndz
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/ndz-windows-* | grep amd64
