// Copyright 2018 The CryptoNodez Team
// This file is part of the go-nodez library.
//
// The go-nodez library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-nodez library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-nodez library. If not, see <http://www.gnu.org/licenses/>.

package eth

import (
	"context"
	"math/big"

	"github.com/NodezCrypto/go-nodez"
	"github.com/NodezCrypto/go-nodez/common"
	"github.com/NodezCrypto/go-nodez/common/hexutil"
	"github.com/NodezCrypto/go-nodez/core/types"
	"github.com/NodezCrypto/go-nodez/internal/ethapi"
	"github.com/NodezCrypto/go-nodez/rlp"
	"github.com/NodezCrypto/go-nodez/rpc"
)

// ContractBackend implements bind.ContractBackend with direct calls to Nodez
// internals to support operating on contracts within subprotocols like eth and
// swarm.
//
// Internally this backend uses the already exposed API endpoints of the Nodez
// object. These should be rewritten to internal Go method calls when the Go API
// is refactored to support a clean library use.
type ContractBackend struct {
	eapi  *ethapi.PublicEthereumAPI        // Wrapper around the Nodez object to access metadata
	bcapi *ethapi.PublicBlockChainAPI      // Wrapper around the blockchain to access chain data
	txapi *ethapi.PublicTransactionPoolAPI // Wrapper around the transaction pool to access transaction data
}

// NewContractBackend creates a new native contract backend using an existing
// Nodez object.
func NewContractBackend(apiBackend ethapi.Backend) *ContractBackend {
	return &ContractBackend{
		eapi:  ethapi.NewPublicEthereumAPI(apiBackend),
		bcapi: ethapi.NewPublicBlockChainAPI(apiBackend),
		txapi: ethapi.NewPublicTransactionPoolAPI(apiBackend, new(ethapi.AddrLocker)),
	}
}

// CodeAt retrieves any code associated with the contract from the local API.
func (b *ContractBackend) CodeAt(ctx context.Context, contract common.Address, blockNum *big.Int) ([]byte, error) {
	return b.bcapi.GetCode(ctx, contract, toBlockNumber(blockNum))
}

// CodeAt retrieves any code associated with the contract from the local API.
func (b *ContractBackend) PendingCodeAt(ctx context.Context, contract common.Address) ([]byte, error) {
	return b.bcapi.GetCode(ctx, contract, rpc.PendingBlockNumber)
}

// ContractCall implements bind.ContractCaller executing an Nodez contract
// call with the specified data as the input. The pending flag requests execution
// against the pending block, not the stable head of the chain.
func (b *ContractBackend) CallContract(ctx context.Context, msg ethereum.CallMsg, blockNum *big.Int) ([]byte, error) {
	out, err := b.bcapi.Call(ctx, toCallArgs(msg), toBlockNumber(blockNum))
	return out, err
}

// ContractCall implements bind.ContractCaller executing an Nodez contract
// call with the specified data as the input. The pending flag requests execution
// against the pending block, not the stable head of the chain.
func (b *ContractBackend) PendingCallContract(ctx context.Context, msg ethereum.CallMsg) ([]byte, error) {
	out, err := b.bcapi.Call(ctx, toCallArgs(msg), rpc.PendingBlockNumber)
	return out, err
}

func toCallArgs(msg ethereum.CallMsg) ethapi.CallArgs {
	args := ethapi.CallArgs{
		To:   msg.To,
		From: msg.From,
		Data: msg.Data,
		Gas:  hexutil.Uint64(msg.Gas),
	}
	if msg.GasPrice != nil {
		args.GasPrice = hexutil.Big(*msg.GasPrice)
	}
	if msg.Value != nil {
		args.Value = hexutil.Big(*msg.Value)
	}
	return args
}

func toBlockNumber(num *big.Int) rpc.BlockNumber {
	if num == nil {
		return rpc.LatestBlockNumber
	}
	return rpc.BlockNumber(num.Int64())
}

// PendingAccountNonce implements bind.ContractTransactor retrieving the current
// pending nonce associated with an account.
func (b *ContractBackend) PendingNonceAt(ctx context.Context, account common.Address) (nonce uint64, err error) {
	out, err := b.txapi.GetTransactionCount(ctx, account, rpc.PendingBlockNumber)
	if out != nil {
		nonce = uint64(*out)
	}
	return nonce, err
}

// SuggestGasPrice implements bind.ContractTransactor retrieving the currently
// suggested gas price to allow a timely execution of a transaction.
func (b *ContractBackend) SuggestGasPrice(ctx context.Context) (*big.Int, error) {
	return b.eapi.GasPrice(ctx)
}

// EstimateGasLimit implements bind.ContractTransactor triing to estimate the gas
// needed to execute a specific transaction based on the current pending state of
// the backend blockchain. There is no guarantee that this is the true gas limit
// requirement as other transactions may be added or removed by miners, but it
// should provide a basis for setting a reasonable default.
func (b *ContractBackend) EstimateGas(ctx context.Context, msg ethereum.CallMsg) (uint64, error) {
	gas, err := b.bcapi.EstimateGas(ctx, toCallArgs(msg))
	return uint64(gas), err
}

// SendTransaction implements bind.ContractTransactor injects the transaction
// into the pending pool for execution.
func (b *ContractBackend) SendTransaction(ctx context.Context, tx *types.Transaction) error {
	raw, _ := rlp.EncodeToBytes(tx)
	_, err := b.txapi.SendRawTransaction(ctx, raw)
	return err
}
