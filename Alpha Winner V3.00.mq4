//+------------------------------------------------------------------+
//|                                                 Alpha Winner.mq4 |
//|                         Copyright 2023, Muhammad Mubashir Mirza. |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza."
#property link      "mirza.mubashir786@hotmail.com"
#property version   "3.00" //Document version 23.10.21
#property strict
#include <stdlib.mqh>
//+------------------------------------------------------------------+
//| External and Global Variabls                                     |
//+------------------------------------------------------------------+
enum lotsizingscheme
{
   A,
   B
};
extern double AlphaUnitsTP = 3.0;
extern lotsizingscheme LotSizingScheme = A;
extern const string A = "---Lot Sizing Scheme A---";
extern double StartingLS = 1.0;
extern double LSMultiplier = 1.1;
extern double MaxLS = 2.5;
extern const string B = "---Lot Sizing Scheme B---";
extern double StartingLs   = 0.02;
extern double LsMultiplier = 1.3;
double lots[20];
double LSCount;
double LS;
double RepNum;
double NumOfChunks = 20;
double ChunkSize;
double StopLoss;
double StartingTP;
double CalcAlphaUnitsTP;
int MagicNumber = 82995;
int BuyTicket, SellTicket;
double glCalcAlphaUnitsTPBuySide;
double glCalcAlphaUnitsTPSellSide;

double highest_unrealized_drawdown = 0.0;
double highest_unrealized_drawdown_p = 0.0;
double current_drawdown;
double current_drawdown_p;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- 
   //Alert(AccountMargin());
   StopLoss = 80.0;
   StartingTP = 1.0;
   StartingTP /= PipPoint(Symbol());
   StopLoss /= PipPoint(Symbol());
   CalcAlphaUnitsTP = 0;
   //-------------Global Variables Setting/Getting--------------------
   if(GlobalVariableGet("CalcAlphaUnitsTPBuySide", glCalcAlphaUnitsTPBuySide)==false)
   {
      GlobalVariableSet("CalcAlphaUnitsTPBuySide", 0.0);
   }
   if(GlobalVariableGet("CalcAlphaUnitsTPSellSide", glCalcAlphaUnitsTPSellSide)==false)
   {
      GlobalVariableSet("CalcAlphaUnitsTPSellSide", 0.0);
   }
   //---------------------------------------------------------------------
   ObjectsDeleteAll();
//+------------------------------------------------------------------+
//| Lot Size Calculation                                             |
//+------------------------------------------------------------------+
   if(LotSizingScheme==0)
   {
   LSCount = 1;
   LS = StartingLS;
   while(LS<=MaxLS)
   {  
      if(LS*LSMultiplier>MaxLS)  break;      
      LS *= LSMultiplier;
      LSCount++;
   };
   RepNum = MaxLS / LSCount;
   RepNum = MathRound(RepNum);
   ChunkSize = MathRound(NumOfChunks/LSCount);
   int i = 0;
   LS = StartingLS;
   while(i<20)
   {
      if(i>0)  LS *= LSMultiplier;
      double ChunkSizeTemp = ChunkSize;
      while(ChunkSizeTemp>0)
      {
         if(i>=20)   break;
         lots[i] = NormalizeDouble(LS, 2);
         ChunkSizeTemp--;
         i++;
      };
   };
   }
   else
   {
      lots[0] = StartingLs;
      for(int c = 1; c<20; c++)
      {
         lots[c] = NormalizeDouble(lots[c-1]*LsMultiplier, 2);
      };
   };
   
//-----CHECK LOTISZE ARRAY--------  
   for(int c = 0; c<20; c++)
   {
      Print(lots[c]);
   };
//----------------HUD-------------------------------------------------------------
   if(GlobalVariableGet("HUD", highest_unrealized_drawdown)==false)
   {
      GlobalVariableSet("HUD", 0.0);
   }
   if(GlobalVariableGet("HUD_P", highest_unrealized_drawdown_p)==false)
   {
      GlobalVariableSet("HUD_P", 0.0);
   }
   if(OrdersTotal()>0)
   {
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
      if(CountLosses()!=-1) current_drawdown = CountLosses();
      current_drawdown = NormalizeDouble(current_drawdown, 2);
      if(current_drawdown>highest_unrealized_drawdown)   GlobalVariableSet("HUD", current_drawdown);
      
      highest_unrealized_drawdown_p = GlobalVariableGet("HUD_P");
      if(AccountEquity()<AccountBalance()) current_drawdown_p = ((AccountBalance()-AccountEquity())/AccountBalance())*100;
      current_drawdown_p = NormalizeDouble(current_drawdown_p, 2);
      if(current_drawdown_p>highest_unrealized_drawdown_p)  GlobalVariableSet("HUD_P", current_drawdown_p);
   }; 
   
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---   
   ObjectDelete(0, "HUD");
   ObjectDelete(0, "HUD_P");
   ObjectsDeleteAll();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//+------------------------------------------------------------------+
//| Initial Order Opening                                            |
//+------------------------------------------------------------------+
   if(TotalOrderCount(Symbol(), MagicNumber)==0 && DayOfWeek()!=FRIDAY)
   {
      BuyTicket = OpenBuyOrder(Symbol(), lots[0], 0, MagicNumber, "Alpha Winner V3.00");
      if(BuyTicket > 0)
      {
         bool selected = OrderSelect(BuyTicket, SELECT_BY_TICKET);
         double OpenPrice = OrderOpenPrice();

               //Calculate and Verify StopLoss and TakeProfit
         double BuyStopLoss = CalcBuyStopLoss(Symbol(), StopLoss, OpenPrice);
         if(BuyStopLoss > 0) BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss, 5);
         double BuyTakeProfit = CalcBuyTakeProfit(Symbol(), StartingTP, OpenPrice);
         if(BuyTakeProfit > 0) BuyTakeProfit = AdjustAboveStopLevel(Symbol(), BuyTakeProfit, 5);

                  //Add StopLoss and TakeProfit to the Order
         AddStopProfit(BuyTicket, BuyStopLoss, BuyTakeProfit);
      };
      SellTicket = OpenSellOrder(Symbol(), lots[0], 0, MagicNumber, "Alpha Winner V3.00");
      if(SellTicket > 0)
      {
         bool selected = OrderSelect(SellTicket, SELECT_BY_TICKET);
         double OpenPrice = OrderOpenPrice();
         double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, OpenPrice);
         if (SellStopLoss > 0 ) SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 5);
         double SellTakeProfit = CalcSellTakeProfit(Symbol(), StartingTP, OpenPrice);
         if (SellTakeProfit > 0) SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit, 5); 
         AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);
      };
   };
   //+---------------------------------------------------------------+
//| Initial Order Continuation                                       |
//+------------------------------------------------------------------+
while(IsTradeContextBusy())   Sleep(1000);
if(BuyMarketCount(Symbol(), MagicNumber)==0 && DayOfWeek()!=FRIDAY)
{
      BuyTicket = OpenBuyOrder(Symbol(), lots[0], 0, MagicNumber, "Alpha Winner V3.00");
      if(BuyTicket > 0)
      {
         bool selected = OrderSelect(BuyTicket, SELECT_BY_TICKET);
         double OpenPrice = OrderOpenPrice();

               //Calculate and Verify StopLoss and TakeProfit
         double BuyStopLoss = CalcBuyStopLoss(Symbol(), StopLoss, OpenPrice);
         if(BuyStopLoss > 0) BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss, 5);
         double BuyTakeProfit = CalcBuyTakeProfit(Symbol(), StartingTP, OpenPrice);
         if(BuyTakeProfit > 0) BuyTakeProfit = AdjustAboveStopLevel(Symbol(), BuyTakeProfit, 5);

                  //Add StopLoss and TakeProfit to the Order
         AddStopProfit(BuyTicket, BuyStopLoss, BuyTakeProfit);
      };
}
else if(SellMarketCount(Symbol(), MagicNumber)==0 && DayOfWeek()!=FRIDAY)
{
      SellTicket = OpenSellOrder(Symbol(), lots[0], 0, MagicNumber, "Alpha Winner V3.00");
      if(SellTicket > 0)
      {
         bool selected = OrderSelect(SellTicket, SELECT_BY_TICKET);
         double OpenPrice = OrderOpenPrice();
         double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, OpenPrice);
         if (SellStopLoss > 0 ) SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 5);
         double SellTakeProfit = CalcSellTakeProfit(Symbol(), StartingTP, OpenPrice);
         if (SellTakeProfit > 0) SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit, 5); 
         AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);
      };
};

//+------------------------------------------------------------------+
//| Hedging                                                          |
//+------------------------------------------------------------------+
   if(OrdersTotal()>=2)
   {
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
        bool selected = OrderSelect(i, SELECT_BY_POS);
        if(OrderType()==OP_BUY) break;
      };
        if(OrderProfit()<0 && MathAbs(NormalizeDouble(OrderOpenPrice()-Bid, _Digits)) >= 7.0)
        {
           BuyTicket = OpenBuyOrder(Symbol(), lots[OrdersTotal()], 0, MagicNumber, "Alpha Winner V3.00");
           if(BuyTicket>0)
           {
              bool selected = OrderSelect(BuyTicket, SELECT_BY_TICKET);
              double OpenPrice = OrderOpenPrice();
              double BuyStopLoss = CalcBuyStopLoss(Symbol(), StopLoss, OpenPrice);
              if(BuyStopLoss > 0) BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss, 5);
              AddStopProfit(BuyTicket, BuyStopLoss, 0);
           };
        };
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
        bool selected = OrderSelect(i, SELECT_BY_POS);
        if(OrderType()==OP_SELL) break;
      };
        if(OrderProfit()<0 && MathAbs(NormalizeDouble(OrderOpenPrice()-Bid, _Digits)) >= 7.0)
        {
           SellTicket = OpenSellOrder(Symbol(), lots[OrdersTotal()], 0, MagicNumber, "Alpha Winner V3.00");
           if(SellTicket>0)
           { 
             bool selected = OrderSelect(SellTicket, SELECT_BY_TICKET);
             double OpenPrice = OrderOpenPrice();
             double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, OpenPrice);
             if (SellStopLoss > 0 ) SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 5); 
             AddStopProfit(SellTicket, SellStopLoss, 0);
           };
        };
   };
//+------------------------------------------------------------------+
//| Evacuation                                                       |
//+------------------------------------------------------------------+
   
   if(TotalOrderCount(Symbol(), MagicNumber)>2)
   {
      //---------Buy Side----------------
      CalcAlphaUnitsTP = 0;
      double CurrentPrice = MarketInfo(Symbol(), MODE_BID);
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
         bool selected = OrderSelect(i, SELECT_BY_POS);
         if( OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderProfit()<0 && OrderType()==OP_BUY)
         {
            double PriceDrop = MathAbs(CurrentPrice - OrderOpenPrice());
            double PartialCalcAlphaUnitsTP = OrderLots()*PriceDrop;
            CalcAlphaUnitsTP += PartialCalcAlphaUnitsTP;
         };
      };
      if(CalcAlphaUnitsTP>GlobalVariableGet("CalcAlphaUnitsTPBuySide"))
      {
         GlobalVariableSet("CalcAlphaUnitsTPBuySide", CalcAlphaUnitsTP);
      };
      if(CalcAlphaUnitsTP >= AlphaUnitsTP)
      {
         CloseAllBuyOrders(Symbol(), MagicNumber);
         GlobalVariableSet("CalcAlphaUnitsTPBuySide", 0.0);
      };
      //---------Sell Side----------------
      CalcAlphaUnitsTP = 0;
      CurrentPrice = MarketInfo(Symbol(), MODE_ASK);
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
         bool selected = OrderSelect(i, SELECT_BY_POS);
         if( OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderProfit()<0 && OrderType()==OP_SELL)
         {
            double PriceDrop = MathAbs(CurrentPrice - OrderOpenPrice());
            double PartialCalcAlphaUnitsTP = OrderLots()*PriceDrop;
            CalcAlphaUnitsTP += PartialCalcAlphaUnitsTP;
         };
      };
      if(CalcAlphaUnitsTP>GlobalVariableGet("CalcAlphaUnitsTPSellSide"))
      {
         GlobalVariableSet("CalcAlphaUnitsTPSellSide", CalcAlphaUnitsTP);
      };
      if(CalcAlphaUnitsTP >= AlphaUnitsTP)
      {
         CloseAllSellOrders(Symbol(), MagicNumber);
         GlobalVariableSet("CalcAlphaUnitsTPSellSide", 0.0);
      };
   };
//+------------------------------------------------------------------+
//| Highest Unrealized Drawdown (HUD)                                |
//+------------------------------------------------------------------+
//---
   if(OrdersTotal()>0)
   {
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
      if(CountLosses()!=-1) current_drawdown = CountLosses();
      current_drawdown = NormalizeDouble(current_drawdown, 2);
      if(current_drawdown>highest_unrealized_drawdown)   GlobalVariableSet("HUD", current_drawdown);
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
      
      highest_unrealized_drawdown_p = GlobalVariableGet("HUD_P");
      if(AccountEquity()<AccountBalance())   current_drawdown_p = ((AccountBalance()-AccountEquity())/AccountBalance())*100;
      current_drawdown_p = NormalizeDouble(current_drawdown_p, 2);
      if(current_drawdown_p>highest_unrealized_drawdown_p)  GlobalVariableSet("HUD_P", current_drawdown_p);
      highest_unrealized_drawdown_p = GlobalVariableGet("HUD_P");
      
   };
   ObjectDelete(0, "HUD");
   ObjectCreate(0, "HUD", OBJ_LABEL, 0, TimeCurrent(), Bid);
   ObjectSetString(0, "HUD", OBJPROP_TEXT, 0, StringConcatenate("HUD($):  ", highest_unrealized_drawdown));
   ObjectSetInteger(0, "HUD", OBJPROP_COLOR, clrWhiteSmoke);
   ObjectSetInteger(0, "HUD", OBJPROP_CORNER, 0);
   ObjectSet("HUD", OBJPROP_FONTSIZE, 15);
   ObjectSet("HUD", OBJPROP_XDISTANCE, 10);
   ObjectSet("HUD", OBJPROP_YDISTANCE, 30);
   
   ObjectDelete(0, "HUD_P");
   ObjectCreate(0, "HUD_P", OBJ_LABEL, 0, TimeCurrent(), Bid);
   ObjectSetString(0, "HUD_P", OBJPROP_TEXT, 0, StringConcatenate("HUD(%): ", highest_unrealized_drawdown_p));
   ObjectSetInteger(0, "HUD_P", OBJPROP_COLOR, clrWhiteSmoke);
   ObjectSetInteger(0, "HUD_P", OBJPROP_CORNER, 0);
   ObjectSet("HUD_P", OBJPROP_FONTSIZE, 15);
   ObjectSet("HUD_P", OBJPROP_XDISTANCE, 10);
   ObjectSet("HUD_P", OBJPROP_YDISTANCE, 55);

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Total Orders Count             |
//+------------------------------------------------------------------+

int TotalOrderCount(string argSymbol, int argMagicNumber)
{
   int OrderCount = 0;
   for(int Counter = 0; Counter <= OrdersTotal() - 1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
      if ( (OrderMagicNumber() == argMagicNumber) && (OrderSymbol() == argSymbol) ) OrderCount++;
   };
   return(OrderCount);
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
//| Calculate Buy Stop Loss                     |
//+------------------------------------------------------------------+

double CalcBuyStopLoss(string argSymbol, double argStopLoss, double argOpenPrice)
{
   if(argStopLoss == 0) return(0);
   double BuyStopLoss = argOpenPrice - (argStopLoss * PipPoint(argSymbol));
   return(BuyStopLoss);
};

//+------------------------------------------------------------------+
//| Calculate Sell Stop Loss                        |
//+------------------------------------------------------------------+

double CalcSellStopLoss(string argSymbol, double argStopLoss, double argOpenPrice)
{
   if(argStopLoss == 0) return(0);
   double SellStopLoss = argOpenPrice + (argStopLoss * PipPoint(argSymbol));
   return(SellStopLoss);
};

//+------------------------------------------------------------------+
//| Calculate Buy Take Profit                     |
//+------------------------------------------------------------------+

double CalcBuyTakeProfit(string argSymbol, double argTakeProfit, double argOpenPrice)
{
   if(argTakeProfit == 0) return(0);
   double BuyTakeProfit = argOpenPrice + (argTakeProfit * PipPoint(argSymbol));
   return(BuyTakeProfit);
};

//+------------------------------------------------------------------+
//| Calculate Sell Take Profit                       |
//+------------------------------------------------------------------+

double CalcSellTakeProfit(string argSymbol, double argTakeProfit, double argOpenPrice)
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
   if(argVerifyPrice < LowerStopLevel) StopVerify = true;
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
   AdjustedPrice = 0;
   if(argAdjustPrice <= UpperStopLevel) AdjustedPrice = UpperStopLevel + (argAddPips * PipPoint(argSymbol));
   else AdjustedPrice = argAdjustPrice;
   return(AdjustedPrice);
};

//+------------------------------------------------------------------+
//| Adjust Below Stop Level                  |
//+------------------------------------------------------------------+
double AdjustedPrice;
double AdjustBelowStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0)
{
   double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
   double OpenPrice;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol, MODE_BID);
   else OpenPrice = argOpenPrice;
   double LowerStopLevel = OpenPrice - StopLevel;
   AdjustedPrice = 0;
   if(argAdjustPrice >= LowerStopLevel) AdjustedPrice = LowerStopLevel - (argAddPips * PipPoint(argSymbol));
   else AdjustedPrice = argAdjustPrice;
   return(AdjustedPrice);
};

//+------------------------------------------------------------------+
//| Add Stop Loss and Take Profit                  |
//+------------------------------------------------------------------+

bool AddStopProfit(int argTicket, double argStopLoss, double argTakeProfit)
{
   bool selected = OrderSelect(argTicket, SELECT_BY_TICKET);
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
//| PipPoint Function                                              |
//+------------------------------------------------------------------+

double PipPoint( string Currency )
{
   double CalcPoint = 0;
   double CalcDigits = MarketInfo(Currency, MODE_DIGITS);
   if ( ( CalcDigits == 2) || ( CalcDigits == 3) ) CalcPoint = 0.01;
   if ( ( CalcDigits == 4) || ( CalcDigits == 5) ) CalcPoint = 0.0001;
   return(CalcPoint);
};
//+------------------------------------------------------------------+
//| Buy Orders Count            |
//+------------------------------------------------------------------+

int BuyMarketCount( string argSymbol, int argMagicNumber)
{
   int OrderCount = 0;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderMagicNumber() == argMagicNumber) && (OrderType() == OP_BUY) ) OrderCount++;
   };
   return(OrderCount);
};

//+------------------------------------------------------------------+
//| Sell Orders Count            |
//+------------------------------------------------------------------+

int SellMarketCount( string argSymbol, int argMagicNumber)
{
   int OrderCount = 0;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderMagicNumber() == argMagicNumber) && (OrderType() == OP_SELL) ) OrderCount++;
   };
   return(OrderCount);
};
//+------------------------------------------------------------------+
//| Close All Orders                                                 |
//+------------------------------------------------------------------+
void CloseAllOrders(string argSymbol, int argMagicNumber)
{
   while(OrdersTotal()>0)
   {
      while (IsTradeContextBusy())  Sleep(10);
      bool selected = OrderSelect(0, SELECT_BY_POS);
      if(OrderSymbol()==argSymbol && OrderMagicNumber()==argMagicNumber)
      {
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         double ClosePrice;
         if(OrderType()==OP_BUY) ClosePrice = Bid;
         else ClosePrice = Ask;
         bool Closed = OrderClose(CloseTicket, OrderLots(), ClosePrice, 0);
            //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All Orders Error - ", ErrCode, " : ", ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID), " Ask: ",MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
      };
   };
};
//+------------------------------------------------------------------+
//| Close All Buy Orders                                                 |
//+------------------------------------------------------------------+

void CloseAllBuyOrders(string argSymbol, int argMagicNumber)
{
   while(BuyMarketCount(Symbol(), MagicNumber)>0)
   {
      while (IsTradeContextBusy())  Sleep(10);
      bool selected = OrderSelect(0, SELECT_BY_POS);
      if(OrderSymbol()==argSymbol && OrderMagicNumber()==argMagicNumber && OrderType()==OP_BUY)
      {
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         double ClosePrice;
         if(OrderType()==OP_BUY) ClosePrice = Bid;
         else ClosePrice = Ask;
         bool Closed = OrderClose(CloseTicket, OrderLots(), ClosePrice, 0);
            //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All Orders Error - ", ErrCode, " : ", ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID), " Ask: ",MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
      };
   };
};

//+------------------------------------------------------------------+
//| Close All Sell Orders                                                 |
//+------------------------------------------------------------------+

void CloseAllSellOrders(string argSymbol, int argMagicNumber)
{
   while(SellMarketCount(Symbol(), MagicNumber)>0)
   {
      while (IsTradeContextBusy())  Sleep(10);
      bool selected = OrderSelect(0, SELECT_BY_POS);
      if(OrderSymbol()==argSymbol && OrderMagicNumber()==argMagicNumber && OrderType()==OP_SELL)
      {
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         double ClosePrice;
         if(OrderType()==OP_BUY) ClosePrice = Bid;
         else ClosePrice = Ask;
         bool Closed = OrderClose(CloseTicket, OrderLots(), ClosePrice, 0);
            //Error Handling
         if(Closed == false)
         {
            int ErrCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrCode);
            string ErrAlert = StringConcatenate("Close All Orders Error - ", ErrCode, " : ", ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID), " Ask: ",MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
      };
   };
};
//+------------------------------------------------------------------+
//| Counting Losses                                                  |
//+------------------------------------------------------------------+
double CountLosses()
{
   double return_value = 0.0;
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      bool selected = OrderSelect(i, SELECT_BY_POS);
      return_value = return_value + OrderProfit();
   };
   if(return_value>0)   return(-1);
   else return(MathAbs(return_value));
};