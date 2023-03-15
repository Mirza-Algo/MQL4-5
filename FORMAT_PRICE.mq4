//+------------------------------------------------------------------+
//|                                                  FormatPrice.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
enum format
{
   XXXXX = 1,
   XPXXXX = 2,
   XXPXXX = 3,
   XXXPXX = 4,
   XXXXPX = 5
};
extern format FORMAT = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   double price = MarketInfo(Symbol(), MODE_BID);
   string value = func(price, FORMAT);
   ObjectCreate(0, "price", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("price", StringConcatenate("Formatted Price: ", value), 20, "Verdana", clrRed);
   ObjectSet("price" ,OBJPROP_CORNER, 0);
   ObjectSet("price" ,OBJPROP_YDISTANCE, 20); 
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectDelete(0, "price");
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double price = MarketInfo(Symbol(), MODE_BID);
   string value = func(price, FORMAT);
   ObjectCreate(0, "price", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("price", StringConcatenate("Formatted Price: ", value), 20, "Verdana", clrRed);
   ObjectSet("price" ,OBJPROP_CORNER, 0);
   ObjectSet("price" ,OBJPROP_YDISTANCE, 20); 
   
  }
//+------------------------------------------------------------------+
string func(double argPrice, format argformat)
{
   double price_original = argPrice;
   string p_1 = DoubleToStr(price_original, 10);
   StringReplace(p_1, ".", "");
   double p_2 = StrToDouble(p_1);
   string p_3 = DoubleToStr(p_2);
   uchar p_4[];
   StringToCharArray(p_3, p_4, 0, 5);
   string p_5 = CharArrayToString(p_4, 0, WHOLE_ARRAY);
   int n = StringToInteger(p_5);
   double m = n;
   string N, M;
   switch(argformat)
   {
      case 1:
         m = EMPTY_VALUE;
         N = IntegerToString(n);
         break;
      case 2:
         n = EMPTY_VALUE;
         m = m/10000;
         M = DoubleToStr(m, 4);
         break;
      case 3:
         n = EMPTY_VALUE;
         m = m/1000;
         M = DoubleToStr(m, 3);
         break;
      case 4:
         n = EMPTY_VALUE;
         m = m/100;
         M = DoubleToStr(m, 2);
         break;
      case 5:
         n = EMPTY_VALUE;
         m = m/10;
         M = DoubleToStr(m, 1);
         break;
   };
   if(n!=EMPTY_VALUE)   return(N);
   else if(m!=EMPTY_VALUE) return(M);
   else return("NULL");
};