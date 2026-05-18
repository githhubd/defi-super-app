import { ConnectButton } from "@rainbow-me/rainbowkit";
import { ProtocolDashboard } from "./components/ProtocolDashboard";
import "./App.css";

function App() {
  return (
    <main className="app">
      <section className="hero">
        <div>
          <p className="badge">DeFi Super-App</p>
          <h1>All-in-one decentralized finance protocol</h1>
          <p className="subtitle">
            AMM swap, lending pool, ERC4626 vault, DAO governance and subgraph
            analytics.
          </p>
        </div>

        <ConnectButton />
      </section>

      <section className="cards">
        <div className="card">
          <h3>AMM</h3>
          <p>Swap tokens with constant-product liquidity.</p>
        </div>

        <div className="card">
          <h3>Lending</h3>
          <p>Deposit collateral, borrow assets and track health factor.</p>
        </div>

        <div className="card">
          <h3>DAO</h3>
          <p>Delegate voting power and participate in governance.</p>
        </div>
      </section>

      <ProtocolDashboard />
    </main>
  );
}

export default App;
