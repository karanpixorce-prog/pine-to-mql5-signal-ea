//+------------------------------------------------------------------+
//| EMA_Cross_Signal.mq5                                             |
//| Signal-only example: prints a closed-bar EMA cross, no trades.   |
//| Educational code. Compile it in MetaEditor before you use it.    |
//+------------------------------------------------------------------+
#property strict
#property description "Signal-only EMA cross. Compare the printed crosses with TradingView."

input int FastPeriod = 10;
input int SlowPeriod = 30;

int      fastHandle       = INVALID_HANDLE;
int      slowHandle       = INVALID_HANDLE;
datetime lastProcessedBar = 0;

int OnInit()
{
   if(FastPeriod >= SlowPeriod)
   {
      Print("FastPeriod must be smaller than SlowPeriod.");
      return INIT_PARAMETERS_INCORRECT;
   }

   fastHandle = iMA(_Symbol, _Period, FastPeriod, 0, MODE_EMA, PRICE_CLOSE);
   slowHandle = iMA(_Symbol, _Period, SlowPeriod, 0, MODE_EMA, PRICE_CLOSE);
   if(fastHandle == INVALID_HANDLE || slowHandle == INVALID_HANDLE)
   {
      Print("Could not create EMA handles. Error: ", GetLastError());
      return INIT_FAILED;
   }
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   if(fastHandle != INVALID_HANDLE) IndicatorRelease(fastHandle);
   if(slowHandle != INVALID_HANDLE) IndicatorRelease(slowHandle);
}

void OnTick()
{
   // Once per bar: skip ticks until a new bar opens.
   const datetime currentBar = iTime(_Symbol, _Period, 0);
   if(currentBar == 0 || currentBar == lastProcessedBar)
      return;

   // Shift 1 and 2 = the last two CLOSED bars. Index 0 is shift 2, index 1 is shift 1.
   double fast[2], slow[2];
   if(CopyBuffer(fastHandle, 0, 1, 2, fast) != 2 ||
      CopyBuffer(slowHandle, 0, 1, 2, slow) != 2)
      return;                      // data not ready, retry on the next tick

   lastProcessedBar = currentBar;  // saved only after both reads succeeded

   const bool crossedUp   = fast[0] <= slow[0] && fast[1] > slow[1];
   const bool crossedDown = fast[0] >= slow[0] && fast[1] < slow[1];
   if(crossedUp)   Print("Closed-bar EMA cross up.");
   if(crossedDown) Print("Closed-bar EMA cross down.");
}
