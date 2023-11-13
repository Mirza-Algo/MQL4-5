//+------------------------------------------------------------------+
//|                                                     Evacuate.mq4 |
//|                                  Copyright 2023, Mubashir Mirza. |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Mubashir Mirza."
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#property strict
#include <stdlib.mqh>
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
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double PnL = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      bool selected = OrderSelect(i, SELECT_BY_POS);
      PnL += OrderProfit();
   };
   if(PnL>=0)
   {
      long chart_id = ChartFirst();
      while(chart_id >= 0)
      {
         if(chart_id != ChartID())  ChartClose(chart_id);
         chart_id = ChartNext(chart_id);
      };
      CloseAllOrders();
      ExpertRemove();
   };
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Close All Orders                                                 |
//+------------------------------------------------------------------+

void CloseAllOrders()
{
   for ( int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
         bool selected = OrderSelect(Counter, SELECT_BY_POS);
               // Close Order
         int CloseTicket = OrderTicket();
         double CloseLots = OrderLots();
         while(IsTradeContextBusy()) Sleep(10);
         double ClosePrice = 0;
         if(OrderType()==OP_BUY) ClosePrice = MarketInfo(OrderSymbol(), MODE_BID);
         else if(OrderType()==OP_SELL) ClosePrice = MarketInfo(OrderSymbol(), MODE_ASK);
         bool Closed = OrderClose(CloseTicket, CloseLots, ClosePrice, 0, clrRed);
               //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDes = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All Orders Error - ", ErrCode, " : ", ErrDes);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ", MarketInfo(OrderSymbol(), MODE_BID), ", Ticket: ", CloseTicket, ", Price: ", ClosePrice);
            Print(ErrLog);
         }
         else Counter--;
   };
};