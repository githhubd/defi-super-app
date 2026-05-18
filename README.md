# DeFi Super-App

Full-stack decentralized finance protocol built on Base Sepolia.

The project combines:
- AMM liquidity pools
- Lending & borrowing
- ERC4626 yield vaults
- DAO governance
- Chainlink price oracles
- The Graph subgraph indexing
- Upgradeable smart contracts

---

# Features

## AMM (Automated Market Maker)
- Token swaps
- Liquidity pools
- Constant-product AMM formula
- PoolFactory deployment system

## Lending Protocol
- Collateral deposits
- Borrowing functionality
- Health factor calculation
- Liquidation mechanism

## ERC4626 Yield Vault
- Tokenized vault standard
- Vault share accounting
- Yield strategy integration

## DAO Governance
- GovernanceToken with ERC20Votes
- Proposal creation
- On-chain voting
- Timelock execution

## Oracle Integration
- Chainlink price feeds

## Indexing & Analytics
- The Graph subgraph integration
- Indexed swaps and governance events

## Upgradeability
- UUPS upgradeable contracts
- Protocol configuration upgrades

---

# Tech Stack

## Smart Contracts
- Solidity ^0.8.24
- OpenZeppelin Contracts
- Foundry

## Frontend
- React
- TypeScript
- Vite
- Wagmi
- Viem
- RainbowKit

## Blockchain Infrastructure
- Base Sepolia
- Chainlink
- The Graph

---

# Project Structure

src/
 ├── amm/
 ├── governance/
 ├── lending/
 ├── vault/
 ├── upgradeable/
 ├── badges/
 └── oracle/

test/
 ├── unit/
 ├── fuzz/
 ├── invariant/
 └── fork/

subgraph/
frontend/

---

# Smart Contracts

| Contract | Description |
|---|---|
| SuperAMM | AMM swap and liquidity pool |
| PoolFactory | Deploys AMM pools |
| LendingPool | Lending and borrowing |
| YieldVault | ERC4626 vault |
| GovernanceToken | ERC20Votes governance token |
| SuperGovernor | DAO governance |
| ProtocolConfigV1/V2 | Upgradeable protocol configuration |
| ProtocolBadge | ERC1155 protocol badges |

---

# Security Features

- ReentrancyGuard
- SafeERC20
- Access control
- Timelock governance
- UUPS upgradeability
- Slippage protection
- Health factor liquidation checks

---

# Testing

The project includes:
- Unit tests
- Fuzz tests
- Invariant tests
- Fork tests

Run tests:

forge test

---

# Frontend

Start frontend:

cd subgraph/frontend
npm install
npm run dev

Frontend includes:
- RainbowKit wallet connection
- Governance dashboard
- AMM swap interface
- Vault interaction UI
- Subgraph analytics

---

# Deployment

Deploy contracts:

forge script script/Deploy.s.sol --rpc-url <RPC_URL> --private-key <PRIVATE_KEY>

---

# Architecture

The protocol architecture includes:
- AMM liquidity layer
- Lending subsystem
- ERC4626 vault system
- DAO governance
- Oracle integration
- Subgraph indexing

---

# Authors

Blockchain Technologies 2 Final Project

Team Members:
- Nurbai Karakat
- Amantay Balnur
- Duiseman Gulnaz