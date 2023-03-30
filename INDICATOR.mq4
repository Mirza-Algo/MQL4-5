//+------------------------------------------------------------------+
//|                                                          ALI.mq4 |
//|                         Copyright 2023, Muhammad Mubashir Mirza. |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza."
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2

//+------------------------------------------------------------------+
//| Custom indicator External and Global Variables                   |
//+------------------------------------------------------------------+

extern int MIN_MOMNETUM = 5;
extern int MAX_RETRACE = 3;
extern int PRICEACTION = 20;
extern double ENGULFING_P = 100;
extern int LICENSE_CODE = 12345678;
double BULL[];
double BEAR[];
datetime CurrentTimeStamp;
int MomentumShift;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_ARROW, STYLE_DOT, 5, clrBlue);
   SetIndexBuffer(0, BULL);
   SetIndexLabel(0, "BULL");
   SetIndexArrow(0, 233);
   
   SetIndexStyle(1, DRAW_ARROW, STYLE_DOT, 5, clrRed);
   SetIndexBuffer(1, BEAR);
   SetIndexLabel(1, "BEAR");
   SetIndexArrow(1, 234); 
   
   Comment("Ali Indicator");
   CurrentTimeStamp = iTime(Symbol(), 0, 0);
   
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator Deinit Function                                 |
//+------------------------------------------------------------------+

void deinit()
{
   Comment("");
};

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//--- 
   //-----------Expiration-------------------
   datetime expiration_time = StrToTime("2023.03.30 00.00.00");
   if( (LICENSE_CODE != 23057489) && (TimeLocal()>=expiration_time) )
   {
      Alert("");Alert("");Alert("");Alert("");Alert("");Alert("");Alert("");Alert("");Alert("");Alert("");
      Alert("License expired, contact the developer!");
      return(-1);
   };
   //-----------Main Function----------------
   int counted_bars = IndicatorCounted();
   int CalculateBars = Bars - counted_bars;
   for(int Count = CalculateBars; Count >= 0; Count--)
   {
      int Shift = Count+1;
      if(Engulfing(Shift, 0)==0 && RETRACEMENT(Shift)==1  &&
                  MOMUMTUM()==0 && PRICE_ACTION(0)==true )        BULL[Shift] = iLow(Symbol(), 0, Shift) - (WindowPriceMax()-WindowPriceMin() )/20;
      else if(Engulfing(Shift, 1)==1 && RETRACEMENT(Shift)==0 &&
                       MOMUMTUM()==1 && PRICE_ACTION (1)==true )  BEAR[Shift] = iHigh(Symbol(), 0, Shift) + (WindowPriceMax()-WindowPriceMin() )/20;
   };
   //----------Alerts-----------------------
   if(CurrentTimeStamp != iTime(Symbol(), 0, 0))
   {
      CurrentTimeStamp = iTime(Symbol(), 0, 0);
      if(BULL[1]!=EMPTY_VALUE)
      {
          Alert(StringConcatenate(Symbol(), " : Bullish Setup!"));
      }
      else if(BEAR[1]!=EMPTY_VALUE) 
      {
         Alert(StringConcatenate(Symbol(), " : Bearish Setup!"));
      };
   };
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|      Bullish Candle Function                                     |
//+------------------------------------------------------------------+
bool BullishCandle(int argShift)
{
   if(iClose(Symbol(), 0, argShift)>iOpen(Symbol(), 0, argShift)) return(true);
   //else if(iClose(Symbol(), 0, argShift)==iOpen(Symbol(), 0, argShift)) return(true);
   else return(false);
};
//+------------------------------------------------------------------+
//|      BearishCandle Function                                      |
//+------------------------------------------------------------------+
bool BearishCandle(int argShift)
{
   if(iClose(Symbol(), 0, argShift)<iOpen(Symbol(), 0, argShift)) return(true);
   //else if(iClose(Symbol(), 0, argShift)==iOpen(Symbol(), 0, argShift)) return(true);
   else return(false);
};
//+------------------------------------------------------------------+
//|      Engulfing Function                                          |
//+------------------------------------------------------------------+
int Engulfing(int argShift, int argType)
{
   int return_value = EMPTY_VALUE;
   double price = NormalizeDouble(0, 5);
   if(argType==0)
   {
      price = iOpen(Symbol(), 0, argShift+1) - iClose(Symbol(), 0, argShift+1);
      price = price * (ENGULFING_P/100);
      price = price + iClose(Symbol(), 0, argShift+1);
      if(BearishCandle(argShift+1)==true && BullishCandle(argShift)==true &&
           iClose(Symbol(), 0, argShift)>=price//&&iOpen(Symbol(), 0, argShift)<=iClose(Symbol(),0,argShift+1)
           )    return_value = 0;
      else return_value = -1;
   }
   else if(argType==1)
   {
      price =  iClose(Symbol(), 0, argShift+1) - iOpen(Symbol(), 0, argShift+1);
      price = price * (ENGULFING_P/100);
      price = iClose(Symbol(), 0, argShift+1) - price;
      if(BullishCandle(argShift+1)==true && BearishCandle(argShift)==true &&
          iClose(Symbol(), 0, argShift)<=price/*&&iOpen(Symbol(), 0, argShift)>=iClose(Symbol(),0,argShift+1)*/)return_value = 1;
      else return_value = -1;
   }
   else return_value = -1;
   return(return_value);
};
//+------------------------------------------------------------------+
//|      RETRACEMENT Function                                        |
//+------------------------------------------------------------------+
int RETRACEMENT(int argShift)
{
   int RetraceShift = argShift+1;
   int bullish_retrace_count, bearish_retrace_count;
   bullish_retrace_count = bearish_retrace_count = 0;
   int return_value;
   if(BullishCandle(RetraceShift)==true)
   {
      bullish_retrace_count += 1;
      RetraceShift += 1;
      while(BullishCandle(RetraceShift)==true)
      {
          bullish_retrace_count += 1;
          RetraceShift += 1;
      };
   }
   else if(BearishCandle(RetraceShift)==true)
   {
      bearish_retrace_count += 1;
      RetraceShift += 1;
      while(BearishCandle(RetraceShift)==true)
      {
          bearish_retrace_count += 1;
          RetraceShift += 1;
      };
   };
   if(bullish_retrace_count>0 && bullish_retrace_count<=MAX_RETRACE) return_value = 0;
   else if(bearish_retrace_count>0 && bearish_retrace_count<=MAX_RETRACE)  return_value = 1;
   else return_value = -1;
   MomentumShift = RetraceShift;
   return(return_value);
};
//+------------------------------------------------------------------+
//|      MOMENTUM Function                                           |
//+------------------------------------------------------------------+
int MOMUMTUM()
{
   int momentum_shift = MomentumShift;
   int return_value;
   int bullish_momentum_count, bearish_momentum_count;
   bullish_momentum_count = bearish_momentum_count = 0;
   if(BullishCandle(momentum_shift)==true)
   {
      bullish_momentum_count += 1;
      momentum_shift += 1;
      while(BullishCandle(momentum_shift)==true)
      {
         bullish_momentum_count += 1;
         momentum_shift += 1;
      };
   }
   if(BearishCandle(momentum_shift)==true)
   {
      bearish_momentum_count += 1;
      momentum_shift += 1;
      while(BearishCandle(momentum_shift)==true)
      {
         bearish_momentum_count += 1;
         momentum_shift += 1;
      };
   };
   if(bullish_momentum_count >= MIN_MOMNETUM)  return_value = 0;
   else if(bearish_momentum_count>=MIN_MOMNETUM)   return_value = 1;
   else return_value = -1;
   return(return_value);
};
//+------------------------------------------------------------------+
//|      PRICEACTION Function                                        |
//+------------------------------------------------------------------+
bool PRICE_ACTION(int argType)
{
   int priceaction_shift = MomentumShift;
   bool return_value;
   if(argType==0)
   {
      if(iHigh(Symbol(), 0, priceaction_shift-1)>iHigh(Symbol(), 0, priceaction_shift)) priceaction_shift -= 1;
      int ihighest_index = iHighest(Symbol(), 0, MODE_HIGH, PRICEACTION, priceaction_shift);
      if(iHigh(Symbol(), 0, ihighest_index)==iHigh(Symbol(), 0, priceaction_shift)) return_value=true;
      else return_value = false;
   }
   else if(argType==1)
   {
      if(iLow(Symbol(), 0, priceaction_shift-1)<iLow(Symbol(), 0, priceaction_shift)) priceaction_shift -= 1;
      int ilowest_index = iLowest(Symbol(), 0, MODE_LOW, PRICEACTION, priceaction_shift);
      if(iLow(Symbol(), 0, ilowest_index)==iLow(Symbol(), 0, priceaction_shift)) return_value=true;
      else return_value = false;
   };
   return return_value;
};
//===========================================================================================================================
//===========================================================================================================================
//===========================================================================================================================