Pine Script to MQL5: a signal-only EA to check your bar timing
A small MetaTrader 5 Expert Advisor that prints a closed-bar EMA cross. It places no trades. Use it as the first step when you convert a TradingView Pine Script strategy to MQL5: get the signals to match the chart before you add any order code.
It is the MQL5 version of this Pine Script:
//@version=5
strategy("EMA Cross", overlay = true)
fast = ta.ema(close, 10)
slow = ta.ema(close, 30)
if ta.crossover(fast, slow)
    strategy.entry("Long", strategy.long)
What it shows
Closed bars only. It reads shift 1 and 2, not the bar that is still forming.
Once per bar. A new-bar check stops OnTick() from repeating the same signal.
Retry on missing data. The bar time is saved only after both CopyBuffer() calls succeeded.