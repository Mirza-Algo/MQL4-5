//+------------------------------------------------------------------+
//|                                               QUANT_EA_ALPHA.mq5 |
//|                         Copyright 2023, Muhammad Mubashir Mirza. |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza."
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#include "..\Include\Trade\Trade.mqh"
#include <MoneyManagement.mqh>
#include <Pending.mqh>
#include <Trade.mqh>
#include <Price.mqh>
CPending Pending;
ATrade Trade;
CTrade trade;
//+------------------------------------------------------------------+
//| External & Global Variables                                      |
//+------------------------------------------------------------------+

input double EquityPercent  = 0.0;
input double RiskAmount     = 0.0;
input double FixedLotSize   = 0.0;

double LotSize = 0.0;
int StopLoss = 0;
int TakeProfit = 0;
int MagicNumber = 786;
double glBuyPlaced, glSellPlaced;
double Price;
long ChartType;
datetime TimeStamp = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ChartType = ChartGetInteger(0, CHART_MODE);
   TimeStamp = iTime(_Symbol, PERIOD_M1, 0);
   ObjectsDeleteAll(0);
   Price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   glBuyPlaced = glSellPlaced = false;
   StopLoss = 100;
   TakeProfit = StopLoss * 2;
   if(RiskAmount!=0)
   {
         double equitypercent = (RiskAmount/AccountInfoDouble(ACCOUNT_EQUITY)) * 100;
         LotSize = MoneyManagement(_Symbol, FixedLotSize, equitypercent, StopLoss);
   }
   else  LotSize = MoneyManagement(_Symbol, FixedLotSize, EquityPercent, StopLoss);
//-----------------------BUYSTOP ORDER----------------------------------------------------------------------
   double PendingPrice = Price + (PipPoint(_Symbol)*10);
   PendingPrice = AdjustAboveStopLevel(_Symbol, PendingPrice);
   double BuyStopLoss = BuyStopLoss(_Symbol, StopLoss, PendingPrice);
   double BuyTakeProfit = BuyTakeProfit(_Symbol, TakeProfit, PendingPrice);
   glBuyPlaced = Trade.BuyStop(_Symbol, LotSize, PendingPrice, BuyStopLoss, BuyTakeProfit, 0, "MUBASHIR MIRZA");
//----------------------SELLSTOP ORDER---------------------------------------------------------------------------
   PendingPrice = Price - (PipPoint(_Symbol)*10);
   PendingPrice = AdjustBelowStopLevel(_Symbol, PendingPrice);
   double SellStopLoss = SellStopLoss(_Symbol, StopLoss, PendingPrice);
   double SellTakeProfit = SellTakeProfit(_Symbol, TakeProfit, PendingPrice);
   glSellPlaced = Trade.SellStop(_Symbol, LotSize, PendingPrice, SellStopLoss, SellTakeProfit, 0, "MUBASHIR MIRZA");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectsDeleteAll(0);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//+------------------------------------------------------------------+
//| Close All forcibly on interrupt.                                 |
//+------------------------------------------------------------------+
if(ChartGetInteger(0, CHART_MODE)!=ChartType)
{
   while(OrdersTotal()>0)
   {  
      ulong ticket = OrderGetTicket(0);
      trade.OrderDelete(ticket);
   };
   while(PositionsTotal()>0)
   {
      ulong ticket = PositionGetTicket(0);
      trade.PositionClose(ticket);
   };
};
//+------------------------------------------------------------------+
//| Close the other after activation of one.                         |
//+------------------------------------------------------------------+
   if(OrdersTotal()==1)
   {
      while(OrdersTotal()>0)
      {
         for(int c=OrdersTotal()-1; c>=0; c--)
         {
            ulong ticket = OrderGetTicket(c);
            bool selected = OrderSelect(ticket);
            if(OrderType(ticket)==ORDER_TYPE_BUY_STOP || OrderType(ticket)==ORDER_TYPE_SELL_STOP)
            {
               Trade.Delete(ticket);
            }
         }
      }
   }
//+------------------------------------------------------------------+
//| Modify after placement.                                          |
//+------------------------------------------------------------------+
if(OrdersTotal()==2 && iTime(_Symbol, PERIOD_M1, 0)==TimeStamp)
{
   Price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   //Modify BuyStop Order
   double PendingPrice = Price + (PipPoint(_Symbol)*10);
   PendingPrice = AdjustAboveStopLevel(_Symbol, PendingPrice);
   ulong ticket = OrderGetTicket(0);
   bool selected = OrderSelect(ticket);
   double OpenPrice = OrderOpenPrice(ticket);
   if(OrderGetInteger(ORDER_TYPE) != ORDER_TYPE_BUY_STOP)
   {
      ticket = OrderGetTicket(1);
      selected = OrderSelect(ticket);
      OpenPrice = OrderOpenPrice(ticket);
   };
   if(MathAbs(OpenPrice-PendingPrice)>=0.0001)
   {
      double BuyStopLoss = BuyStopLoss(_Symbol, StopLoss, PendingPrice);
      double BuyTakeProfit = BuyTakeProfit(_Symbol, TakeProfit, PendingPrice);
      Trade.ModifyPending(ticket, PendingPrice, BuyStopLoss, BuyTakeProfit, 0);
   };
   //Modify SellStop Order
   PendingPrice = Price - (PipPoint(_Symbol)*10);
   PendingPrice = AdjustBelowStopLevel(_Symbol, PendingPrice);
   ticket = OrderGetTicket(0);
   selected = OrderSelect(ticket);
   OpenPrice = OrderOpenPrice(ticket);
   if(OrderGetInteger(ORDER_TYPE) != ORDER_TYPE_SELL_STOP)
   {
      ticket = OrderGetTicket(1);
      selected = OrderSelect(ticket);
      OpenPrice = OrderOpenPrice(ticket);
   };
   if(MathAbs(OpenPrice-PendingPrice)>=0.0001)
   {
      double SellStopLoss = SellStopLoss(_Symbol, StopLoss, PendingPrice);
      double SellTakeProfit = SellTakeProfit(_Symbol, TakeProfit, PendingPrice);
      Trade.ModifyPending(ticket, PendingPrice, SellStopLoss, SellTakeProfit, 0);
   }
};
//+------------------------------------------------------------------+
//| Close after done.                                                |
//+------------------------------------------------------------------+
   if(PositionsTotal()==0 && OrdersTotal()==0)
   {
      Alert("No Orders, Expert Removed!");
      ExpertRemove();
   }
  }
//+------------------------------------------------------------------+