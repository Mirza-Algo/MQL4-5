//+------------------------------------------------------------------+
//|                                                   Forex Lord.mq4 |
//|                          Copyright 2023, Muhammad Mubashir Mirza |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza"
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#property strict
#include  <stdlib.mqh>
//+------------------------------------------------------------------+
//| Expert External and Global Variables                             |
//+------------------------------------------------------------------+

extern double EquityPercent = 0.0;
extern double RiskAmount    = 0.0;
extern double FixedLotSize  = 0.0;

double LotSize     = 0.0;
int    StopLoss    = 10.0;
int    TakeProfit  = 30.0;
int    BuyTicket, SellTicket;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
//+------------------------------------------------------------------+
//| Calculate and Verify LotSize                                     |
//+------------------------------------------------------------------+
   if(EquityPercent != 0)  LotSize = CalcLotSize(EquityPercent/3, StopLoss, TRUE, 0.0); 
   else if(RiskAmount != 0)   LotSize = CalcLotSize(0.0, StopLoss, FALSE, RiskAmount/3); 
   else if(FixedLotSize != 0) LotSize = FixedLotSize;
   LotSize = NormalizeDouble(LotSize, 2);
   //---Margin Check
   double maxlot, lotstep;
   lotstep =  MarketInfo(Symbol(),MODE_LOTSTEP);
   maxlot  = (AccountFreeMargin())/MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   maxlot  =  StrToDouble(DoubleToStr(MathFloor(maxlot/lotstep)*lotstep,2));
   maxlot = maxlot - 0.1;
   if(LotSize>maxlot)   LotSize = maxlot;
   //
   LotSize = VerifyLotSize(LotSize);

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
bool selected = OrderSelect(0, SELECT_BY_POS);
Print("Order Magic Number: ", OrderMagicNumber());
ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
ChartSetInteger(0, CHART_COLOR_BID, clrPurple);
ChartSetInteger(0, CHART_COLOR_ASK, clrAqua);
ChartSetInteger(0, CHART_SHOW_GRID, FALSE);
ChartSetInteger(0, CHART_SCALE, 3);
//+------------------------------------------------------------------+
//| Indicators Calculation                                           |
//+------------------------------------------------------------------+
bool BuySignal, SellSignal;
BuySignal = SellSignal = false;

double SPM15UP = iCustom(Symbol(), PERIOD_M15, "super-trend", 0, 1);
double SPM15DN = iCustom(Symbol(), PERIOD_M15, "super-trend", 1, 1);
double SPH1UP  = iCustom(Symbol(), PERIOD_H1, "super-trend", 0, 1);
double SPH1DN  = iCustom(Symbol(), PERIOD_H1, "super-trend", 1, 1);
double SPH4UP  = iCustom(Symbol(), PERIOD_H4, "super-trend", 0, 1);
double SPH4DN  = iCustom(Symbol(), PERIOD_H4, "super-trend", 1, 1);
if(SPM15UP!=EMPTY_VALUE && SPH1UP!=EMPTY_VALUE && SPH4UP!=EMPTY_VALUE)  {BuySignal=true; SellSignal=false;}
else if(SPM15DN!=EMPTY_VALUE && SPH1DN!=EMPTY_VALUE && SPH4DN!=EMPTY_VALUE)  {SellSignal=true; BuySignal=false;}
//+------------------------------------------------------------------+
//| First Order Opening                                              |
//+------------------------------------------------------------------+
   if(MarketCount(Symbol())==0)
   {
      string symbol;
      for(int i=OrdersHistoryTotal()-1; i>=0; i--)
      {
       bool selected = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
       if(OrderSymbol()==Symbol())   {symbol = Symbol(); break;};
      };
      if(symbol==Symbol() && (OrderMagicNumber()==1 || OrderMagicNumber()==2) && OrderProfit()<0)  BuySignal = SellSignal = false;
      if(BuySignal==true)
   {
      BuyTicket = OpenBuyOrder(Symbol(), LotSize, 0, 1, "Forex Lord Step One");
      
      if( (BuyTicket > 0) && (StopLoss>0 || TakeProfit>0) )
      {
         bool selected = OrderSelect(BuyTicket, SELECT_BY_TICKET);
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
   else if( (MarketCount(Symbol())==0) && SellSignal==true)
   {
      SellTicket = OpenSellOrder(Symbol(), LotSize, 0, 1, "Forex Lord Step One");
      
      if ( (SellTicket > 0) && (StopLoss>0 || TakeProfit>0))
      {
         bool selected = OrderSelect(SellTicket, SELECT_BY_TICKET);
         double OpenPrice = OrderOpenPrice();
         double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, OpenPrice);
         if (SellStopLoss > 0 ) SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 5);
         double SellTakeProfit = CalcSellTakeProfit(Symbol(), TakeProfit, OpenPrice);
         if (SellTakeProfit > 0) SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit, 5);
         
         AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);
      };
  };
  };
//+------------------------------------------------------------------+
//| Second Order Opening                                             |
//+------------------------------------------------------------------+

if(MarketCount(Symbol())==0)
{
   string symbol;
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
   {
      bool selected = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      if(OrderSymbol()==Symbol())   {symbol = Symbol(); break;};
   };
   if(OrderMagicNumber()==2 || OrderMagicNumber()==3)  symbol = "";
   if(symbol==Symbol() && OrderProfit()<0)
   {
      if(OrderType()==OP_SELL)
      {
         BuyTicket = OpenBuyOrder(Symbol(), LotSize, 0, 2, "Forex Lord Step Two");
      
         if( (BuyTicket > 0) && (StopLoss>0 || TakeProfit>0) )
         {
             bool selected = OrderSelect(BuyTicket, SELECT_BY_TICKET);
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
      else if(OrderType()==OP_BUY)
      {
         SellTicket = OpenSellOrder(Symbol(), LotSize, 0, 2, "Forex Lord Step Two");
      
          if ( (SellTicket > 0) && (StopLoss>0 || TakeProfit>0))
          {
             bool selected = OrderSelect(SellTicket, SELECT_BY_TICKET);
             double OpenPrice = OrderOpenPrice();
             double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, OpenPrice);
             if (SellStopLoss > 0 ) SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 5);
             double SellTakeProfit = CalcSellTakeProfit(Symbol(), TakeProfit, OpenPrice);
             if (SellTakeProfit > 0) SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit, 5);
              
             AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);
          };
      };
   };
};

//+------------------------------------------------------------------+
//| Third Order Opening                                              |
//+------------------------------------------------------------------+
if(MarketCount(Symbol())==0)
{
   string symbol;
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
   {
      bool selected = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      if(OrderSymbol()==Symbol())   {symbol = Symbol(); break;};
   };
   if(OrderMagicNumber()!=2)  symbol = "";
   if(symbol==Symbol() && OrderProfit()<0)
   {
      if(OrderType()==OP_SELL)
      {
         BuyTicket = OpenBuyOrder(Symbol(), LotSize, 0, 3, "Forex Lord Step Three");
      
         if( (BuyTicket > 0) && (StopLoss>0 || TakeProfit>0) )
         {
             bool selected = OrderSelect(BuyTicket, SELECT_BY_TICKET);
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
      else if(OrderType()==OP_BUY)
      {
         SellTicket = OpenSellOrder(Symbol(), LotSize, 0, 3, "Forex Lord Step Three");
      
          if ( (SellTicket > 0) && (StopLoss>0 || TakeProfit>0))
          {
             bool selected = OrderSelect(SellTicket, SELECT_BY_TICKET);
             double OpenPrice = OrderOpenPrice();
             double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, OpenPrice);
             if (SellStopLoss > 0 ) SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 5);
             double SellTakeProfit = CalcSellTakeProfit(Symbol(), TakeProfit, OpenPrice);
             if (SellTakeProfit > 0) SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit, 5);
              
             AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);
          };
      };
   };
};
  };
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Calculate Lot Size                                                   |
//+------------------------------------------------------------------+

double CalcLotSize(double argEquityPercent, double argStopLoss, bool argRiskPercent, double argRiskAmount)
{
      double RISKAMOUNT;
      if(argRiskPercent==TRUE)   RISKAMOUNT = AccountEquity() * (argEquityPercent/100);
      else  RISKAMOUNT = argRiskAmount;
      double TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
      if((Point == 0.001) || (Point == 0.00001)) TickValue*=10;
      LotSize = (RISKAMOUNT / argStopLoss) / TickValue;
      return(LotSize);
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
//| Market Orders Count                                              |
//+------------------------------------------------------------------+

int MarketCount( string argSymbol)
{
   int OrderCount = 0;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderType() == OP_BUY || OrderType() == OP_SELL) ) OrderCount++;
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
   bool StopVerify = false;
   if(argVerifyPrice < LowerStopLevel) StopVerify = true;
   else StopVerify = false;
   return(StopVerify);
};

//+------------------------------------------------------------------+
//| Adjust Above Stop Level                  |
//+------------------------------------------------------------------+

double AdjustedPrice;
double AdjustAboveStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0)
{
   double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
   double OpenPrice;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol, MODE_ASK);
   else OpenPrice = argOpenPrice;
   double UpperStopLevel = OpenPrice + StopLevel;

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
   if(argAdjustPrice >= LowerStopLevel) AdjustedPrice = LowerStopLevel - (argAddPips * PipPoint(argSymbol));
   else AdjustedPrice = argAdjustPrice;
   return(AdjustedPrice);
};