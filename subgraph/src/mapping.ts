import { BigInt } from "@graphprotocol/graph-ts";
import {
  Swapped,
  LiquidityAdded as LiquidityAddedEvent
} from "../generated/SuperAMM/SuperAMM";
import { Swap, LiquidityAdded } from "../generated/schema";

export function handleSwapped(event: Swapped): void {
  let entity = new Swap(
    event.transaction.hash.toHexString() + "-" + event.logIndex.toString()
  );

  entity.user = event.params.user;
  entity.amountIn = event.params.amountIn;
  entity.amountOut = event.params.amountOut;
  entity.blockNumber = event.block.number;
  entity.timestamp = event.block.timestamp;

  entity.save();
}

export function handleLiquidityAdded(event: LiquidityAddedEvent): void {
  let entity = new LiquidityAdded(
    event.transaction.hash.toHexString() + "-" + event.logIndex.toString()
  );

  entity.user = event.params.user;
  entity.amountA = event.params.amountA;
  entity.amountB = event.params.amountB;
  entity.blockNumber = event.block.number;
  entity.timestamp = event.block.timestamp;

  entity.save();
}