# Nonce Repros (Devin)

## Setup
1. `cd /home/baron/corecoin/reproduce_nonce`
2. `.env` must contain:
   - `DEVIN_ADDRESS`
   - `DEVIN_RPC_URL`
   - `DEVIN_NETWORK_ID`
3. Build: `spark build`

## 1) Old Simulation Repro (fixed)
Repro command:
```bash
set -a && source .env && set +a
spark script script/DeployNonceBug.s.sol:DeployNonceBugScript \
  --rpc-url "$DEVIN_RPC_URL" \
  --network-id "$DEVIN_NETWORK_ID" \
  --sender "0x$DEVIN_ADDRESS" \
  --tx-origin "0x$DEVIN_ADDRESS" \
  -vvvvv
```

Current expected behavior:
- Script + on-chain simulation complete successfully (fix confirmed).

## 2) Broadcast Nonce Repro (current issue)
Command:
```bash
set -a && source .env && set +a
probe rpc --rpc-url "$DEVIN_RPC_URL" xcb_getTransactionCount "$DEVIN_ADDRESS" latest

RUST_LOG=foxar_cli::cmd::spark::script::broadcast=debug \
spark script script/DeployBroadcastNonceBug.s.sol:DeployBroadcastNonceBugScript \
  --rpc-url "$DEVIN_RPC_URL" \
  --network-id "$DEVIN_NETWORK_ID" \
  --wallet-network devin \
  --private-key "$DEVIN_PRIVATE_KEY" \
  --legacy \
  --with-energy-price 5000000000 \
  --broadcast \
  --skip-simulation \
  -vvv
```

Expected failure signal:
- RPC nonce from `xcb_getTransactionCount(..., latest)` is `N`.
- `spark` debug log sends tx with nonce `N+1`.
- Then tx is not mined / or returns `already known` or `replacement transaction underpriced`.
