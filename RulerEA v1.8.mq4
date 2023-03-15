//+------------------------------------------------------------------+
//|                                                      RulerEA.mq4 |
//|                         Copyright 2022, Muhammad Mubashir Mirza. |
//|                                     mirza.mubashir0001@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Muhammad Mubashir Mirza."
#property link      "mirza.mubashir0001@gmail.com"
#property version   "1.8"
#property strict
#include <stdlib.mqh>
enum tradetype
{
   Buy = 0,
   Sell = 1,
};
//---External Variable Inputs
extern   double     MeasureNumber  = 0.0;
extern   double     RulerLength    = 15.6;
extern   tradetype  TradeType      = Buy;
extern   string     EntryTime1     = "00:00";
extern   string     EntryTime2     = "00:00";
extern   int        WaitingTime    = 0;
extern   double     MoneyPerTrades = 0.0;
extern   double     ExtraMoneyTP   = 0.0;
extern   double     LotSize        = 0.1;
extern   double     StopLoss       = 0.0;
extern   int        MinimumTrades  = 0;
extern   int        Slippage       = 10;
//---Global Variables
double    Level;
int       BuyTicket;
int       SellTicket;
bool      NoPrevTrades;
bool      NotTradedYet;
int       MagicNumber = 555;
bool      TimeCondition;
double    MinPrice;
double    MaxPrice;
datetime  entrytime1;
datetime  entrytime2;
datetime  waitingtime1;
datetime  waitingtime2;
datetime  EntryTime1T;
string   _EntryTime1M;
string   _entrytime1;
datetime  EntryTime2T;
string   _EntryTime2M;
string   _entrytime2;
string   _waitingtime1;
string   _waitingtime2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Comment("RulerEA v1.8");
   double Ruler = iCustom(Symbol(), 0, "Ruler", 0, 0);
   MeasureNumber *= 10;
   RulerLength *= 10;
   StopLoss *= -1;
   Slippage *= 10;
   CalcLevel();
   ChartSetInteger(0, CHART_SHIFT, 0, TRUE);
   ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
   ObjectCreate(0, StringConcatenate(Symbol(), " TradeLevel"), OBJ_HLINE, 0, TimeCurrent(), Level);
   ObjectSetInteger(0, "EURUSD TradeLevel", OBJPROP_COLOR, clrBlue);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectDelete(0, StringConcatenate(Symbol(), " TradeLevel"));
   ChartSetInteger(0, CHART_SHIFT, 0, FALSE);
   ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
   Comment("");

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   Printing();
   CalcLevel();
   NotTradedYet();
   TimeCalculation();
   CheckMinTrades();
   CheckPrevTrades();
   if(MarketCount(Symbol(), MagicNumber)>0)
   {
      CheckTP();
      CheckSL();
   };
//---Trade Block
   if( Bid>Level && TimeCondition==true && NoPrevTrades==true && NotTradedYet==true && MarketCount(Symbol(), MagicNumber)==0 )
   {
      switch(TradeType)
      {
         case 0:
         {
            BuyTicket = OpenBuyOrder(Symbol(), LotSize, Slippage, MagicNumber, "RulerEA v1.8");
            break;
         };
         
         case 1:
         {
            SellTicket = OpenSellOrder(Symbol(), LotSize, Slippage, MagicNumber, "RulerEA v1.8");
            break;
         };
      };
   };
  }
//+------------------------------------------------------------------+
void Printing()
{
   Print(StringConcatenate("RulerEA running on ", Symbol(), " ", ChartPeriod(), " Minutes Chart."));
};
void CalcLevel()
{
   Print(StringConcatenate("RulerEA running on ", Symbol(), " ", ChartPeriod(), " Minutes Chart."));
   MaxPrice = ChartGetDouble(0, CHART_PRICE_MAX);
   MinPrice = ChartGetDouble(0, CHART_PRICE_MIN);
   double Difference = MaxPrice - MinPrice;
   double onemm = Difference / RulerLength;
   Level = MaxPrice - (MeasureNumber*onemm);
   Level = NormalizeDouble(Level, 5); 
   ObjectMove(0, StringConcatenate(Symbol(), " TradeLevel"), 0, TimeCurrent(), Level);
};
void TimeCalculation()
{  
   Print(StringConcatenate("RulerEA running on ", Symbol(), " ", ChartPeriod(), " Minutes Chart."));
   EntryTime1T  = StrToTime(EntryTime1);
   _EntryTime1M = TimeToStr(EntryTime1T, TIME_MINUTES);
   _entrytime1  = StringConcatenate(Year(), ".", Month(), ".",  Day(), ".", _EntryTime1M);
   entrytime1   = StrToTime(_entrytime1);
   //-----------------
   EntryTime2T  = StrToTime(EntryTime2);
   _EntryTime2M = TimeToStr(EntryTime2T, TIME_MINUTES);
   _entrytime2  = StringConcatenate(Year(), ".", Month(), ".",  Day(), ".", _EntryTime2M);
   entrytime2   = StrToTime(_entrytime2);
   //-----------------
   waitingtime1  = entrytime1 + (WaitingTime*60);
   waitingtime2  = entrytime2 + (WaitingTime*60);
   //-----------------
   if(TimeCurrent()>=entrytime1 && TimeCurrent()<=waitingtime1)              TimeCondition = true;
   else if(TimeCurrent()>=entrytime2 && TimeCurrent()<=waitingtime2)         TimeCondition = true;
   else                                                                      TimeCondition = false;
};

void NotTradedYet()
{
   Print(StringConcatenate("RulerEA running on ", Symbol(), " ", ChartPeriod(), " Minutes Chart."));
   bool selected = OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS, MODE_HISTORY);
   if(TimeCurrent()>=entrytime1 && TimeCurrent()<=waitingtime1)
      {
         if(OrderCloseTime()>entrytime1 && OrderCloseTime()<waitingtime1)  NotTradedYet = false;
         else NotTradedYet = true;
      }   
   if(TimeCurrent()>=entrytime2 && TimeCurrent()<=waitingtime2)
      {
         if(OrderCloseTime()>=entrytime2 && OrderCloseTime()<=waitingtime2)   NotTradedYet = false;
         else  NotTradedYet = true;
      }
};

void CheckPrevTrades()
{
   Print(StringConcatenate("RulerEA running on ", Symbol(), " ", ChartPeriod(), " Minutes Chart."));
   if(TimeCurrent()>=entrytime2 && TimeCurrent()<=waitingtime2)
   {
    bool selected = OrderSelect(OrdersTotal()-1, SELECT_BY_POS, MODE_TRADES);
    if(selected==true)
    {
      if(OrderOpenTime()>=entrytime1 && OrderOpenTime()<=waitingtime1)     NoPrevTrades = false;
      else                                                                 NoPrevTrades = true;
    }
    else                                                                   NoPrevTrades = true;
   }
   else                                                                    NoPrevTrades = true;
};

void CheckMinTrades()
{
   Print(StringConcatenate("RulerEA running on ", Symbol(), " ", ChartPeriod(), " Minutes Chart."));
   int TotalOrders = TotalOrderCount(MagicNumber);
   if(TimeCondition==false && TotalOrders>0 && TotalOrders<MinimumTrades)
   {
      CloseAllOrders(MagicNumber, Slippage);
      Alert("All orders closed because EA didn't open ", MinimumTrades," trades within the waiting time.");
   };
};

void CheckTP()
{
   Print(StringConcatenate("RulerEA running on ", Symbol(), " ", ChartPeriod(), " Minutes Chart."));
   int TotalOrders = TotalOrderCount(MagicNumber);
   double TP = (MoneyPerTrades*TotalOrders) + ExtraMoneyTP;
   if( CalculateProfit(MagicNumber) >= TP )
   {
      CloseAllOrders(MagicNumber, Slippage);
      Alert("All orders closed because the TP: ", TP, " USD reached.");
   };
};

void CheckSL()
{
   Print(StringConcatenate("RulerEA running on ", Symbol(), " ", ChartPeriod(), " Minutes Chart."));
   if( CalculateProfit(MagicNumber) <= StopLoss)
   {
      CloseAllOrders(MagicNumber, Slippage);
      Alert("All orders closed becuase the SL: ", StopLoss, " USD was hit.");
   };
};
//+--------------------------------------------------------------------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Open Buy Order                                                  |
//+------------------------------------------------------------------+

int OpenBuyOrder(string argSymbol, double argLotSize, int argSlippage, int argMagicNumber, string argComment = "RulerEA")
{
   while(IsTradeContextBusy()) Sleep(10);
   RefreshRates();
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

int OpenSellOrder(string argSymbol, double argLotSize, int argSlippage, int argMagicNumber, string argComment = "RulerEA")
{
   while(IsTradeContextBusy()) Sleep(10);
   RefreshRates();
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
//| Total Orders Count             |
//+------------------------------------------------------------------+

int TotalOrderCount(int argMagicNumber)
{
   int OrderCount = 0;
   for(int Counter = 0; Counter <= OrdersTotal() - 1; Counter++)
   {
      int Selected = OrderSelect(Counter, SELECT_BY_POS);
      if (OrderMagicNumber() == argMagicNumber) OrderCount++;
   };
   return(OrderCount);
};
//+------------------------------------------------------------------+
//| Close All Orders                                                 |
//+------------------------------------------------------------------+

void CloseAllOrders(int argMagicNumber, int argSlippage)
{
   if(IsTradeContextBusy())   Sleep(10);
   while(TotalOrderCount(MagicNumber)>0)
   {
   for ( int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      if(IsTradeContextBusy())   Sleep(10);
      int Selected = OrderSelect(Counter, SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber)
      {
               // Close Order
         int CloseTicket = OrderTicket();
         double CloseLots = OrderLots();
         while(IsTradeContextBusy()) Sleep(10);
         RefreshRates();
         double ClosePrice = 0.00000;
         if(OrderType()==OP_BUY)          ClosePrice = MarketInfo(OrderSymbol(), MODE_BID);
         else if(OrderType()==OP_SELL)    ClosePrice = MarketInfo(OrderSymbol(), MODE_ASK);
         bool Closed = OrderClose(CloseTicket, CloseLots, ClosePrice, argSlippage, clrNONE);
         if(Closed == true)   Counter--;
      };
   };
   };
   NotTradedYet = false;
};
//+------------------------------------------------------------------+
//| Calculate Profit                                                 |
//+------------------------------------------------------------------+
double CalculateProfit(int argMagicNumber) 
{
   double Profit = 0.0;
   for (int Count = OrdersTotal() - 1; Count >= 0; Count--) 
   {
      int Selected = OrderSelect(Count, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == argMagicNumber)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Profit += OrderProfit();
   }
   return (Profit);
}
//+------------------------------------------------------------------+
//| Market Count           |
//+------------------------------------------------------------------+

int MarketCount( string argSymbol, int argMagicNumber)
{
   int OrderCount = 0;
   for(int Counter = OrdersTotal()-1; Counter >= 0; Counter--)
   {
      int Selected = OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderMagicNumber() == argMagicNumber) && (OrderType()==OP_BUY || OrderType()==OP_SELL) ) OrderCount++;
   };
   return(OrderCount);
};
//+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//+------------------------------------------------------------------------------------------------------------------------------------------------------------------------+