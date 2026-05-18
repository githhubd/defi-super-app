# DeFi Super-App

DeFi Super-App is a full-stack decentralized protocol that includes an AMM, lending pool, ERC4626 vault, Chainlink oracle integration, DAO governance, ERC1155 badges, upgradeable configuration, factory deployment, and automated testing.

## Tech Stack

- Solidity
- Foundry
- OpenZeppelin
- Chainlink
- GitHub Actions
- Slither
- React frontend
- The Graph

## Core Contracts

- GovernanceToken — ERC20Votes + ERC20Permit
- SuperAMM — constant product AMM with 0.3% fee
- LendingPool — collateral, borrow, repay, health factor
- YieldVault — ERC4626 tokenized vault
- ChainlinkOracle — price feed with stale price check
- SuperGovernor — DAO governance
- Treasury — DAO treasury
- PoolFactory — CREATE and CREATE2 deployment
- ProtocolConfigV1/V2 — UUPS upgrade path
- ProtocolBadge — ERC1155 badge NFT
- AssemblyMath — Yul gas comparison

## How to Install

```bash
forge install