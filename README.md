# Pine Script to MQL5: a signal-only EA to check your bar timing

A small MetaTrader 5 Expert Advisor that prints a closed-bar EMA cross. It places **no trades**. Use it as the first step when you convert a TradingView Pine Script strategy to MQL5: get the signals to match the chart before you add any order code.

It is the MQL5 version of this Pine Script:

```pine
//@version=5
strategy("EMA Cross", overlay = true)
fast = ta.ema(close, 10)
slow = ta.ema(close, 30)
if ta.crossover(fast, slow)
    strategy.entry("Long", strategy.long)
```

## What it shows

- **Closed bars only.** It reads shift 1 and 2, not the bar that is still forming.
- **Once per bar.** A new-bar check stops `OnTick()` from repeating the same signal.
- **Retry on missing data.** The bar time is saved only after both `CopyBuffer()` calls succeeded.

## How to use it

1. Copy `EMA_Cross_Signal.mq5` to `MQL5/Experts` and compile it in MetaEditor.
2. Attach it to a chart and watch the Experts tab.
3. Put the same EMAs (10 and 30, close) on the same symbol and timeframe in TradingView.
4. Compare each printed cross with the cross on the chart. If one is a bar early or late, fix the shift before you add orders.

## Status

The code is educational. It was not tested in every terminal build, so compile it yourself and check the result.

## Learn more

- Full conversion guide: https://codeflowos.com/blog/pine-script-to-mql5-guide
- Pine Script to MQL5 converter (first-draft tool, review the output): https://codeflowos.com/pine-script-to-mql5

Disclosure: maintained by the author of CodeFlowOS. Not financial advice. Not a trading system.
