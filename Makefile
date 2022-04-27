
# include .env file and export its env vars (-include to ignore error if it does not exist)
-include .env

deploy-wmd:
	forge create src/WMDToken.sol:WMDToken --private-key ${PRIVATE_KEY_EDGE} --rpc-url ${ETH_RPC_URL} --constructor-args 0

verify-wmd:
	forge verify-contract --chain-id ${KOVAN_CHAINID} --compiler-version v0.8.13+commit.abaa5c0e ${WMD_CONTRACT_ADDRESS} src/WMDToken.sol:WMDToken ${ETHERSCAN_API_KEY} --num-of-optimizations 200 --flatten --constructor-args 0x0000000000000000000000000000000000000000000000000000000000000000

verify-check-wmd:
	forge verify-check --chain-id ${KOVAN_CHAINID} ${WMD_GUID} ${ETHERSCAN_API_KEY}

deploy-vault:
	forge create src/BasicVault.sol:BasicVault --private-key ${PRIVATE_KEY_EDGE} --rpc-url ${ETH_RPC_URL} --constructor-args "0xfac14d6d486542c1d71b65745d8d881e7d9eb8e1"

verify-vault:
	forge verify-contract --chain-id ${KOVAN_CHAINID} --compiler-version v0.8.13+commit.abaa5c0e ${VAULT_CONTRACT_ADDRESS} src/BasicVault.sol:BasicVault ${ETHERSCAN_API_KEY} --num-of-optimizations 200 --flatten --constructor-args 0x000000000000000000000000fac14d6d486542c1d71b65745d8d881e7d9eb8e1

verify-check-vault:
	forge verify-check --chain-id ${KOVAN_CHAINID} ${VAULT_GUID} ${ETHERSCAN_API_KEY}