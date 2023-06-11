//+------------------------------------------------------------------+
//|                                                      testing.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property show_inputs;
input double price = 1.0000;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   double point = Point();
   double pip = point*10;
   ObjectDelete(0, "BUYSTOP");
   ObjectDelete(0, "SELLSTOP");
   ObjectDelete(0, "BUYTP");
   ObjectDelete(0, "SELLTP");
   ObjectDelete(0, "START");
   ObjectCreate(0, "START", OBJ_HLINE, 0, TimeCurrent(), price);
   ObjectCreate(0, "BUYSTOP", OBJ_HLINE, 0, TimeCurrent(), price+(pip*10));
   ObjectCreate(0, "SELLSTOP", OBJ_HLINE, 0, TimeCurrent(), price-(pip*10));
   ObjectCreate(0, "BUYTP", OBJ_HLINE, 0, TimeCurrent(), price+(pip*30));
   ObjectCreate(0, "SELLTP", OBJ_HLINE, 0, TimeCurrent(), price-(pip*30));
   ObjectSetInteger(0, "BUYSTOP", OBJPROP_COLOR, clrBlue);
   ObjectSetInteger(0, "BUYTP", OBJPROP_COLOR, clrBlue);
   ObjectSetInteger(0, "START", OBJPROP_COLOR, clrWhite);
  }
//+------------------------------------------------------------------+
