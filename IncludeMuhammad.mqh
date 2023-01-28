//+------------------------------------------------------------------+
//|                                              IncludeMuhammad.mqh |
//|                        Copyright 2022, Muhammad Mubashir Mirza.  |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Muhammad Mubashir Mirza"
#property link      "https://www.mql4.com"
#property strict
//+------------------------------------------------------------------+
//| Include files                                                         |
//+------------------------------------------------------------------+

#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| Calculate Lot Size                                                   |
//+------------------------------------------------------------------+

double CalcLotSize(bool argDynamicLotSize, double argEquityPercent, double argStopLoss, double argFixedLotSize)
{
   double LotSize;
   if((argDynamicLotSize == true) && (argStopLoss > 0))
   {
      double RiskAmount = AccountEquity() * (argEquityPercent/100);
      double TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
      if((Point == 0.001) || (Point == 0.00001)) TickValue*=10;
      LotSize = (RiskAmount / argStopLoss) / TickValue;
   }
   else LotSize = argFixedLotSize;
   return(LotSize);
};

//+------------------------------------------------------------------+
//| Verify Lot Size                                                  |
//+------------------------------------------------------------------+

double VerifyLotSize(double argLotSize)
{ 
   if( argLotSize < (MarketInfo(Symbol(), MODE_MINLOT))) argLotSize = MarketInfo(Symbol(), MODE_MINLOT);
   else if( argLotSize > (MarketInfo(Symbol(), MODE_MAXLOT))) argLotSize = MarketInfo(Symbol(), MODE_MAXLOT);
   if( MarketInfo(Symbol(), MODE_LOTSTEP) == 0.1) argLotSize = NormalizeDouble(argLotSize, 1);
   else argLotSize = NormalizeDouble(argLotSize, 2);
   return(argLotSize);
};

//+------------------------------------------------------------------+
//| Open Buy Order                                                  |
//+------------------------------------------------------------------+

int OpenBuyOrder(string argSymbol, double argLotSize, int argSlippage, int argMagicNumber, string argComment = "Muhammad V1.0")
{
   while(IsTradeContextBusy()) Sleep(10);
               //Place Buy Order
   int Ticket = OrderSend(argSymbol, OP_BUY, argLotSize, MarketInfo(argSymbol, MODE_ASK), argSlippage, 0, 0, argComment, argMagicNumber, 0, clrGreen);
               //Error Handling
   if (Ticket == -1)
   {
      int ErrCode = GetLastError();
      string ErrDesc = ErrorDescription(ErrCode);
      string ErrAlert = StringConcatenate("Open Buy Order Error - ", ErrCode, " : ", ErrDesc);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID), ", Ask: ", MarketInfo(argSymbol, MODE_ASK), ", LotSize = ", argLotSize);
      Print(ErrLog); 
   };
   return Ticket;
};

//+------------------------------------------------------------------+
//| Open Sell Order                                                 |
//+------------------------------------------------------------------+

int OpenSellOrder(string argSymbol, double argLotSize, int argSlippage, int argMagicNumber, string argComment = "Muhammad V1.0")
{
   while(IsTradeContextBusy()) Sleep(10);
            //Place Sell Order
   int Ticket = OrderSend(argSymbol, OP_SELL, argLotSize, MarketInfo(argSymbol, MODE_BID), argSlippage, 0, 0, argComment, argMagicNumber, 0, clrRed);
            //Error Handling
   if( Ticket == -1 )
   {
      int ErrCode = GetLastError();
      string ErrDes = ErrorDescription(ErrCode);
      string ErrAlert = StringConcatenate("Open Sell Order Error - ", ErrCode, " : ", ErrDes);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID), ", Ask: ", MarketInfo(argSymbol, MODE_ASK), ", LotSize: ", argLotSize);
      Print(ErrLog);
   };
   return Ticket;
};

//+------------------------------------------------------------------+
//| Open BuyStop Order                                                 |
//+------------------------------------------------------------------+

int OpenBuyStopOrder(string argSymbol, double argLotSize, double argPendingPrice, double argStopLoss, double argTakeProfit, int argSlippage, 
                     int argMagicNumber, datetime argExpiration=0, string argComment = "Muhammad v1.0")
{
   while(IsTradeContextBusy()) Sleep(10);
   
      //Place BuyStop Order
   int Ticket = OrderSend(argSymbol, OP_BUYSTOP, argLotSize, argPendingPrice, argSlippage, argStopLoss, argTakeProfit, argComment, argMagicNumber,
                          argExpiration, clrGreen);
      //Error Handling
   if(Ticket = -1)
   {
      int ErrCode = GetLastError();
      string ErrDesc = ErrorDescription(ErrCode);
      string ErrAlert = StringConcatenate("Open BuyStop Order Error - ", ErrCode, ", : ", ErrDesc);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Ask: ",MarketInfo(argSymbol,MODE_ASK)," Lots: ",argLotSize," Price: ",argPendingPrice, 
                        " Stop: ",argStopLoss," Profit: ",argTakeProfit," Expiration: ",TimeToStr(argExpiration)); 
      Print(ErrLog);
   };
   return Ticket;
};

//+------------------------------------------------------------------+
//| Open SellStop Order                                                 |
//+------------------------------------------------------------------+

int OpenSellStopOrder(string argSymbol, double argLotSize, double argPendingPrice, double argStopLoss, double argTakeProfit, int argSlippage, 
                     int argMagicNumber, datetime argExpiration=0, string argComment = "Muhammad v1.0")
{
   while(IsTradeContextBusy()) Sleep(10);
   
      //Place SellStop Order
   int Ticket = OrderSend(argSymbol, OP_SELLSTOP, argLotSize, argPendingPrice, argSlippage, argStopLoss, argTakeProfit, argComment, argMagicNumber,
                          argExpiration, clrRed);
      //Error Handling
   if(Ticket = -1)
   {
      int ErrCode = GetLastError();
      string ErrDesc = ErrorDescription(ErrCode);
      string ErrAlert = StringConcatenate("Open SellStop Order Error - ", ErrCode, ", : ", ErrDesc);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID)," Lots: ",argLotSize," Price: ",argPendingPrice," Stop: ", 
                                          argStopLoss," Profit: ",argTakeProfit," Expiration: ",TimeToStr(argExpiration));
      Print(ErrLog);
   };
   return Ticket;
};

//+------------------------------------------------------------------+
//| Open BuyLimit Order                                              |
//+------------------------------------------------------------------+

int OpenBuyLimitOrder(string argSymbol, double argLotSize, double argPendingPrice, double argStopLoss, double argTakeProfit, int argSlippage, 
                        int argMagicNumber, datetime argExpiration, string argComment = "Muhammad v1.0")
{
   while(IsTradeContextBusy()) Sleep(10);
      //Place BuyLimit Order
   int Ticket = OrderSend(argSymbol, OP_BUYLIMIT, argLotSize, argPendingPrice, argSlippage, argStopLoss, argTakeProfit, argComment, argMagicNumber,
                           argExpiration, clrGreen);
      //Error Handling
   if(Ticket == -1)
   {
      int ErrCode = GetLastError();
      string ErrDesc = ErrorDescription(ErrCode);
      string ErrAlert = StringConcatenate("Open BuyLimit Order Error - ", ErrCode, " : ", ErrDesc);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID)," Lots: ",argLotSize," Price: ",argPendingPrice," Stop: ", 
                                          argStopLoss," Profit: ",argTakeProfit," Expiration: ",TimeToStr(argExpiration));
      Print(ErrLog);
   };
   return Ticket;
};

//+------------------------------------------------------------------+
//| Open SellLimit Order                                              |
//+------------------------------------------------------------------+

int OpenSellLimitOrder(string argSymbol, double argLotSize, double argPendingPrice, double argStopLoss, double argTakeProfit, int argSlippage, 
                        int argMagicNumber, datetime argExpiration, string argComment = "Muhammad v1.0")
{
   while(IsTradeContextBusy()) Sleep(10);
      //Place SellLimit Order
   int Ticket = OrderSend(argSymbol, OP_SELLLIMIT, argLotSize, argPendingPrice, argSlippage, argStopLoss, argTakeProfit, argComment, argMagicNumber,
                           argExpiration, clrRed);
      //Error Handling
   if(Ticket == -1)
   {
      int ErrCode = GetLastError();
      string ErrDesc = ErrorDescription(ErrCode);
      string ErrAlert = StringConcatenate("Open SellLimit Order Error - ", ErrCode, " : ", ErrDesc);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Ask: ",MarketInfo(argSymbol,MODE_ASK)," Lots: ",argLotSize," Price: ",argPendingPrice," Stop: ", 
                                             argStopLoss," Profit: ",argTakeProfit," Expiration: ",TimeToStr(argExpiration));
      Print(ErrLog);
   };
   return Ticket;
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
//| Get Slippage Function                                             |
//+------------------------------------------------------------------+

int GetSlippage( string Currency, int SlippagePips)
{
   double CalcSlippage;
   double CalcDigits = MarketInfo(Currency, MODE_DIGITS);
   if( ( CalcDigits == 2 ) || ( CalcDigits == 4 ) ) CalcSlippage = SlippagePips;
   else if( ( CalcDigits == 3 ) || ( CalcDigits == 5 ) ) CalcSlippage = SlippagePips * 10;
   return(CalcSlippage);
};

//+------------------------------------------------------------------+
//| Close Buy Order                           |
//+------------------------------------------------------------------+

bool CloseBuyOrder(string argSymbol, int argCloseTicket, double argSlippage)
{
   bool Closed;
   OrderSelect(argCloseTicket, SELECT_BY_TICKET);
   if(OrderCloseTime()==0)
   {
      double CloseLots = OrderLots();
      while(IsTradeContextBusy()) Sleep(10);
      double ClosePrice = MarketInfo(argSymbol, MODE_BID);
      Closed = OrderClose(argCloseTicket, CloseLots, ClosePrice, argSlippage, clrGreen);
               //Error Handling
      if(Closed == false)
      {
         int ErrCode = GetLastError();
         string ErrDes = ErrorDescription(ErrCode);
         string ErrAlert = StringConcatenate("Close Buy Order Error - ", ErrCode, " : ", ErrDes);
         Alert(ErrAlert);
         string ErrLog = StringConcatenate("Ticket: ", argCloseTicket, ", Bid: ", MarketInfo(argSymbol, MODE_BID));
         Print(ErrLog);
      };
   };
   return(Closed);
};

//+------------------------------------------------------------------+
//| Close Sell Order                         |
//+------------------------------------------------------------------+

bool CloseSellOrder(string argSymbol, int argCloseTicket, double argSlippage)
{
   bool Closed;
   OrderSelect(argCloseTicket, SELECT_BY_TICKET);
   if(OrderCloseTime()==0)
   {
      double CloseLots = OrderLots();
      while(IsTradeContextBusy()) Sleep(10);
      double ClosePrice = MarketInfo(argSymbol, MODE_ASK);
      Closed = OrderClose(argCloseTicket, CloseLots, ClosePrice, argSlippage, Red);
      if(Closed == false)
      {
         int ErrCode = GetLastError();
         string ErrDes = ErrorDescription(ErrCode);
         string ErrAlert = StringConcatenate("Close Sell Order Error - ", ErrCode, " : ", ErrDes);
         Alert(ErrAlert);
         string ErrLog = StringConcatenate("Ticket: ", argCloseTicket, ", Ask: ", MarketInfo(argSymbol, MODE_ASK));
         Print(ErrLog);
      };
   };
   return(Closed);
};

//+------------------------------------------------------------------+
//| Close Pending Order                         |
//+------------------------------------------------------------------+

bool ClosePendingOrder(string argSymbol, int argCloseTicket)
{
   OrderSelect(argCloseTicket, SELECT_BY_TICKET);
   bool Deleted;
   if(OrderCloseTime() == 0)
   {
      while(IsTradeContextBusy()) Sleep(10);
      Deleted = OrderDelete(argCloseTicket, clrRed);
      if(Deleted == false)
      {
         int ErrCode = GetLastError();
         string ErrDesc = ErrorDescription(ErrCode);
         string ErrAlert = StringConcatenate("Close Pending Order Error - ", ErrCode, " : ", ErrDesc);
         Alert(ErrAlert);
         string ErrLog = StringConcatenate("Ticket: ",argCloseTicket," Bid: ",MarketInfo(argSymbol,MODE_BID)," Ask: ",MarketInfo(argSymbol,MODE_ASK));
         Print(ErrLog);
      };
   };
   return Deleted;
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
//| Verify Upper Stop Level                       |
//+------------------------------------------------------------------+

bool VerifyUpperStopLevel(string argSymbol, double argVerifyPrice, double argOpenPrice = 0)
{
   double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
   double OpenPrice;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol, MODE_ASK);
   else OpenPrice = argOpenPrice;
   double UpperStopLevel = OpenPrice + StopLevel;
   bool StopVerify;
   if (argVerifyPrice > UpperStopLevel) StopVerify = true;
   else StopVerify = false;
   return(StopVerify);
};

//+------------------------------------------------------------------+
//| Verify Lower Stop Level                      |
//+------------------------------------------------------------------+

bool VerifyLowerStopLevel(string argSymbol, double argVerifyPrice, double argOpenPrice = 0)
{
   double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
   double OpenPrice;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol, MODE_BID);
   else OpenPrice = argOpenPrice;
   double LowerStopLevel = OpenPrice - StopLevel;
   bool StopVerify;
   if(argVerifyPrice < LowerStopLevel) StopVerify == true;
   else StopVerify = false;
   return(StopVerify);
};

//+------------------------------------------------------------------+
//| Adjust Above Stop Level                  |
//+------------------------------------------------------------------+

double AdjustAboveStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0)
{
   double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
   double OpenPrice;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol, MODE_ASK);
   else OpenPrice = argOpenPrice;
   double UpperStopLevel = OpenPrice + StopLevel;
   double AdjustedPrice;
   if(argAdjustPrice <= UpperStopLevel) AdjustedPrice = UpperStopLevel + (argAddPips * PipPoint(argSymbol));
   else AdjustedPrice = argAdjustPrice;
   return(AdjustedPrice);
};

//+------------------------------------------------------------------+
//| Adjust Below Stop Level                  |
//+------------------------------------------------------------------+

double AdjustBelowStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0)
{
   double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
   double OpenPrice;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol, MODE_BID);
   else OpenPrice = argOpenPrice;
   double LowerStopLevel = OpenPrice - StopLevel;
   double AdjustedPrice;
   if(argAdjustPrice >= LowerStopLevel) double AdjustedPrice = LowerStopLevel - (argAddPips * PipPoint(argSymbol));
   else AdjustedPrice = argAdjustPrice;
   return(AdjustedPrice);
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
      string ErrDes = ErrorDescription(ErrCode);
      string ErrAlert = StringConcatenate("Add Stop/Profit Error - ", ErrCode, " : ", ErrDes);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Ask: ", MarketInfo(OrderSymbol(), MODE_ASK), ", Bid: ", MarketInfo(OrderSymbol(), MODE_BID), ", Ticket: ", argTicket,
                      ", StopLoss: ", argStopLoss, ", TakeProfit: ", argTakeProfit);
   };
   return(TickMod);
};

//+------------------------------------------------------------------+
//| Total Orders Count             |
//+------------------------------------------------------------------+

int TotalOrderCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal() - 1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if ( (OrderMagicNumber() == argMagicNumber) && (OrderSymbol() == argSymbol) ) OrderCount++;
   };
   return(OrderCount);
};

//+------------------------------------------------------------------+
//| Buy Orders Count            |
//+------------------------------------------------------------------+

int BuyMarketCount( string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderMagicNumber() == argMagicNumber) && (OrderType() == OP_BUY) ) OrderCount++;
   };
   return(OrderCount);
};

//+------------------------------------------------------------------+
//| Sell Orders Count            |
//+------------------------------------------------------------------+

int SellMarketCount( string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderMagicNumber() == argMagicNumber) && (OrderType() == OP_SELL) ) OrderCount++;
   };
   return(OrderCount);
};

//+------------------------------------------------------------------+
//| BuyStop Orders Count          |
//+------------------------------------------------------------------+

int BuyStopCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if(OrderMagicNumber()==argMagicNumber && OrderSymbol()==argSymbol && OrderType()==OP_BUYSTOP)   OrderCount++;
   };
   return OrderCount;
};

//+------------------------------------------------------------------+
//| SellStop Orders Count          |
//+------------------------------------------------------------------+

int SellStopCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if(OrderMagicNumber()==argMagicNumber && OrderSymbol()==argSymbol && OrderType()==OP_SELLSTOP)   OrderCount++;
   };
   return OrderCount;
};

//+------------------------------------------------------------------+
//| BuyLimit Orders Count          |
//+------------------------------------------------------------------+

int BuyLimitCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if(OrderMagicNumber()==argMagicNumber && OrderSymbol()==argSymbol && OrderType()==OP_BUYLIMIT)   OrderCount++;
   };
   return OrderCount;
};

//+------------------------------------------------------------------+
//| SellLimit Orders Count          |
//+------------------------------------------------------------------+

int SellLimitCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if(OrderMagicNumber()==argMagicNumber && OrderSymbol()==argSymbol && OrderType()==OP_SELLLIMIT)   OrderCount++;
   };
   return OrderCount;
};

//+------------------------------------------------------------------+
//| Close All Buy Orders          |
//+------------------------------------------------------------------+

void CloseAllBuyOrders(string argSymbol, int argMagicNumber, int argSlippage)
{
   for ( int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderMagicNumber() == argMagicNumber) && (OrderType() == OP_BUY) )
      {
               // Close Order
         int CloseTicket = OrderTicket();
         double CloseLots = OrderLots();
         while(IsTradeContextBusy()) Sleep(10);
         double ClosePrice = MarketInfo(argSymbol, MODE_BID);
         bool Closed = OrderClose(CloseTicket, CloseLots, ClosePrice, argSlippage, clrRed);
               //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDes = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All Buy Orders Error - ", ErrCode, " : ", ErrDes);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID), ", Ticket: ", CloseTicket, ", Price: ", ClosePrice);
            Print(ErrLog);
         }
         else Counter--;
      };
   };
};

//+------------------------------------------------------------------+
//| Close All Sell Orders          |
//+------------------------------------------------------------------+

void CloseAllSellOrders(string argSymbol, int argMagicNumber, int argSlippage)
{
   for ( int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderMagicNumber() == argMagicNumber) && (OrderType() == OP_SELL) )
      {
               // Close Order
         int CloseTicket = OrderTicket();
         double CloseLots = OrderLots();
         while(IsTradeContextBusy()) Sleep(10);
         double ClosePrice = MarketInfo(argSymbol, MODE_ASK);
         bool Closed = OrderClose(CloseTicket, CloseLots, ClosePrice, argSlippage, clrRed);
               //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDes = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All Sell Orders Error - ", ErrCode, " : ", ErrDes);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Ask: ", MarketInfo(argSymbol, MODE_ASK), ", Ticket: ", CloseTicket, ", Price: ", ClosePrice);
            Print(ErrLog);
         }
         else Counter--;
      };
   };
};

//+------------------------------------------------------------------+
//| Close All BuyStop Orders          |
//+------------------------------------------------------------------+

void CloseAllBuyStopOrders(string argSymbol, int argMagicNumber)
{
   for(int Counter = 0; Counter<=OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_TICKET);
      if(OrderMagicNumber()==argMagicNumber && OrderSymbol()==argSymbol && OrderType()==OP_BUYSTOP)
      {
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         bool Closed = OrderDelete(CloseTicket ,clrRed);
            //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All BuyStop Order Error - ", ErrCode, " : ", ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID), " Ask: ",MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
         else Counter--;
      };
   };
};

//+------------------------------------------------------------------+
//| Close All SellStop Orders          |
//+------------------------------------------------------------------+

void CloseAllSellStopOrders(string argSymbol, int argMagicNumber)
{
   for(int Counter = 0; Counter<=OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_TICKET);
      if(OrderMagicNumber()==argMagicNumber && OrderSymbol()==argSymbol && OrderType()==OP_SELLSTOP)
      {
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         bool Closed = OrderDelete(CloseTicket ,clrRed);
            //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All SellStop Order Error - ", ErrCode, " : ", ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID), " Ask: ",MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
         else Counter--;
      };
   };
};

//+------------------------------------------------------------------+
//| Close All BuyLimit Orders          |
//+------------------------------------------------------------------+

void CloseAllBuyLimitOrders(string argSymbol, int argMagicNumber)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if(OrderSymbol()==argSymbol && OrderMagicNumber()==argMagicNumber && OrderType()==OP_BUYLIMIT)
      {
               //Delete Order
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         bool Closed = OrderDelete(CloseTicket , clrRed);
               //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All BuyLimit Orders Error - ", ErrCode, " : ", ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID), " Ask: ",MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
         else Counter --;
      };
   };
};

//+------------------------------------------------------------------+
//| Close All SellLimit Orders          |
//+------------------------------------------------------------------+

void CloseAllSellLimitOrders(string argSymbol, int argMagicNumber)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if(OrderSymbol()==argSymbol && OrderMagicNumber()==argMagicNumber && OrderType()==OP_SELLLIMIT)
      {
               //Delete Order
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         bool Closed = OrderDelete(CloseTicket , clrRed);
               //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All SellLimit Orders Error - ", ErrCode, " : ", ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID), " Ask: ",MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
         else Counter --;
      };
   };
};

//+------------------------------------------------------------------+
//| Buy Trailing Stop        |
//+------------------------------------------------------------------+

void BuyTrailingStop(string argSymbol, int argTrailingStop, int argMinProfit, int argMagicNubmer)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter ++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
            //Calculate Max Stop and Min Profit
      double MaxStopLoss = MarketInfo(argSymbol, MODE_BID) - (argTrailingStop * PipPoint(argSymbol));
      MaxStopLoss = NormalizeDouble(MaxStopLoss, MarketInfo(argSymbol, MODE_DIGITS));
      double CurrentStop = NormalizeDouble(OrderStopLoss(), MarketInfo(argSymbol, MODE_DIGITS));
      double PipsProfit = MarketInfo(argSymbol, MODE_BID) - OrderOpenPrice();
      double MinProfit = argMinProfit * PipPoint(argSymbol);
            //Modify Stop
      bool Trailed;
      if( (OrderMagicNumber() == argMagicNubmer) && (OrderSymbol() == argSymbol) && (OrderType() == OP_BUY) && (CurrentStop < MaxStopLoss) && (PipsProfit >= MinProfit) )
      {
         Trailed = OrderModify(OrderTicket(), OrderOpenPrice(), MaxStopLoss, OrderTakeProfit(), 0);
               //Error Handling
         if (Trailed == false)
         {
            int ErrCode = GetLastError();
            string ErrDes = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Buy Trailing Stop Error - ", ErrCode, " : ", ErrDes);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID), ", Ticket: ", OrderTicket(), ", StopLoss: ", OrderStopLoss(),
                            ", Trail: ", MaxStopLoss);
            Print(ErrLog);
         }; 
      };
   };
};

//+------------------------------------------------------------------+
//| Sell Trailing Stop        |
//+------------------------------------------------------------------+

void SellTrailingStop(string argSymbol, int argTrailingStop, int argMinProfit, int argMagicNubmer)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter ++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
            //Calculate Max Stop and Min Profit
      double MaxStopLoss = MarketInfo(argSymbol, MODE_ASK) + (argTrailingStop * PipPoint(argSymbol));
      MaxStopLoss = NormalizeDouble(MaxStopLoss, MarketInfo(argSymbol, MODE_DIGITS));
      double CurrentStop = NormalizeDouble(OrderStopLoss(), MarketInfo(argSymbol, MODE_DIGITS));
      double PipsProfit = OrderOpenPrice() - MarketInfo(argSymbol, MODE_ASK);
      double MinProfit = argMinProfit * PipPoint(argSymbol);
            //Modify Stop
      bool Trailed;
      if( (OrderMagicNumber() == argMagicNubmer) && (OrderSymbol() == argSymbol) && (OrderType() == OP_SELL) && (CurrentStop>MaxStopLoss || CurrentStop == 0 )
          && (PipsProfit >= MinProfit) )
      {
         Trailed = OrderModify(OrderTicket(), OrderOpenPrice(), MaxStopLoss, OrderTakeProfit(), 0);
               //Error Handling
         if (Trailed == false)
         {
            int ErrCode = GetLastError();
            string ErrDes = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Sell Trailing Stop Error - ", ErrCode, " : ", ErrDes);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Ask: ", MarketInfo(argSymbol, MODE_ASK), ", Ticket: ", OrderTicket(), ", StopLoss: ", OrderStopLoss(),
                            ", Trail: ", MaxStopLoss);
            Print(ErrLog);
         }; 
      };
   };
};

//+------------------------------------------------------------------+
//| Consecutive Losses Check        |
//+------------------------------------------------------------------+

void ConsecutiveLossesCheck(int ConsecutiveLosses, int MagicNumber)
{
   int losses = 0;
   int h = OrdersHistoryTotal()-1;
   for(int c=ConsecutiveLosses; c>=1; c--)
   {
      OrderSelect(h, SELECT_BY_POS, MODE_HISTORY);
      if(OrderMagicNumber()==MagicNumber && OrderProfit()<0)
         losses ++;
      h--;
   };
   if(losses >= ConsecutiveLosses)
   {
      ExpertRemove();
      Print("EA removed after ", ConsecutiveLosses, " consecutive losses.");
   };
};

//+------------------------------------------------------------------+
//| Send Telegram Messages    |
//+------------------------------------------------------------------+

void SendTelegramMessage(string url, string token, string chat, string text)
{
   string headers = "";
   string requestUrl = "";
   char   postData[];
   char   resultData[];
   string resultHeaders;
   int timeout = 1000;
   
   requestUrl = StringFormat("%s/bot%s/sendmessage?chat_id=%s&text=%s", url, token, chat, text);
   ResetLastError();
   int Response = WebRequest("POST", requestUrl, headers, timeout, postData, resultData, resultHeaders);
   
   switch( Response )
   {
      case 200:
         {
            Print("The message has been successfully sent!");
            break;
         };
      case -1:
         {
            Print("Connect to VPN and add URL to send messages!");
            break;
         };
      default:
        { int err = GetLastError();
          string errdesc = ErrorDescription(err);
          Print(err, " : ", errdesc);
          break;
        };
   };
};