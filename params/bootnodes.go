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

package params

// MainnetBootnodes are the enode URLs of the P2P bootstrap nodes running on
// the main Nodez network.
var MainnetBootnodes = []string{
	"enode://1fa2c41050219e1ec8d68e22c6da4dc54fff417a1416570e6225f3cfedb60dd98bdbca48fcc75741deabded9958814f9cd4a30890d86477d631378808ed3103a@45.76.141.1:13373",
	"enode://bc98c96609fa892d9e83c8f5e0d0a7a5fd849f8c8dac718abde0cb8d0df646ab9aa9a38123979af68b25b663965eb352027a04b84af041d9fba715f19521f44a@45.32.175.21:13373",
}

// TestnetBootnodes are the enode URLs of the P2P bootstrap nodes running on the
// Ropsten test network.
var TestnetBootnodes = []string{}

// RinkebyBootnodes are the enode URLs of the P2P bootstrap nodes running on the
// Rinkeby test network.
var RinkebyBootnodes = []string{}

// RinkebyV5Bootnodes are the enode URLs of the P2P bootstrap nodes running on the
// Rinkeby test network for the experimental RLPx v5 topic-discovery network.
var RinkebyV5Bootnodes = []string{}

// DiscoveryV5Bootnodes are the enode URLs of the P2P bootstrap nodes for the
// experimental RLPx v5 topic-discovery network.
var DiscoveryV5Bootnodes = []string{}
