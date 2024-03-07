//+------------------------------------------------------------------+
//|                                                     QUANT_EA.mq4 |
//|                          Copyright 2023, Muhammad Mubashir Mirza |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza"
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.2"
#include <stdlib.mqh>
//+------------------------------------------------------------------+
//| External & Global Variables                                      |
//+------------------------------------------------------------------+

extern double EquityPercent  = 0.0;
extern double RiskAmount     = 0.0;
extern double FixedLotSize   = 0.01;

string comments = "MUBASHIR MIRZA V1.2";
double LotSize = 0.0;
double StopLoss = 0;
double TakeProfit = 0;
int MagicNumber = 786;
double BuyTicket, SellTicket;
datetime TimeStamp = 0;
int ChartType;
double price;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(!IsConnected())
   {
      Alert("No Connection!");
      return(-1);
   };
   ObjectsDeleteAll();
   ChartType = ChartGetInteger(0, CHART_MODE);
   TimeStamp = iTime(Symbol(), PERIOD_M1, 0);
   price = MarketInfo(Symbol(), MODE_BID);
   BuyTicket = SellTicket = 0;
   StopLoss = PipPoint(Symbol())*200; StopLoss = StopLoss/PipPoint(Symbol());
   TakeProfit = StopLoss*2;
//------------------Calculate and Verify Lot Size-------------------
   if(EquityPercent != 0)  LotSize = CalcLotSize(EquityPercent, StopLoss, TRUE, 0.0); 
   else if(RiskAmount != 0)   LotSize = CalcLotSize(0.0, StopLoss, FALSE, RiskAmount); 
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
//-----------------------BUYSTOP ORDER-------------------------------------------
   double PendingPrice = price+(PipPoint(Symbol())*200);
   PendingPrice = AdjustAboveStopLevel(Symbol(), PendingPrice, 5);
   double BuyStopLoss = CalcBuyStopLoss(Symbol(), StopLoss, PendingPrice);
   BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss, 5, PendingPrice);
   double BuyTakeProfit = CalcBuyTakeProfit(Symbol(), TakeProfit, PendingPrice);
   BuyTakeProfit = AdjustAboveStopLevel(Symbol(), BuyTakeProfit, 5, PendingPrice);
   BuyTicket = OpenBuyStopOrder(Symbol(), LotSize, PendingPrice, 0, 0, 0, MagicNumber, 0, comments); 
//----------------------SELLSTOP ORDER---------------------------------------------------
   PendingPrice = price-(PipPoint(Symbol())*200);
   PendingPrice = AdjustBelowStopLevel(Symbol(), PendingPrice, 5);
   double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, PendingPrice);
   SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 5, PendingPrice);
   double SellTakeProfit = CalcSellTakeProfit(Symbol(), TakeProfit, PendingPrice);
   SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit, 5, PendingPrice);
   SellTicket = OpenSellStopOrder(Symbol(), LotSize, PendingPrice, SellStopLoss, SellTakeProfit, 0, MagicNumber, 0, comments); 

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectsDeleteAll();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   while(IsTradeContextBusy()) Sleep(10);
//+------------------------------------------------------------------+
//| Close All forcibly on Interrupt.                                 |
//+------------------------------------------------------------------+
if(ChartGetInteger(0, CHART_MODE)!=ChartType)
{
   CloseAllMarketOrders(Symbol(), MagicNumber, 0);
   CloseAllStopOrders(Symbol(), MagicNumber);
};
//+------------------------------------------------------------------+
//| Close the other and remove after activation of one.              |
//+------------------------------------------------------------------+
   if(StopsCount(Symbol(), MagicNumber)==1)
   {
      while(StopsCount(Symbol(), MagicNumber)>0)   CloseAllStopOrders(Symbol(), MagicNumber);
      ExpertRemove();
   };
//+------------------------------------------------------------------+
//| Modify after placement.                                          |
//+------------------------------------------------------------------+
   if(StopsCount(Symbol(), MagicNumber)==2 && iTime(Symbol(), PERIOD_M1, 0)==TimeStamp)
   {
      price = MarketInfo(Symbol(), MODE_BID);
      //Modify BuyStop Order
      double PendingPrice = price+(PipPoint(Symbol())*200);
      PendingPrice = AdjustAboveStopLevel(Symbol(), PendingPrice, 5);
      bool selected = OrderSelect(0, SELECT_BY_POS);
      if(OrderType()!=OP_BUYSTOP)   selected = OrderSelect(1, SELECT_BY_POS);
      if(MathAbs(OrderOpenPrice()-PendingPrice)>=0.0001)
      {
         double BuyStopLoss = CalcBuyStopLoss(Symbol(), StopLoss, PendingPrice);
         BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss, 5, PendingPrice);
         double BuyTakeProfit = CalcBuyTakeProfit(Symbol(), TakeProfit, PendingPrice);
         BuyTakeProfit = AdjustAboveStopLevel(Symbol(), BuyTakeProfit, 5, PendingPrice);
         bool modified = OrderModify(OrderTicket(), PendingPrice, BuyStopLoss, BuyTakeProfit, 0, clrBlue);
         if(modified==false)  Print("Modify BuyStop Error: ", GetLastError(), " : ", ErrorDescription(GetLastError()));      
      };
      //Modify SellStopOrder
      PendingPrice = price-(PipPoint(Symbol())*200);
      PendingPrice = AdjustBelowStopLevel(Symbol(), PendingPrice, 5);
      selected = OrderSelect(0, SELECT_BY_POS);
      if(OrderType()!=OP_SELLSTOP)   selected = OrderSelect(1, SELECT_BY_POS);
      if(MathAbs(OrderOpenPrice()-PendingPrice)>=0.0001)
      {
         double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, PendingPrice);
         SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss, 5, PendingPrice);
         double SellTakeProfit = CalcSellTakeProfit(Symbol(), TakeProfit, PendingPrice);
         SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit, 5, PendingPrice);
         modified = OrderModify(OrderTicket(), PendingPrice, SellStopLoss, SellTakeProfit, 0, clrRed);
         if(modified==false)  Print("Modify SellStop Error: ", GetLastError(), " : ", ErrorDescription(GetLastError())); 
      };
   };
//+------------------------------------------------------------------+
//| Close after done.                                                |
//+------------------------------------------------------------------+
   if(TotalOrderCount(Symbol(), MagicNumber)==0)
   {
      Alert("No Orders, Expert Removed!");
      ExpertRemove();
   };
  }
//+------------------------------------------------------------------+
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
   double CalcPoint;
   int CalcDigits = MarketInfo(Currency, MODE_DIGITS);
   if ( ( CalcDigits == 2) || ( CalcDigits == 3) ) CalcPoint = 0.01;
   if ( ( CalcDigits == 4) || ( CalcDigits == 5) ) CalcPoint = 0.0001;
   return(CalcPoint);
};//+------------------------------------------------------------------+
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
   if(Ticket == -1)
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
   if(Ticket == -1)
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
   if(argAdjustPrice >= LowerStopLevel) AdjustedPrice = LowerStopLevel - (argAddPips * PipPoint(argSymbol));
   else AdjustedPrice = argAdjustPrice;
   return(AdjustedPrice);
};
//+------------------------------------------------------------------+
//| Stop Orders Count          |
//+------------------------------------------------------------------+

int StopsCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
      if(OrderMagicNumber()==argMagicNumber && OrderSymbol()==argSymbol && (OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP))   OrderCount++;
   };
   return OrderCount;
};
//+------------------------------------------------------------------+
//| Close All Stop Orders          |
//+------------------------------------------------------------------+

void CloseAllStopOrders(string argSymbol, int argMagicNumber)
{
   for(int Counter = 0; Counter<=OrdersTotal()-1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
      if(OrderMagicNumber()==argMagicNumber && OrderSymbol()==argSymbol && (OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP))
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
//| Total Orders Count             |
//+------------------------------------------------------------------+

int TotalOrderCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal() - 1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
      if ( (OrderMagicNumber() == argMagicNumber) && (OrderSymbol() == argSymbol) ) OrderCount++;
   };
   return(OrderCount);
};
//+------------------------------------------------------------------+
//| Close All Market Orders                                          |
//+------------------------------------------------------------------+

void CloseAllMarketOrders(string argSymbol, int argMagicNumber, int argSlippage)
{
   for ( int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      bool selected = OrderSelect(Counter, SELECT_BY_POS);
      if( (OrderSymbol() == argSymbol) && (OrderMagicNumber() == argMagicNumber) && ((OrderType() == OP_BUY)||(OrderType() == OP_SELL)) )
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