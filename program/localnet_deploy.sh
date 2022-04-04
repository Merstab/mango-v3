# devnet
if [ $# -eq 0 ]
  then
    KEYPAIR=~/.config/solana/localnet.json
  else
    KEYPAIR=$1
fi

CLUSTER_URL="http://localhost:8899"
solana config set --url $CLUSTER_URL

cd ~/merstab/mango-v3/


mkdir target/localnet
cargo build-bpf --features localnet --bpf-out-dir target/localnet

# localnet.1
MANGO_PROGRAM_ID="95vVcA2MzfMGfnH7vUA32VUau3Z9uQ9DCuA2F6gnYGT5"
solana program deploy target/localnet/mango.so --keypair $KEYPAIR --program-id $MANGO_PROGRAM_ID --output json-compact
anchor build -p mango_logs
cp ~/merstab/mango-v3/target/idl/mango_logs.json ~/merstab/mango-client-v3/src/mango_logs.json

#solana program deploy target/devnet/mango.so --keypair $KEYPAIR --output json-compact

# serum dex
DEX_PROGRAM_ID="DouSNP811YocCyMf3dnJhkrZR44vQQaRQRQLW6iFnXze"
cd ~/merstab/serum-dex/dex
anchor build
solana program deploy target/verifiable/serum_dex.so --keypair $KEYPAIR --program-id $DEX_PROGRAM_ID

# VERSION=v1.7.11
# sh -c "$(curl -sSfL https://release.solana.com/$VERSION/install)"

### Example Mango Client CLI commands to launch a new group from source/cli.ts in mango-client-v3
###
### yarn cli init-group mango_test_v3.4 32WeJ46tuY6QEkgydqzHYU5j85UT9m1cPJwFxPjuSVCt DESVgJVGajEgKGXhb6XmqDHGz3VjdgP7rEVESBgxmroY EMjjdsqERN4wJUR9jMBax2pzqQPeGLNn5NeucbHpDUZK
### yarn cli add-oracle mango_test_v3.4 BTC
### yarn cli set-oracle mango_test_v3.4 BTC 40000000
### yarn cli add-spot-market mango_test_v3.4 BTC E1mfsnnCcL24JcDQxr7F2BpWjkyy5x2WHys8EL2pnCj9 bypQzRBaSDWiKhoAw3hNkf35eF3z3AZCU8Sxks6mTPP
### yarn cli add-perp-market mango_test_v3.4 BTC
