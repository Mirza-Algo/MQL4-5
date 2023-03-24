//+------------------------------------------------------------------+
//|                                                        SALEM.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza."
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#property strict
#include <stdlib.mqh>
extern double TP_DOLLARS = 10.0;
double effective_lots=0.0;
double TakeProfit;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   effective_lots = 0.0;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(EffectiveLots(Symbol())==0 && CountMainOrders(Symbol())!=0)
   {
      Alert("Buys and Sells Lots Equal, nothing changed!");
   };
   if((effective_lots!=EffectiveLots(Symbol()) && (EffectiveLots(Symbol())!=0)))
   {
      effective_lots = EffectiveLots(Symbol());
      double avg_price = CalcAvgPrice(Symbol());
      double TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
      if((Point == 0.001) || (Point == 0.00001)) TickValue*=10;
      TakeProfit = TP_DOLLARS/(effective_lots*TickValue);
      TakeProfit = MathAbs(TakeProfit);
      bool Convention1 = (MathAbs(effective_lots)==effective_lots);
      SetTakeProfits(TakeProfit, Convention1, Symbol());
      NormalizeStops(Symbol());
   };
  }
//+------------------------------------------------------------------+
double EffectiveLots(string argSymbol)
{
   double lots = 0.0;
   for(int Counter = 0; Counter<=OrdersTotal()-1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==argSymbol && OrderType()==OP_BUY)  lots = lots + OrderLots();
      else if(OrderSymbol()==argSymbol && OrderType()==OP_SELL)  lots = lots - OrderLots();
   };
   lots = NormalizeDouble(lots, 2);
   return(lots);
};
double CalcAvgPrice(string argSymbol)
{
    double price = 0.0;
    for(int Counter = 0; Counter<=OrdersTotal()-1; Counter++)
    {
      OrderSelect(Counter, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==argSymbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))  price = price + OrderOpenPrice();
    };
    price = price / OrdersTotal();
    price = NormalizeDouble(price, 5);
    return(price);
};
void SetTakeProfits(double argTakeProfit, bool argConvention, string argSymbol)
{
   for(int Counter = 0; Counter<=OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==argSymbol && OrderType()==0 && argConvention==True)
      {
         double tp = CalcBuyTakeProfit(Symbol(), argTakeProfit, OrderOpenPrice());
         AddStopProfit(OrderTicket(), 0.00000, tp);
      }
      else if(OrderSymbol()==argSymbol && OrderType()==1 && argConvention==True)
      {
         double sl = CalcSellStopLoss(Symbol(), argTakeProfit, OrderOpenPrice());
         AddStopProfit(OrderTicket(), sl, 0.00000);
      }
      else if(OrderSymbol()==argSymbol && OrderType()==0 && argConvention==False)
      {
         double sl = CalcBuyStopLoss(Symbol(), argTakeProfit, OrderOpenPrice());
         sl = sl + (MarketInfo(Symbol(), MODE_SPREAD)/10000);
         AddStopProfit(OrderTicket(), sl, 0.00000);
      }
      else if(OrderSymbol()==argSymbol && OrderType()==1 && argConvention==False)
      {
         double tp = CalcSellTakeProfit(Symbol(), argTakeProfit, OrderOpenPrice());
         AddStopProfit(OrderTicket(), 0.00000, tp);
      };
   };
};
//+------------------------------------------------------------------+
//| Calculate Buy Take Profit                     |
//+------------------------------------------------------------------+

double CalcBuyTakeProfit(string argSymbol, int argTakeProfit, double argOpenPrice)
{
   if(argTakeProfit == 0) return(0);
   double BuyTakeProfit = argOpenPrice + (argTakeProfit * PipPoint(argSymbol));
   return(BuyTakeProfit);
};

//+------------------------------------------------------------------+
//| Calculate Sell Take Profit                       |
//+------------------------------------------------------------------+

double CalcSellTakeProfit(string argSymbol, int argTakeProfit, double argOpenPrice)
{
   if(argTakeProfit == 0) return(0);
   double SellTakeProfit = argOpenPrice - (argTakeProfit * PipPoint(argSymbol));
   return(SellTakeProfit);
};
//+------------------------------------------------------------------+
//| Add Stop Loss and Take Profit                  |
//+------------------------------------------------------------------+

bool AddStopProfit(int argTicket, double argStopLoss, double argTakeProfit)
{
   OrderSelect(argTicket, SELECT_BY_TICKET);
   double OpenPrice = OrderOpenPrice();
   while(IsTradeContextBusy()) Sleep(10);
         //Modify Order
   bool TickMod = OrderModify(argTicket, OpenPrice, argStopLoss, argTakeProfit, 0);
         //Error Handling
   if(TickMod == false)
   {
      int ErrCode = GetLastError();
      if(ErrCode==1) return(TickMod);
      string ErrDes = ErrorDescription(ErrCode);
      string ErrAlert = StringConcatenate("Add Stop/Profit Error - ", ErrCode, " : ", ErrDes);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Ask: ", MarketInfo(OrderSymbol(), MODE_ASK), ", Bid: ", MarketInfo(OrderSymbol(), MODE_BID), ", Ticket: ", argTicket,
                      ", StopLoss: ", argStopLoss, ", TakeProfit: ", argTakeProfit);
   };
   return(TickMod);
};
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
//+------------------------------------------------------------------+
//| Calculate Buy Stop Loss                     |
//+------------------------------------------------------------------+

double CalcBuyStopLoss(string argSymbol, int argStopLoss, double argOpenPrice)
{
   if(argStopLoss == 0) return(0);
   double BuyStopLoss = argOpenPrice - (argStopLoss * PipPoint(argSymbol));
   return(BuyStopLoss);
};

//+------------------------------------------------------------------+
//| Calculate Sell Stop Loss                        |
//+------------------------------------------------------------------+

double CalcSellStopLoss(string argSymbol, int argStopLoss, double argOpenPrice)
{
   if(argStopLoss == 0) return(0);
   double SellStopLoss = argOpenPrice + (argStopLoss * PipPoint(argSymbol));
   return(SellStopLoss);
};
//------------------------------------------------------------------------
void NormalizeStops(string argSymbol)
{
   double temp = 0.0;
   for(int Counter = 0; Counter<=OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==argSymbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
      {
         temp = temp + OrderTakeProfit();
         temp = temp + OrderStopLoss();
      };
   };
   temp = temp / CountMainOrders(Symbol());
   for(int Counter = 0; Counter<=OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==argSymbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
      {
         if(OrderTakeProfit()!=0)   AddStopProfit(OrderTicket(), 0, temp);
         else if(OrderStopLoss()!=0)   AddStopProfit(OrderTicket(), temp, 0);
      };
   };
};
int CountMainOrders(string argSymbol)
{
   int return_value = 0;
   for(int Counter = 0; Counter<=OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==argSymbol && (OrderType()==OP_BUY || OrderType()==OP_SELL)) return_value = return_value + 1;
   };
   Print("Return Value: ", return_value);
   return(return_value);
};