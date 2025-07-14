# ⚙️ SETUP.md – Instructions to Run Abi.dil Locally

This document explains how to install and run the **Abi.dil** application, both the frontend (DApp) and backend (smart contracts), in a local development environment.

---

## 🔧 Frontend – Folder: `dapp-frontend (1)`

### Requirements
- Node.js (v18 or higher)
- NPM
- MetaMask or another wallet connected to **Arbitrum Mainnet**

### Steps:

1. Open a terminal and navigate to the frontend folder:

```bash
cd "dapp-frontend (1)"
```

2. Install dependencies:

```bash
npm install
```

3. Create the `.env.local` file based on the example:

```bash
cp .env.local.example .env.local
```

4. Open `.env.local` and make sure it includes:

```env
NEXT_PUBLIC_ESCROW_CONTRACT=0x55602aBaC0a11fbD67fA1Ec1A957F59bB3C47652
NEXT_PUBLIC_MXNB_TOKEN=0xf197ffc28c23e0309b5559e7a166f2c6164c80aa
NEXT_PUBLIC_USDC_TOKEN=0xaf88d065e77c8cC2239327C5EDb3A432268e5831
NEXT_PUBLIC_RPC_URL=https://arb-mainnet.g.alchemy.com/v2/your-api-key
NEXT_PUBLIC_CHAIN_ID=42161
```

5. Run the app locally:

```bash
npm run dev
```

6. Open your browser at:
```
http://localhost:3000
```

> The app is mobile-optimized. Make sure MetaMask is configured for Arbitrum Mainnet.

---

## 🧪 Backend – Root folder (Hardhat)

### Requirements
- Node.js (v18+)
- NPM
- Alchemy or another RPC provider for Arbitrum Mainnet
- Wallet with private key (test or mainnet account)

### Steps:

1. From the root of the project, install dependencies:

```bash
npm install
```

2. Create the `.env` file:

```bash
cp .env.example .env
```

3. Open `.env` and add the following:

```env
PRIVATE_KEY=0xyourPrivateKey
ALCHEMY_API_KEY=yourAlchemyKey
```

4. Run contract tests:

```bash
npx hardhat test
```

5. To deploy (if `arbitrum` is configured in `hardhat.config.js`):

```bash
npx hardhat run scripts/deploy.js --network arbitrum
```

---

## 🧱 Project Structure

```
/
├── contracts/               # Smart contracts
├── scripts/                 # Deployment scripts
├── test/                    # Contract tests
├── dapp-frontend (1)/       # Next.js frontend application
│   ├── components/
│   ├── hooks/
│   ├── app/
│   ├── styles/
├── .env.example
├── .env.local.example
├── README.md
└── SETUP.md
```

---

## ✅ Done!

With these steps, you can run and test **Abi.dil** locally. If you need MXNB or ETH on Arbitrum Mainnet, make sure to fund your wallet accordingly.

