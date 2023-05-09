//+------------------------------------------------------------------+
//|                                                     TRAIL_EA.mq4 |
//|                         Copyright 2023, Muhammad Mubashir Mirza. |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza."
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#include <stdlib.mqh>
//+------------------------------------------------------------------+
//| External and Global Variables                                    |
//+------------------------------------------------------------------+
enum long_type
{
   MIDDLE = 0,
   LOWER = 1
};
enum short_type
{
   MIDDLE_ = 0,
   UPPER = 1
};
extern int DonchianPeriod = 50;
extern int Displacement = 0;
extern long_type LONG_TYPE = LOWER;
extern short_type SHORT_TYPE = UPPER;
double buy_stoploss;
double sell_stoploss;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectDelete(0, "upper");
   ObjectDelete(0, "lower");
   ObjectDelete(0, "middle");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double channel_lower = iCustom(Symbol(), 0, "Donchian Channel.ex4", DonchianPeriod, 1, Displacement, 1, 700, 1, 0);
   double channel_upper = iCustom(Symbol(), 0, "Donchian Channel.ex4", DonchianPeriod, 1, Displacement, 1, 700, 0, 0);
   double channel_middle = (channel_lower + channel_upper) / 2;
   
   channel_lower = NormalizeDouble(channel_lower, 5);
   channel_upper = NormalizeDouble(channel_upper, 5);
   channel_middle = NormalizeDouble(channel_middle, 5);
   
   if(channel_upper<channel_lower)
   {
      double temp = channel_upper;
      channel_upper = channel_lower;
      channel_lower = temp;
   };
   
   if(LONG_TYPE==LOWER) buy_stoploss = channel_lower;
   else buy_stoploss = channel_middle;
   if(SHORT_TYPE==UPPER)   sell_stoploss = channel_upper;
   else sell_stoploss = channel_middle;
   
   //buy_stoploss = AdjustBelowStopLevel(Symbol(), buy_stoploss);
   //sell_stoploss = AdjustAboveStopLevel(Symbol(), sell_stoploss);
   
   ObjectDelete(0, "upper");
   ObjectDelete(0, "lower");
   ObjectDelete(0, "middle");
   
   ObjectCreate(0, "upper", OBJ_HLINE, 0, TimeCurrent(), channel_upper);
   ObjectCreate(0, "lower", OBJ_HLINE, 0, TimeCurrent(), channel_lower);
   ObjectCreate(0, "middle", OBJ_HLINE, 0, TimeCurrent(), channel_middle);
  
   ObjectSetInteger(0, "upper", OBJPROP_COLOR, clrHotPink);
   ObjectSetInteger(0, "lower", OBJPROP_COLOR, clrHotPink);
   ObjectSetInteger(0, "middle", OBJPROP_COLOR, clrHotPink);
   
   if(TotalOrderCount(Symbol())>0)
   {
      BuyTrailingStop(Symbol(), buy_stoploss);
      SellTrailingStop(Symbol(), sell_stoploss);
   }
};
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| PipPoint Function                                              |
//+------------------------------------------------------------------+

double PipPoint( string Currency )
{
   double CalcPoint;
   int CalcDigits = MarketInfo(Currency, MODE_DIGITS);
   if ( ( CalcDigits == 2) || ( CalcDigits == 3) ) CalcPoint = 0.01;
   if ( ( CalcDigits == 4) || ( CalcDigits == 5) ) CalcPoint = 0.0001;
   return(CalcPoint);
};
//------------------------------------------------------------------+
//| Total Orders Count             |
//+------------------------------------------------------------------+

int TotalOrderCount(string argSymbol)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal() - 1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
      if (OrderSymbol() == argSymbol ) OrderCount++;
   };
   return(OrderCount);
};
//+------------------------------------------------------------------+
//| Buy Trailing Stop        |
//+------------------------------------------------------------------+

void BuyTrailingStop(string argSymbol, double argTrailingStop)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter ++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
            //Calculate Max Stop and Min Profit
     // double MaxStopLoss = MarketInfo(argSymbol, MODE_BID) - (argTrailingStop * PipPoint(argSymbol));
     // MaxStopLoss = NormalizeDouble(MaxStopLoss, MarketInfo(argSymbol, MODE_DIGITS));
      double MaxStopLoss = argTrailingStop;
      double CurrentStop = NormalizeDouble(OrderStopLoss(), MarketInfo(argSymbol, MODE_DIGITS));
            //Modify Stop
      bool Trailed;
      if( (OrderSymbol() == argSymbol) && (OrderType() == OP_BUY) && (CurrentStop != MaxStopLoss) )
      {
         Trailed = OrderModify(OrderTicket(), OrderOpenPrice(), MaxStopLoss, OrderTakeProfit(), 0);
               //Error Handling
         if (Trailed == false && GetLastError()!=1)
         {
            int ErrCode = GetLastError();
            string ErrDes = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Buy Trailing Stop Error - ", ErrCode, " : ", ErrDes);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("BuyTrailingStop Error, Bid: ", MarketInfo(argSymbol, MODE_BID), ", Ticket: ", OrderTicket(), ", StopLoss: ", OrderStopLoss(),
                            ", Trail: ", MaxStopLoss);
            Print(ErrLog);
         }; 
      };
   };
};

//+------------------------------------------------------------------+
//| Sell Trailing Stop        |
//+------------------------------------------------------------------+

void SellTrailingStop(string argSymbol, double argTrailingStop)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter ++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
            //Calculate Max Stop and Min Profit
     // double MaxStopLoss = MarketInfo(argSymbol, MODE_ASK) + (argTrailingStop * PipPoint(argSymbol));
      //MaxStopLoss = NormalizeDouble(MaxStopLoss, MarketInfo(argSymbol, MODE_DIGITS));
      double MaxStopLoss = argTrailingStop;
      double CurrentStop = NormalizeDouble(OrderStopLoss(), MarketInfo(argSymbol, MODE_DIGITS));
            //Modify Stop
      bool Trailed;
      if( (OrderSymbol() == argSymbol) && (OrderType() == OP_SELL) && (CurrentStop != MaxStopLoss) )
      {
         Trailed = OrderModify(OrderTicket(), OrderOpenPrice(), MaxStopLoss, OrderTakeProfit(), 0);
               //Error Handling
         if (Trailed == false && GetLastError()!=1)
         {
            int ErrCode = GetLastError();
            string ErrDes = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Sell Trailing Stop Error - ", ErrCode, " : ", ErrDes);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("SellTrailingStop Error, Ask: ", MarketInfo(argSymbol, MODE_ASK), ", Ticket: ", OrderTicket(), ", StopLoss: ", OrderStopLoss(),
                            ", Trail: ", MaxStopLoss);
            Print(ErrLog);
         }; 
      };
   };
};