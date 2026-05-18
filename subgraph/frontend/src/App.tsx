import { ConnectButton } from "@rainbow-me/rainbowkit";

function App() {
  return (
    <main style={{ padding: "40px", fontFamily: "Arial" }}>
      <h1>DeFi Super-App</h1>
      <p>AMM + Lending + ERC4626 Vault + DAO Governance</p>

      <ConnectButton />

      <section style={{ marginTop: "40px" }}>
        <h2>Protocol Dashboard</h2>
        <p>Wallet connection is ready.</p>
      </section>
    </main>
  );
}

export default App;