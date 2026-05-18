# GraphQL Queries

## 1. Recent swaps

```graphql
{
  swaps(first: 10, orderBy: timestamp, orderDirection: desc) {
    id
    user
    amountIn
    amountOut
    timestamp
  }
}
{
  liquidityAddeds(first: 10) {
    id
    user
    amountA
    amountB
  }
}
{
  swaps(where: { user: "0x0000000000000000000000000000000000000000" }) {
    id
    amountIn
    amountOut
  }
}
{
  swaps(where: { amountIn_gt: "1000000000000000000" }) {
    id
    user
    amountIn
    amountOut
  }
}
{
  liquidityAddeds(first: 5, orderBy: timestamp, orderDirection: desc) {
    id
    user
    amountA
    amountB
    timestamp
  }
}

## 6. Commit

```bash
git add .
git commit -m "feat(subgraph): add protocol indexing schema and mappings"
git push