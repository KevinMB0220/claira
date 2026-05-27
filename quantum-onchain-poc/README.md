# Quantum FNFT — 100% On-Chain POC

> Zero APIs · Zero Servers · 100% Blockchain (Base Sepolia)

## 🔗 Deployed Contract Info

| Field | Value |
|-------|-------|
| **Network** | Base Sepolia (Chain ID: 84532) |
| **Contract Address** | `0xCbE0F785EDc2d823a44d5DB44C8099407000B843` |
| **Token Name** | Quantum Financial NFT (QFNFT) |
| **Token Standard** | ERC-721 (ERC721URIStorage) |
| **Mint TX** | [`0x8a199d2965dd9a0a93c1306b636552eb5d083b26be94f38cadf851a839b275bd`](https://sepolia.basescan.org/tx/0x8a199d2965dd9a0a93c1306b636552eb5d083b26be94f38cadf851a839b275bd) |
| **Block** | 42,078,417 |
| **Explorer** | [View on BaseScan](https://sepolia.basescan.org/address/0xCbE0F785EDc2d823a44d5DB44C8099407000B843) |

## 📋 ABI (Minimal — for Frontend)

Only two read functions are needed:

```javascript
const CONTRACT_ADDRESS = "0xCbE0F785EDc2d823a44d5DB44C8099407000B843";
const RPC_URL = "https://sepolia.base.org";

const CONTRACT_ABI = [
  "function tokenURI(uint256 tokenId) view returns (string)",
  "function getFinancialSnapshot(uint256 tokenId) view returns (tuple(string assetId, uint256 netOperatingIncome, uint256 occupancyRate, uint256 dscr, uint256 cashflow, uint256 lastVerifiedTimestamp))"
];
```

## 📊 On-Chain Data (Token ID 0)

### Token Metadata (`tokenURI(0)`)

```json
{
  "asset_id": "QM1-001",
  "ownership": "0.05%",
  "legal_vehicle": "Quantum M1 SPV",
  "last_verified": "2026-05-27T16:00:00Z",
  "claira_endpoint": "ONCHAIN_RESOLVER"
}
```

### Financial Snapshot (`getFinancialSnapshot(0)`)

| Field | Raw Value | Formatted | Notes |
|-------|-----------|-----------|-------|
| `assetId` | `"QM1-001"` | QM1-001 | Asset identifier |
| `netOperatingIncome` | `450000` | **$450,000.00** | Annual NOI |
| `occupancyRate` | `9450` | **94.50%** | Divide by 100 |
| `dscr` | `135` | **1.35x** | Divide by 100 |
| `cashflow` | `125000` | **$125,000.00** | Quarterly |
| `lastVerifiedTimestamp` | `1779925122` | **2026-05-27 23:38:42 UTC** | Block timestamp |

## 🏗️ Project Structure

```
quantum-onchain-poc/
├── contracts/
│   └── QuantumFNFT.sol          # ERC-721 + FinancialSnapshot struct
├── scripts/
│   ├── deploy.js                # Full deploy + mint
│   └── mint.js                  # Mint-only (for already deployed contract)
├── frontend/
│   └── index.html               # Institutional dashboard (ethers.js v6 CDN)
├── hardhat.config.js            # Solidity 0.8.28 / Cancun EVM / Base Sepolia
├── package.json
└── .env                         # ⚠️ NOT committed (contains private key)
```

## 🚀 Frontend Quick Start

The frontend is a single `index.html` file. No build step needed.

1. The contract address and RPC are already hardcoded in `frontend/index.html`
2. Open `frontend/index.html` in any browser
3. Click **"Query Blockchain State"** — data resolves from Base Sepolia via public RPC
4. No wallet connection required (read-only mode works)

### Frontend Sections:
1. **Wallet Connection** — MetaMask connect with auto chain-switch to Base Sepolia
2. **Token Metadata** — Parsed from `tokenURI(0)` on-chain JSON
3. **Financial Snapshot** — NOI, Occupancy, DSCR, Cashflow from `getFinancialSnapshot(0)`
4. **Timestamp Verification** — Block timestamp proving when data was recorded

## 🔧 Development

```bash
# Install dependencies
npm install

# Compile contracts
npm run compile

# Deploy to Base Sepolia (needs funded .env)
npm run deploy

# Or mint only (if contract already deployed)
npx hardhat run scripts/mint.js --network baseSepolia
```

## ✅ Verification

Anyone can verify on-chain data without our frontend:

- **BaseScan:** Go to [Read Contract](https://sepolia.basescan.org/address/0xCbE0F785EDc2d823a44d5DB44C8099407000B843#readContract) → call `tokenURI(0)` and `getFinancialSnapshot(0)`
- **CLI:** `cast call 0xCbE0F785EDc2d823a44d5DB44C8099407000B843 "getFinancialSnapshot(uint256)" 0 --rpc-url https://sepolia.base.org`
