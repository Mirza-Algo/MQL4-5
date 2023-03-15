//+------------------------------------------------------------------+
//|                                                  COPY_ORDERS.mq4 |
//|                         Copyright 2023, Muhammad Mubashir Mirza. |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza."
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#property strict
#include <stdlib.mqh>
#property show_inputs;
#property tester_file "orders.txt"
int x = 1;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnInit()
  {
//---
  }
//+------------------------------------------------------------------+
void OnTick()
{
   if(!IsTesting())
   {
      func();
      ExpertRemove();
   }
   else if(IsTesting())
   {
      if(x==1)
      {
         func();
         x = x + 1;
      };
   };
};
void OnDeinit(const int reason)
  {
//---
   
  }
void func()
{
      int FileHandle = FileOpen("orders.txt", FILE_READ|FILE_CSV|FILE_COMMON);
   if(FileHandle==INVALID_HANDLE)
   {
      int err = GetLastError();
      string ErrDesc = ErrorDescription(err);
      Alert(StringConcatenate("Error ", err, ": ", ErrDesc));
   }
   else
   {
      int c = 1;
      while(!FileIsEnding(FileHandle))
      {
         string s = FileReadString(FileHandle, 0);
         string values[7];
         ushort sep_code = StringGetChar(",", 0);
         StringSplit(s, sep_code, values);
         int order_type = StringToInteger(values[2]);;
         double order_volume = StringToDouble(values[3]);
         double order_price = StringToDouble(values[4]);
         double order_sl = StringToDouble(values[5]);
         double order_tp = StringToDouble(values[6]);  
         if(order_type==0)
         {
            if(Bid<order_price)
            {
               while(IsTradeContextBusy()) Sleep(10);
               int ticket = OrderSend(Symbol(), OP_BUYSTOP, order_volume, order_price, 100, 0, 0, "Orders from text file");
               if(ticket==-1)
               {
                  int ErrCode = GetLastError();
                string ErrDesc = ErrorDescription(ErrCode);
                Print(OrderTicket(), " Open BuyStop Order Error: ", ErrCode, ": ", ErrDesc);
               };
               if(ticket>0)
                {
                   while(IsTradeContextBusy()) Sleep(10);
                   bool selected = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
                   bool modified = OrderModify(ticket, OrderOpenPrice(), order_sl, order_tp, 0, clrNONE);
                   if(modified==false)
                  {
                     int ErrCode = GetLastError();
                   string ErrDesc = ErrorDescription(ErrCode);
                   Print(OrderTicket(), " Order Modify Error: ", ErrCode, ": ", ErrDesc);
                  };
               };
            }
            else if(Bid>order_price)
            {
               while(IsTradeContextBusy()) Sleep(10);
               int ticket = OrderSend(Symbol(), OP_BUYLIMIT, order_volume, order_price, 100, 0, 0, "Orders from text file");
               if(ticket==-1)
               {
                  int ErrCode = GetLastError();
                string ErrDesc = ErrorDescription(ErrCode);
                Print(OrderTicket(), " Open BuyLimit Order Error: ", ErrCode, ": ", ErrDesc);
               };
               if(ticket>0)
                {
                   while(IsTradeContextBusy()) Sleep(10);
                   bool selected = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
                   bool modified = OrderModify(ticket, OrderOpenPrice(), order_sl, order_tp, 0, clrNONE);
                   if(modified==false)
                  {
                     int ErrCode = GetLastError();
                   string ErrDesc = ErrorDescription(ErrCode);
                   Print(OrderTicket(), " Order Modify Error: ", ErrCode, ": ", ErrDesc);
                  };
               };
            };
            
         }
         if(order_type==1)
         {
            if(Bid>order_price)
            {
               while(IsTradeContextBusy()) Sleep(10);
               int ticket = OrderSend(Symbol(), OP_SELLSTOP, order_volume, order_price, 100, 0, 0, "Orders from text file");
               if(ticket==-1)
               {
                 int ErrCode = GetLastError();
                string ErrDesc = ErrorDescription(ErrCode);
                Print(OrderTicket(), " Open SellStop Order Error: ", ErrCode, ": ", ErrDesc);
               };
               if(ticket>0)
               {
                while(IsTradeContextBusy()) Sleep(10);
                bool selected = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
                bool modified = OrderModify(ticket, OrderOpenPrice(), order_sl, order_tp, 0, clrNONE);
                if(modified==false)
                {
                   int ErrCode = GetLastError();
                   string ErrDesc = ErrorDescription(ErrCode);
                   Print(OrderTicket(), " Order Modify Error: ", ErrCode, ": ", ErrDesc);
                };
               };
            }
            else if(Bid<order_price)
            {
               while(IsTradeContextBusy()) Sleep(10);
               int ticket = OrderSend(Symbol(), OP_SELLLIMIT, order_volume, order_price, 100, 0, 0, "Orders from text file");
               if(ticket==-1)
               {
                 int ErrCode = GetLastError();
                string ErrDesc = ErrorDescription(ErrCode);
                Print(OrderTicket(), " Open SellLimit Order Error: ", ErrCode, ": ", ErrDesc);
               };
               if(ticket>0)
               {
                while(IsTradeContextBusy()) Sleep(10);
                bool selected = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);
                bool modified = OrderModify(ticket, OrderOpenPrice(), order_sl, order_tp, 0, clrNONE);
                if(modified==false)
                {
                   int ErrCode = GetLastError();
                   string ErrDesc = ErrorDescription(ErrCode);
                   Print(OrderTicket(), " Order Modify Error: ", ErrCode, ": ", ErrDesc);
                };
               };
            };
            
         };
   };
   };
   FileClose(FileHandle);
};