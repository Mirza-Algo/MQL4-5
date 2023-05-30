//+------------------------------------------------------------------+
//|                                                       MPIANA.mq5 |
//|                         Copyright 2023, Muhammad Mubashir Mirza. |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza."
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots 4
//+------------------------------------------------------------------+
//| Change Account Number and Expiry down here!                      |
//+------------------------------------------------------------------+
  
long   AccountNumber = 30819066;
string ExpiryDate    = "2023.05.31";

//+------------------------------------------------------------------+
//| Change Account Number and Expiry up here!                      |
//+------------------------------------------------------------------+
//-------Support---------
#property indicator_label1 "Support"
#property indicator_type1 DRAW_LINE
#property indicator_color1 clrHotPink
#property indicator_width1 2
//-------Resistance----------
#property indicator_label2 "Resistance"
#property indicator_type2 DRAW_LINE
#property indicator_color2 clrHotPink
#property indicator_width2 2
//-------Buy Signal----------
#property indicator_label3 "BUY"
#property indicator_type3 DRAW_ARROW
#property indicator_color3 clrBlue
#property indicator_width3 3
//-------Sell Signal-------------
#property indicator_label4 "SELL"
#property indicator_type4 DRAW_ARROW
#property indicator_color4 clrRed
#property indicator_width4 3
//--------Indicator Buffers
double Support[];
double Resistance[];
double BUY[];
double SELL[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0, Support, INDICATOR_DATA);
   SetIndexBuffer(1, Resistance, INDICATOR_DATA);
   SetIndexBuffer(2, BUY, INDICATOR_DATA);
   SetIndexBuffer(3, SELL, INDICATOR_DATA);
   PlotIndexSetInteger(2, PLOT_ARROW, 233);
   PlotIndexSetInteger(3, PLOT_ARROW, 234);
//---
   return(INIT_SUCCEEDED);
  }
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
//---Check Expiration-----
   if(AccountInfoInteger(ACCOUNT_LOGIN)!=AccountNumber || TimeLocal()>=StringToTime(ExpiryDate))
   {
      Alert("License Expired!");
      return(rates_total);
   }
//------------------------
   if(NewBar.CheckNewBar(_Symbol, _Period)==true)
   {
   ArraySetAsSeries(Support, true);
   ArraySetAsSeries(Resistance, true);
   ArraySetAsSeries(BUY, true);
   ArraySetAsSeries(SELL, true);

   int DailyShift = 1;
   string CurrentTime = TimeToString(iTime(Symbol(), 0, 0), TIME_DATE);
   string TIMES[3];
   StringSplit(CurrentTime, StringGetCharacter(".", 0), TIMES);
   long current_day = StringToInteger(TIMES[2]);
   
   
   int bars = rates_total - 1;
   if(prev_calculated > 0) bars = rates_total - (prev_calculated - 1);
   for(int Count = 0; Count<=bars; Count++)
   {
      if(Count>=bars-1) break;      //Array Out of Range Problem Fix.
      string candle_time = TimeToString(iTime(Symbol(), 0, Count), TIME_DATE);
      string times[3];
      StringSplit(candle_time, StringGetCharacter(".", 0), times);
      long candle_day = StringToInteger(times[2]);
      if(candle_day != current_day)
      {
         current_day = candle_day;
         DailyShift++;
      };
      double HIGH = iHigh(_Symbol, PERIOD_D1, DailyShift);
      double LOW = iLow(_Symbol, PERIOD_D1, DailyShift);
      double CLOSE = iClose(_Symbol, PERIOD_D1, DailyShift);
      
      double PP = (HIGH+LOW+CLOSE)/3;
      Support[Count] =  (2*PP)-HIGH;  Support[Count] = NormalizeDouble(Support[Count], _Digits);
      Resistance[Count] = (2*PP)-LOW; Resistance[Count] = NormalizeDouble(Resistance[Count], _Digits);
      
      if(iClose(_Symbol, _Period, Count+2)>Resistance[Count] && iClose(_Symbol, _Period, Count+1)>Resistance[Count]
      && iClose(_Symbol, _Period, Count+3)<Resistance[Count])
      {
         BUY[Count+1] = iLow(_Symbol, _Period, Count+1);
      }
      
      else if(iClose(_Symbol, _Period, Count+2)<Support[Count] && iClose(_Symbol, _Period, Count+1)<Support[Count]
      && iClose(_Symbol, _Period, Count+3)>Support[Count])
      {
         SELL[Count+1] = iHigh(_Symbol, _Period, Count+1);
      }
      
      else if(iClose(_Symbol, _Period, Count+2)<Support[Count] && iClose(_Symbol, _Period, Count+1)>Support[Count]
      && iClose(_Symbol, _Period, Count+3)>Support[Count])
      {
         BUY[Count+1] = iLow(_Symbol, _Period, Count+1);
      }
      
      else if(iClose(_Symbol, _Period, Count+2)>Resistance[Count] && iClose(_Symbol, _Period, Count+1)<Resistance[Count]
      && iClose(_Symbol, _Period, Count+3)<Resistance[Count])
      {
         SELL[Count+1] = iHigh(_Symbol, _Period, Count+1);
      }
      else if(iClose(_Symbol, _Period, Count+3)<Support[Count] && iClose(_Symbol, _Period, Count+2)>Support[Count]
      && iClose(_Symbol, _Period, Count+1)>Support[Count])
      {
         BUY[Count+1] = iLow(_Symbol, _Period, Count+1);
      }
      else if(iClose(_Symbol, _Period, Count+3)>Resistance[Count] && iClose(_Symbol, _Period, Count+2)<Resistance[Count]
      && iClose(_Symbol, _Period, Count+1)<Resistance[Count])
      {
         SELL[Count+1] = iHigh(_Symbol, _Period, Count+1);
      }
      else
        {
         BUY[Count+1] = 0;
         SELL[Count+1] = 0;
        }

//--------------------------------
   }
//-----Alerts---------------------
      string alert;
      double price = iClose(_Symbol, _Period, 1);
      if(BUY[1] != 0)
      {
         StringConcatenate(alert, _Symbol, " : ", price, " : Buy Signal!");
         Alert(alert); 
      }
      else if(SELL[1] != 0)
      {
         StringConcatenate(alert, _Symbol, " : ", price, " : Sell Signal!");
         Alert(alert);
      }
   };
      
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Check for New Bar                                                |
//+------------------------------------------------------------------+

class CNewBar
{
	private:
		datetime Time[], LastTime;
	
	public:
		void CNewBar();
		bool CheckNewBar(string pSymbol, ENUM_TIMEFRAMES pTimeframe);
};


void CNewBar::CNewBar(void)
{
	ArraySetAsSeries(Time,true);
}


bool CNewBar::CheckNewBar(string pSymbol,ENUM_TIMEFRAMES pTimeframe)
{
	bool firstRun = false, newBar = false;
	CopyTime(pSymbol,pTimeframe,0,2,Time);
	
	if(LastTime == 0) firstRun = true;
	
	if(Time[0] > LastTime)
	{
		newBar = true;
		LastTime = Time[0];
	}
	
	return(newBar);
};
CNewBar NewBar;
//+------------------------------------------------------------------+
