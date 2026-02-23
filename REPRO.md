# Nonce Simulation Repro (Devin)

## Setup
1. `cd /home/baron/corecoin/reproduce_nonce`
2. `.env` must contain:
   - `DEVIN_ADDRESS`
   - `DEVIN_RPC_URL`
   - `DEVIN_NETWORK_ID`
3. Build: `spark build`

## Repro command
```bash
set -a && source .env && set +a
spark script script/DeployNonceBug.s.sol:DeployNonceBugScript \
  --rpc-url "$DEVIN_RPC_URL" \
  --network-id "$DEVIN_NETWORK_ID" \
  --sender "0x$DEVIN_ADDRESS" \
  --tx-origin "0x$DEVIN_ADDRESS" \
  -vvvvv
```

## Expected behavior
- Local phase prints `Script ran successfully`.
- Then on-chain simulation fails with:
  - `Transaction failed when running the on-chain simulation`
  - `EvmError: Revert`
  - Create trace mismatch (`new <Unknown>` appears first, then subsequent CREATE fails with `0 bytes of code`).

This indicates nonce/address drift in simulation replay for CREATE-dependent script flow.
