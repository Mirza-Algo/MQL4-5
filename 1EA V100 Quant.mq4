//+------------------------------------------------------------------+
//|                                                          ea3.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Muhammad Mubashir Mirza."
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#property strict
#include <stdlib.mqh>

double macdArray[500];
int BuyTicket;
int SellTicket;

extern int LotSizeDividor = 5000;
extern int TakeProfit = 50;
extern int TrailingStopPips = 10;
extern double CloseAllAt = 1;
extern int IdealDivisionforOrder2 = 4;
extern int MagicNumber = 786;
extern int MagicNumber2 = 787;


double Pip;
double LotSize;
double StopLoss=0;
double StopLoss2=0;
double TakeProfit2;
int MinimumProfit2;
int MinimumProfit;
bool NewBarM15 = false;
double TrailingStop = 0;
double TrailingStop2 = 0;
datetime CurrentTimeStamp;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Pip = PipPoint(Symbol());
   MinimumProfit = TrailingStopPips;
   MinimumProfit2 = TrailingStopPips/IdealDivisionforOrder2;
   LotSize = NormalizeDouble(AccountEquity()/LotSizeDividor, 2);
   TakeProfit2 = NormalizeDouble((TakeProfit / IdealDivisionforOrder2), 5);
   TrailingStop = TrailingStopPips;
   TrailingStop2 = TrailingStopPips/IdealDivisionforOrder2;
   NewBarM15 = false;
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
      LotSize = NormalizeDouble(AccountEquity()/LotSizeDividor, 2);
      if(MarketCount(Symbol())>1)
      {
         double PNL = TotalPNLCount(Symbol());
         if(PNL>=CloseAllAt)
         {
            CloseAllOrders(Symbol(), 100);
            Alert("Closed All Orders with Profit: ", PNL);
         };
      };
      ArraySetAsSeries(macdArray,true);
      
      for(int i=0; i<500; i++)
      {
         macdArray[i]= iMACD(NULL, PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,i);  
      };
      
      double EMA= NormalizeDouble(iMAOnArray(macdArray, 0,59,0,MODE_EMA,0),6);

      double macdLine=NormalizeDouble(iMACD(NULL, PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_SIGNAL, 0), 6);
     
      bool dSell= NormalizeDouble(iOpen(NULL,PERIOD_D1,0), 5) > NormalizeDouble(MarketInfo(NULL, MODE_BID), 5);
      bool dBuy= NormalizeDouble(iOpen(NULL,PERIOD_D1,0), 5) < NormalizeDouble(MarketInfo(NULL, MODE_BID), 5);
      //---------NewBarM15------------------------
      if (CurrentTimeStamp != iTime(NULL, PERIOD_M15, 0))
      {
         CurrentTimeStamp = iTime(NULL, PERIOD_M15, 0);
         NewBarM15 = true;
      }
      else NewBarM15 = false;
      //----------------------------------------------
      if(NewBarM15==true)
      {
         NewBarM15=false;
            if(dBuy==true && macdLine>EMA)
         {
               //Buy Order
               BuyTicket = OpenBuyOrder(Symbol(), LotSize, 50, MagicNumber, "1EA. big. opp.");
                              //OrderModification
                 if( (BuyTicket > 0) && (TakeProfit>0) )
                 { 
                     OrderSelect(BuyTicket, SELECT_BY_TICKET);
                     double OpenPrice = OrderOpenPrice();
         
                         //Calculate and Verify StopLoss and TakeProfit
                     double BuyStopLoss = CalcBuyStopLoss(Symbol(), StopLoss, OpenPrice);
                     if(BuyStopLoss > 0) BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss, 5);
                     double BuyTakeProfit = CalcBuyTakeProfit(Symbol(), TakeProfit, OpenPrice);
                     if(BuyTakeProfit > 0) BuyTakeProfit = AdjustAboveStopLevel(Symbol(), BuyTakeProfit, 5);
                              //Add StopLoss and TakeProfit to the Order
                     AddStopProfit(BuyTicket, BuyStopLoss, BuyTakeProfit);
                 };
         }
         
           if(dSell==true && macdLine<EMA)
            {     
                 //Sell Order
                 SellTicket = OpenSellOrder(Symbol(), LotSize, 50, MagicNumber, "1EA. big. opp.");
                     if ( (SellTicket > 0) && (TakeProfit>0))
                {
                    OrderSelect(SellTicket, SELECT_BY_TICKET);
                    double OpenPrice = OrderOpenPrice(); 
                    double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, OpenPrice);
                    if (SellStopLoss > 0 ) SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 5);
                    double SellTakeProfit = CalcSellTakeProfit(Symbol(), TakeProfit, OpenPrice);
                    if (SellTakeProfit > 0) SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit, 5);        
                    AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);
                 }
            }
           if(dBuy==false && dSell==true && macdLine>EMA)
            {  
               BuyTicket = OpenBuyOrder(Symbol(), LotSize, 50, MagicNumber2, "1EA. less. opp.");
                  //Order Modification
               OrderSelect(BuyTicket, SELECT_BY_TICKET);
               double OpenPrice = OrderOpenPrice();
         
                   //Calculate and Verify StopLoss and TakeProfit
               double BuyStopLoss = CalcBuyStopLoss(Symbol(), StopLoss2, OpenPrice);
               if(BuyStopLoss > 0) BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss, 10);
               double BuyTakeProfit = CalcBuyTakeProfit(Symbol(), TakeProfit2, OpenPrice);
               if(BuyTakeProfit > 0) BuyTakeProfit = AdjustAboveStopLevel(Symbol(), BuyTakeProfit, 10);
                        //Add StopLoss and TakeProfit to the Order
               AddStopProfit(BuyTicket, BuyStopLoss, BuyTakeProfit);
            }
            if(dSell==false && dBuy==true && macdLine<EMA)
            {
               SellTicket = OpenSellOrder(Symbol(), LotSize, 50, MagicNumber2, "1EA. less. opp.");
  
               OrderSelect(SellTicket, SELECT_BY_TICKET);
               double OpenPrice = OrderOpenPrice(); 
               double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss2, OpenPrice);
               if (SellStopLoss > 0 ) SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 10);
               double SellTakeProfit = CalcSellTakeProfit(Symbol(), TakeProfit2, OpenPrice); 
               Alert("SellTakeProfit: ", SellTakeProfit);
               if(SellTakeProfit > 0) SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit, 10);
               AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);
            };
       }
 //+------------------------------------------------------------------+
//| Adjust Trailing Stop                                              |
//+------------------------------------------------------------------+

if ( (BuyMarketCount(Symbol(), MagicNumber) > 0) && (TrailingStop > 0) )
{
   BuyTrailingStop(Symbol(), TrailingStop, MinimumProfit, MagicNumber);
};
if ( (SellMarketCount(Symbol(), MagicNumber) > 0) && (TrailingStop > 0) )
{
   SellTrailingStop(Symbol(), TrailingStop, MinimumProfit, MagicNumber);
};
if ( (BuyMarketCount(Symbol(), MagicNumber2) > 0) && (TrailingStop2 > 0) )
{
   BuyTrailingStop(Symbol(), TrailingStop2, MinimumProfit2, MagicNumber2);
};
if ( (SellMarketCount(Symbol(), MagicNumber2) > 0) && (TrailingStop2 > 0) )
{
   SellTrailingStop(Symbol(), TrailingStop2, MinimumProfit2, MagicNumber2);
};
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
      if( (OrderMagicNumber() == argMagicNubmer) && (OrderSymbol() == argSymbol) && (OrderType() == OP_BUY) && (CurrentStop < MaxStopLoss || CurrentStop == 0) && (PipsProfit >= MinProfit) )
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
//| Market Orders Count            |
//+------------------------------------------------------------------+

int MarketCount(string argSymbol)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderType()==OP_BUY || OrderType()==OP_SELL)  ) OrderCount++;
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
}
//+------------------------------------------------------------------+
//| Close All Orders          |
//+------------------------------------------------------------------+

void CloseAllOrders(string argSymbol, int argSlippage)
{
   while(MarketCount(Symbol())>0)
   {
    for ( int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
     {
         OrderSelect(Counter, SELECT_BY_POS);
        if( (OrderSymbol() == argSymbol) )
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
    }
};
//+------------------------------------------------------------------+
//| Total PNL Count          |
//+------------------------------------------------------------------+
double TotalPNLCount(string argSymbol)
{
   double FloatingPNL = 0;
   for ( int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) )
      {
         FloatingPNL += OrderProfit();
      };
   };
   return(FloatingPNL);
};