import { useAccount, useReadContract, useWriteContract, useChainId, useSwitchChain } from "wagmi";
import { baseSepolia } from "wagmi/chains";
import { formatEther, parseEther } from "viem";
import { ADDRESSES } from "../contracts/addresses";
import { erc20Abi, ammAbi, vaultAbi } from "../contracts/abis";

export function ProtocolDashboard() {
  const { address, isConnected } = useAccount();
  const chainId = useChainId();
  const { switchChain } = useSwitchChain();
  const { writeContract, error, isPending } = useWriteContract();

  const wrongNetwork = chainId !== baseSepolia.id;

  const { data: balance } = useReadContract({
    address: ADDRESSES.governanceToken as `0x${string}`,
    abi: erc20Abi,
    functionName: "balanceOf",
    args: address ? [address] : undefined,
    query: { enabled: Boolean(address) },
  });

  const { data: votes } = useReadContract({
    address: ADDRESSES.governanceToken as `0x${string}`,
    abi: erc20Abi,
    functionName: "getVotes",
    args: address ? [address] : undefined,
    query: { enabled: Boolean(address) },
  });

  const { data: delegate } = useReadContract({
    address: ADDRESSES.governanceToken as `0x${string}`,
    abi: erc20Abi,
    functionName: "delegates",
    args: address ? [address] : undefined,
    query: { enabled: Boolean(address) },
  });

  const { data: reserveA } = useReadContract({
    address: ADDRESSES.amm as `0x${string}`,
    abi: ammAbi,
    functionName: "reserveA",
  });

  const { data: reserveB } = useReadContract({
    address: ADDRESSES.amm as `0x${string}`,
    abi: ammAbi,
    functionName: "reserveB",
  });

  const { data: vaultShares } = useReadContract({
    address: ADDRESSES.vault as `0x${string}`,
    abi: vaultAbi,
    functionName: "balanceOf",
    args: address ? [address] : undefined,
    query: { enabled: Boolean(address) },
  });

  if (!isConnected) {
    return <p>Please connect your wallet.</p>;
  }

  return (
    <section style={{ marginTop: 30 }}>
      {wrongNetwork && (
        <div style={{ padding: 15, background: "#ffe0e0", marginBottom: 20 }}>
          <b>Wrong network.</b>
          <br />
          Please switch to Base Sepolia.
          <br />
          <button onClick={() => switchChain({ chainId: baseSepolia.id })}>
            Switch Network
          </button>
        </div>
      )}

      <h2>Protocol Dashboard</h2>

      <p>Token balance: {balance ? formatEther(balance) : "0"}</p>
      <p>Voting power: {votes ? formatEther(votes) : "0"}</p>
      <p>Delegate: {delegate ?? "No delegate"}</p>
      <p>AMM Reserve A: {reserveA ? formatEther(reserveA) : "0"}</p>
      <p>AMM Reserve B: {reserveB ? formatEther(reserveB) : "0"}</p>
      <p>Vault shares: {vaultShares ? formatEther(vaultShares) : "0"}</p>

      <h3>Write Actions</h3>

      <button
        disabled={isPending || wrongNetwork}
        onClick={() =>
          writeContract({
            address: ADDRESSES.governanceToken as `0x${string}`,
            abi: erc20Abi,
            functionName: "delegate",
            args: [address!],
          })
        }
      >
        Delegate Votes
      </button>

      <button
        disabled={isPending || wrongNetwork}
        onClick={() =>
          writeContract({
            address: ADDRESSES.amm as `0x${string}`,
            abi: ammAbi,
            functionName: "swapAForB",
            args: [parseEther("1"), 1n],
          })
        }
      >
        Swap 1 Token
      </button>

      <button
        disabled={isPending || wrongNetwork}
        onClick={() =>
          writeContract({
            address: ADDRESSES.vault as `0x${string}`,
            abi: vaultAbi,
            functionName: "deposit",
            args: [parseEther("1"), address!],
          })
        }
      >
        Deposit to Vault
      </button>

      {error && (
        <p style={{ color: "red" }}>
          Transaction failed or rejected. Please check wallet, balance, and network.
        </p>
      )}

      <h3>Active Proposals</h3>
      <p>Proposal #1 — Pending / Active / Succeeded / Defeated / Queued / Executed</p>
      <button disabled={wrongNetwork}>Vote For</button>

      <h3>Subgraph Data</h3>
      <p>Recent swaps will be loaded from The Graph after subgraph deployment.</p>
    </section>
  );
}