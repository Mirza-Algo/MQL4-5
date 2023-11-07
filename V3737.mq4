//+------------------------------------------------------------------+ V3737 - NEWDAILY speed EA
//|                                                   EK EA.mq4 |
//|                              Copyright ï¿½ 2010, Ernst Kenk |
//|                                     e |
//+------------------------------------------------------------------+ //Pips Per Sec: OrderSend TP  ATT2 ContraryLastLine 
#property copyright "Copyright © 2010, Ernst Kenk"
#property link      "e"

// 13.2 - Added CloseAllTradesOnAverageMins, contained in the function subAverageMins();
// line 5115 to 5165 = pip profit total and timed tp functions
// line 181 to 184 = timedtp variables
// line 632 = timedtp function call

enum GMTDays
{
   Mon = 1, //Monday     
   Tues = 2,//Tuesday         
   Weds = 3,//Wednesday       
   Thurs = 4,//Thursday      
   Fri = 5,//Friday          
};

//SettingsSection1
extern string
   Password                  = "Password";
extern string
   ChartText                 = "ALGO V33";
extern string 
   ManualTradeID             = "MAN";

extern bool
   BrokerIsECN               = true;
extern double
   AddPipsToTP               = 2.0;      
extern int
   DENSE_MagicNumber         = 11111,
   CALM_MagicNumber          = 22222,
   Slippage                  = 5;
extern double
   GeneralDollarStopLoss_Pct = 50;   
extern bool
   UseEquityClose            = true;
extern double
   EquityClosePct            = 2.5;        
extern bool 
   UseTradeTime              = false,
   SkipNextTradeTime         = false,
   UseLocalTime              = true;
extern int  
   TradeTime_StartHour_1     = 7,
   TradeTime_StartMinute_1   = 30,
   TradeTime_EndHour_1       = 21,
   TradeTime_EndMinute_1     = 15,
   TradeTime_StartHour_2     = 7,
   TradeTime_StartMinute_2   = 30,
   TradeTime_EndHour_2       = 21,
   TradeTime_EndMinute_2     = 15,
   TradeTime_StartHour_3     = 7,
   TradeTime_StartMinute_3   = 30,
   TradeTime_EndHour_3       = 21,
   TradeTime_EndMinute_3     = 15,
   TradeTime_StartHour_4     = 7,
   TradeTime_StartMinute_4   = 30,
   TradeTime_EndHour_4       = 21,
   TradeTime_EndMinute_4     = 15,
   TradeTime_StartHour_5     = 7,
   TradeTime_StartMinute_5   = 30,
   TradeTime_EndHour_5       = 21,
   TradeTime_EndMinute_5     = 15,   
   TradeTime_StartHour_6     = 7,
   TradeTime_StartMinute_6   = 30,
   TradeTime_EndHour_6       = 21,
   TradeTime_EndMinute_6     = 15,
   TradeTime_StartHour_7     = 7,
   TradeTime_StartMinute_7   = 30,
   TradeTime_EndHour_7       = 21,
   TradeTime_EndMinute_7     = 15; 
  
extern bool
   TradeOnSunday             = false,
   TradeOnMonday             = true,
   TradeOnTuesday            = true,
   TradeOnWednesday          = true,
   TradeOnThursday           = true,
   TradeOnFriday             = true;
extern bool
   SkipTradeTime1OnMonday    = true;
extern int
   MaxTradePerTradeTime      = 12;
bool 
   UseMultiMaxTrades         = false,
   ForceMaxTrades            = false;
int
   MaxTrades_1               = 5,
   MaxTrades_2               = 10,
   MaxTrades_3               = 20,
   MaxTrades_4               = 30,
   MaxTrades_5               = 40,
   MaxTrades_6               = 50,
   MaxTrades_7               = 70,
   MaxTrades_8               = 80,
   MaxTrades_9               = 90,
   MaxTrades_10              = 100;      

extern bool
   UseNoTradeDate = false;
extern int
   NoTradeDates_StartMonth = 1, 
   NoTradeDates_StartDay = 1,
   NoTradeDates_EndMonth = 1, 
   NoTradeDates_EndDay = 2;
extern bool
   UseStandardTrailStop      = false;
extern int
   TrailStopStart            = 15,
   TrailingStop              = 15;       
extern bool
   UseExponentialGrid        = true;
extern double
   Exponential_Percent       = 0.50;
extern bool
   UseAveragePipTakeProfit   = true;
extern int
   AvePricePipTakeProfit     = 15;
extern bool
   UseSoftTarget             = true;
extern double
   SoftPipTarget             = 500;
   //RetracePercent_           = 30;    
extern bool
   AutoCalculateLots         = true;
extern double
   StartingCapital           = 10000,
   Lots                      = 0.1; 
extern double
   LotsMultiplier            = 1;   

extern bool
   TradeBuy                  = true,
   TradeSell                 = true;
extern int      
   MaxTrades                 = 10,
   InterruptTradingDays      = 3,
   MaxOpenTrades             = 50;
extern double   
   TakeProfit                = 100;
extern bool
   UseStopLoss               = false;  
extern double   
   Stop_Loss                 = 0;
extern bool
   UseInvisibleTPSL           = true;
extern int
   WaitToPlaceStop            = 0,
   WaitToResumeTradingAfterSL = 0,
   NoStopLossMinutes          = 30;   
extern bool
   ReviveTradeAfterSL         = false;   
extern double   
   TicksBetweenTrades         = 15,
   PipsBetweenTrades          = 15;
extern bool
   AddTradesAfterSeconds      = true;
extern int
   RetradeAfterHangDays       = 3;
extern int
   SecondsToAddTrades         = 3;
extern int
   MaxPipsPerSecond           = 3;
extern bool
   AddToWinningTrades         = true;
extern double 
   PipsProfitToAddTrades      = 3;
extern bool
   UseBrokerTakeProfit        = false, 
   UseMarketFillOrKill        = false,
   AddSwapToTP                = false; 
extern double
   CloseAllTotalPipProfit     = 100,
   TargetProfitOrLossUsd      = 10000,
   TargetProfitLossPlusCommission = 10000;  
 
extern bool
   ReverseTrading              = false,
   AutoReverseTrading          = false,
   AutoReverseTradingMinutes   = false;
extern int
   AutoReverseMinutes          = 30;
extern int
   PipsToSwitch                = 50;   
extern bool
   UseSecondLevel        = true;
extern int
   PipsFromVirtualTrade  = 120;   


extern bool
   FreeMarginLevelClose             = true; //v11
extern double
   FreeMarginPercentLevelClose      = 250;
extern int
   FreeMarginLevelCloseTradeCount   = 10;
extern bool
   CloseLowCountTradesAfterTradeTime= true; //v11
extern int
   MinimumTradesForTradeTime        = 5; 

extern bool
   OpenInstantTrades = true; //v14
extern double 
   InstantTradesLotMultiplier = 1.0;
extern int
   OpenInstantTrades_MinimumClosedProfit = 3;
   
extern bool
   UseCloseTradesGMT = true;
extern GMTDays
   CloseTradesGMTDay = 1;
extern int
   CloseTradesGMTHour = 7,
   CloseTradesGMTClosePercent = 50;
   
extern bool
   UseDrawdownCloseAllTrades = true;
extern double
   DrawdownCloseAllTradesPercent = 12;
extern bool   
   StopTradeSizeIncreaseInProfit = true,
   StopTradeSizeIncreaseInProfitResetStartAmount = false;
extern double 
   StopTradeSizeIncreaseInProfitPercent = 200,
   StopTradeSizeIncreaseInProfitStartAmount = 1000;
   
extern string
   Mirror_Settings = "------- Mirror Script Settings";
extern double
   MirrorLotsMultiplier             = 1.0;   
extern bool
   EnableMirrorTrading              = true,
   MirrorTradeClose                 = false;
extern int
   MirrorTradeClosePipsFromMainTrade = 2; //v13
extern int
   BrokerTakeProfit                 = 20;   
extern int Mirror_MagicNumber = 451496;
extern bool
   UseAveragePipTakeProfitMirror   = true;
extern int
   AvePricePipTakeProfitTrigger = 50,
   AvePricePipTakeProfitMax     = 50,
   AvePricePipTakeProfitMin     = 50;

extern string
   StdDev_Settings           = "-------- StdDev Settings";  
extern string
   Note                      = "Set to 0(zero) to disable StdDev rule";
extern double 
   NoTradeWhenGreaterThanX   =  0.0015,   
   NoTradeWhenIncreaseGreaterThanX  = 0.0001,
   TradePossibleWhenDecrease  = 0.0001;   
extern int
   StdDev_Period              = 10,
   StdDev_MA_Method           = MODE_SMA,
   StdDev_AppliedPrice        = PRICE_CLOSE;   
extern string
   Hedge_Settings             = "-------- Hedge Settings";  
extern bool
   UseHedgeMaxDD              = true;
extern double 
   HedgeMaxDDPct              = 50;
extern int
   HedgeTradeMagicNumber      = 34491;
   
extern string
   LureTrades_Settings        = "-------- Lure Trades Settings"; 
extern bool
   UseLureTrades              = false;
extern int
   LureTradeMagicNumber       = 123123,
   LureTradesToOpen           = 1,
   MaxLureTradesPerTradeTime  = 2,
   LureTradeOpenSeconds       = 1;
   
extern string
   ContraryPosition_Settings = "-------- Contrary Position  Settings";  
extern bool
   UseContraryPosition       = true;
extern int
   ContraryPositionMagicNumber = 111,
   ContraryPositionTP      = 20,
   ContraryPositionSL      = 20;
//----- EXTERNAL VARIABLES
extern bool 
   UseContraryPositionTrailingStop       = true;
extern int 
   ContraryPositionTrailStopTrigger      = 25,
   ContraryPositionTrailingStopPips      = 25; 

extern string
   HedgePair_Settings          = "-------- Hedge Pair Settings"; 
extern bool 
   OpenHedgePair               = true;  
extern int
   HedgePairMagicNumber        = 888,
   HedgePairCloseSeconds       = 1,
   MaxHedgePairTrades          = 10;

extern string
   SoftPipTargetLine_Settings  = "--- SoftPipTargetLine Settings";
extern bool
   ShowSoftPipTargetLine       = true;
extern color
   SoftPipTarget_LineColor     = clrYellow; 
input ENUM_LINE_STYLE
   SoftPipTarget_LineStyle     = STYLE_DOT;
 extern int
   SoftPipTarget_LineWidth     = 1;
   
extern string
   MirrorTradesTargetLine_Settings  = "--- MirrorTradesTargetLine Settings"; //v13
extern bool
   MirrorTradesTargetLine       = true;
extern color
   MirrorTradesTarget_LineColor     = clrAqua; 
input ENUM_LINE_STYLE
   MirrorTradesTarget_LineStyle     = STYLE_DOT;
extern int
   MirrorTradesTarget_LineWidth     = 1;
   
extern string
   ContraryTradesTargetLine_Settings  = "--- ContraryTradesTargetLine Settings"; //v13
extern bool
   ContraryTradesTargetLine       = true;
extern color
   ContraryTradesTarget_LineColor     = clrGoldenrod; 
input ENUM_LINE_STYLE
   ContraryTradesTarget_LineStyle     = STYLE_DOT;
extern int
   ContraryTradesTarget_LineWidth     = 1;

extern string
   AverageOpenPriceLine_Settings  = "--- AverageOpenPriceLine Settings";
extern bool
   ShowAverageOpenPriceLine       = true;
extern color
   AverageOpenPriceLine_LineColor = clrLime; 
input ENUM_LINE_STYLE
   AverageOpenPriceLine_LineStyle = STYLE_DOT;
 extern int
   AverageOpenPriceLine_LineWidth = 1;

extern string
   AveragePipTakeProfitLine_Settings  = "--- AveragePipTakeProfit Line Settings";
extern bool
   ShowAveragePipTakeProfitLine       = true;
extern color
   AveragePipTakeProfitLine_BuyTradeLineColor = clrGreen, 
   AveragePipTakeProfitLine_SellTradeLineColor = clrRed; 
input ENUM_LINE_STYLE
   AveragePipTakeProfitLine_LineStyle = STYLE_DOT;
 extern int
   AveragePipTakeProfitLine_LineWidth = 1;  

extern string
   RSI_Settings            = "-------- RSI Settings";
extern bool
   UseRSI_TPSL             = false; 
extern int  
   RSIPeriod               = 14, 
   LongExitLevel           = 67,
   ShortExitLevel          = 33,
   LongSLLevel             = 50,
   ShortSLLevel            = 50;
   
extern bool
   FastBackTest            = false;  
extern bool
   UseBreakevenAfterLoss   = true;
extern double
   BreakevenAfterLossPercent = 5;
extern bool
   UseMarginLimitCloseTrade     = true;
extern double
   MarginLimitCloseMarginPercentLevel = 100;  

//---  
extern double
   Backtest_percent = 0.9;
//---
//---
//---

 
int TextCorner = 4;  

int MyDigits;
double MyPoint;
double OLots;
double CLots;
datetime CTP;
bool FirstTime = true;
string ReName,DD,PP;
bool RSwitch;
double SwitchPrice = 0;
datetime SwitchTime = 0;
datetime OPO = 0;
datetime PerDay;
int tick = 0;

string HOL;
datetime LastTime;
datetime ATT;
string LastTicket;
string Cycles;
bool ReadyCycle;
double initTP = 0;
datetime DTT =0;
double Swap;
double
    InitAvePricePipTakeProfitTrig,
   InitAvePricePipTakeProfitMax,     
   InitAvePricePipTakeProfitMin,    
   InitBrokerTakeProfit;           
string StartingBal;
datetime EAStartTime;    
int StopLoss = 0;
datetime CloseTime;
datetime LastTimex=0;
double LastPrice=0;
datetime ResetTime =0;
string LastDecrease;
string DecreaseLot;

int MagicNumber;

datetime SkipTT;
string SkipTTGV;

string PREF = "ASEA:";

datetime LTTT;
datetime EBCTT;
double ABalance;

int MagicNumberOIT = (DENSE_MagicNumber+100);

bool NoTradeDateStopTrading;//v15
datetime AllLotsTT;//v15
bool UseBrokerTakeProfitForMirror = false;//v15

int TakeProfitX = TakeProfit;

datetime ATT2;
datetime ATT3;
double Lots1 = Lots;
datetime STT;

bool StopLureTrades;

string StopTradeSizeIncreaseInProfitGV;
string StopTradeSizeIncreaseInProfitTTGV;

bool BreakevenAfterLoss;

bool TradeBuyX = true;
bool TradeSellX = true;
string ReverseTime;
string ReverseTimeType;
//-------------------------------------------------------------------+
string expire_date = "2023.08.01"; // YYYY.MM.DD SET EXPIRY DATE     |
//-------------------------------------------------------------------+
string EAPassword = "MoeweMoewe1";//v15-v19.2
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   MagicNumber = DENSE_MagicNumber;
   LastDecrease = "LastDecrease:"+Symbol()+MagicNumber+":"+IsTesting();
   DecreaseLot = "DecreaseLOT:"+Symbol()+MagicNumber+":"+IsTesting();
   EAStartTime = TimeCurrent();
   InitAvePricePipTakeProfitTrig = AvePricePipTakeProfitTrigger;
   InitAvePricePipTakeProfitMax = AvePricePipTakeProfitMax;    
   InitAvePricePipTakeProfitMin = AvePricePipTakeProfitMin;   
   InitBrokerTakeProfit = BrokerTakeProfit;   
   initTP =CloseAllTotalPipProfit;

   PerDay = 0;
   if(UseStopLoss==false)StopLoss=0;
   if(Digits==5)MyDigits=4;
   else if(Digits==3)MyDigits=2;
   else MyDigits = Digits; 
   if (Point == 0.00001) MyPoint = 0.0001; //6 digits
   else if (Point == 0.001) MyPoint = 0.01; //3 digits (for Yen based pairs)
   else MyPoint = Point; //Normal
   ReName = "Restart Time: "+Symbol()+":"+MagicNumber+":"+IsTesting();
   Cycles = "CycleNumber: "+Symbol()+":"+MagicNumber+":"+IsTesting();  
   DD = "DrawDown: "+Symbol()+":"+MagicNumber+":"+IsTesting();
   PP = "Profit5.0: "+Symbol()+":"+MagicNumber+":"+IsTesting();
   HOL = "HOL: "+Symbol()+":"+MagicNumber+":"+IsTesting();
   LastTicket = "LastTicket: "+Symbol()+":"+MagicNumber+":"+IsTesting();
   StartingBal = "StartingBalTurbo:"+Symbol()+":"+MagicNumber+":"+IsTesting();
   CloseTime = 0;
   ResetTime = 0;
   
   if(IsTesting())GlobalVariableSet(HOL,0);
   if(IsTesting())
   {
      GlobalVariableDel(ReName);
      GlobalVariableDel(LastTicket);
   }
   ReadyCycle = false;
   CTP=0;
   RSwitch = ReverseTrading;
   ATT=iTime(Symbol(),0,0);
   //LastTime=0;
   if(IsTesting())GlobalVariablesDeleteAll("COMPLETED"+IsTesting()+":");

   Lots = Lots * LotsMultiplier;

   if(GlobalVariableGet(LastDecrease)<=0)GlobalVariableSet(LastDecrease,TimeCurrent());
   
   SkipTT = 0;//iTime(Symbol(),0,0);
   SkipTTGV = "SkipTTGV: "+Symbol()+":"+MagicNumber+":"+IsTesting(); 
   
   if(IsTesting())
   {
      GlobalVariableDel(SkipTTGV);
   }
   
   DELETE(PREF);
   DELETE(PREF);
   DELETE3(PREF);
   DELETE4(PREF);
   DELETE5B();
   DELETE5S();
   
   LTTT = 0;
   
   EBCTT = iTime(Symbol(),PERIOD_D1,0);
   ABalance = AccountBalance();
   
   NoTradeDateStopTrading = false;
   
   AllLotsTT = TimeCurrent();
   
   ATT2=0;
   ATT3=0;
   STT=0;
   
   StopLureTrades = false;
   
   StopTradeSizeIncreaseInProfitGV = "STSIIP.ALGO:"+Symbol()+":"+MagicNumber+":"+IsTesting();
   StopTradeSizeIncreaseInProfitTTGV = "STSIIPTT.ALGO:"+Symbol()+":"+MagicNumber+":"+IsTesting();
   if(StopTradeSizeIncreaseInProfit==true)
   {
      if(StopTradeSizeIncreaseInProfitResetStartAmount==true)
      {
         GlobalVariableSet(StopTradeSizeIncreaseInProfitGV,StopTradeSizeIncreaseInProfitStartAmount);
         GlobalVariableSet(StopTradeSizeIncreaseInProfitTTGV,TimeCurrent());
      }
      if(StopTradeSizeIncreaseInProfitResetStartAmount==false && GlobalVariableCheck(StopTradeSizeIncreaseInProfitGV)==false)
      {
         GlobalVariableSet(StopTradeSizeIncreaseInProfitGV,StopTradeSizeIncreaseInProfitStartAmount);
         GlobalVariableSet(StopTradeSizeIncreaseInProfitTTGV,TimeCurrent());
      }
   }
   if(StopTradeSizeIncreaseInProfit==false && GlobalVariableCheck(StopTradeSizeIncreaseInProfitGV)==true)
   {
      GlobalVariableDel(StopTradeSizeIncreaseInProfitGV);
      GlobalVariableDel(StopTradeSizeIncreaseInProfitTTGV);
   }
   //Print("StopTradeSizeIncreaseInProfitGV:"+GlobalVariableGet(StopTradeSizeIncreaseInProfitGV)+", StopTradeSizeIncreaseInProfitTTGV :"+GlobalVariableGet(StopTradeSizeIncreaseInProfitTTGV)+", StopTradeSizeIncreaseInProfitTTGV :"+TimeToStr(GlobalVariableGet(StopTradeSizeIncreaseInProfitTTGV),TIME_DATE|TIME_MINUTES));
   
   BreakevenAfterLoss = false;
   
   if(AutoReverseTradingMinutes==true)
   {
      if(TradeBuy==false)TradeBuyX=false;
      if(TradeSell==false)TradeSellX=false;
      ReverseTime = "ReverseTime: "+Symbol()+":"+MagicNumber+":"+IsTesting();
      ReverseTimeType = "ReverseTimeType: "+Symbol()+":"+MagicNumber+":"+IsTesting();
      GlobalVariableDel(ReverseTime);
      if(GlobalVariableGet(ReverseTime)<=0)GlobalVariableSet(ReverseTimeType,-1);
   }
   
   //---
   //---
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
   Print("TOTAL OF ALL LOTS OPENED :"+subAllLots());
   
   if(IsTesting())
   {
      GlobalVariableDel(LastDecrease);
      GlobalVariableDel(DecreaseLot);
   }
   
   DELETE(PREF);
   DELETE(PREF);
   DELETE3(PREF);
   DELETE4(PREF);
   DELETE5B();
   DELETE5S();
      
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   
   datetime e_d = StrToTime(expire_date);
      
   if (TimeCurrent() >= e_d && Password!=EAPassword)
   {
      Alert ("This EA will expire in 15 days. Please enter the correct password to continue.");
      return(0);
   }
   
   //---
   //---
   
   if(FastBackTest==true && IsTesting()==true)
   {
      ObjectsDeleteAll(0,OBJ_TREND);
      ObjectsDeleteAll(0,OBJ_ARROW);
      ObjectsDeleteAll(0,OBJ_LABEL);
   }
   
   if(UseRSI_TPSL==false)
   {
      if(UseInvisibleTPSL==true)
      {
         if(TakeProfitX>0)subVirtualTP(TakeProfitX);
         if(UseStopLoss==true && Stop_Loss>0)subVirtualSL(Stop_Loss);
         TakeProfit = 0;
         StopLoss=0;
      }
      if(UseInvisibleTPSL==false)
      {
         TakeProfit = TakeProfitX;
         subDelayedSL(MagicNumber, Stop_Loss);
         subDelayedSL(Mirror_MagicNumber, Stop_Loss);
      }
      
      if(UseSoftTarget==true)
      { 
         subSoftPipTarget(); //v11 
      }
   }
  
   if(UseRSI_TPSL==true)
   {
      RSITPSL();
   }

   if(UseHedgeMaxDD==true) 
   {
      bool HEDGED = subHedge(HedgeMaxDDPct, HedgeTradeMagicNumber);
      if(HEDGED==true)
      {
         Comment("Trading Disabled, Hedge DD Triggered.");
         return(0);
      }
   }
   if(subTotalTradeMagic(CALM_MagicNumber)>0)
   {
      Comment("Trading Stoppped, Algo CALM has a trade running");
      return(0);
   }
   
   if(CloseLowCountTradesAfterTradeTime==true) //v11
   {
      CloseTradesAtEndTradeTime(MinimumTradesForTradeTime); 
   }
   if(OpenHedgePair==true) //v12
   {
       subCloseHedgePairTrades(HedgePairCloseSeconds);
       
       int HedgePairCountToday = subTotalTradeHedgePairToday();
       if(HedgePairCountToday<MaxHedgePairTrades)
       {
         subTotalTrade_MainTrades(); 
       }
       
       subCloseHedgePairTrades(HedgePairCloseSeconds);
       subCloseHedgePairTrades(HedgePairCloseSeconds);
   }
   
   if(MirrorTradesTargetLine==true) //v13
   {
      subMirrorPipTarget();
   }
   if(MirrorTradesTargetLine==false) //v15
   {
      subVirtualTPMirror(BrokerTakeProfit);
   }
   
   if(ContraryTradesTargetLine==true) //v13
   {
      subContraryPipTarget();
   }

   if(OpenInstantTrades==true) //v14
   {
      subLastTradePL_OpenInstantTrades();
   }
   
   if(UseLureTrades==true)
   {
      subCloseOrderBySeconds(LureTradeOpenSeconds);
   }
   
   if(UseCloseTradesGMT==true) //32
   {
      int GMTHour = TimeHour(TimeGMT());
      //Print("GMTHour:"+GMTHour);
      if(GMTHour==CloseTradesGMTHour)
      {
         if(CloseTradesGMTDay==1 && DayOfWeek()==1)GMTClose();
         if(CloseTradesGMTDay==2 && DayOfWeek()==2)GMTClose();
         if(CloseTradesGMTDay==3 && DayOfWeek()==3)GMTClose();
         if(CloseTradesGMTDay==4 && DayOfWeek()==4)GMTClose();
         if(CloseTradesGMTDay==5 && DayOfWeek()==5)GMTClose();
      }
   }
   
   if(UseDrawdownCloseAllTrades==true)
   {
      double MagicDollarPnL = subDollarProfitTotalAllMagic();
      double MagicDDCal2 = (MagicDollarPnL/AccountBalance());
      double MagicDDCal3 = (MagicDDCal2*100);
      MagicDDCal3 = NormalizeDouble(MagicDDCal3,2);
      double DDClosePercent = (DrawdownCloseAllTradesPercent*(-1));
      //Print("MagicDDCal3: "+MagicDDCal3+", DDClosePercent :"+DDClosePercent);
      if(MagicDDCal3<=DDClosePercent)
      {
         subCloseOrderAllMagic();
         subCloseOrderAllMagic();
         Print("UseDrawdownCloseAllTrades-CLOSE ALL TRADES! CurrentDrawDown: "+MagicDDCal3+"%"+", DrawdownCloseAllTradesPercent:"+DrawdownCloseAllTradesPercent);
      }
   }
   
   if(UseBreakevenAfterLoss==true) 
   {      
      double BEAL_Cal1 = (BreakevenAfterLossPercent/100);
      double BEAL_Cal2 = (AccountBalance()*BEAL_Cal1);
      double BEAL_Cal3 = (AccountBalance()-BEAL_Cal2);
      double CurrentPnL = (AccountEquity()-AccountBalance());
      
      double BEAL_Cal4 = (CurrentPnL/AccountBalance());
      double BEAL_Cal5 = (BEAL_Cal4*100);
      double CurrentPnLPercent = NormalizeDouble(BEAL_Cal5,2);

      if(AccountEquity()<=BEAL_Cal3)
      {
         BreakevenAfterLoss = true;
         Print("BEAL_Cal1 :"+BEAL_Cal1+", BEAL_Cal2: "+BEAL_Cal2+", BEAL_Cal3 :"+BEAL_Cal3+", CurrentPnL :"+CurrentPnL);
         Print("BEAL_Cal4 :"+BEAL_Cal4+", BEAL_Cal5: "+BEAL_Cal5+", CurrentPnLPercent :"+CurrentPnLPercent+"%");
      }
      
      if(BreakevenAfterLoss==true && AccountEquity()>=AccountBalance())
      {
         subCloseOrderAllMagic();
         subCloseOrderAllMagic();
         subCloseOrderAllMagic();
         BreakevenAfterLoss = false;
         Print("UseBreakevenAfterLoss-CLOSE ALL TRADES! AccountBalance: $"+AccountBalance()+", AccountEquity: $"+AccountEquity()+", CurrentPnL :"+CurrentPnL);
      }
   }
   
   if(UseMarginLimitCloseTrade==true)
   {
      double MarginLevel = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
      //Print("1MarginLevel: "+MarginLevel);
      if(MarginLevel!=0 && MarginLevel<=MarginLimitCloseMarginPercentLevel)
      {
         //subCloseOrderFIFO();
         int OldestTradeTicket = subFirstOrderTicket();
         subCloseOrderByTicket(OldestTradeTicket);
         Print("Trade Closed by UseMarginLimitCloseTrade - MarginLevel: "+MarginLevel);
      }
   }
   
   //---
   
   Comment("Pips Per Sec: "+PipsPerSecond());
   RefreshRates();
   
   subEquityClose();
   
   if(subLastTradeHitSL()==true)
   {
      // WriteCom2("Trading Temporarily Stopped",
      //       "Due To WaitToResumeTradingAfterSL",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "");
      // return(0);
   }
   
   if(IsTesting())
   {
      // WriteCom2("",
      //       "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "");
   }
   
   //CloseAllTotalPipProfit
   if(DTT!=iTime(Symbol(),PERIOD_D1,0) && AddSwapToTP == true)
   {
      Swap = subTotalSwapPips();    
      DTT = iTime(Symbol(),PERIOD_D1,0);
   }
   
   if(AddSwapToTP==false)Swap = 0;
   if(Swap>0)Swap = 0;
   
   CloseAllTotalPipProfit = initTP+(Swap*(-1));
   //Comment("SWAP: "+Swap);
   
   int LastTicketX = subLastTicket();
   if(LastTicketX!=GlobalVariableGet(LastTicket))
   {
      ObjectDelete("BUY ENTRY1");
      ObjectDelete("SELL ENTRY1");
      GlobalVariableSet(LastTicket,LastTicketX);
      PerDay = iTime(Symbol(),PERIOD_D1,0);
   }
   
   if(UseMarketFillOrKill==true)FillOrKill();
   
   if(EnableMirrorTrading==true)MirrorStart();
   //saveMarketOrders();
   if(CloseAllTotalPipProfit>0 && UseBrokerTakeProfit==true)
   {
      double AveTPB = subAverageTP(OP_BUY, CloseAllTotalPipProfit);
      double AveTPS = subAverageTP(OP_SELL, CloseAllTotalPipProfit);
              
      if(AveTPB!=0)
      {  
         ObjectDelete("BUY ENTRY1");   
      }
      if(AveTPS!=0)
      {
         ObjectDelete("SELL ENTRY1");
      }
      
      if(AveTPB!=0 && AveTPS!=0)
      {
         AveTPB = 0;
         AveTPS = 0;
      }
      
      double HSellOK = subHighestOrder(OP_SELL)-(1*MyPoint);
      double LBuyOK = subLowestOrder(OP_BUY)+(1*MyPoint);
      if(Ask>LBuyOK)subECNSLTP(AveTPB, OP_BUY);
      if(Bid<HSellOK)subECNSLTP(AveTPS, OP_SELL);//subAverageTP(int Type, double TP)
   }
   
   if(ReviveTradeAfterSL==true)subTradeReviver();
    
   WindowRedraw();
   if(GlobalVariableGet("Disables EAs")==1)
   {
      //  WriteCom2("This EA has been stopped by General StopLoss Script v1",
      //      "ReInitialize General StopLoss Script to resume trading",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "",
      //      "");
      //      OPO=0;
      // return(0);
   }
   
   double DollarProfitTotal = subDollarProfitTotal(); 
   if(DollarProfitTotal<GlobalVariableGet(HOL))GlobalVariableSet(HOL, DollarProfitTotal);
   
   double Balance = AccountBalance();
   double Equity = AccountEquity();
   double SL = Balance-Equity;
   double GSL = (GeneralDollarStopLoss_Pct*0.01)*Balance;
   
   int TotalTrades = subTotalTrade();
   
   if(TotalTrades<1)
   {
      Swap = 0;
      GlobalVariableSet(Cycles,0);
   }
   if(SL>GSL && TotalTrades>0)
   {
      subCloseOrder();
      subCloseOrder();
      Print(" Closed by General StopLoss ");
   }    
  
   double LX = Lots*100;
   
   if(UseStandardTrailStop==true)subTrailingStop(TrailStopStart, TrailingStop);
   
   if(UseContraryPositionTrailingStop==true)subTrailingStopContrary(ContraryPositionTrailStopTrigger, ContraryPositionTrailingStopPips); //v3
    
   if(AutoReverseTrading==false)AutoReverseTrading = true;//RSwitch = ReverseTrading;
   
   if(UseTradeTime == true)//XXX
   {
      if(SkipNextTradeTime==true) //v2
      {
         if(CheckSkipNextTradeTime()==true)
         {
            return(0);
         }
      }
   } 
   
   if(AutoReverseTrading==true)
   {
      if(SwitchPrice == 0)
      {
         double AvePrice = subAvePrice();
         if(Bid>=AvePrice+PipsToSwitch*MyPoint)
         {
            if(ReverseTrading==true)RSwitch = false;
            if(ReverseTrading==false)RSwitch = true;
            SwitchPrice = Bid;
         }
         if(Bid<=AvePrice-PipsToSwitch*MyPoint)
         {
            if(ReverseTrading==true)RSwitch = false;
            if(ReverseTrading==false)RSwitch = true;
            SwitchPrice = Bid;
         }
      }
      if(SwitchPrice > 0)
      {
         if(Bid>=SwitchPrice+PipsToSwitch*MyPoint)
         {
            if(RSwitch==true)
            {
               RSwitch = false;
               SwitchPrice = Bid;
               OPO = iTime(Symbol(),0,0);
               return(0);
            }
            if(RSwitch==false)
            {
               RSwitch = true;
               SwitchPrice = Bid;
               OPO = iTime(Symbol(),0,0);
               return(0);
            }
         }
         if(Bid<=SwitchPrice-PipsToSwitch*MyPoint)
         {
            if(RSwitch==true)
            {
               RSwitch = false;
               SwitchPrice = Bid;
               OPO = iTime(Symbol(),0,0);
               return(0);
            }
            if(RSwitch==false)
            {
               RSwitch = true;
               SwitchPrice = Bid;
               OPO = iTime(Symbol(),0,0);
               return(0);
            }
         }
      }
   }
   
   //---
   
   int BuyTrades = subTotalTypeOrders(OP_BUY);
   int SellTrades = subTotalTypeOrders(OP_SELL);
  
   //---
   
   if(UseAveragePipTakeProfit == true)
   {
      double ATPB = subAvePriceNormalized(OP_BUY)+(AvePricePipTakeProfit*MyPoint);
      double ATPS = subAvePriceNormalized(OP_SELL)-(AvePricePipTakeProfit*MyPoint);

      if(ShowAveragePipTakeProfitLine==true)
      {
         if(BuyTrades>0)CreateATPBLine(ATPB);
         if(SellTrades>0)CreateATPSLine(ATPS);
      }
      
      if(Bid>=ATPB)
      {
         subCloseOrderType(OP_BUY);
         subCloseOrderType(OP_BUY);
         subCloseOrderType(OP_BUY);
         subCloseOrderType(OP_BUY);
         subCloseOrderType(OP_BUY);
         DELETE5B();
      }
      if(Bid<=ATPS)
      {
         subCloseOrderType(OP_SELL);
         subCloseOrderType(OP_SELL);
         subCloseOrderType(OP_SELL);
         subCloseOrderType(OP_SELL);
         subCloseOrderType(OP_SELL);
         DELETE5S();
      }
   }
   
   if(UseStopLoss==false)StopLoss=0;
   if(TotalTrades>=MaxOpenTrades)
   {
      subCloseOrder();
   }
   if(TotalTrades<1 && GlobalVariableGet(DD)!=0)
   {
      GlobalVariableSet(DD,0);
   }
   
   double ProfitUSD = subProfitUSD();
   
   //-------------------------
   
   if(FreeMarginLevelClose == true) //v11
   {
      double MarginPercentLevel = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
   
      if(TotalTrades>0 && MarginPercentLevel<=FreeMarginPercentLevelClose)
      {
         subCloseSequence(FreeMarginLevelCloseTradeCount);
      }
   } 
   
   if(ShowAverageOpenPriceLine==true) // v11
   {
      CreateAOPLine(subAverageOpenPriceCal()); 
      if(TotalTrades<1)DELETE(PREF);
   }
   
   //---
   
   if(TotalTrades<1)GlobalVariableSet(PP,0);
   //------------------------
   
   double LastTradePL = subLastTradePL();
   
   if(IsTesting()==false)double TOTALP = subProfitTotal()+subProfitToday(MagicNumber)+subProfitToday2(0);
   
   if(FirstTime ==  false)
   {
      if(IsTesting()==false)
      {
         // WriteCom2("Restart Todays IB Commissions = true",
         //      "ReStarting EA...",
         //      "",
         //      "",
         //      "",
         //      "",
         //      "",
         //      "",
         //      "",
         //      "",
         //      "",
         //      "",
         //      "");
      }
      GlobalVariableSet(ReName,TimeCurrent());
      FirstTime = true;
      OPO = iTime(Symbol(),0,0);
      return(0);
   }
   
   double TotalProfit=subPipProfitTotal();
   
   if(TotalProfit>=CloseAllTotalPipProfit)
   {
      if((AveTPB==0 && AveTPS==0)||(TotalProfit>=CloseAllTotalPipProfit*1.2))
      {
         if(TotalTrades>0)
         {
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            FirstTime = false;
            RefreshRates();
         }
      }
      if((UseBrokerTakeProfit==false && UseMarketFillOrKill ==false)||
         (BuyTrades>0 && SellTrades>0))
      {
         if(TotalTrades>0)
         {
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            FirstTime = false;
            RefreshRates();
         }
      }
      OPO = iTime(Symbol(),0,0);
      return(0);
   }   
   if(ProfitUSD>=TargetProfitOrLossUsd*LX && TargetProfitOrLossUsd>0)
   {
      if(TotalTrades>0)
      {
         subCloseOrder();
         subCloseOrder();
         subCloseOrder();
         subCloseOrder();
         subCloseOrder();
         FirstTime = false;
         RefreshRates();
      }
      OPO = iTime(Symbol(),0,0);
      return(0);
   }    
   if(ProfitUSD<=TargetProfitOrLossUsd*LX && TargetProfitOrLossUsd<0)
   {
      if(TotalTrades>0)
      {
         subCloseOrder();
         subCloseOrder();
         subCloseOrder();
         subCloseOrder();
         subCloseOrder();
         FirstTime = false;
         RefreshRates();
      }
      OPO = iTime(Symbol(),0,0);
      return(0);
   } 
  
   if(IsTesting()==false)TOTALP = subProfitTotal()+subProfitToday(MagicNumber)+subProfitToday2(0);
   
   //---
   
   double Lotz = Lots;
   Lotz = subLotSize(AutoCalculateLots,Lots);
   
   if(StopTradeSizeIncreaseInProfit==true)
   {
      double STSIIP = GlobalVariableGet(StopTradeSizeIncreaseInProfitGV);
      //double STSIIPTT = GlobalVariableGet(StopTradeSizeIncreaseInProfitTTGV);
      
      double StopIncreaseCal1 = (StopTradeSizeIncreaseInProfitPercent/100);
      double StopIncreaseCal2 = (STSIIP*StopIncreaseCal1);
      double StopIncreaseProfit = subStopIncreaseProfit();
      //Print("StopIncreaseProfit :"+StopIncreaseProfit);
      if(StopIncreaseProfit>=StopIncreaseCal2)
      {
         Lotz = 0;
         Lotz = subLastTradeLots();
         if(Lotz==0)Lotz = subLastLots();
      }
   }
   
   double BLotz = Lotz;
   double SLotz = Lotz;  
   
   //--- 

  if(subTradingTime(UseTradeTime,TradeTime_StartHour_1,TradeTime_StartMinute_1, TradeTime_EndHour_1,TradeTime_EndMinute_1)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_2,TradeTime_StartMinute_2, TradeTime_EndHour_2,TradeTime_EndMinute_2)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_3,TradeTime_StartMinute_3, TradeTime_EndHour_3,TradeTime_EndMinute_3)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_4,TradeTime_StartMinute_4, TradeTime_EndHour_4,TradeTime_EndMinute_4)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_5,TradeTime_StartMinute_5, TradeTime_EndHour_5,TradeTime_EndMinute_5)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_6,TradeTime_StartMinute_6, TradeTime_EndHour_6,TradeTime_EndMinute_6)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_7,TradeTime_StartMinute_7, TradeTime_EndHour_7,TradeTime_EndMinute_7)=="no")
   {
        
        if(TotalTrades<GetMaxtTotalTrades() && TotalTrades>0 && ForceMaxTrades==true)
        {
         //XXXXXXXXXXXXXXXXXXxxx
            int Bs = BuyTrades;
            int Ss = SellTrades;
            int TYPE = OP_SELL;
            if(Bs>Ss)TYPE = OP_BUY;
            
        }
        
        if(IsTesting()==false)
        {
            WriteCom2("None Trading Time",
                  "Todays Profit= "+DoubleToStr(TOTALP,2),
                   "Open Position Profit= "+DoubleToStr(subProfitTotal(),2),
                   "Closed Position Profit= "+DoubleToStr(subProfitClosed(MagicNumber),2),
                   "Total Open Trades: "+DoubleToStr(TotalTrades,0),
                   "Total Open Lots: "+DoubleToStr(OLots,2),
                   "Total Closed Trades: "+DoubleToStr(subClosedTotal(MagicNumber),0),
                   "Total Closed Lots: "+DoubleToStr(CLots,2),
                   "Total Net Open Lots: "+DoubleToStr(subTotalNetLots(),3),
                   "Average price of Total Net Open Lots: "+DoubleToStr(subAvePriceNormalizedAll(),Digits),
                   "",
                   "",
                   "");
         }

         if(TotalTrades<1)
         {
            ObjectDelete("BUY ENTRY1");
            ObjectDelete("SELL ENTRY1");
         }
      PerDay = 0;   
      ReadyCycle = true;
      OPO = iTime(Symbol(),0,0);
      return(0);     
      
   }  
   LastTime=TimeCurrent();
  
      //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   int MaxMax = GetMaxTrades();
   /*
   Comment(
   "Cycle: "+GlobalVariableGet(Cycles)+"\n"+
   "MaxMax: "+MaxMax);
   */
   
   if(UseTradeTime == true)
   {
      if(SkipTradeTime1OnMonday==true && DayOfWeek()==1)
      {
         if(subTradingTime(UseTradeTime,TradeTime_StartHour_1,TradeTime_StartMinute_1,TradeTime_EndHour_1,TradeTime_EndMinute_1)=="yes")
         {
            OPO = iTime(Symbol(),0,0);
            return(0);
         }
      }
      if(SkipTradeTime1OnMonday==false || (SkipTradeTime1OnMonday==true && DayOfWeek()!=1))
      {
         if(subTradingTime(UseTradeTime,TradeTime_StartHour_1,TradeTime_StartMinute_1,TradeTime_EndHour_1,TradeTime_EndMinute_1)=="yes")
         {
            string StartTime_1 = TradeTime_StartHour_1+":"+TradeTime_StartMinute_1;
            string EndTime_1 = TradeTime_EndHour_1+":"+TradeTime_EndMinute_1;
            if(subTotalTradeTT(StartTime_1, EndTime_1)>=MaxMax)
            {
               OPO = iTime(Symbol(),0,0);
               return(0);
            }
            if(subTotalTradeTTLureTrades(StartTime_1, EndTime_1)>=MaxLureTradesPerTradeTime)
            {
               StopLureTrades = true;
            }
            if(subTotalTradeTTLureTrades(StartTime_1, EndTime_1)<MaxLureTradesPerTradeTime)
            {
               StopLureTrades = false;
            }
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_2,TradeTime_StartMinute_2,TradeTime_EndHour_2,TradeTime_EndMinute_2)=="yes")
      {
         string StartTime_2 = TradeTime_StartHour_2+":"+TradeTime_StartMinute_2;
         string EndTime_2 = TradeTime_EndHour_2+":"+TradeTime_EndMinute_2;
         if(subTotalTradeTT(StartTime_2, EndTime_2)>=MaxMax)
         {
            OPO = iTime(Symbol(),0,0);
            return(0);
         }
         if(subTotalTradeTTLureTrades(StartTime_2, EndTime_2)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_2, EndTime_2)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_3,TradeTime_StartMinute_3,TradeTime_EndHour_3,TradeTime_EndMinute_3)=="yes")
      {
         string StartTime_3 = TradeTime_StartHour_3+":"+TradeTime_StartMinute_3;
         string EndTime_3 = TradeTime_EndHour_3+":"+TradeTime_EndMinute_3;
         if(subTotalTradeTT(StartTime_3, EndTime_3)>=MaxMax)
         {
            OPO = iTime(Symbol(),0,0);
            return(0);
         }
         if(subTotalTradeTTLureTrades(StartTime_3, EndTime_3)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_3, EndTime_3)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_4,TradeTime_StartMinute_4,TradeTime_EndHour_4,TradeTime_EndMinute_4)=="yes")
      {
         string StartTime_4 = TradeTime_StartHour_4+":"+TradeTime_StartMinute_4;
         string EndTime_4 = TradeTime_EndHour_4+":"+TradeTime_EndMinute_4;
         if(subTotalTradeTT(StartTime_4, EndTime_4)>=MaxMax)
         {
            OPO = iTime(Symbol(),0,0);
            return(0);
         }
         if(subTotalTradeTTLureTrades(StartTime_4, EndTime_4)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_4, EndTime_4)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_5,TradeTime_StartMinute_5,TradeTime_EndHour_5,TradeTime_EndMinute_5)=="yes")
      {
         string StartTime_5 = TradeTime_StartHour_5+":"+TradeTime_StartMinute_5;
         string EndTime_5 = TradeTime_EndHour_5+":"+TradeTime_EndMinute_5;
         if(subTotalTradeTT(StartTime_5, EndTime_5)>=MaxMax)
         {
            OPO = iTime(Symbol(),0,0);
            return(0);
         }
         if(subTotalTradeTTLureTrades(StartTime_5, EndTime_5)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_5, EndTime_5)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_6,TradeTime_StartMinute_6,TradeTime_EndHour_6,TradeTime_EndMinute_6)=="yes")
      {
         string StartTime_6 = TradeTime_StartHour_6+":"+TradeTime_StartMinute_6;
         string EndTime_6 = TradeTime_EndHour_6+":"+TradeTime_EndMinute_6;
         if(subTotalTradeTT(StartTime_6, EndTime_6)>=MaxMax)
         {
            OPO = iTime(Symbol(),0,0);
            return(0);
         }
         if(subTotalTradeTTLureTrades(StartTime_6, EndTime_6)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_6, EndTime_6)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_7,TradeTime_StartMinute_7,TradeTime_EndHour_7,TradeTime_EndMinute_7)=="yes")
      {
         string StartTime_7 = TradeTime_StartHour_7+":"+TradeTime_StartMinute_7;
         string EndTime_7 = TradeTime_EndHour_7+":"+TradeTime_EndMinute_7;
         if(subTotalTradeTT(StartTime_7, EndTime_7)>=MaxMax)
         {
            OPO = iTime(Symbol(),0,0);
            return(0);
         }
         if(subTotalTradeTTLureTrades(StartTime_7, EndTime_7)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_7, EndTime_7)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      
      //---
   }
   if(UseTradeTime == false)
   {
      StartTime_1 = TradeTime_StartHour_1+":"+TradeTime_StartMinute_1;
      EndTime_1 = TradeTime_EndHour_1+":"+TradeTime_EndMinute_1;
      if(subTotalTradeTT(StartTime_1, EndTime_1)>=MaxMax)return(0);
      
      if(subTotalTradeTTLureTrades(StartTime_1, EndTime_1)>=MaxLureTradesPerTradeTime)
      {
         StopLureTrades = true;
      }
      if(subTotalTradeTTLureTrades(StartTime_1, EndTime_1)<MaxLureTradesPerTradeTime)
      {
         StopLureTrades = false;
      }
   }
   
   if(TradeOnSunday==false && DayOfWeek()==0)
   {
      Comment("Sunday Non Trading Day..");
      return(0);
   }
   
   if(TradeOnMonday==false && DayOfWeek()==1)
   {
      Comment("Monday Non Trading Day..");
      return(0);
   }
   
   if(TradeOnTuesday==false && DayOfWeek()==2)
   {
      Comment("Tuesday Non Trading Day..");
      return(0);
   }
   
   if(TradeOnWednesday==false && DayOfWeek()==3)
   {
      Comment("Wednesday Non Trading Day..");
      return(0);
   }
   
   if(TradeOnThursday==false && DayOfWeek()==4)
   {
      Comment("Thursday Non Trading Day..");
      return(0);
   }
   
   if(TradeOnFriday==false && DayOfWeek()==5)
   {
      Comment("Friday Non Trading Day..");
      return(0);
   }
   
   if(UseNoTradeDate==true)
   {
      if(Month()==NoTradeDates_StartMonth && Day()==NoTradeDates_StartDay)
      {
         NoTradeDateStopTrading = true;
      }
      if(Month()==NoTradeDates_EndMonth && Day()==NoTradeDates_EndDay)
      {
         NoTradeDateStopTrading = false;
      }

      if(NoTradeDateStopTrading==true)
      {
         Comment("UseNoTradeDate - Non Trading Day...");
         return(0);
      }
   }

   //---
   //---
   //---
   
   if(AddToWinningTrades==true)subAddWinningTrades(PipsProfitToAddTrades);
   
   Lotz = subLotSize(AutoCalculateLots,Lots);
   
   if(StopTradeSizeIncreaseInProfit==true)
   {
      STSIIP = GlobalVariableGet(StopTradeSizeIncreaseInProfitGV);
      //double STSIIPTT = GlobalVariableGet(StopTradeSizeIncreaseInProfitTTGV);
      
      StopIncreaseCal1 = (StopTradeSizeIncreaseInProfitPercent/100);
      StopIncreaseCal2 = (STSIIP*StopIncreaseCal1);
      StopIncreaseProfit = subStopIncreaseProfit();
      //Print("StopIncreaseProfit :"+StopIncreaseProfit);
      if(StopIncreaseProfit>=StopIncreaseCal2)
      {
         Lotz = 0;
         Lotz = subLastTradeLots();
         if(Lotz==0)Lotz = subLastLots();
      }
   }
   
   BLotz = Lotz;
   SLotz = Lotz;   
   if(UseExponentialGrid)
   {
      double BLL = BuyTrades;
      double SLL = SellTrades;
      double SmallBL = subSmallestLots(OP_BUY);
      double SmallSL = subSmallestLots(OP_SELL);
      if(BLL>0)BLotz=  subExpoLots(SmallBL, Exponential_Percent, BLL);
      if(SLL>0)SLotz= subExpoLots(SmallSL, Exponential_Percent, SLL);
   }
   
    //-------------- ReverseTrading
   if(TotalTrades>0 && AddTradesAfterSeconds==true && subSecsSinceLastTrade(MagicNumber)<SecondsToAddTrades)
   {
      if(IsTesting()==false)
      {
         WriteCom2("Trading Time",
               "Todays Profit= "+DoubleToStr(TOTALP,2),
               "Open Position Profit= "+DoubleToStr(subProfitTotal(),2),
               "Closed Position Profit= "+DoubleToStr(subProfitClosed(MagicNumber),2),
               "Total Open Trades: "+DoubleToStr(TotalTrades,0),
               "Total Open Lots: "+DoubleToStr(OLots,2),
               "Total Closed Trades: "+DoubleToStr(subClosedTotal(MagicNumber),0),
               "Total Closed Lots: "+DoubleToStr(CLots,2),
               "Total Net Open Lots: "+DoubleToStr(subTotalNetLots(),3), 
               "Average price of Total Net Open Lots: "+DoubleToStr(subAvePriceNormalizedAll(),Digits),
               "",
               "",
               "");
      }
      tick = tick+1;  
      OPO = iTime(Symbol(),0,0);
      return(0);
   }
   
   if(subInterrupt()==true)return(0);
   if(PipsPerSecond()>=MaxPipsPerSecond)return(0);
   
   double std =iStdDev(Symbol(),0,StdDev_Period,0,StdDev_MA_Method,StdDev_AppliedPrice,0);
   double std_L =iStdDev(Symbol(),0,StdDev_Period,0,StdDev_MA_Method,StdDev_AppliedPrice,1);
   double diff = std-std_L;

   //Comment("std: "+std);
   double OK = false;
   
   if(diff<TradePossibleWhenDecrease*(-1) && TradePossibleWhenDecrease>0)OK=true;
   if(std>NoTradeWhenGreaterThanX && NoTradeWhenGreaterThanX>0 && OK==false)return(0);
   if(diff>NoTradeWhenIncreaseGreaterThanX && NoTradeWhenIncreaseGreaterThanX>0)return(0);
   
   int ticket = 0;  
   int ticketCP = 0;  
   BarsFromNewestTrade();
   
   double HSell = subHighestOrderX(OP_SELL)+(PipsBetweenTrades*MyPoint);
   double LBuy = subLowestOrderX(OP_BUY)-(PipsBetweenTrades*MyPoint);

   int TotalTradeX = subTotalTradeX();
   int BuyTradesX = subTotalTypeOrdersX(OP_BUY);
   int SellTradesX = subTotalTypeOrdersX(OP_SELL);
   
   //---
   
   if(AutoReverseTradingMinutes==true)
   {
      datetime FindOpenTimeX = subFindOpenTime();
      datetime FindOpenTimeXX = (FindOpenTimeX+(AutoReverseMinutes*60));
      int FindTradeType = subFindTradeType();
      
      if(subTotalTrade()>0 && GlobalVariableGet(ReverseTime)<=0)
      {
         GlobalVariableSet(ReverseTime,FindOpenTimeXX);
         GlobalVariableSet(ReverseTimeType,FindTradeType);
      }
      if(GlobalVariableGet(ReverseTime)!=0 && TimeCurrent()>GlobalVariableGet(ReverseTime))
      {
         GlobalVariableSet(ReverseTime,(TimeCurrent()+(AutoReverseMinutes*60)));
   
         int ReverseTimeTypeNext = -1;
         if(GlobalVariableGet(ReverseTimeType)==OP_BUY)ReverseTimeTypeNext = OP_SELL;
         if(GlobalVariableGet(ReverseTimeType)==OP_SELL)ReverseTimeTypeNext = OP_BUY;
         GlobalVariableSet(ReverseTimeType,ReverseTimeTypeNext);
      }
      
      //---
      
      if(TradeBuyX==true && TradeSellX==true)
      {
         if(GlobalVariableGet(ReverseTimeType)==OP_BUY)
         {
            TradeBuy = true;
            TradeSell = false;
         }
         if(GlobalVariableGet(ReverseTimeType)==OP_SELL)
         {
            TradeBuy = false;
            TradeSell = true;
         }
      }
   }
   
   //---
   
   if(TotalTradeX<MaxTrades && tick>=TicksBetweenTrades)
   {
      if(AddTradesAfterSeconds==false)
      {
         if(Bid>=HSell && TradeSell && SellTradesX>0)
         {
            if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
            {
               LureTradesOpen(OP_SELL,SLotz);
               LTTT = iTime(Symbol(),0,0);
               Print("UseLureTradesOpen.AddTradesAfterSeconds");
            }
            
            ticket = 0;
            ticket = subOpenOrder(OP_SELL, StopLoss, TakeProfit, SLotz);
            if(ticket>0)
            {
               int Cyc = GlobalVariableGet(Cycles);
               if(ReadyCycle==true)
               {
                  GlobalVariableSet(Cycles,Cyc+1);
                  ReadyCycle=false;
               }
               ObjectDelete("SELLTP");
               tick = 0;
               
               if(UseContraryPosition==true)
               {
                  if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                  {
                     LureTradesOpen(OP_BUY,SLotz);
                     LTTT = iTime(Symbol(),0,0);
                     Print("UseLureTradesOpen.AddTradesAfterSeconds");
                  }
                  
                  ticketCP = subOpenOrderCP(OP_BUY, ContraryPositionSL, ContraryPositionTP, SLotz, ("CONTRARY:"+ticket));
               }
            }
         }
         if(Ask<=LBuy && TradeBuy && BuyTradesX>0)
         {
            if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
            {
               LureTradesOpen(OP_BUY,BLotz);
               LTTT = iTime(Symbol(),0,0);
               Print("UseLureTradesOpen.AddTradesAfterSeconds");
            }
            
            ticket = 0;
            ticket = subOpenOrder(OP_BUY, StopLoss, TakeProfit, BLotz);
            if(ticket>0)
            {
               Cyc = GlobalVariableGet(Cycles);
               if(ReadyCycle==true)
               {
                  GlobalVariableSet(Cycles,Cyc+1);
                  ReadyCycle=false;
               }
               ObjectDelete("BUYTP");
               tick = 0;
               
               if(UseContraryPosition==true)
               {
                  if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                  {
                     LureTradesOpen(OP_SELL,BLotz);
                     LTTT = iTime(Symbol(),0,0);
                     Print("UseLureTradesOpen.AddTradesAfterSeconds");
                  }
                  
                  ticketCP = subOpenOrderCP(OP_SELL, ContraryPositionSL, ContraryPositionTP, BLotz, ("CONTRARY:"+ticket));
               }
            }
         }
      }
      if(AddTradesAfterSeconds==true && subSecsSinceLastTradeX(MagicNumber)>=SecondsToAddTrades)
      {
         if(Bid>=HSell && TradeSell && SellTradesX>0)
         {
            if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
            {
               LureTradesOpen(OP_SELL,SLotz);
               LTTT = iTime(Symbol(),0,0);
               Print("UseLureTradesOpen>AddTradesAfterSeconds");
            }
            
            ticket = 0;
            ticket = subOpenOrder(OP_SELL, StopLoss, TakeProfit, SLotz);
            if(ticket>0)
            {
               Cyc = GlobalVariableGet(Cycles);
               if(ReadyCycle==true)
               {
                  GlobalVariableSet(Cycles,Cyc+1);
                  ReadyCycle=false;
               }
               ObjectDelete("SELLTP");
               tick = 0;

               if(UseContraryPosition==true)
               {
                  if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                  {
                     LureTradesOpen(OP_BUY,SLotz);
                     LTTT = iTime(Symbol(),0,0);
                     Print("UseLureTradesOpen>AddTradesAfterSeconds>UseContraryPosition");
                  }
                  
                  ticketCP = subOpenOrderCP(OP_BUY, ContraryPositionSL, ContraryPositionTP, SLotz, ("CONTRARY:"+ticket));
               }
            }  
         }
         if(Ask<=LBuy && TradeBuy && BuyTradesX>0)
         {
            if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
            {
               LureTradesOpen(OP_BUY,BLotz);
               LTTT = iTime(Symbol(),0,0);
               Print("UseLureTradesOpen>AddTradesAfterSeconds");
            }
            
            ticket = 0;
            ticket = subOpenOrder(OP_BUY, StopLoss, TakeProfit, BLotz);
            if(ticket>0)
            {
               Cyc = GlobalVariableGet(Cycles);
               if(ReadyCycle==true)
               {
                  GlobalVariableSet(Cycles,Cyc+1);
                  ReadyCycle=false;
               }
               ObjectDelete("BUYTP");
               tick = 0;

               if(UseContraryPosition==true)
               {
                  if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                  {
                     LureTradesOpen(OP_SELL,BLotz);
                     LTTT = iTime(Symbol(),0,0);
                     Print("UseLureTradesOpen>AddTradesAfterSeconds>UseContraryPosition");
                  }
                  ticketCP = subOpenOrderCP(OP_SELL, ContraryPositionSL, ContraryPositionTP, BLotz, ("CONTRARY:"+ticket));
               }
            }
         }
      }
   }
   
   double SPOT = Ask+Bid;
   if(SPOT>0 && STT!=iTime(Symbol(),PERIOD_M1,0))
   {
      SPOT = SPOT/2;
      STT=iTime(Symbol(),PERIOD_M1,0);
   }
   if(RSwitch==false)
   {
      if(BuyTradesX<1 && TradeBuy)
      {
         if(UseSecondLevel==false)
         {
            if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
            {
               LureTradesOpen(OP_BUY,BLotz);
               LTTT = iTime(Symbol(),0,0);
               Print("UseLureTradesOpen.");
            }
            
            ticket = subOpenOrder(OP_BUY, StopLoss, TakeProfit, BLotz);
            if(ticket>0)
            {
               Cyc = GlobalVariableGet(Cycles);
               if(ReadyCycle==true)
               {
                  GlobalVariableSet(Cycles,Cyc+1);
                  ReadyCycle=false;
               }
               ObjectDelete("BUYTP");
               tick = 0;
               
               if(UseContraryPosition==true)
               {
                  if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                  {
                     LureTradesOpen(OP_SELL,BLotz);
                     LTTT = iTime(Symbol(),0,0);
                     Print("UseLureTradesOpen.");
                  }
            
                  ticketCP = subOpenOrderCP(OP_SELL, ContraryPositionSL, ContraryPositionTP, BLotz, ("CONTRARY:"+ticket));
               }
            }
         }
         if(UseSecondLevel==true)
         {
            if(ObjectFind("BUY ENTRY1")==-1)
            {
               ObjectCreate("BUY ENTRY1",OBJ_HLINE,0,TimeCurrent(),(SPOT-(PipsFromVirtualTrade*MyPoint)));
               ObjectSet("BUY ENTRY1",OBJPROP_STYLE,STYLE_DASHDOTDOT);
               ObjectSet("BUY ENTRY1",OBJPROP_COLOR,DodgerBlue);
            }
            double BP = ObjectGet("BUY ENTRY1",OBJPROP_PRICE1);
            if(Ask<=BP)
            {
               if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
               {
                  LureTradesOpen(OP_BUY,BLotz);
                  LTTT = iTime(Symbol(),0,0);
                  Print("UseLureTradesOpen.");
               }
            
               ticket = subOpenOrder(OP_BUY, StopLoss, TakeProfit, BLotz);  
               if(ticket>0)
               {
                  Cyc = GlobalVariableGet(Cycles);
                  if(ReadyCycle==true)
                  {
                     GlobalVariableSet(Cycles,Cyc+1);
                     ReadyCycle=false;
                  }
                  ObjectDelete("BUYTP");
                  tick = 0;
                  
                  if(UseContraryPosition==true)
                  {
                     if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                     {
                        LureTradesOpen(OP_SELL,BLotz);
                        LTTT = iTime(Symbol(),0,0);
                        Print("UseLureTradesOpen.");
                     }
                     
                     ticketCP = subOpenOrderCP(OP_SELL, ContraryPositionSL, ContraryPositionTP, BLotz, ("CONTRARY:"+ticket));
                  }
               }
            }
         }
      }
      if(SellTradesX<1 && TradeSell)
      {
         if(UseSecondLevel==false)
         {
            if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
            {
               LureTradesOpen(OP_SELL,SLotz);
               LTTT = iTime(Symbol(),0,0);
               Print("UseLureTradesOpen.");
            }
               
            ticket = subOpenOrder(OP_SELL, StopLoss, TakeProfit, SLotz);
            if(ticket>0)
            {
               Cyc = GlobalVariableGet(Cycles);
               if(ReadyCycle==true)
               {
                  GlobalVariableSet(Cycles,Cyc+1);
                  ReadyCycle=false;
               }
               ObjectDelete("SELLTP");
               tick = 0;
               
               if(UseContraryPosition==true)
               {
                  if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                  {
                     LureTradesOpen(OP_BUY,SLotz);
                     LTTT = iTime(Symbol(),0,0);
                     Print("UseLureTradesOpen.");
                  }
                  
                  ticketCP = subOpenOrderCP(OP_BUY, ContraryPositionSL, ContraryPositionTP, SLotz, ("CONTRARY:"+ticket));
               }
            }
         }
         if(UseSecondLevel==true)
         {
            if(ObjectFind("SELL ENTRY1")==-1)
            {
               ObjectCreate("SELL ENTRY1",OBJ_HLINE,0,TimeCurrent(),(SPOT+(PipsFromVirtualTrade*MyPoint)));
               ObjectSet("SELL ENTRY1",OBJPROP_STYLE,STYLE_DASHDOTDOT);
               ObjectSet("SELL ENTRY1",OBJPROP_COLOR,DarkOrange);
            }
      
            double SP = ObjectGet("SELL ENTRY1",OBJPROP_PRICE1);
            if(Bid>=SP)
            {
               if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
               {
                  LureTradesOpen(OP_SELL,SLotz);
                  LTTT = iTime(Symbol(),0,0);
                  Print("UseLureTradesOpen.");
               }
            
               ticket = subOpenOrder(OP_SELL, StopLoss, TakeProfit, SLotz);      
               if(ticket>0)
               {
                  Print("S1");
                  Cyc = GlobalVariableGet(Cycles);
                  if(ReadyCycle==true)
                  {
                     GlobalVariableSet(Cycles,Cyc+1);
                     ReadyCycle=false;
                  }
                  ObjectDelete("SELLTP");
                  tick = 0;
                  
                  if(UseContraryPosition==true)
                  {
                     if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                     {
                        LureTradesOpen(OP_BUY,SLotz);
                        LTTT = iTime(Symbol(),0,0);
                        Print("UseLureTradesOpen.");
                     }
                     
                     ticketCP = subOpenOrderCP(OP_BUY, ContraryPositionSL, ContraryPositionTP, SLotz, ("CONTRARY:"+ticket));
                  }
               }
            }
         }
      }
   }
   
   if(RSwitch==true)
   {
      if(BuyTradesX<1 && TradeBuy)
      {
         if(UseSecondLevel==false)
         {
            if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
            {
               LureTradesOpen(OP_BUY,BLotz);
               LTTT = iTime(Symbol(),0,0);
               Print("UseLureTradesOpen.");
            }
            
            ticket = subOpenOrder(OP_BUY, StopLoss, TakeProfit, BLotz);
            if(ticket>0)
            {
               Cyc = GlobalVariableGet(Cycles);
               if(ReadyCycle==true)
               {
                  GlobalVariableSet(Cycles,Cyc+1);
                  ReadyCycle=false;
               }
               ObjectDelete("BUYTP");
               tick = 0;
               
               if(UseContraryPosition==true)
               {
                  if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                  {
                     LureTradesOpen(OP_SELL,BLotz);
                     LTTT = iTime(Symbol(),0,0);
                     Print("UseLureTradesOpen.");
                  }
            
                  ticketCP = subOpenOrderCP(OP_SELL, ContraryPositionSL, ContraryPositionTP, BLotz, ("CONTRARY:"+ticket));
               }
            }
         }
         if(UseSecondLevel==true)
         {
            if(ObjectFind("BUY ENTRY1")==-1)
            {
               ObjectCreate("BUY ENTRY1",OBJ_HLINE,0,TimeCurrent(),(SPOT+(PipsFromVirtualTrade*MyPoint)));
               ObjectSet("BUY ENTRY1",OBJPROP_STYLE,STYLE_DASHDOTDOT);
               ObjectSet("BUY ENTRY1",OBJPROP_COLOR,DodgerBlue);
            }
            BP = ObjectGet("BUY ENTRY1",OBJPROP_PRICE1);
            if(Bid>=BP)
            {
               if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
               {
                  LureTradesOpen(OP_BUY,BLotz);
                  LTTT = iTime(Symbol(),0,0);
                  Print("UseLureTradesOpen.");
               }
            
               ticket = subOpenOrder(OP_BUY, StopLoss, TakeProfit, BLotz);  
               if(ticket>0)
               {
                  Cyc = GlobalVariableGet(Cycles);
                  if(ReadyCycle==true)
                  {
                     GlobalVariableSet(Cycles,Cyc+1);
                     ReadyCycle=false;
                  }
                  ObjectDelete("BUYTP");
                  tick = 0;
                  
                  if(UseContraryPosition==true)
                  {
                     if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                     {
                        LureTradesOpen(OP_SELL,BLotz);
                        LTTT = iTime(Symbol(),0,0);
                        Print("UseLureTradesOpen.");
                     }
                     
                     ticketCP = subOpenOrderCP(OP_SELL, ContraryPositionSL, ContraryPositionTP, BLotz, ("CONTRARY:"+ticket));
                  }
               }
            }
         }
      }
      if(SellTradesX<1 && TradeSell)
      {
         if(UseSecondLevel==false)
         {
            if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
            {
               LureTradesOpen(OP_SELL,SLotz);
               LTTT = iTime(Symbol(),0,0);
               Print("UseLureTradesOpen.");
            }
            
            ticket = subOpenOrder(OP_SELL, StopLoss, TakeProfit, SLotz);
            if(ticket>0)
            {
               Cyc = GlobalVariableGet(Cycles);
               if(ReadyCycle==true)
               {
                  GlobalVariableSet(Cycles,Cyc+1);
                  ReadyCycle=false;
               }
               ObjectDelete("SELLTP");
               tick = 0;
               
               if(UseContraryPosition==true)
               {
                  if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                  {
                     LureTradesOpen(OP_BUY,SLotz);
                     LTTT = iTime(Symbol(),0,0);
                     Print("UseLureTradesOpen.");
                  }
            
                  ticketCP = subOpenOrderCP(OP_BUY, ContraryPositionSL, ContraryPositionTP, SLotz, ("CONTRARY:"+ticket));
               }
            }
         }
         if(UseSecondLevel==true)
         {
            if(ObjectFind("SELL ENTRY1")==-1)
            {
               ObjectCreate("SELL ENTRY1",OBJ_HLINE,0,TimeCurrent(),(SPOT-(PipsFromVirtualTrade*MyPoint)));
               ObjectSet("SELL ENTRY1",OBJPROP_STYLE,STYLE_DASHDOTDOT);
               ObjectSet("SELL ENTRY1",OBJPROP_COLOR,DarkOrange);
            }
      
            SP = ObjectGet("SELL ENTRY1",OBJPROP_PRICE1);
            if(Bid<=SP)
            {
               if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
               {
                  LureTradesOpen(OP_SELL,SLotz);
                  LTTT = iTime(Symbol(),0,0);
                  Print("UseLureTradesOpen.");
               }
            
               ticket = subOpenOrder(OP_SELL, StopLoss, TakeProfit, SLotz);      
               if(ticket>0)
               {
                  Print("S2");
                  Cyc = GlobalVariableGet(Cycles);
                  if(ReadyCycle==true)
                  {
                     GlobalVariableSet(Cycles,Cyc+1);
                     ReadyCycle=false;
                  }
                  ObjectDelete("SELLTP");
                  tick = 0;
                  
                  if(UseContraryPosition==true)
                  {
                     if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
                     {
                        LureTradesOpen(OP_BUY,SLotz);
                        LTTT = iTime(Symbol(),0,0);
                        Print("UseLureTradesOpen.");
                     }
                     
                     ticketCP = subOpenOrderCP(OP_BUY, ContraryPositionSL, ContraryPositionTP, SLotz, ("CONTRARY:"+ticket));
                  }
               }
            }
         }
      }
   }
 
   if(IsTesting()==false)//???????????????
   {
      WriteCom2("Trading Time",
                  "Todays Profit= "+DoubleToStr(TOTALP,2),
                  "Open Position Profit= "+DoubleToStr(subProfitTotal(),2),
                  "Closed Position Profit= "+DoubleToStr(subProfitClosed(MagicNumber),2),
                  "Total Open Trades: "+DoubleToStr(TotalTrades,0),
                  "Total Open Lots: "+DoubleToStr(OLots,2),
                  "Total Closed Trades: "+DoubleToStr(subClosedTotal(MagicNumber),0),
                  "Total Closed Lots: "+DoubleToStr(CLots,2),
                  "Total Net Open Lots: "+DoubleToStr(subTotalNetLots(),3),
                  "Average price of Total Net Open Lots: "+DoubleToStr(subAvePriceNormalizedAll(),Digits),
                  "",
                  "",
                  "");
   }       
   tick = tick+1;
   OPO = iTime(Symbol(),0,0);
   if(CloseAllTotalPipProfit>0 && UseBrokerTakeProfit==true)
   {
      AveTPB = subAverageTP(OP_BUY, CloseAllTotalPipProfit);
      AveTPS = subAverageTP(OP_SELL, CloseAllTotalPipProfit);
              
      if(AveTPB!=0)
      {  
         ObjectDelete("BUY ENTRY1"); 
      }
      if(AveTPS!=0)
      {
         ObjectDelete("SELL ENTRY1");
      }
      
      if(AveTPB!=0 && AveTPS!=0)
      {
         AveTPB = 0;
         AveTPS = 0;
      }
      
      HSellOK = subHighestOrder(OP_SELL)-(1*MyPoint);
      LBuyOK = subLowestOrder(OP_BUY)+(1*MyPoint);
      if(Ask>LBuyOK)subECNSLTP(AveTPB, OP_BUY);
      if(Bid<HSellOK)subECNSLTP(AveTPS, OP_SELL);//subAverageTP(int Type, double TP)
   }
   if(UseMarketFillOrKill==true)FillOrKill();
//----
   return(0);
  }
//+------------------------------------------------------------------+

int GetMaxTrades()
{
   if(UseMultiMaxTrades==false)int Max = MaxTradePerTradeTime;
   if(UseMultiMaxTrades==true)
   {
      Max = MaxTrades_1;
      if(GlobalVariableGet(Cycles)==1)Max = MaxTrades_1;
      if(GlobalVariableGet(Cycles)==2)Max = MaxTrades_2;
      if(GlobalVariableGet(Cycles)==3)Max = MaxTrades_3;
      if(GlobalVariableGet(Cycles)==4)Max = MaxTrades_4;
      if(GlobalVariableGet(Cycles)==5)Max = MaxTrades_5;
      if(GlobalVariableGet(Cycles)==6)Max = MaxTrades_6;
      if(GlobalVariableGet(Cycles)==7)Max = MaxTrades_7;
      if(GlobalVariableGet(Cycles)==8)Max = MaxTrades_8;
      if(GlobalVariableGet(Cycles)==9)Max = MaxTrades_9;
      if(GlobalVariableGet(Cycles)>=10)Max = MaxTrades_10;
   }
   return(Max);
}
int GetMaxtTotalTrades()
{
   if(UseMultiMaxTrades==false)int Max = MaxTradePerTradeTime;
   if(UseMultiMaxTrades==true)
   {
      
      if(GlobalVariableGet(Cycles)<=1)Max = MaxTrades_1;
      if(GlobalVariableGet(Cycles)>=2)Max = Max+MaxTrades_2;
      if(GlobalVariableGet(Cycles)>=3)Max = Max+MaxTrades_3;
      if(GlobalVariableGet(Cycles)>=4)Max = Max+MaxTrades_4;
      if(GlobalVariableGet(Cycles)>=5)Max = Max+MaxTrades_5;
      if(GlobalVariableGet(Cycles)>=6)Max = Max+MaxTrades_6;
      if(GlobalVariableGet(Cycles)>=7)Max = Max+MaxTrades_7;
      if(GlobalVariableGet(Cycles)>=8)Max = Max+MaxTrades_8;
      if(GlobalVariableGet(Cycles)>=9)Max = Max+MaxTrades_9;
      if(GlobalVariableGet(Cycles)>=10)Max = Max+MaxTrades_10;
   }
   return(Max);
}
double subExpoLots(double Start, double expo, int total)
{
   double lots = Start;
   for(int cnt=1;cnt<=total;cnt++)
   {
      double EXPO = expo*0.01;
      lots = lots+(lots*EXPO);    
     // Print("LOTS: "+lots);
   }
   return(lots);
}
double subLotSize(bool useMoneyManagement,double LOTSIZE)
{
   double lot=Lots;

   int    decimalPlaces=1;
   if(useMoneyManagement==true)
   {
      if(MarketInfo(Symbol(),MODE_MINLOT)<0.1)decimalPlaces=2;
   
      lot=NormalizeDouble((AccountEquity()*LOTSIZE)/StartingCapital,decimalPlaces);   
   }
   double GOLOTS = subTotalOpenTradeLots();
   if(GOLOTS>0)
   {
      lot = GOLOTS; 
   }
   
   return(lot);
}

/*
double subRecenLots()
{
   int
      cnt, 
      total = 0;
   double OPENLOTS = 0;
   double SMALLEST = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber)
         {
           
             if(OrderLots()<SMALLEST || SMALLEST == 0) SMALLEST = OrderLots();
         }    
      }
   }
   if(SMALLEST==0)
   {
       int orders = OrdersHistoryTotal();
       double TIME = 0;
       for(int i=orders-1;i>=0;i--)
       {
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
            if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=MagicNumber) continue;
            //----
            if(OrderCloseTime()<EAStartTime)break;
            SMALLEST = OrderLots();
            if(SMALLEST>0)break;    
       }
   }
   return(SMALLEST);
}
*/
/*
datetime subFirstTimeOfDecrease(double SLOTS)
{
   int
      cnt, 
      total = 0;
   double OPENLOTS = 0;
   datetime OT = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber)
         {
             if(OrderLots()==SLOTS)
             {
                if(OrderOpenTime()<OT || OT == 0)OT = OrderOpenTime();
             }
         }    
      }
   }
   if(OT==0)
   {
      int orders = OrdersHistoryTotal();
       double TIME = 0;
      for(int i=orders-1;i>=0;i--)
       {
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
            if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=MagicNumber) continue;
            //----
             if(OrderLots()==SLOTS)
             {
                if(OrderOpenTime()<OT || OT == 0)OT = OrderOpenTime();
             }
       }
   }
   return(OT);
}
*/

void WriteCom2(string Line1,string Line2, string Line3, string Line4, string Line5,string Line6,string Line7,string Line8,string Line9,string Line10,string Line11,string Line12,string Line13)
{
   int AddY = 15;
   
   if (ObjectFind("001a") == -1 ){
   ObjectCreate("001a", OBJ_LABEL, 0, 0, 0);
   ObjectSet("001a", OBJPROP_COLOR, Red);
   ObjectSet("001a", OBJPROP_CORNER,4);
   ObjectSet("001a", OBJPROP_XDISTANCE, 5);
   ObjectSet("001a", OBJPROP_YDISTANCE, 13);} 
   ObjectSetText("001a",ChartText,9, "Tahoma Bold", Yellow);
   
   if (ObjectFind("001") == -1 ){
   ObjectCreate("001", OBJ_LABEL, 0, 0, 0);
   ObjectSet("001", OBJPROP_COLOR, Red);
   ObjectSet("001", OBJPROP_CORNER,4);
   ObjectSet("001", OBJPROP_XDISTANCE, 5);
   ObjectSet("001", OBJPROP_YDISTANCE, 13+AddY);} 
   ObjectSetText("001",Line1,9, "Tahoma Bold", Yellow);
      
   if (ObjectFind("002") == -1 ){
   ObjectCreate("002", OBJ_LABEL, 0, 0, 0);
   ObjectSet("002", OBJPROP_COLOR, Red);
   ObjectSet("002", OBJPROP_CORNER, 4);
   ObjectSet("002", OBJPROP_XDISTANCE, 5);
   ObjectSet("002", OBJPROP_YDISTANCE, 28+AddY);} 
   ObjectSetText("002",Line2,9, "Tahoma Bold", Yellow);   
   
   if (ObjectFind("003") == -1 ){
   ObjectCreate("003", OBJ_LABEL, 0, 0, 0);
   ObjectSet("003", OBJPROP_COLOR, Red);
   ObjectSet("003", OBJPROP_CORNER,TextCorner);
   ObjectSet("003", OBJPROP_XDISTANCE, 5);
   ObjectSet("003", OBJPROP_YDISTANCE, 43+AddY);} 
   ObjectSetText("003",Line3,9, "Tahoma Bold", Yellow);
      
   if (ObjectFind("004") == -1 ){
   ObjectCreate("004", OBJ_LABEL, 0, 0, 0);
   ObjectSet("004", OBJPROP_COLOR, Red);
   ObjectSet("004", OBJPROP_CORNER,TextCorner);
   ObjectSet("004", OBJPROP_XDISTANCE, 5);
   ObjectSet("004", OBJPROP_YDISTANCE, 58+AddY);} 
   ObjectSetText("004",Line4,9, "Tahoma Bold", Yellow);
      
   if (ObjectFind("005") == -1 ){
   ObjectCreate("005", OBJ_LABEL, 0, 0, 0);
   ObjectSet("005", OBJPROP_COLOR, Red);
   ObjectSet("005", OBJPROP_CORNER,TextCorner);
   ObjectSet("005", OBJPROP_XDISTANCE, 5);
   ObjectSet("005", OBJPROP_YDISTANCE, 73+AddY);} 
   ObjectSetText("005",Line5,9, "Tahoma Bold", Yellow); 
   
   if (ObjectFind("006") == -1 ){
   ObjectCreate("006", OBJ_LABEL, 0, 0, 0);
   ObjectSet("006", OBJPROP_COLOR, Red);
   ObjectSet("006", OBJPROP_CORNER,TextCorner);
   ObjectSet("006", OBJPROP_XDISTANCE, 5);
   ObjectSet("006", OBJPROP_YDISTANCE, 88+AddY);} 
   ObjectSetText("006",Line6,9, "Tahoma Bold", Yellow); 
   
   if (ObjectFind("007") == -1 ){
   ObjectCreate("007", OBJ_LABEL, 0, 0, 0);
   ObjectSet("007", OBJPROP_COLOR, Red);
   ObjectSet("007", OBJPROP_CORNER,TextCorner);
   ObjectSet("007", OBJPROP_XDISTANCE, 5);
   ObjectSet("007", OBJPROP_YDISTANCE, 103+AddY);} 
   ObjectSetText("007",Line7,9, "Tahoma Bold", Yellow); 
   
   if (ObjectFind("008") == -1 ){
   ObjectCreate("008", OBJ_LABEL, 0, 0, 0);
   ObjectSet("008", OBJPROP_COLOR, Red);
   ObjectSet("008", OBJPROP_CORNER,TextCorner);
   ObjectSet("008", OBJPROP_XDISTANCE, 5);
   ObjectSet("008", OBJPROP_YDISTANCE, 118+AddY);} 
   ObjectSetText("008",Line8,9, "Tahoma Bold", Yellow); 
      
   if (ObjectFind("009") == -1 ){
   ObjectCreate("009", OBJ_LABEL, 0, 0, 0);
   ObjectSet("009", OBJPROP_COLOR, Red);
   ObjectSet("009", OBJPROP_CORNER,TextCorner);
   ObjectSet("009", OBJPROP_XDISTANCE, 5);
   ObjectSet("009", OBJPROP_YDISTANCE, 133+AddY);} 
   ObjectSetText("009",Line9,9, "Tahoma Bold", Yellow); 
    
   if (ObjectFind("010") == -1 ){
   ObjectCreate("010", OBJ_LABEL, 0, 0, 0);
   ObjectSet("010", OBJPROP_COLOR, Red);
   ObjectSet("010", OBJPROP_CORNER,TextCorner);
   ObjectSet("010", OBJPROP_XDISTANCE, 5);
   ObjectSet("010", OBJPROP_YDISTANCE, 148+AddY);} 
   ObjectSetText("010",Line10,9, "Tahoma Bold", Yellow); 
   
   if (ObjectFind("011") == -1 ){
   ObjectCreate("011", OBJ_LABEL, 0, 0, 0);
   ObjectSet("011", OBJPROP_COLOR, Red);
   ObjectSet("011", OBJPROP_CORNER,TextCorner);
   ObjectSet("011", OBJPROP_XDISTANCE, 5);
   ObjectSet("011", OBJPROP_YDISTANCE, 163+AddY);} 
   ObjectSetText("011",Line11,9, "Tahoma Bold", Yellow); 
   
      if (ObjectFind("012") == -1 ){
   ObjectCreate("012", OBJ_LABEL, 0, 0, 0);
   ObjectSet("012", OBJPROP_COLOR, Red);
   ObjectSet("012", OBJPROP_CORNER,TextCorner);
   ObjectSet("012", OBJPROP_XDISTANCE, 5);
   ObjectSet("012", OBJPROP_YDISTANCE, 178+AddY);} 
   ObjectSetText("012",Line12,9, "Tahoma Bold", Yellow); 
   
         if (ObjectFind("013") == -1 ){
   ObjectCreate("013", OBJ_LABEL, 0, 0, 0);
   ObjectSet("013", OBJPROP_COLOR, Red);
   ObjectSet("013", OBJPROP_CORNER,TextCorner);
   ObjectSet("013", OBJPROP_XDISTANCE, 5);
   ObjectSet("013", OBJPROP_YDISTANCE, 193+AddY);} 
   ObjectSetText("013",Line13,9, "Tahoma Bold", Yellow); 
   
   string Line14 =  "Total Lots Opened: "+DoubleToStr(subAllLots(),2);
   if (ObjectFind("014") == -1 ){
   ObjectCreate("014", OBJ_LABEL, 0, 0, 0);
   ObjectSet("014", OBJPROP_COLOR, Red);
   ObjectSet("014", OBJPROP_CORNER,TextCorner);
   ObjectSet("014", OBJPROP_XDISTANCE, 5);
   ObjectSet("014", OBJPROP_YDISTANCE, 208+AddY);} 
   ObjectSetText("014",Line14,9, "Tahoma Bold", Yellow);
   
   string Line15 = "Highest Open Loss: $"+DoubleToStr(GlobalVariableGet(HOL),2);
   if (ObjectFind("015") == -1 ){
   ObjectCreate("015", OBJ_LABEL, 0, 0, 0);
   ObjectSet("015", OBJPROP_COLOR, Red);
   ObjectSet("015", OBJPROP_CORNER,TextCorner);
   ObjectSet("015", OBJPROP_XDISTANCE, 5);
   ObjectSet("015", OBJPROP_YDISTANCE, 223+AddY);} 
   ObjectSetText("015",Line15,9, "Tahoma Bold", Yellow); 
}
void WriteCom3(string Line1,string Line2, string Line3, string Line4)
{
   int AddY = 15;
   
   if (ObjectFind("001M") == -1 ){
   ObjectCreate("001M", OBJ_LABEL, 0, 0, 0);
   ObjectSet("001M", OBJPROP_COLOR, Red);
   ObjectSet("001M", OBJPROP_CORNER,4);
   ObjectSet("001M", OBJPROP_XDISTANCE, 5);
   ObjectSet("001M", OBJPROP_YDISTANCE, 238+AddY);} 
   ObjectSetText("001M",Line1,9, "Tahoma Bold", Lime);
      
   if (ObjectFind("002M") == -1 ){
   ObjectCreate("002M", OBJ_LABEL, 0, 0, 0);
   ObjectSet("002M", OBJPROP_COLOR, Red);
   ObjectSet("002M", OBJPROP_CORNER, 4);
   ObjectSet("002M", OBJPROP_XDISTANCE, 5);
   ObjectSet("002M", OBJPROP_YDISTANCE, 253+AddY);} 
   ObjectSetText("002M",Line2,9, "Tahoma Bold", Lime);   
   
   if (ObjectFind("003M") == -1 ){
   ObjectCreate("003M", OBJ_LABEL, 0, 0, 0);
   ObjectSet("003M", OBJPROP_COLOR, Red);
   ObjectSet("003M", OBJPROP_CORNER,TextCorner);
   ObjectSet("003M", OBJPROP_XDISTANCE, 5);
   ObjectSet("003M", OBJPROP_YDISTANCE, 268+AddY);} 
   ObjectSetText("003M",Line3,9, "Tahoma Bold", Lime);
      
   if (ObjectFind("004M") == -1 ){
   ObjectCreate("004M", OBJ_LABEL, 0, 0, 0);
   ObjectSet("004M", OBJPROP_COLOR, Red);
   ObjectSet("004M", OBJPROP_CORNER,TextCorner);
   ObjectSet("004M", OBJPROP_XDISTANCE, 5);
   ObjectSet("004M", OBJPROP_YDISTANCE, 283+AddY);} 
   ObjectSetText("004M",Line4,9, "Tahoma Bold", Lime);
}

int subSecsSinceLastTrade(int Magic)
{
   int
      cnt, 
      total = 0;
   int Mins = 0;
   datetime Last_Time = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Magic)
         {
             if(OrderOpenTime()>Last_Time)
             {
               LastTime = OrderOpenTime();
               int Secs = TimeCurrent()-OrderOpenTime();
               
             }
         }    
      }
   }
   return(Secs);
}
int subTotalTrade()
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             total++;
            OLots = OLots+OrderLots();
         }    
      }
   }
   return(total);
}
double subTotalOpenTradeLots()
{
   int
      cnt, 
      total = 0;
   double OPENLOTS = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() &&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             OPENLOTS = OrderLots();
             if(OPENLOTS>0)break;
         }    
      }
   }
   return(OPENLOTS);
}
int subTotalTradeTT(string ST, string ET)
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             datetime Start = StrToTime(ST);
             datetime End = StrToTime(ET);
             
             if(Start<End)
             {
                if(OrderOpenTime()>=Start && OrderOpenTime()<=End)total++;
             }
             if(Start>End)
             {
                if(OrderOpenTime()>=Start && OrderOpenTime()<= StrToTime("23:59"))total++;
                if(OrderOpenTime()>= StrToTime("00:00") && OrderOpenTime()<= End)total++;
             } 
         }    
      }
   }
   return(total);
}

int subTotalTradeTTLureTrades(string ST, string ET)
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() && StringFind(OrderComment(),"LureTrade",0)!=-1 && 
         (OrderMagicNumber()==LureTradeMagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             datetime Start = StrToTime(ST);
             datetime End = StrToTime(ET);
             
             if(Start<End)
             {
                if(OrderOpenTime()>=Start && OrderOpenTime()<=End)total++;
             }
             if(Start>End)
             {
                if(OrderOpenTime()>=Start && OrderOpenTime()<= StrToTime("23:59"))total++;
                if(OrderOpenTime()>= StrToTime("00:00") && OrderOpenTime()<= End)total++;
             } 
         }    
      }
   }
   return(total);
}

datetime subLastTradeTime()
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   datetime DT = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            if(OrderOpenTime()>DT)DT=OrderOpenTime();
         }    
      }
   }
   return(DT);
}
double subSmallestLots(int Type)
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   double L = 0;
   double OT = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==Type && OrderSymbol()==Symbol() &&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            if(OrderLots()<L||L==0)L = OrderLots();   
         }    
      }
   }
   return(L);
}
double subLastTradeLots()
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   double L = 0;
   datetime OT = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            if(OrderOpenTime()>OT)
            {
               L = OrderLots();   
               OT = OrderOpenTime();
            }
         }    
      }
   }
   return(L);
}
double subAvePrice()
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   double TPrice = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() &&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             total++;
             TPrice = OrderOpenPrice()+TPrice;
         }    
      }
   }
   double Ave = 0;
   if(total>0 && TPrice>0)Ave = TPrice/total;
   return(Ave);
}
double subAvePriceNormalized(int Type)
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==Type && OrderSymbol()==Symbol() &&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   return(Ave);
}
double subAvePriceNormalizedAll()
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   return(Ave);
}
int subTotalTypeOrders(int Type)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==Type&&OrderSymbol()==Symbol()&&
      (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))) total++;
      }
   }
   return(total);
}
int subTotalTypeOrdersMirror(int Type)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==Type&&OrderSymbol()==Symbol()&&
      OrderMagicNumber()==Mirror_MagicNumber) total++;
      }
   }
   return(total);
}
int subTotalTypeOrdersContrary(int Type)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==Type&&OrderSymbol()==Symbol()&&
      OrderMagicNumber()==ContraryPositionMagicNumber) total++;
      }
   }
   return(total);
}

int subTotalTypeProfitOrders(int Type)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==Type&&OrderSymbol()==Symbol()&&
      (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)) && OrderProfit()>0) total++;
      }
   }
   return(total);
}
double subTotalNetLots()
{
   int
      cnt, 
      total = 0;
   double L = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol()&&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            if(OrderType()==OP_BUY)L = L+OrderLots();
            if(OrderType()==OP_SELL)L= L-OrderLots();
         }
      }
   }
   return(L);
}
double subHighestOrder(int Type)
{
   int
      cnt, 
      total = 0;
   double OP = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type&&OrderSymbol()==Symbol()&&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            if(OrderOpenPrice()>OP)OP=OrderOpenPrice();
         }
      }
   }
   return(OP);
}
double subLowestOrder(int Type)
{
   int
      cnt, 
      total = 0;
   double OP = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type&&OrderSymbol()==Symbol()&&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            if(OrderOpenPrice()<OP||OP==0)OP=OrderOpenPrice();
         }
      }
   }
   return(OP);
}
 
int subOpenOrder(int type, int stoploss, int takeprofit,double Lotz)
{
   string TicketComment = WindowExpertName(); 
   int NumberOfTries = 10;
   int
         ticket      = 0,
         err         = 0,
         c           = 0;
         
   double         
         aStopLoss   = 0,
         aTakeProfit = 0,
         bStopLoss   = 0,
         bTakeProfit = 0;

   int    decimalPlaces=0;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<1)decimalPlaces=1;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<0.1)decimalPlaces=2;

   double Lotzs = NormalizeDouble(Lotz,decimalPlaces);   
   if(Lotzs<MarketInfo(Symbol(),MODE_MINLOT)) Lotzs=MarketInfo(Symbol(),MODE_MINLOT);
   if(Lotzs>MarketInfo(Symbol(),MODE_MAXLOT)) Lotzs=MarketInfo(Symbol(),MODE_MAXLOT);   
   
   
   if(type==OP_BUY)
   {
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }

         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_BUY,Lotzs,NormalizeDouble(Ask,Digits),Slippage,aStopLoss,aTakeProfit,TicketComment,MagicNumber,0,Green);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_BUY,Lotzs,NormalizeDouble(Ask,Digits),Slippage,0,0,TicketComment,MagicNumber,0,Green);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss>0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit>0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(aStopLoss>0 || aTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red)==false)
                     {
                        bool Mod = OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red);
                     }
                  }
               }
            }
         }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));         
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_SELL)
   {   
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }
         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_SELL,Lotzs,NormalizeDouble(Bid,Digits),Slippage,bStopLoss,bTakeProfit,TicketComment,MagicNumber,0,Red);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_SELL,Lotzs,NormalizeDouble(Bid,Digits),Slippage,0,0,TicketComment,MagicNumber,0,Red);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss>0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit>0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(bStopLoss>0 || bTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red)==false)
                     {
                        Mod  = OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red);
                     }
                  }
               }   
            }
         }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }  
   return(ticket);
}

void subCloseOrderProfit()
{
   int
         cnt, 
         total       = 0,
         ticket      = 0,
         err         = 0,
         c           = 0;

   int NumberOfTries = 10;
   total = OrdersTotal();
   for(cnt=total-1;cnt>=0;cnt--)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {

         if(OrderSymbol()==Symbol() &&
            (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)) && OrderProfit()>0)
         {
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0)
                        {
                            cnt = cnt-1;
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0)
                           {
                            cnt = cnt-1;
                            break;
                            }
                        }  
                     }
                  }   
                  continue;
                  
               case OP_SELL     :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0)
                        {
                            cnt = cnt-1;
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                            if(ticket>0)
                           {
                               cnt = cnt-1;
                               break;
                           }
                        }  
                     }
                  }   
                  continue;
            }
         }
      }
   }      
}

void subCloseOrderLoss()
{
   int
         cnt, 
         total       = 0,
         ticket      = 0,
         err         = 0,
         c           = 0;

   int NumberOfTries = 10;
   total = OrdersTotal();
   for(cnt=total-1;cnt>=0;cnt--)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {

         if(OrderSymbol()==Symbol() &&
            (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)) && OrderProfit()<0)
         {
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0)
                        {
                            cnt = cnt-1;
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           
                           if(ticket>0)
                           {
                            cnt = cnt-1;
                            break;
                            }
                        }  
                     }
                  }   
                  continue;
                  
               case OP_SELL     :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                         if(ticket>0)
                        {
                            cnt = cnt-1;
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                            if(ticket>0)
                           {
                               cnt = cnt-1;
                               break;
                           }
                        }  
                     }
                  }   
                  continue;
            }
         }
      }
   }      
}

void subCloseOrderType(int Type)
{
   int
         cnt, 
         total       = 0,
         ticket      = 0,
         err         = 0,
         c           = 0;

   int NumberOfTries = 10;
   total = OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {

         if(OrderSymbol()==Symbol() &&
           (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)) && Type == OrderType())
         {
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0)
                        {
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                        if(ticket>0)
                        {
                            break;
                        }
                        }  
                     }
                  }   
                  continue;
                  
               case OP_SELL     :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0)
                        {
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                            if(ticket>0)
                        {
                            break;
                        }
                        }  
                     }
                  }   
                  continue;
            }
            
            if(ticket>0)
            {
               total=OrdersTotal();
               cnt=0;
            }
         }
      }
   }
   
   if(Type==OP_BUY)ObjectDelete("BUY ENTRY1");
   if(Type==OP_SELL)ObjectDelete("SELL ENTRY1");      
}

double subProfitTotal()//COUNTS THE TOTAL PROFIT IN PIP
{
   int
      cnt, 
      total = 0;

   double TotalProfit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
         double PipProfit = OrderProfit()+OrderCommission();
         TotalProfit = TotalProfit+PipProfit;
         }
      }
   }
   return(TotalProfit);
} 

double subProfitUSD()//COUNTS THE TOTAL PROFIT IN PIP
{
   int
      cnt, 
      total = 0;

   double TotalProfit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
         double PipProfit = OrderProfit();
         TotalProfit = TotalProfit+PipProfit;
         }
      }
   }
   return(TotalProfit);
} 

double subProfitToday(int Magic)
{
    int orders = OrdersHistoryTotal();
    double PL = 0;

    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=Magic) continue;
         //----
         int CBAR = iBarShift(Symbol(),PERIOD_D1,OrderCloseTime(),false);
         datetime ST = GlobalVariableGet(ReName);
         if(OrderCloseTime()<ST)break;
         if(CBAR == 0)
         {
            PL = PL+OrderProfit()+OrderCommission();
         }
         if(CBAR > 0)
         {
            break;
         }
    }
    return(PL);
}  
double subProfitToday2(int Magic)
{
    int orders = OrdersHistoryTotal();
    double PL = 0;

    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=Magic||OrderComment()!=ManualTradeID) continue;
         //----
         int CBAR = iBarShift(Symbol(),PERIOD_D1,OrderCloseTime(),false);
         datetime ST = GlobalVariableGet(ReName);
         if(OrderCloseTime()<ST)break;
         if(CBAR == 0)
         {
            PL = PL+OrderProfit()+OrderCommission();
         }
         if(CBAR > 0)
         {
            break;
         }
    }
    return(PL);
}              

double subProfitClosed(int Magic)
{
    int orders = OrdersHistoryTotal();
    double PL = 0;

    for(int i=orders-1;i>=0;i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=Magic) continue;
         //----
         PL = PL+OrderProfit()+OrderCommission();
    }
    return(PL);
}   

int subClosedTotal(int Magic)
{
    int orders = OrdersHistoryTotal();
    int PL = 0;
    CLots = 0;
    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=Magic) continue;
         //----
         
         PL = PL+1;
         CLots = CLots+OrderLots();
    }
    return(PL);
}  

string subTradingTime(bool Use_TradeTime,int TradeTime_Start_Hour,int TradeTime_Start_Minute, int TradeTime_End_Hour, int TradeTime_End_Minute)
{
   int StartHour = TradeTime_Start_Hour;
   int StartMinute = TradeTime_Start_Minute;
   
   int EndHour = TradeTime_End_Hour;
   int EndMinute = TradeTime_End_Minute;
   
   int Hour1 = Hour();
   int Minute1 = Minute();
   
   if(UseLocalTime==true)
   {
      Hour1 = TimeHour(TimeLocal());
      Minute1 = TimeMinute(TimeLocal());
   }
   
   string TradeTime = "no";

   if(Use_TradeTime)
   {   
      if(StartHour<EndHour)
      {
         if(Hour1>=StartHour&& Hour1<=EndHour)
         {
            TradeTime = "yes";
            if(Hour1==StartHour&&Minute1<StartMinute)
            {
               TradeTime = "no";
            }
            if(Hour1==EndHour&&Minute1>EndMinute)
            {
               TradeTime = "no";
            }
         }
      }
      if(StartHour>EndHour)
      {
         if(Hour1>=StartHour||Hour1<=EndHour)
         {
            TradeTime = "yes";
            if(Hour1==StartHour&&Minute1<StartMinute)
            {
               TradeTime = "no";
            }
            if(Hour1==EndHour&&Minute1>EndMinute)
            {
               TradeTime = "no";
            }
         }
      }
   }
   if(StartHour==EndHour)
      {
         TradeTime = "yes";
         if(Hour1==StartHour)
         {
            if(Minute1<StartMinute || Minute1>EndMinute)TradeTime = "no";
         }
         if(Hour1!=StartHour)TradeTime = "no";
      }
   if(!Use_TradeTime)
   {   
      TradeTime = "not used";
   }
   
   if((TradeTime_Start_Hour==0 && TradeTime_Start_Minute==0) || (TradeTime_End_Hour==0 && TradeTime_End_Minute==0))TradeTime = "no";
   return(TradeTime);      
}  

double subLastTradePL()
{
    int orders = OrdersHistoryTotal();
    double PL = 0;
    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=MagicNumber) continue;
         if(iBarShift(Symbol(), PERIOD_D1, OrderCloseTime(),false) == 0)
         {
         //----
            PL = OrderProfit();
         }
            break;
    }

    return(PL);
}
//StringSubstr(Symbol(),0,6);
void subTrailingStop(int TS_MinProfit, int Trailing_Stop)
{
   /*
   CALM_MagicNumber          = 22222,
   Mirror_MagicNumber = 451496;
   HedgeTradeMagicNumber      = 34491;
   HedgePairMagicNumber        = 888,
   MagicNumberOIT
   */
   
    int total = OrdersTotal();
    for(int cnt=0;cnt<total;cnt++)
    {
        if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
        {

           if(OrderType()<=OP_SELL &&
                OrderSymbol()==Symbol() &&
                (OrderMagicNumber()==MagicNumber||OrderMagicNumber()==CALM_MagicNumber||OrderMagicNumber()==Mirror_MagicNumber||
                OrderMagicNumber()==HedgeTradeMagicNumber||OrderMagicNumber()==HedgePairMagicNumber||OrderMagicNumber()==MagicNumberOIT || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
           {
              if(OrderType()==OP_BUY)   // buy position is opened   
              {
                  if(Bid-OrderOpenPrice()>MyPoint*TS_MinProfit &&
                  OrderStopLoss()<Bid-(MyPoint*Trailing_Stop))
                  {
                     bool Mod = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-(MyPoint*Trailing_Stop),OrderTakeProfit(),0,Green);
                  }
             
              }         
              if(OrderType()==OP_SELL)   // sell position is opened   
              {
                     
                  if(OrderOpenPrice()-Ask>MyPoint*TS_MinProfit)
                  {
                     if(OrderStopLoss()>Ask+(MyPoint*Trailing_Stop) || OrderStopLoss()==0)
                     {
                        Mod = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(MyPoint*Trailing_Stop),OrderTakeProfit(),0,Red);
                        //return(0);
                     }
                   }    
              }
           }
        }
     }
}      

void subTrailingStopContrary(int TS_MinProfit, int Trailing_Stop)
{
   /*
   DENSE_MagicNumber         = 11111,
   CALM_MagicNumber          = 22222,
   Mirror_MagicNumber = 451496;
   HedgeTradeMagicNumber      = 34491;
   ContraryPositionMagicNumber = 111,
   HedgePairMagicNumber        = 888,
   MagicNumberOIT
   */
   
    int total = OrdersTotal();
    for(int cnt=0;cnt<total;cnt++)
    {
        if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
        {

           if(OrderType()<=OP_SELL &&
              OrderSymbol()==Symbol() &&
              OrderMagicNumber()==ContraryPositionMagicNumber)
           {
              if(OrderType()==OP_BUY)   // buy position is opened   
              {
                  if(Bid-OrderOpenPrice()>MyPoint*TS_MinProfit &&
                  OrderStopLoss()<Bid-(MyPoint*Trailing_Stop))
                  {
                     bool Mod = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-(MyPoint*Trailing_Stop),OrderTakeProfit(),0,Green);
                  }
             
              }         
              if(OrderType()==OP_SELL)   // sell position is opened   
              {
                     
                  if(OrderOpenPrice()-Ask>MyPoint*TS_MinProfit)
                  {
                     if(OrderStopLoss()>Ask+(MyPoint*Trailing_Stop) || OrderStopLoss()==0)
                     {
                        Mod = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(MyPoint*Trailing_Stop),OrderTakeProfit(),0,Red);
                        //return(0);
                     }
                   }    
              }
           }
        }
     }
}        

bool subCloseHighProfit(int Type)//COUNTS THE TOTAL PROFIT IN PIP
{
   int
      cnt, 
      total = 0;

   int ticket = 0;
   double Profit = EMPTY_VALUE*(-1);
   bool TF = false;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==Type &&
         OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            if(OrderProfit()>Profit)
            {
               Profit = OrderProfit();
               ticket = OrderTicket();   
            }
         }
       }  
   }
   
   if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
   {
      TF = OrderClose(ticket,OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),60,Violet);
       
      Print("CLOSE HEDGE TRADE!");
   }
   return(TF);
} 
double subDollarProfitTotal()//COUNTS THE TOTAL PROFIT IN DOLLAR
{
   int
      cnt, 
      total = 0;
   double Profit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             Profit = Profit+OrderProfit();
         }
      }
   }
   return(Profit);
}

/*
70 BUY
30 SELL
Hi,

I read trough your emails and both ideas are possible to code. But it would be easier to code this:
 
" if we close out all the profitable trades and leaving open the losing trades,  the EA should try to make a new good average based on the losing open trades"
 
So let me try to reiterate what we will be coding so that you can confirm if I understood what you need.

We add a new input "CloseHedgeAfterTrades" so this is the number of open trades before closing out the hedge trades. So after this number is reached EA will methodically close out your BUY and SELL trades starting with trades with the highest profit being closed first, until there are no hedge trades left on the board.
(But I believe your partner is right we should leave the 2 initial BUY and SELL trades open)

Now from this point onwards the EA will resume averaging the trades with the LOSING trades as reference for averaging.
 
We can code all this for $200. Please email me if you are ready to start this project so that I may send the proper invoice for the deposit. I estimate we can complete this within 5-7 days. Also if you wish to start this project please email the EA version that you want to apply this function to.

Best Regards,
Mikhail


extern int
   BrokerTakeProfit                 = 20;   
extern int Mirror_MagicNumber = 451496;
extern bool
   UseAveragePipTakeProfitMirror   = true;
extern int
   AvePricePipTakeProfitTrigger = 50,
   AvePricePipTakeProfitMax     = 50,
   AvePricePipTakeProfitMin     = 50;

*/
//------------------------------
//------ MIRROR FUNCTIONS------
//-----------------------------
datetime StartTime;
string LastStatus = "NULL";
bool TriggerBuy = false;
bool TriggerSell = false;
int Stick;
datetime M_DTT = 0;
double M_Swap;
void MirrorStart()//MMMMMMMMMMMMMMMMMMMMMM
{
   
   if(M_DTT!=iTime(Symbol(),PERIOD_D1,0) && AddSwapToTP == true)
   {
      M_Swap = subTotalSwapPips_Mirror();    
      M_DTT = iTime(Symbol(),PERIOD_D1,0);
   }
   if(AddSwapToTP==false)M_Swap = 0;
   if(M_Swap>0)M_Swap = 0;
   
   int TotalTradeMirror_Script = subTotalTradeMirror_Script();
   if(TotalTradeMirror_Script<1)M_Swap = 0;
   
   AvePricePipTakeProfitTrigger = InitAvePricePipTakeProfitTrig+M_Swap;
   AvePricePipTakeProfitMax     = InitAvePricePipTakeProfitMax+M_Swap;
   AvePricePipTakeProfitMin     = InitAvePricePipTakeProfitMin+M_Swap;
   BrokerTakeProfit             = InitBrokerTakeProfit+M_Swap; 
   
   if(!IsTesting())
   {
      WriteCom3(
      "Open Trades: "+subTotalAllOrders_Script(),
      "Open Position Profit: "+DoubleToStr(subPipProfitTotal_Script(),1), 
      "Total Open Lots: "+DoubleToStr(subTotalLots_Script(),2), 
      "Average price of Total Net Open Lots: "+DoubleToStr(subAvePriceNormalizedAll_Script(),Digits));
   }
   subLastTradeHitTP_Mirror();
   if(LastStatus == "NULL")
   {
      StartTime = TimeCurrent();
      DrawDashboard_Script();
      LastStatus = "ON";
   }
   WindowRedraw();
   string Status = ObjectDescription("SWITCH");
   RefreshRates();
   if(Status == "OFF"||Status == "PAUSE")
   {
      StartTime = TimeCurrent();
   }
   
   int TotalTradeMasters_Script = subTotalTradeMasters_Script();
   if(TotalTradeMasters_Script<1 && TotalTradeMirror_Script>0)
   {
      subAddTrades_Script();
      TurnSwitch_Script("PAUSE",OrangeRed);
   }
   if(MirrorTradeClose==true)CloseMirrorTrade_Script();
   if(Status == "PAUSE")
   {
      subAveTP_Script(); // TURN SWITCH TO PAUSE
      
      if(TotalTradeMasters_Script<1 && TotalTradeMirror_Script<1)TurnSwitch_Script("ON",Lime);
      Status = ObjectDescription("SWITCH");
   }
   if(Status == "ON")
   {
      CopyOpenTrades_Script(StartTime);
      
      subAveTP_Script();// TURN SWITCH TO PAUSE
   }
   Status = ObjectDescription("SWITCH");
   LastStatus = Status;
   subLastTradeHitTP_Mirror();
   if(UseBrokerTakeProfitForMirror==true && BrokerTakeProfit>0)MirrorBrokerTP(BrokerTakeProfit);
   WindowRedraw();          
   //TurnSwitch.Script("PAUSE",Gold);         
}
void CopyOpenTrades_Script(datetime Start)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()<=OP_SELL &&
         OrderOpenTime()>=Start && 
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))) 
        {
            int TICKET = OrderTicket();
            if(OrderType()==OP_SELL)int RTYPE = OP_BUY;
            if(OrderType()==OP_BUY)RTYPE = OP_SELL;
            double lotz = OrderLots()*MirrorLotsMultiplier;
            if(subTotalTrade_Script(TICKET)<1)
            {  
               int t = 0;
               t= subOpenOrder_Script(OrderSymbol(), RTYPE, 0, 0, 0, lotz, "MIRROR:"+DoubleToStr(TICKET,0)+";");
               if(t>0)break;
            }
        }
      }
   }
}
void subAddTrades_Script()
{
   int RETURN = 1;
   
   if(subTradingTime(UseTradeTime,TradeTime_StartHour_1,TradeTime_StartMinute_1, TradeTime_EndHour_1,TradeTime_EndMinute_1)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_2,TradeTime_StartMinute_2, TradeTime_EndHour_2,TradeTime_EndMinute_2)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_3,TradeTime_StartMinute_3, TradeTime_EndHour_3,TradeTime_EndMinute_3)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_4,TradeTime_StartMinute_4, TradeTime_EndHour_4,TradeTime_EndMinute_4)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_5,TradeTime_StartMinute_5, TradeTime_EndHour_5,TradeTime_EndMinute_5)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_6,TradeTime_StartMinute_6, TradeTime_EndHour_6,TradeTime_EndMinute_6)=="no" &&
     subTradingTime(UseTradeTime,TradeTime_StartHour_7,TradeTime_StartMinute_7, TradeTime_EndHour_7,TradeTime_EndMinute_7)=="no")
   {
      RETURN=0;
   }  
   if(UseTradeTime == true)
   {
      if(SkipTradeTime1OnMonday==true && DayOfWeek()==1)
      {
         if(subTradingTime(UseTradeTime,TradeTime_StartHour_1,TradeTime_StartMinute_1,TradeTime_EndHour_1,TradeTime_EndMinute_1)=="yes")
         {
            RETURN=0;
         }
      }
      if(SkipTradeTime1OnMonday==false || (SkipTradeTime1OnMonday==true && DayOfWeek()!=1))
      {
         if(subTradingTime(UseTradeTime,TradeTime_StartHour_1,TradeTime_StartMinute_1,TradeTime_EndHour_1,TradeTime_EndMinute_1)=="yes")
         {
            string StartTime_1 = TradeTime_StartHour_1+":"+TradeTime_StartMinute_1;
            string EndTime_1 = TradeTime_EndHour_1+":"+TradeTime_EndMinute_1;
            if(subTotalTradeTT_Script(StartTime_1, EndTime_1)>=MaxTradePerTradeTime)
            {
               RETURN=0;
            }
            if(subTotalTradeTTLureTrades(StartTime_1, EndTime_1)>=MaxLureTradesPerTradeTime)
            {
               StopLureTrades = true;
            }
            if(subTotalTradeTTLureTrades(StartTime_1, EndTime_1)<MaxLureTradesPerTradeTime)
            {
               StopLureTrades = false;
            }
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_2,TradeTime_StartMinute_2,TradeTime_EndHour_2,TradeTime_EndMinute_2)=="yes")
      {
         string StartTime_2 = TradeTime_StartHour_2+":"+TradeTime_StartMinute_2;
         string EndTime_2 = TradeTime_EndHour_2+":"+TradeTime_EndMinute_2;
         if(subTotalTradeTT_Script(StartTime_2, EndTime_2)>=MaxTradePerTradeTime)
         {
            RETURN=0;
         }
         if(subTotalTradeTTLureTrades(StartTime_2, EndTime_2)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_2, EndTime_2)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_3,TradeTime_StartMinute_3,TradeTime_EndHour_3,TradeTime_EndMinute_3)=="yes")
      {
         string StartTime_3 = TradeTime_StartHour_3+":"+TradeTime_StartMinute_3;
         string EndTime_3 = TradeTime_EndHour_3+":"+TradeTime_EndMinute_3;
         if(subTotalTradeTT_Script(StartTime_3, EndTime_3)>=MaxTradePerTradeTime)
         {
            RETURN=0;
         }
         if(subTotalTradeTTLureTrades(StartTime_3, EndTime_3)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_3, EndTime_3)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_4,TradeTime_StartMinute_4,TradeTime_EndHour_4,TradeTime_EndMinute_4)=="yes")
      {
         string StartTime_4 = TradeTime_StartHour_4+":"+TradeTime_StartMinute_4;
         string EndTime_4 = TradeTime_EndHour_4+":"+TradeTime_EndMinute_4;
         if(subTotalTradeTT_Script(StartTime_4, EndTime_4)>=MaxTradePerTradeTime)
         {
            RETURN=0;
         }
         if(subTotalTradeTTLureTrades(StartTime_4, EndTime_4)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_4, EndTime_4)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_5,TradeTime_StartMinute_5,TradeTime_EndHour_5,TradeTime_EndMinute_5)=="yes")
      {
         string StartTime_5 = TradeTime_StartHour_5+":"+TradeTime_StartMinute_5;
         string EndTime_5 = TradeTime_EndHour_5+":"+TradeTime_EndMinute_5;
         if(subTotalTradeTT_Script(StartTime_5, EndTime_5)>=MaxTradePerTradeTime)
         {
            RETURN=0;
         }
         if(subTotalTradeTTLureTrades(StartTime_5, EndTime_5)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_5, EndTime_5)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_6,TradeTime_StartMinute_6,TradeTime_EndHour_6,TradeTime_EndMinute_6)=="yes")
      {
         string StartTime_6 = TradeTime_StartHour_6+":"+TradeTime_StartMinute_6;
         string EndTime_6 = TradeTime_EndHour_6+":"+TradeTime_EndMinute_6;
         if(subTotalTradeTT_Script(StartTime_6, EndTime_6)>=MaxTradePerTradeTime)
         {
            RETURN=0;
         }
         if(subTotalTradeTTLureTrades(StartTime_6, EndTime_6)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_6, EndTime_6)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_7,TradeTime_StartMinute_7,TradeTime_EndHour_7,TradeTime_EndMinute_7)=="yes")
      {
         string StartTime_7 = TradeTime_StartHour_7+":"+TradeTime_StartMinute_7;
         string EndTime_7 = TradeTime_EndHour_7+":"+TradeTime_EndMinute_7;
         if(subTotalTradeTT_Script(StartTime_7, EndTime_7)>=MaxTradePerTradeTime)
         {
            RETURN=0;
         }
         if(subTotalTradeTTLureTrades(StartTime_7, EndTime_7)>=MaxLureTradesPerTradeTime)
         {
            StopLureTrades = true;
         }
         if(subTotalTradeTTLureTrades(StartTime_7, EndTime_7)<MaxLureTradesPerTradeTime)
         {
            StopLureTrades = false;
         }
      }
   }
     
   if(UseTradeTime == false)
   {
       StartTime_1 = TradeTime_StartHour_1+":"+TradeTime_StartMinute_1;
       EndTime_1 = TradeTime_EndHour_1+":"+TradeTime_EndMinute_1;
       if(subTotalTradeTT(StartTime_1, EndTime_1)>=MaxTradePerTradeTime)RETURN=0;
       
      if(subTotalTradeTTLureTrades(StartTime_1, EndTime_1)>=MaxLureTradesPerTradeTime)
      {
         StopLureTrades = true;
      }
      if(subTotalTradeTTLureTrades(StartTime_1, EndTime_1)<MaxLureTradesPerTradeTime)
      {
         StopLureTrades = false;
      }
   }
   
   double HSell = subHighestOrder_Script(OP_SELL)+(PipsBetweenTrades*MyPoint);
   double LBuy = subLowestOrder_Script(OP_BUY)-(PipsBetweenTrades*MyPoint);
   int ticket = 0;
   double SLotz = subTypeLotsMirror_Script(OP_SELL);
   double BLotz = subTypeLotsMirror_Script(OP_BUY);
   
   if(RETURN==1)
   {
      if(subTotalTradeMirror_Script()<MaxTrades && Stick>=TicksBetweenTrades)
      {
         if(AddTradesAfterSeconds==false)
         {
            if(Bid>=HSell && subTotalTypeOrders_Script(OP_SELL)>0)
            {
               if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
               {
                  LureTradesOpen(OP_SELL,SLotz);
                  LTTT = iTime(Symbol(),0,0);
                  Print("UseLureTradesOpen.AddTradesAfterSeconds.EnableMirrorTrading");
               }
               
               ticket = 0;
               ticket = subOpenOrder_Script(Symbol(), OP_SELL, 0, StopLoss, 0, SLotz, "MIRROR:ADDTRADE");
               if(ticket>0)
               {
                  Stick = 0;
               }
            }
            if(Ask<=LBuy && subTotalTypeOrders_Script(OP_BUY)>0)
            {
               if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
               {
                  LureTradesOpen(OP_BUY,BLotz);
                  LTTT = iTime(Symbol(),0,0);
                  Print("UseLureTradesOpen.AddTradesAfterSeconds.EnableMirrorTrading");
               }
               
               ticket = 0;
               ticket = subOpenOrder_Script(Symbol(), OP_BUY, 0, StopLoss, 0, BLotz, "MIRROR:ADDTRADE");
               if(ticket>0)
               {
                  Stick = 0;
               }
            }
         }
         if(AddTradesAfterSeconds==true && subSecsSinceLastTrade_Script()>=SecondsToAddTrades)
         {
            if(Bid>=HSell && subTotalTypeOrders_Script(OP_SELL)>0)
            {
               if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
               {
                  LureTradesOpen(OP_SELL,SLotz);
                  LTTT = iTime(Symbol(),0,0);
                  Print("UseLureTradesOpen>AddTradesAfterSeconds>EnableMirrorTrading");
               }
               
               ticket = 0;
               ticket = subOpenOrder_Script(Symbol(), OP_SELL, 0, StopLoss, 0, SLotz, "MIRROR:ADDTRADE");
               if(ticket>0)
               {
                  Stick = 0;
               }  
            }
            if(Ask<=LBuy && subTotalTypeOrders_Script(OP_BUY)>0)
            {
               if(UseLureTrades==true && StopLureTrades==false && LTTT!=iTime(Symbol(),0,0))
               {
                  LureTradesOpen(OP_BUY,BLotz);
                  LTTT = iTime(Symbol(),0,0);
                  Print("UseLureTradesOpen>AddTradesAfterSeconds>EnableMirrorTrading");
               }
               
               ticket = 0;
               ticket = subOpenOrder_Script(Symbol(), OP_BUY, 0, StopLoss, 0, BLotz, "MIRROR:ADDTRADE");
               if(ticket>0)
               {
                  Stick = 0;
               }
            }
         }
      }
   }
   Stick++;  
}
int subTotalTradeTT_Script(string ST, string ET)
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
             datetime Start = StrToTime(ST);
             datetime End = StrToTime(ET);

             if(OrderOpenTime()>=Start && OrderOpenTime()<=End)total++;
         }    
      }
   }
   return(total);
}
double subAvePriceNormalizedAll_Script()
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   return(Ave);


}
int subTotalTypeOrders_Script(int Type)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==Type&&OrderSymbol()==Symbol()&&
      OrderMagicNumber()==Mirror_MagicNumber) total++;
      }
   }
   return(total);
}
int subTotalAllOrders_Script()
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol()&&
      OrderMagicNumber()==Mirror_MagicNumber) total++;
      }
   }
   return(total);
}
int subSecsSinceLastTrade_Script()
{
   int
      cnt, 
      total = 0;
   int Mins = 0;
   datetime Last_Time = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
             if(OrderOpenTime()>Last_Time)
             {
               Last_Time = OrderOpenTime();
               int Secs = TimeCurrent()-OrderOpenTime();
               
             }
         }    
      }
   }
   return(Secs);
}
void CloseMirrorTrade_Script()
{
   int
      cnt, 
      total = 0;

   if(MirrorTradeClosePipsFromMainTrade==0)
   {
      for(cnt=0;cnt<OrdersTotal();cnt++)
      {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
         {
            if(StringFind(OrderComment(),"MIRROR:",0)!=-1 && OrderMagicNumber()==Mirror_MagicNumber)
            {
               int index1 = StringFind(OrderComment(),":",0);
               int index2 = StringFind(OrderComment(),";",index1);
               int ticket = StrToInteger(StringSubstr(OrderComment(),index1+1,index2));
               int TICKET = OrderTicket();
               double LOTS = OrderLots();
               double Price= OrderClosePrice();
               //Print(OrderComment()+":"+ticket);
               
               if(subTotalOriginalTrade_Script(ticket)<1)
               {
                  int t = OrderClose(TICKET, LOTS, Price, Slippage, CLR_NONE);
                  if(ticket>0)
                  {
                      break;
                  } 
               }
            }
         }
      }
   }
   
   if(MirrorTradeClosePipsFromMainTrade>0) //v13
   {
      for(cnt=0;cnt<OrdersTotal();cnt++)
      {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
         {
            if(StringFind(OrderComment(),"MIRROR:",0)!=-1 && OrderMagicNumber()==Mirror_MagicNumber)
            {
               index1 = StringFind(OrderComment(),":",0);
               index2 = StringFind(OrderComment(),";",index1);
               ticket = StrToInteger(StringSubstr(OrderComment(),index1+1,index2));
               TICKET = OrderTicket();
               LOTS = OrderLots();
               Price= OrderClosePrice();
               int Type = OrderType();
               //Print(OrderComment()+":"+ticket);
               double MainTradeClosePrice = subClosePrice(ticket);
               
               if(Type==OP_BUY)
               {
                  double BClosePrice = (MainTradeClosePrice+(MirrorTradeClosePipsFromMainTrade*MyPoint)); 
                  
                  if(subTotalOriginalTrade_Script(ticket)<1 && Price>=BClosePrice)
                  {
                     t = OrderClose(TICKET, LOTS, Price, Slippage, CLR_NONE);
                     if(ticket>0)
                     {
                        Print("CloseMirrorTrade-MirrorTradeClosePipsFromMainTrade. BMirrorClosePrice :"+BClosePrice+", MainTradeClosePrice :"+MainTradeClosePrice);
                        Print("B.MirrorTicket :"+TICKET+", S.MainTicket :"+ticket);
                        break;
                     } 
                  }  
               }
               if(Type==OP_SELL)
               {
                  double SClosePrice = (MainTradeClosePrice-(MirrorTradeClosePipsFromMainTrade*MyPoint));
                  
                  if(subTotalOriginalTrade_Script(ticket)<1 && Price<=SClosePrice)
                  {
                     t = OrderClose(TICKET, LOTS, Price, Slippage, CLR_NONE);
                     if(ticket>0)
                     {
                        Print("MirrorTradeClosePipsFromMainTrade. SMirrorClosePrice :"+SClosePrice+", MainTradeClosePrice :"+MainTradeClosePrice);
                        Print("S.MirrorTicket :"+TICKET+", B.MainTicket :"+ticket);
                        break;
                     } 
                  }
               }
            }
         }
      }
   } 
}

int subTotalOriginalTrade_Script(int ticket)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderTicket()==ticket) 
         {
            total++;
            break;
         }
      }
   }
   return(total);
}
int subTotalTrade_Script(int ticket)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(StringFind(OrderComment(),"MIRROR:"+DoubleToStr(ticket,0)+";",0)!=-1 && OrderMagicNumber()==Mirror_MagicNumber) total++;
      }
   }
   return(total);
}
int subTotalTradeMasters_Script()
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)) total++;
      }
   }
   return(total);
}
int subTotalTradeMirror_Script()
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderMagicNumber()==Mirror_MagicNumber) total++;
      }
   }
   return(total);
}
double subTotalLots_Script()
{
   int
      cnt;
   double    
      total = 0;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderMagicNumber()==Mirror_MagicNumber) total=total+OrderLots();
      }
   }
   return(total);
}
double subTypeLotsMirror_Script(int Type)
{
   int
      cnt, 
      total = 0;
   double Lo = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type && OrderMagicNumber()==Mirror_MagicNumber) 
         {
            Lo=OrderLots();
            break;
         }
      }
   }
   return(Lo);
}
/*
string error(int ai_0) 
{
   switch (ai_0) {
   case 0:
      return ("No error returned.");
   case 1:
      return ("No error returned, but the result is unknown. ");
   case 2:
      return ("Common error. ");
   case 3:
      return ("Invalid trade parameters. ");
   case 4:
      return ("Trade server is busy. ");
   case 5:
      return ("Old version of the client terminal. ");
   case 6:
      return ("No connection with trade server. ");
   case 7:
      return ("Not enough rights. ");
   case 8:
      return ("Too frequent requests.");
   case 9:
      return ("Malfunctional trade operation. ");
   case 64:
      return ("Account disabled. ");
   case 65:
      return ("Invalid account. ");
   case 128:
      return ("Trade timeout. ");
   case 129:
      return ("Invalid price. ");
   case 130:
      return ("Invalid stops. ");
   case 131:
      return ("Invalid trade volume. ");
   case 132:
      return ("Market is closed. ");
   case 133:
      return ("Trade is disabled. ");
   case 134:
      return ("Not enough money. ");
   case 135:
      return ("Price changed. ");
   case 136:
      return ("Off quotes. ");
   case 137:
      return ("Broker is busy.");
   case 138:
      return ("Requote. ");
   case 139:
      return ("Order is locked. ");
   case 140:
      return ("Long positions only allowed. ");
   case 141:
      return ("Too many requests. ");
   case 145:
      return ("Modification denied because order too close to market. ");
   case 146:
      return ("Trade context is busy. ");
   case 147:
      return ("Expirations are denied by broker. ");
   case 148:
      return ("The amount of open and pending orders has reached the limit set by the broker. ");
   case 4000:
      return ("No error. ");
   case 4001:
      return ("Wrong function pointer. ");
   case 4002:
      return ("Array index is out of range. ");
   case 4003:
      return ("No memory for function call stack. ");
   case 4004:
      return ("Recursive stack overflow. ");
   case 4005:
      return ("Not enough stack for parameter. ");
   case 4006:
      return ("No memory for parameter string. ");
   case 4007:
      return ("No memory for temp string. ");
   case 4008:
      return ("Not initialized string. ");
   case 4009:
      return ("Not initialized string in array. ");
   case 4010:
      return ("No memory for array string. ");
   case 4011:
      return ("Too long string. ");
   case 4012:
      return ("Remainder from zero divide. ");
   case 4013:
      return ("Zero divide. ");
   case 4014:
      return ("Unknown command. ");
   case 4015:
      return ("Wrong jump (never generated error). ");
   case 4016:
      return ("Not initialized array. ");
   case 4017:
      return ("DLL calls are not allowed. ");
   case 4018:
      return ("Cannot load library. ");
   case 4019:
      return ("Cannot call function. ");
   case 4020:
      return ("Expert function calls are not allowed. ");
   case 4021:
      return ("Not enough memory for temp string returned from function. ");
   case 4022:
      return ("System is busy (never generated error). ");
   case 4050:
      return ("Invalid function parameters count. ");
   case 4051:
      return ("Invalid function parameter value. ");
   case 4052:
      return ("String function internal error. ");
   case 4053:
      return ("Some array error. ");
   case 4054:
      return ("Incorrect series array using. ");
   case 4055:
      return ("Custom indicator error. ");
   case 4056:
      return ("Arrays are incompatible. ");
   case 4057:
      return ("Global variables processing error. ");
   case 4058:
      return ("Global variable not found. ");
   case 4059:
      return ("Function is not allowed in testing mode. ");
   case 4060:
      return ("Function is not confirmed. ");
   case 4061:
      return ("Send mail error. ");
   case 4062:
      return ("String parameter expected. ");
   case 4063:
      return ("Integer parameter expected. ");
   case 4064:
      return ("Double parameter expected. ");
   case 4065:
      return ("Array as parameter expected. ");
   case 4066:
      return ("Requested history data in updating state. ");
   case 4067:
      return ("Some error in trading function. ");
   case 4099:
      return ("End of file. ");
   case 4100:
      return ("Some file error.");
   case 4101:
      return ("Wrong file name. ");
   case 4102:
      return ("Too many opened files. ");
   case 4103:
      return ("Cannot open file. ");
   case 4104:
      return ("Incompatible access to a file. ");
   case 4105:
      return ("No order selected. ");
   case 4106:
      return ("Unknown symbol. ");
   case 4107:
      return ("Invalid price. ");
   case 4108:
      return ("Invalid ticket. ");
   case 4109:
      return ("Trade is not allowed. ");
   case 4110:
      return ("Longs are not allowed. ");
   case 4111:
      return ("Shorts are not allowed. ");
   case 4200:
      return ("Object exists already. ");
   case 4201:
      return ("Unknown object property. ");
   case 4202:
      return ("Object does not exist. ");
   case 4203:
      return ("Unknown object type. ");
   case 4204:
      return ("No object name. ");
   case 4205:
      return ("Object coordinates error. ");
   case 4206:
      return ("No specified subwindow. ");
   case 4207:
      return ("Some error in object function. ");
   }
   return ("Unknown error:" + ai_0);
}
*/

int subOpenOrder_Script(string SYMBOL, int type,double OpenPrice, double stoploss, double takeprofit,double Lotz,string TicketComment)
{

   int
         ticket      = 0,
         err         = 0,
         c           = 0;
         
   double         
         aStopLoss   = 0,
         aTakeProfit = 0,
         bStopLoss   = 0,
         bTakeProfit = 0;

   int MYDIGITS;
   double MYPOINT;
//----
   MYDIGITS = MarketInfo(SYMBOL,MODE_DIGITS);
   if (MarketInfo(SYMBOL,MODE_POINT) == 0.00001) MYPOINT = 0.0001; //6 digits
   else if (MarketInfo(SYMBOL,MODE_POINT) == 0.001) MYPOINT = 0.01; //3 digits (for Yen based pairs)
   else MYPOINT = MarketInfo(SYMBOL,MODE_POINT); //Normal
   if(stoploss!=0)
   {
      aStopLoss   = NormalizeDouble(stoploss,MYDIGITS);
      bStopLoss   = NormalizeDouble(stoploss,MYDIGITS);
   }

   if(takeprofit!=0)
   {
      aTakeProfit = NormalizeDouble(takeprofit,MYDIGITS);
      bTakeProfit = NormalizeDouble(takeprofit,MYDIGITS);
   }
   int NumberOfTries = 10;
   if(type==OP_BUY)
   {
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         double ASK = MarketInfo(SYMBOL,MODE_ASK);
         double BID = MarketInfo(SYMBOL,MODE_BID);
         
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(stoploss,MYDIGITS);
            bStopLoss   = NormalizeDouble(stoploss,MYDIGITS);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(takeprofit,MYDIGITS);
            bTakeProfit = NormalizeDouble(takeprofit,MYDIGITS);
         }
         ticket=OrderSend(SYMBOL,OP_BUY,Lotz,ASK,Slippage,0,0,TicketComment,Mirror_MagicNumber,0,Green);
         err=GetLastError();

         if(ticket>0)
         {
            int cnt = 0;
            while(OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,CLR_NONE)==false && cnt<10)
            {
               cnt++;  
            }
         }
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            //if(Problems_AlertByEmail==true)SendMail("ERROR OPENING TRADE: "+error(err),SYMBOL+" "+"ERROR OPENING TRADE: "+error(err) );
            Print("Error: "+err+"| SL: "+aStopLoss+"| TP: "+aTakeProfit);
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_SELL)
   {   
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         ASK = MarketInfo(SYMBOL,MODE_ASK);
         BID = MarketInfo(SYMBOL,MODE_BID);
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(stoploss,MYDIGITS);
            bStopLoss   = NormalizeDouble(stoploss,MYDIGITS);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(takeprofit,MYDIGITS);
            bTakeProfit = NormalizeDouble(takeprofit,MYDIGITS);
         }
         ticket=OrderSend(SYMBOL,OP_SELL,Lotz,BID,Slippage,0,0,TicketComment,Mirror_MagicNumber,0,Red);
         err=GetLastError();
    
         if(ticket>0)
         {
            Print("stopLoss: "+bStopLoss+"|TakeProfit: "+bTakeProfit);
            cnt = 0;
            while(OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,CLR_NONE)==false && cnt<10)
            {
               cnt++;  
            }
         }
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("Error: "+err+"| SL: "+bStopLoss+"| TP: "+bTakeProfit);
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }  
   if(type==OP_BUYSTOP)
   {
      for(c=0;c<10;c++)
      {
         ticket=OrderSend(SYMBOL,OP_BUYSTOP,Lotz,OpenPrice,6,aStopLoss,aTakeProfit,TicketComment,Mirror_MagicNumber,0,Green);
         err=GetLastError();
     
         
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_SELLSTOP)
   {   
      for(c=0;c<10;c++)
      {
         ticket=OrderSend(SYMBOL,OP_SELLSTOP,Lotz,OpenPrice,6,bStopLoss,bTakeProfit,TicketComment,Mirror_MagicNumber,0,Red);
         err=GetLastError();

         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_BUYLIMIT)
   {
      Print("OP_BUYLIMIT @"+OpenPrice);
      for(c=0;c<10;c++)
      {
         ticket=OrderSend(SYMBOL,OP_BUYLIMIT,Lotz,OpenPrice,6,aStopLoss,aTakeProfit,TicketComment,Mirror_MagicNumber,0,Green);
         err=GetLastError();
        
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_SELLLIMIT)
   {   
      for(c=0;c<10;c++)
      {
         ticket=OrderSend(SYMBOL,OP_SELLLIMIT,Lotz,OpenPrice,6,bStopLoss,bTakeProfit,TicketComment,Mirror_MagicNumber,0,Red);
         err=GetLastError();

         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }  
   return(ticket);
}

void DrawDashboard_Script()
{
   int Text_Corner = 2;
   int FontSize = 14;
   string Font = "Arial Black";
   
   ObjectCreate("SWITCH",OBJ_LABEL,0,0,0);
   ObjectSetText("SWITCH","ON",FontSize,Font,Lime);
   ObjectSet("SWITCH", OBJPROP_CORNER,Text_Corner);
   ObjectSet("SWITCH", OBJPROP_XDISTANCE, 5);
   ObjectSet("SWITCH", OBJPROP_YDISTANCE, 5);
}


void TurnSwitch_Script(string Text,color C)
{
   int Text_Corner = 2;
   int FontSize = 14;
   string Font = "Arial Black";
   
   ObjectCreate("SWITCH",OBJ_LABEL,0,0,0);
   ObjectSetText("SWITCH",Text,FontSize,Font,C);
   ObjectSet("SWITCH", OBJPROP_CORNER,Text_Corner);
   ObjectSet("SWITCH", OBJPROP_XDISTANCE, 5);
   ObjectSet("SWITCH", OBJPROP_YDISTANCE, 5);
}

void subAveTP_Script()
{
   if (Point == 0.00001) double MYPOINT = 0.0001; //6 digits
   else if (Point == 0.001) MYPOINT = 0.01; //3 digits (for Yen based pairs)
   else MyPoint = Point; //Normal
   
   double PipProfit = subPipProfitTotal_Script();
   if(UseAveragePipTakeProfitMirror == true)
   {
      double AveBuy = subAvePriceNormalized_Script(OP_BUY);
      double AveSell = subAvePriceNormalized_Script(OP_SELL); 
      
      if(AveBuy==0 && AveSell==0)TriggerBuy =  false;
      
      if(PipProfit>= AvePricePipTakeProfitTrigger)
      {
         TriggerBuy = true;
      }
      
      if(PipProfit <= AvePricePipTakeProfitMin && TriggerBuy==true)
      {
         subCloseOrderType_Script(OP_BUY);
         subCloseOrderType_Script(OP_BUY);
         subCloseOrderType_Script(OP_BUY);
         
         subCloseOrderType_Script(OP_SELL);
         subCloseOrderType_Script(OP_SELL);
         subCloseOrderType_Script(OP_SELL);
      }
      if(PipProfit >= AvePricePipTakeProfitMax)
      {
         subCloseOrderType_Script(OP_BUY);
         subCloseOrderType_Script(OP_BUY);
         subCloseOrderType_Script(OP_BUY);
         
         subCloseOrderType_Script(OP_SELL);
         subCloseOrderType_Script(OP_SELL);
         subCloseOrderType_Script(OP_SELL);
    
      }
   }
}
double subHighestOrder_Script(int Type)
{
   int
      cnt, 
      total = 0;
   double OP = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type&&OrderSymbol()==Symbol()&&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
            if(OrderOpenPrice()>OP)OP=OrderOpenPrice();
         }
      }
   }
   return(OP);
}
double subLowestOrder_Script(int Type)
{
   int
      cnt, 
      total = 0;
   double OP = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type&&OrderSymbol()==Symbol()&&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
            if(OrderOpenPrice()<OP||OP==0)OP=OrderOpenPrice();
         }
      }
   }
   return(OP);
}
/*
   AvePricePipTakeProfitTrigger = 5,
   AvePricePipTakeProfitMax     = 15,
   AvePricePipTakeProfitMin     = 2;
*/
double subAvePriceNormalized_Script(int Type)
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type && OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   return(Ave);


}
void subCloseOrderType_Script(int Type)
{
   int
         cnt, 
         total       = 0,
         ticket      = 0,
         err         = 0,
         c           = 0;

   int NumberOfTries = 10;
   total = OrdersTotal();
   
   //Change Name
   for(cnt=total-1;cnt>=0;cnt--)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol() &&
            OrderMagicNumber()==Mirror_MagicNumber && Type == OrderType())
         {
            TurnSwitch_Script("PAUSE",Gold);
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     //PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0)
                        {
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                        if(ticket>0)
                        {
                            break;
                        }
                        }  
                     }
                  }   
                  continue;
                  
               case OP_SELL     :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     //PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                         if(ticket>0)
                        {
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                            if(ticket>0)
                           {
                               break;
                           }
                        }  
                     }
                  }   
                  continue;
            }
         }
      }
   } 
}
double subTradeReviver()
{
    int orders = OrdersHistoryTotal();
    double PL = 0;
    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderType()>OP_SELL || OrderSymbol()!=Symbol()) continue;
         //----  

         
         if(GlobalVariableGet("COMPLETED"+":"+OrderTicket())>0)break;
         if(OrderCloseTime()<EAStartTime)break;
         
         int ticket = OrderTicket();
         int T = 0;
         double LOTS = OrderLots();
         GlobalVariableSet("COMPLETED"+IsTesting()+":"+ticket,100);
         if(StopLoss>0 && GlobalVariableGet("COMPLETED"+":"+OrderTicket())<=0 )// 
         {
            if(OrderClosePrice()<=OrderStopLoss() && OrderStopLoss()>0)//
            {
               if(OrderType()==OP_BUY)
               {
                  T = subOpenOrder(OP_BUY,TakeProfit,StopLoss,LOTS);
                  if(T>0)
                  {
                     GlobalVariableSet("COMPLETED"+":"+ticket,100);
                     Print(" Revive Buy ");
                  }
               }
            }     
            if(OrderClosePrice()>=OrderStopLoss() && OrderStopLoss()>0)//
            {
               if(OrderType()==OP_SELL)
               {
                  T = subOpenOrder(OP_SELL,TakeProfit,StopLoss,LOTS);
                  if(T>0)
                  {
                     GlobalVariableSet("COMPLETED"+":"+ticket,100);
                     Print(" Revive Sell ");
                  }
               }                     
            }  
         }
    }

    return(PL);
}
void subECNSLTP(double Take_Profit, int Type)//subAverageTP(int Type, double TP)
{
    int total = OrdersTotal();
    for(int cnt=0;cnt<total;cnt++)
    {
        if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
        {

           if(OrderType()<=OP_SELL &&
                OrderSymbol()==Symbol() &&
                (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            //Print ("ModifyOrder "+OrderTicket()+"Magic "+OrderMagicNumber());
            if(OrderType()==Type)
            {
               if((NormalizeDouble(OrderTakeProfit(),Digits)!=NormalizeDouble(TakeProfit,Digits)))
                     bool Mod = OrderModify(
                                 OrderTicket(),
                                 OrderOpenPrice(),
                                 OrderStopLoss(),
                                 NormalizeDouble(TakeProfit,Digits),
                                 0,
                                 CLR_NONE);
                    
            }
            if(OrderType()==Type)
            {
               if(NormalizeDouble(OrderTakeProfit(),Digits)!=NormalizeDouble(TakeProfit,Digits))
                     Mod = OrderModify(
                                 OrderTicket(),
                                 OrderOpenPrice(),
                                 OrderStopLoss(),
                                 NormalizeDouble(TakeProfit,Digits),
                                 0,
                                 CLR_NONE);
   
            }
         }
      }
   }   
}
void subCloseOrder()
{
   if(UseLureTrades==false)
   {
      int
            cnt, 
            total       = 0,
            ticket      = 0,
            err         = 0,
            c           = 0;

      int NumberOfTries = 10;
      total = OrdersTotal();
      for(cnt=0;cnt<OrdersTotal();cnt++)
      {
         if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
         {

            if(OrderSymbol()==Symbol() &&
              (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
            {
               switch(OrderType())
               {
                  case OP_BUY      :
                     for(c=0;c<NumberOfTries;c++)
                     {
                        RefreshRates();
                        ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                        PerDay = iTime(Symbol(),PERIOD_D1,0);
                        err=GetLastError();
                        if(err==0)
                        {  
                           if(ticket>0)
                           {
                               cnt = cnt-1;
                               break;
                           }
                        }
                        else
                        {
                           if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                           {
                              Sleep(5000);
                              continue;
                           }
                           else //normal error
                           {
                              if(ticket>0)
                              {
                               cnt = cnt-1;
                               break;
                               }
                           }  
                        }
                     }   
                     continue;
                  
                  case OP_SELL     :
                     for(c=0;c<NumberOfTries;c++)
                     {
                        RefreshRates();
                        ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                        PerDay = iTime(Symbol(),PERIOD_D1,0);
                        err=GetLastError();
                        if(err==0)
                        { 
                            if(ticket>0)
                           {
                               cnt = cnt-1;
                               break;
                           }
                        }
                        else
                        {
                           if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                           {
                              Sleep(5000);
                              continue;
                           }
                           else //normal error
                           {
                               if(ticket>0)
                              {
                                  cnt = cnt-1;
                                  break;
                              }
                           }  
                        }
                     }   
                     continue;
               }
            }
         } 
      }     
      ObjectDelete("BUY ENTRY1");
      ObjectDelete("SELL ENTRY1");
   }
   
   if(UseLureTrades==true)
   {
      total       = 0;
      ticket      = 0;
      err         = 0;
      c           = 0;
      
      double BT = subTotalTypeOrders(OP_BUY);
      double ST =subTotalTypeOrders(OP_SELL);
      string Lure = "none";
      if(BT>0 && ST==0)Lure = "BUY";
      if(BT==0 && ST>0)Lure = "SELL";   
      
      if(LTTT!=iTime(Symbol(),0,0))
      {
         if(Lure == "BUY")
         {
            subCloseOrderType_Cnt(OP_BUY);
            LTTT = iTime(Symbol(),0,0);
         }
         if(Lure == "SELL")
         {
            subCloseOrderType_Cnt(OP_SELL);
            LTTT = iTime(Symbol(),0,0);
         }
      }
      
      subCloseOrderAllClean();
      subCloseOrderAllClean();
      subCloseOrderAllClean();   
          
      ObjectDelete("BUY ENTRY1");
      ObjectDelete("SELL ENTRY1");
   }
}

void subCloseOrderType_Cnt(int Type)
{
   int
         cnt, 
         total       = 0,
         ticket      = 0,
         err         = 0,
         c           = 0;

   int NumberOfTries = 10;
   total = OrdersTotal();
   int LureCnt = 1;
   //Change Name
   for(cnt=total-1;cnt>=0;cnt--)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {

         if(OrderSymbol()==Symbol() &&
            (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)) && Type == OrderType())
         {
            double L = OrderLots();
            if(LureCnt > 11)LureCnt = 1;
            if(LureCnt == 1)
            {
               if(OrderType()==OP_SELL)
               {
                  int TEX = subOpenOrder(OP_BUY, 0, 0, L);
                  if(TEX>0)LureCnt++;
               }
               if(OrderType()==OP_BUY)
               {
                  TEX = subOpenOrder(OP_SELL, 0, 0, L);
                  if(TEX>0)LureCnt++;
               }
            }
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     //PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           LureCnt++;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              LureCnt++;
                              break;
                           }
                        }  
                     }
                  }   
                  continue;
                  
               case OP_SELL     :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     //PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           LureCnt++;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              LureCnt++;
                              break;
                           }
                        }  
                     }
                  }   
                  continue;
            }
         }
      }
   } 
}
void subCloseOrderAllClean()
{
   int
         cnt, 
         total       = 0,
         ticket      = 0,
         err         = 0,
         c           = 0;

   int NumberOfTries = 10;
   total = OrdersTotal();
   for(cnt=total-1;cnt>=0;cnt--)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {

         if(OrderSymbol()==Symbol() &&
           (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0)
                        {
                            cnt = cnt-1;
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0)
                           {
                            cnt = cnt-1;
                            break;
                            }
                        }  
                     }
                  }   
                  continue;
                  
               case OP_SELL     :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                         if(ticket>0)
                        {
                            cnt = cnt-1;
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                            if(ticket>0)
                           {
                               cnt = cnt-1;
                               break;
                           }
                        }  
                     }
                  }   
                  continue;
            }
         }
      }
   }      
   ObjectDelete("BUY ENTRY1");
   ObjectDelete("SELL ENTRY1");
}
void CreateMoveLine(string Name, double Price)
{
   if(ObjectFind(Name)==-1)
   {
      ObjectCreate(Name,OBJ_HLINE,0,TimeCurrent(), Price);
      ObjectSet(Name,OBJPROP_STYLE,STYLE_DASHDOTDOT);
      ObjectSet(Name,OBJPROP_COLOR,Red);
   }
   //if(ObjectFind(Name)!=-1)ObjectMove(Name,OBJPROP_PRICE1, TimeCurrent(),Price);
}
void FillOrKill()
{
   if(CloseAllTotalPipProfit>0)
   {
      double AveTPB = subAverageTP(OP_BUY, CloseAllTotalPipProfit);
      double AveTPS = subAverageTP(OP_SELL, CloseAllTotalPipProfit);
              
      if(AveTPB!=0 && AveTPS!=0)
      {
         ObjectDelete("BUYTP");
         ObjectDelete("SELLTP");
      }
      if(AveTPB==0 || AveTPS==0)
      {
         if(AveTPB>0)CreateMoveLine("BUYTP", AveTPB);
         if(AveTPS>0)CreateMoveLine("SELLTP", AveTPS);
      }   
      //subECNSLTP(AveTPB, OP_BUY);
      //subECNSLTP(AveTPS, OP_SELL);//subAverageTP(int Type, double TP)
      double BUYTP = ObjectGet("BUYTP",OBJPROP_PRICE1);
      double SELLTP = ObjectGet("SELLTP",OBJPROP_PRICE1); 
      
      if(Bid>=BUYTP && BUYTP>0)subCloseOrderType_FOK(OP_BUY, BUYTP);
      if(Ask<=SELLTP && SELLTP>0)subCloseOrderType_FOK(OP_SELL, SELLTP);
   }
   if(subTotalTrade()<=0)
   {
      ObjectDelete("BUYTP");
      ObjectDelete("SELLTP");
   }
   //CreateMoveLine(string Name, double Price)
}
void subCloseOrderType_FOK(int Type,double Price)
{
   int
         cnt, 
         total       = 0,
         ticket      = 0,
         err         = 0,
         c           = 0;

   int NumberOfTries = 10;
   total = OrdersTotal();
   int LureCnt = 1;
   //Change Name
   for(cnt=total-1;cnt>=0;cnt--)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {

         if(OrderSymbol()==Symbol() &&
           (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)) && Type == OrderType())
         {
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     if(OrderClosePrice()>=Price)ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),1,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           LureCnt++;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              LureCnt++;
                              break;
                           }
                        }  
                     }
                  }   
                  continue;
                  
               case OP_SELL     :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     if(OrderClosePrice()<=Price)ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),1,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           LureCnt++;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              LureCnt++;
                              break;
                           }
                        }  
                     }
                  }   
                  continue;
            }
         }
      }
   } 
}
int subLastTicket()
{
    int orders = OrdersHistoryTotal();
    int PL = 0;
    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=MagicNumber) continue;
         //----
          PL = OrderTicket();
          break;
    }

    return(PL);
}
//-----------------------
void MirrorBrokerTP(double MCTP)
{
   double AveTPB = subAverageTP_Mirror(OP_BUY, MCTP);
   double AveTPS = subAverageTP_Mirror(OP_SELL, MCTP);
           
   if(AveTPB!=0 && AveTPS!=0)
   {
      AveTPB = 0;
      AveTPS = 0;
   }

   subECNSLTP_Mirror(AveTPB, OP_BUY);
   subECNSLTP_Mirror(AveTPS, OP_SELL);//subAverageTP(int Type, double TP)
}
void subECNSLTP_Mirror(double Take_Profit, int Type)//subAverageTP(int Type, double TP)
{
    int total = OrdersTotal();
    for(int cnt=0;cnt<total;cnt++)
    {
        if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
        {

           if(OrderType()<=OP_SELL &&
                OrderSymbol()==Symbol() &&
                OrderMagicNumber()==Mirror_MagicNumber)
         {
            //Print ("ModifyOrder "+OrderTicket()+"Magic "+OrderMagicNumber());
            if(OrderType()==Type)
            {
               if((NormalizeDouble(OrderTakeProfit(),Digits)!=NormalizeDouble(Take_Profit,Digits)))
                     bool Mod = OrderModify(
                                 OrderTicket(),
                                 OrderOpenPrice(),
                                 OrderStopLoss(),
                                 NormalizeDouble(Take_Profit,Digits),
                                 0,
                                 CLR_NONE);
                    
            }
            if(OrderType()==Type)
            {
               if(NormalizeDouble(OrderTakeProfit(),Digits)!=NormalizeDouble(Take_Profit,Digits))
                     Mod = OrderModify(
                                 OrderTicket(),
                                 OrderOpenPrice(),
                                 OrderStopLoss(),
                                 NormalizeDouble(Take_Profit,Digits),
                                 0,
                                 CLR_NONE);
   
            }
         }
      }
   }   
}
double subAverageTP_Mirror(int Type, double TP)// COUNTS THE TOTAL ORDERS DEPENDING ON TYPE
{
   int
      cnt, 
      total = 0;
   double TPrice = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type&&OrderSymbol()==Symbol()&&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
            total++;
            TPrice = TPrice+OrderOpenPrice();
         }
      }
   }
   if(total>0)
   {
      if(Type==OP_BUY)
      {
         double AvePrice = (TPrice/total)+((TP/total)*MyPoint);
      }
      if(Type==OP_SELL)
      {
         AvePrice = (TPrice/total)-((TP/total)*MyPoint);
      }
   }
   return(AvePrice);
}
int subLastTradeHitTP_Mirror()
{
    int orders = OrdersHistoryTotal();
    int PL = 0;
    string NAME = "LASTTICKET: "+Mirror_MagicNumber+Symbol()+":"+IsTesting();
    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=Mirror_MagicNumber) continue;
         //----
         if(OrderTicket()!=GlobalVariableGet(NAME))
         {
            TurnSwitch_Script("PAUSE",Gold);       
            GlobalVariableSet(NAME,OrderTicket());
         }
         break;
     
    }

    return(PL);
}
double subTotalSwapPips()
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   double SWAP = 0;
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {            
             if(OrderSwap()!=0 && OrderLots()!=0 && tickvalue!=0)SWAP = SWAP+(OrderSwap()/OrderLots()/tickvalue);
         }    
      }
   }
   return(SWAP);
}
double subTotalSwapPips_Mirror()
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   double SWAP = 0;
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {            
             if(OrderSwap()!=0 && OrderLots()!=0 && tickvalue!=0)SWAP = SWAP+(OrderSwap()/OrderLots()/tickvalue);
         }    
      }
   }
   return(SWAP);
}
string error(int ai_0) 
{
   switch (ai_0) {
   case 0:
      return ("No error returned.");
   case 1:
      return ("No error returned, but the result is unknown. ");
   case 2:
      return ("Common error. ");
   case 3:
      return ("Invalid trade parameters. ");
   case 4:
      return ("Trade server is busy. ");
   case 5:
      return ("Old version of the client terminal. ");
   case 6:
      return ("No connection with trade server. ");
   case 7:
      return ("Not enough rights. ");
   case 8:
      return ("Too frequent requests.");
   case 9:
      return ("Malfunctional trade operation. ");
   case 64:
      return ("Account disabled. ");
   case 65:
      return ("Invalid account. ");
   case 128:
      return ("Trade timeout. ");
   case 129:
      return ("Invalid price. ");
   case 130:
      return ("Invalid stops. ");
   case 131:
      return ("Invalid trade volume. ");
   case 132:
      return ("Market is closed. ");
   case 133:
      return ("Trade is disabled. ");
   case 134:
      return ("Not enough money. ");
   case 135:
      return ("Price changed. ");
   case 136:
      return ("Off quotes. ");
   case 137:
      return ("Broker is busy.");
   case 138:
      return ("Requote. ");
   case 139:
      return ("Order is locked. ");
   case 140:
      return ("Long positions only allowed. ");
   case 141:
      return ("Too many requests. ");
   case 145:
      return ("Modification denied because order too close to market. ");
   case 146:
      return ("Trade context is busy. ");
   case 147:
      return ("Expirations are denied by broker. ");
   case 148:
      return ("The amount of open and pending orders has reached the limit set by the broker. ");
   case 4000:
      return ("No error. ");
   case 4001:
      return ("Wrong function pointer. ");
   case 4002:
      return ("Array index is out of range. ");
   case 4003:
      return ("No memory for function call stack. ");
   case 4004:
      return ("Recursive stack overflow. ");
   case 4005:
      return ("Not enough stack for parameter. ");
   case 4006:
      return ("No memory for parameter string. ");
   case 4007:
      return ("No memory for temp string. ");
   case 4008:
      return ("Not initialized string. ");
   case 4009:
      return ("Not initialized string in array. ");
   case 4010:
      return ("No memory for array string. ");
   case 4011:
      return ("Too long string. ");
   case 4012:
      return ("Remainder from zero divide. ");
   case 4013:
      return ("Zero divide. ");
   case 4014:
      return ("Unknown command. ");
   case 4015:
      return ("Wrong jump (never generated error). ");
   case 4016:
      return ("Not initialized array. ");
   case 4017:
      return ("DLL calls are not allowed. ");
   case 4018:
      return ("Cannot load library. ");
   case 4019:
      return ("Cannot call function. ");
   case 4020:
      return ("Expert function calls are not allowed. ");
   case 4021:
      return ("Not enough memory for temp string returned from function. ");
   case 4022:
      return ("System is busy (never generated error). ");
   case 4050:
      return ("Invalid function parameters count. ");
   case 4051:
      return ("Invalid function parameter value. ");
   case 4052:
      return ("String function internal error. ");
   case 4053:
      return ("Some array error. ");
   case 4054:
      return ("Incorrect series array using. ");
   case 4055:
      return ("Custom indicator error. ");
   case 4056:
      return ("Arrays are incompatible. ");
   case 4057:
      return ("Global variables processing error. ");
   case 4058:
      return ("Global variable not found. ");
   case 4059:
      return ("Function is not allowed in testing mode. ");
   case 4060:
      return ("Function is not confirmed. ");
   case 4061:
      return ("Send mail error. ");
   case 4062:
      return ("String parameter expected. ");
   case 4063:
      return ("Integer parameter expected. ");
   case 4064:
      return ("Double parameter expected. ");
   case 4065:
      return ("Array as parameter expected. ");
   case 4066:
      return ("Requested history data in updating state. ");
   case 4067:
      return ("Some error in trading function. ");
   case 4099:
      return ("End of file. ");
   case 4100:
      return ("Some file error.");
   case 4101:
      return ("Wrong file name. ");
   case 4102:
      return ("Too many opened files. ");
   case 4103:
      return ("Cannot open file. ");
   case 4104:
      return ("Incompatible access to a file. ");
   case 4105:
      return ("No order selected. ");
   case 4106:
      return ("Unknown symbol. ");
   case 4107:
      return ("Invalid price. ");
   case 4108:
      return ("Invalid ticket. ");
   case 4109:
      return ("Trade is not allowed. ");
   case 4110:
      return ("Longs are not allowed. ");
   case 4111:
      return ("Shorts are not allowed. ");
   case 4200:
      return ("Object exists already. ");
   case 4201:
      return ("Unknown object property. ");
   case 4202:
      return ("Object does not exist. ");
   case 4203:
      return ("Unknown object type. ");
   case 4204:
      return ("No object name. ");
   case 4205:
      return ("Object coordinates error. ");
   case 4206:
      return ("No specified subwindow. ");
   case 4207:
      return ("Some error in object function. ");
   }
   return ("Unknown error:" + ai_0);
}
double subMirrorPipProfitTotal()//COUNTS THE TOTAL PROFIT IN PIP
{
   int
      cnt, 
      total = 0;
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   double TotalProfit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
         
         if(OrderProfit()!=0&&OrderLots()!=0)double PipProfit = (OrderProfit()/OrderLots()/tickvalue);
         TotalProfit = TotalProfit+PipProfit;
         }
      }
   }
   return(TotalProfit);
}
double subContraryPipProfitTotal()//COUNTS THE TOTAL PROFIT IN PIP
{
   int
      cnt, 
      total = 0;
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   double TotalProfit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==ContraryPositionMagicNumber)
         {
         
         if(OrderProfit()!=0&&OrderLots()!=0)double PipProfit = (OrderProfit()/OrderLots()/tickvalue);
         TotalProfit = TotalProfit+PipProfit;
         }
      }
   }
   return(TotalProfit);
}
double subPipProfitTotal()//COUNTS THE TOTAL PROFIT IN PIP
{
   int
      cnt, 
      total = 0;
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   double TotalProfit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
         
         if(OrderProfit()!=0&&OrderLots()!=0)double PipProfit = (OrderProfit()/OrderLots()/tickvalue)-AddPipsToTP;
         TotalProfit = TotalProfit+PipProfit;
         }
      }
   }
   return(TotalProfit);
} 
double subPipProfitTotal_Script()//COUNTS THE TOTAL PROFIT IN PIP
{
   int
      cnt, 
      total = 0;
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   double TotalProfit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
         
         if(OrderProfit()!=0&&OrderLots()!=0)double PipProfit = (OrderProfit()/OrderLots()/tickvalue)-AddPipsToTP;
         TotalProfit = TotalProfit+PipProfit;
         }
      }
   }
   return(TotalProfit);
} 
double subAverageTP(int Type, double TP)// COUNTS THE TOTAL ORDERS DEPENDING ON TYPE
{
   int
      cnt, 
      total = 0;
   double TPrice = 0;
   double AvePrice = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type&&OrderSymbol()==Symbol()&&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            total++;
            TPrice = TPrice+OrderOpenPrice();
         }
      }
   }
   if(total>0)
   {
      if(Type==OP_BUY)
      {
         AvePrice = ((TPrice/total)+((TP/total)*MyPoint))+(AddPipsToTP*MyPoint);
      }
      if(Type==OP_SELL)
      {
         AvePrice = (TPrice/total)-((TP/total)*MyPoint)-(AddPipsToTP*MyPoint);
      }
   }
   return(AvePrice);
}
void subEquityClose()
{
   if(UseEquityClose)
   {
      if(subTotalTrade()<1)
      {
         GlobalVariableSet(StartingBal,AccountBalance());
      }
      double PL = AccountEquity()-GlobalVariableGet(StartingBal);
      if(PL!=0 && GlobalVariableGet(StartingBal)!=0)double Pct = (PL/GlobalVariableGet(StartingBal))*100;
      if(Pct>EquityClosePct)
      {
         subCloseOrder();
         subCloseOrder();
         subCloseOrder();
         subCloseOrder();
         subCloseOrderType_Script(OP_BUY);
         subCloseOrderType_Script(OP_BUY);
         subCloseOrderType_Script(OP_BUY);
         
         subCloseOrderType_Script(OP_SELL);
         subCloseOrderType_Script(OP_SELL);
         subCloseOrderType_Script(OP_SELL);
      }
      if(subTotalTrade()<1)
      {
         GlobalVariableSet(StartingBal,AccountBalance());
      }
   }
   
}

/*
extern bool
   UseStopLoss               = false;  
extern double   
   Stop_Loss                  = 0;
extern int
   WaitToPlaceStop            = 0;   
*/

void subDelayedSL(int Magic,int SL)
{
    int total = OrdersTotal();
    
    int MinsSinceLastTradeCloseSL = subLastTradeHitSLCloseMins();
     
    if(UseStopLoss==true && Stop_Loss>0)
    {
      for(int cnt=0;cnt<total;cnt++)
      {
          if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
          {

          if(OrderType()<=OP_SELL &&
               OrderSymbol()==Symbol() &&
               OrderMagicNumber()==Magic)
           {
              //Print ("ModifyOrder "+OrderTicket()+"Magic "+OrderMagicNumber());
              int OpenSecs = TimeCurrent()-OrderOpenTime();
              if(OpenSecs>=WaitToPlaceStop*60 && MinsSinceLastTradeCloseSL>=NoStopLossMinutes)
              {
                  
                  if(OrderType()==OP_BUY)
                  {
                     if(NormalizeDouble(OrderStopLoss(),Digits)!=NormalizeDouble(OrderOpenPrice()-(SL*MyPoint),Digits) &&SL>0 && (Ask-(3*MyPoint))>NormalizeDouble(OrderOpenPrice()-(SL*MyPoint),Digits))
                     {
                           bool Mod = OrderModify(
                                       OrderTicket(),
                                       OrderOpenPrice(),
                                       NormalizeDouble(OrderOpenPrice()-(SL*MyPoint),Digits),
                                       OrderTakeProfit(),
                                       0,
                                       CLR_NONE);
                                       Print("B-MinsSinceLastTradeCloseSL :"+MinsSinceLastTradeCloseSL+", Ask :"+Ask+", OrderOpenPrice()-(SL*MyPoint) :"+(OrderOpenPrice()-(SL*MyPoint)));
                    
                     }
                  }
                  if(OrderType()==OP_SELL)
                  {
                     if(NormalizeDouble(OrderStopLoss(),Digits)!=NormalizeDouble(OrderOpenPrice()+(SL*MyPoint),Digits) &&SL>0 && (Bid+(3*MyPoint))<NormalizeDouble(OrderOpenPrice()+(SL*MyPoint),Digits))
                     {
                           Mod = OrderModify(
                                       OrderTicket(),
                                       OrderOpenPrice(),
                                       NormalizeDouble(OrderOpenPrice()+(SL*MyPoint),Digits),
                                       OrderTakeProfit(),
                                       0,
                                       CLR_NONE);
                                       Print("S-MinsSinceLastTradeCloseSL :"+MinsSinceLastTradeCloseSL+", Bid :"+Bid+", OrderOpenPrice()+(SL*MyPoint) :"+(OrderOpenPrice()+(SL*MyPoint)));
                    
   
                     }
                  }
              }
           }
        }
     }   
   }
}

bool subLastTradeHitSL()
{
    int orders = OrdersHistoryTotal();
    double PL = 0;
    bool SLHit = false;
    if(WaitToResumeTradingAfterSL>0)
    {
      for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
      {
           if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
           if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=MagicNumber) continue;
           //----
           int CloseSecs = TimeCurrent()-OrderCloseTime();
           if(CloseSecs>WaitToResumeTradingAfterSL*60)break;
           if(CloseSecs<=WaitToResumeTradingAfterSL*60)
           {
              if(OrderType()==OP_BUY)
              {
                 if(OrderClosePrice()<=OrderStopLoss() && OrderStopLoss()>0)
                 {
                    SLHit = true;
                    break;
                 }
              }
              if(OrderType()==OP_SELL)
              {
                 if(OrderClosePrice()>=OrderStopLoss() && OrderStopLoss()>0)
                 {
                    SLHit = true;
                    break;
                 }
              }
              if(StringFind(OrderComment(),"[sl]",0)!=-1)
              {
                 SLHit = true;
                 break;
              }
           }
      }
   }
    return(SLHit);
}
double subPipProfitTotal2()//COUNTS THE TOTAL PROFIT IN PIP
{
   int
      cnt, 
      total = 0;
   double Profit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            if(OrderType()==OP_BUY)
            {
               Profit = Profit+(OrderClosePrice()-OrderOpenPrice());
            }
            if(OrderType()==OP_SELL)
            {
               Profit = Profit+(OrderOpenPrice()-OrderClosePrice());
            }
         }
      }
   }
   double TotalProfit = 0;
   if(Profit!=0)TotalProfit = Profit/MyPoint;
   return(TotalProfit);
} 

double PipsPerSecond()
{
   if(TimeCurrent()-LastTimex>=1)
   {
      double Pips = MathAbs(Bid-LastPrice);
      if(Pips>0)Pips = Pips/MyPoint;
      LastTimex= TimeCurrent();
      LastPrice = Bid;
   }
   return(Pips);
}
void BarsFromNewestTrade()
{
   int
      cnt, 
      total = OrdersTotal();
   datetime OT = 0;
   int shift = 0;
   
   for(cnt=0;cnt<total;cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            if(OrderOpenTime()>OT)
            {
               OT = OrderOpenTime();
               shift = iBarShift(Symbol(),PERIOD_D1,OT,false);
            }
         }
      }
   } 
   Comment("ReTrade Shift Days: "+shift+"\n"+
           "Reset Time: "+TimeToStr(ResetTime, TIME_DATE|TIME_MINUTES));
   if(shift>=RetradeAfterHangDays && RetradeAfterHangDays>0)ResetTime = TimeCurrent();
}
double subHighestOrderX(int Type)
{
   int
      cnt, 
      total = 0;
   double OP = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type&&OrderSymbol()==Symbol()&&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))
         && OrderOpenTime()>=ResetTime)
         {
            if(OrderOpenPrice()>OP )OP=OrderOpenPrice();
         }
      }
   }
   return(OP);
}
double subLowestOrderX(int Type)
{
   int
      cnt, 
      total = 0;
   double OP = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type&&OrderSymbol()==Symbol()&&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))
         && OrderOpenTime()>=ResetTime)
         {
            if(OrderOpenPrice()<OP||OP==0)OP=OrderOpenPrice();
         }
      }
   }
   return(OP);
}
int subTotalTradeX()
{
   int
      cnt, 
      total = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))
         && OrderOpenTime()>=ResetTime)
         {
             total++;
         }    
      }
   }
   return(total);
}
int subTotalTradeMagic(int Magic)
{
   int
      cnt, 
      total = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Magic)
         {
             total++;
         }    
      }
   }
   return(total);
}
int subTotalTypeOrdersX(int Type)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==Type&&OrderSymbol()==Symbol()&&
        (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))
         && OrderOpenTime()>=ResetTime) total++;
      }
   }
   return(total);
}
int subSecsSinceLastTradeX(int Magic)
{
   int
      cnt, 
      total = 0;
   int Mins = 0;
   datetime Last_Time = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Magic
         && OrderOpenTime()>=ResetTime)
         {
             if(OrderOpenTime()>Last_Time)
             {
               LastTime = OrderOpenTime();
               int Secs = TimeCurrent()-OrderOpenTime();
               
             }
         }    
      }
   }
   return(Secs);
}

bool subInterrupt()
{
   bool Interrupt = false;
   string Name = "INTERUPT:"+Symbol()+Period()+":"+IsTesting();
   
   int TOTAL = subTotalTrade();
   if(TOTAL>=MaxTrades*0.5)
   {
      if(GlobalVariableGet(Name)<=0)GlobalVariableSet(Name,TimeCurrent());   
     
      if(TimeCurrent()-GlobalVariableGet(Name)<InterruptTradingDays*86400)
      {
         Interrupt = true;
         Comment("Interrupt Triggered. Waiting "+InterruptTradingDays+" Days before trading again");
      }
   }
   return(Interrupt);
}

//------------------- Add winning Trades mod
double subSmallestPL(int Type)
{
   int
      cnt, 
      total = 0;
   double SPL = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()==Type&&OrderSymbol()==Symbol()&&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))) 
         {
            if(OrderType()==OP_BUY)
            {
               double PL = OrderClosePrice()-OrderOpenPrice();
            }
            if(OrderType()==OP_SELL)
            {
               PL = OrderOpenPrice()-OrderClosePrice();
            }
            if(PL<SPL || SPL==0)SPL = PL;
         }
      }
   }
   return(SPL);
}
void subAddWinningTrades(double WinTradePips)
{
   double LOTZ = subTotalOpenTradeLots();
   //Print("subSmallestPL(OP_BUY): "+subSmallestPL(OP_BUY));
   if(subSmallestPL(OP_BUY)>=WinTradePips*MyPoint)
   {
      Print("ADD BUY");
      //OPEN BUY TRADE
      int ticket2 = subOpenOrder(OP_BUY,StopLoss,TakeProfit,LOTZ);
   }
   if(subSmallestPL(OP_SELL)>=WinTradePips*MyPoint)
   {
      
      Print("ADD SELL");
      //OPEN SELL TRADE
      ticket2 = subOpenOrder(OP_SELL,StopLoss,TakeProfit,LOTZ);
   }
}

bool subHedge(double MaxDD, int HedgeMagic)
{
    int
      cnt, 
      total = 0;
   
   bool HEDGED = false;
   
   double Profit = 0;
   double BuyProfit = 0;
   double SellProfit = 0;
   double BuyLots = 0;
   double SellLots = 0;
   int HedgeTotal=0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol())
         {
            if((OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
            {
                Profit = Profit+OrderProfit()+OrderSwap()+OrderCommission();
                if(OrderType()==OP_BUY)
                {
                    BuyProfit = BuyProfit+OrderProfit()+OrderSwap()+OrderCommission();
                    BuyLots = BuyLots+OrderLots();
                }
                if(OrderType()==OP_SELL)
                {
                    SellProfit = SellProfit+OrderProfit()+OrderSwap()+OrderCommission();
                    SellLots = SellLots+OrderLots();
                }
            }
            if(OrderMagicNumber()==HedgeMagic)
            {
               HedgeTotal++;
            }
         }
      }
   }
   double ESL = (AccountBalance()*(MaxDD*0.01))*(-1);
   
   if(Profit<ESL && HedgeTotal<1)
   {
      if(BuyLots>SellLots)
      {
         double HLOTS = BuyLots-SellLots;
         //subOpenOrder
         if(HedgeTotal<1)
         {
            int ticket = subOpenOrderHedge(OP_SELL, 0, 0, HLOTS,HedgeMagic);
            if(ticket>0)HedgeTotal++;
         }
      }
      if(BuyLots<SellLots)
      {
         HLOTS = SellLots-BuyLots;
         //subOpenOrder
         if(HedgeTotal<1)
         {
            ticket = subOpenOrderHedge(OP_BUY, 0, 0, HLOTS,HedgeMagic);
            if(ticket>0)HedgeTotal++;
         }
      }
   }
   if(HedgeTotal>0)HEDGED = true;
   
   return(HEDGED);
}

int subOpenOrderHedge(int type, int stoploss, int takeprofit,double Lotz, int HMagicNumber)
{
   string TicketComment = "HEDGE";
   int
         ticket      = 0,
         err         = 0,
         c           = 0;
         
   double         
         aStopLoss   = 0,
         aTakeProfit = 0,
         bStopLoss   = 0,
         bTakeProfit = 0;

   
   int NumberOfTries = 10;
   if(type==OP_BUY)
   {
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,MyDigits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,MyDigits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,MyDigits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,MyDigits);
         }
         ticket=OrderSend(Symbol(),OP_BUY,Lotz,Ask,Slippage,aStopLoss,aTakeProfit,TicketComment,HMagicNumber,0,Green);
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_SELL)
   {   
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,MyDigits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,MyDigits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,MyDigits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,MyDigits);
         }
         ticket=OrderSend(Symbol(),OP_SELL,Lotz,Bid,Slippage,bStopLoss,bTakeProfit,TicketComment,HMagicNumber,0,Red);
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }  
   return(ticket);
}

bool CheckSkipNextTradeTime()
{
   bool SkipNextTT = false;
   
   int TotalTrades = subTotalTrade();
   
   int FindLatestOpenTimeTT = subFindLatestOpenTimeTT();
   
   if(subTradingTime(UseTradeTime,TradeTime_StartHour_1,TradeTime_StartMinute_1, TradeTime_EndHour_1,TradeTime_EndMinute_1)=="yes")
   {
      if(TotalTrades>0)
      {
         if(FindLatestOpenTimeTT==iTime(Symbol(),0,0) && SkipTT!=iTime(Symbol(),0,0))
         {
            //Print("subFindLatestOpenTimeTT() :"+subFindLatestOpenTimeTT()+", subFindLatestOpenTimeTT() :"+TimeToStr(subFindLatestOpenTimeTT(),TIME_DATE|TIME_MINUTES));
            GlobalVariableSet(SkipTTGV,0);
            SkipTT=iTime(Symbol(),0,0);
            
            Print("1A SkipTT() :"+TimeToStr(SkipTT,TIME_DATE|TIME_MINUTES));
         }
         
         int StartHour1 = TradeTime_StartHour_1; 
         int EndMinute1 = TradeTime_StartMinute_1; 
         if(Hour()==StartHour1 && (Minute()==EndMinute1 || Minute()==(EndMinute1+1)))
         {
            if(GlobalVariableGet(SkipTTGV)==0 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,100);
               SkipTT=iTime(Symbol(),0,0);
               Print("1B-100 SkipTT() :"+TimeToStr(SkipTT,TIME_DATE|TIME_MINUTES));
            }
            if(GlobalVariableGet(SkipTTGV)==100 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,0);
               SkipTT=iTime(Symbol(),0,0);
               Print("1B-0 SkipTT() :"+TimeToStr(SkipTT,TIME_DATE|TIME_MINUTES));
            }
         }
      }
   }
   if(subTradingTime(UseTradeTime,TradeTime_StartHour_2,TradeTime_StartMinute_2, TradeTime_EndHour_2,TradeTime_EndMinute_2)=="yes") 
   {
      if(TotalTrades>0)
      {
         if(FindLatestOpenTimeTT==iTime(Symbol(),0,0) && SkipTT!=iTime(Symbol(),0,0))
         {
            //Print("subFindLatestOpenTimeTT() :"+subFindLatestOpenTimeTT()+", subFindLatestOpenTimeTT() :"+TimeToStr(subFindLatestOpenTimeTT(),TIME_DATE|TIME_MINUTES));
            GlobalVariableSet(SkipTTGV,0);
            SkipTT=iTime(Symbol(),0,0);
            Print("2A SkipTT() :"+TimeToStr(SkipTT,TIME_DATE|TIME_MINUTES));
         }
         
         int StartHour2 = TradeTime_StartHour_2; 
         int EndMinute2 = TradeTime_StartMinute_2; 
         if(Hour()==StartHour2 && (Minute()==EndMinute2 || Minute()==(EndMinute2+1)))
         {
            if(GlobalVariableGet(SkipTTGV)==0 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,100);
               SkipTT=iTime(Symbol(),0,0);
               Print("2B-100 SkipTT() :"+TimeToStr(SkipTT,TIME_DATE|TIME_MINUTES));
            }
            if(GlobalVariableGet(SkipTTGV)==100 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,0);
               SkipTT=iTime(Symbol(),0,0);
               Print("2B-0 SkipTT() :"+TimeToStr(SkipTT,TIME_DATE|TIME_MINUTES));
            }
         }
      }
   }
   if(subTradingTime(UseTradeTime,TradeTime_StartHour_3,TradeTime_StartMinute_3, TradeTime_EndHour_3,TradeTime_EndMinute_3)=="yes") 
   {
      if(TotalTrades>0)
      {
         if(FindLatestOpenTimeTT==iTime(Symbol(),0,0) && SkipTT!=iTime(Symbol(),0,0))
         {
            //Print("subFindLatestOpenTimeTT() :"+subFindLatestOpenTimeTT()+", subFindLatestOpenTimeTT() :"+TimeToStr(subFindLatestOpenTimeTT(),TIME_DATE|TIME_MINUTES));
            GlobalVariableSet(SkipTTGV,0);
            SkipTT=iTime(Symbol(),0,0);
         }
         
         int StartHour3 = TradeTime_StartHour_3; 
         int EndMinute3 = TradeTime_StartMinute_3; 
         if(Hour()==StartHour3 && (Minute()==EndMinute3 || Minute()==(EndMinute3+1)))
         {
            if(GlobalVariableGet(SkipTTGV)==0 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,100);
               SkipTT=iTime(Symbol(),0,0);
            }
            if(GlobalVariableGet(SkipTTGV)==100 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,0);
               SkipTT=iTime(Symbol(),0,0);
            }
         }
      }
   }
   if(subTradingTime(UseTradeTime,TradeTime_StartHour_4,TradeTime_StartMinute_4, TradeTime_EndHour_4,TradeTime_EndMinute_4)=="yes") 
   {
      if(TotalTrades>0)
      {
         if(FindLatestOpenTimeTT==iTime(Symbol(),0,0) && SkipTT!=iTime(Symbol(),0,0))
         {
            //Print("subFindLatestOpenTimeTT() :"+subFindLatestOpenTimeTT()+", subFindLatestOpenTimeTT() :"+TimeToStr(subFindLatestOpenTimeTT(),TIME_DATE|TIME_MINUTES));
            GlobalVariableSet(SkipTTGV,0);
            SkipTT=iTime(Symbol(),0,0);
         }
         
         int StartHour4 = TradeTime_StartHour_4; 
         int EndMinute4 = TradeTime_StartMinute_4; 
         if(Hour()==StartHour4 && (Minute()==EndMinute4 || Minute()==(EndMinute4+1)))
         {
            if(GlobalVariableGet(SkipTTGV)==0 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,100);
               SkipTT=iTime(Symbol(),0,0);
            }
            if(GlobalVariableGet(SkipTTGV)==100 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,0);
               SkipTT=iTime(Symbol(),0,0);
            }
         }
      }
   }
   if(subTradingTime(UseTradeTime,TradeTime_StartHour_5,TradeTime_StartMinute_5, TradeTime_EndHour_5,TradeTime_EndMinute_5)=="yes")
   {
      if(TotalTrades>0)
      {
         if(FindLatestOpenTimeTT==iTime(Symbol(),0,0) && SkipTT!=iTime(Symbol(),0,0))
         {
            //Print("subFindLatestOpenTimeTT() :"+subFindLatestOpenTimeTT()+", subFindLatestOpenTimeTT() :"+TimeToStr(subFindLatestOpenTimeTT(),TIME_DATE|TIME_MINUTES));
            GlobalVariableSet(SkipTTGV,0);
            SkipTT=iTime(Symbol(),0,0);
         }
         
         int StartHour5 = TradeTime_StartHour_5; 
         int EndMinute5 = TradeTime_StartMinute_5; 
         if(Hour()==StartHour5 && (Minute()==EndMinute5 || Minute()==(EndMinute5+1)))
         {
            if(GlobalVariableGet(SkipTTGV)==0 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,100);
               SkipTT=iTime(Symbol(),0,0);
            }
            if(GlobalVariableGet(SkipTTGV)==100 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,0);
               SkipTT=iTime(Symbol(),0,0);
            }
         }
      }
   }
   if(subTradingTime(UseTradeTime,TradeTime_StartHour_6,TradeTime_StartMinute_6, TradeTime_EndHour_6,TradeTime_EndMinute_6)=="yes")
   {
      if(TotalTrades>0)
      {
         if(FindLatestOpenTimeTT==iTime(Symbol(),0,0) && SkipTT!=iTime(Symbol(),0,0))
         {
            //Print("subFindLatestOpenTimeTT() :"+subFindLatestOpenTimeTT()+", subFindLatestOpenTimeTT() :"+TimeToStr(subFindLatestOpenTimeTT(),TIME_DATE|TIME_MINUTES));
            GlobalVariableSet(SkipTTGV,0);
            SkipTT=iTime(Symbol(),0,0);
         }
         
         int StartHour6 = TradeTime_StartHour_6; 
         int EndMinute6 = TradeTime_StartMinute_6; 
         if(Hour()==StartHour6 && (Minute()==EndMinute6 || Minute()==(EndMinute6+1)))
         {
            if(GlobalVariableGet(SkipTTGV)==0 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,100);
               SkipTT=iTime(Symbol(),0,0);
            }
            if(GlobalVariableGet(SkipTTGV)==100 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,0);
               SkipTT=iTime(Symbol(),0,0);
            }
         }
      }
   }
   if(subTradingTime(UseTradeTime,TradeTime_StartHour_7,TradeTime_StartMinute_7, TradeTime_EndHour_7,TradeTime_EndMinute_7)=="yes")
   {
      if(TotalTrades>0)
      {
         if(FindLatestOpenTimeTT==iTime(Symbol(),0,0) && SkipTT!=iTime(Symbol(),0,0))
         {
            //Print("subFindLatestOpenTimeTT() :"+subFindLatestOpenTimeTT()+", subFindLatestOpenTimeTT() :"+TimeToStr(subFindLatestOpenTimeTT(),TIME_DATE|TIME_MINUTES));
            GlobalVariableSet(SkipTTGV,0);
            SkipTT=iTime(Symbol(),0,0);
         }
         
         int StartHour7 = TradeTime_StartHour_7; 
         int EndMinute7 = TradeTime_StartMinute_7; 
         if(Hour()==StartHour7 && (Minute()==EndMinute7 || Minute()==(EndMinute7+1)))
         {
            if(GlobalVariableGet(SkipTTGV)==0 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,100);
               SkipTT=iTime(Symbol(),0,0);
            }
            if(GlobalVariableGet(SkipTTGV)==100 && SkipTT!=iTime(Symbol(),0,0))
            {
               GlobalVariableSet(SkipTTGV,0);
               SkipTT=iTime(Symbol(),0,0);
            }
         }
      }
   }
   
   //---
   
   if(GlobalVariableCheck(SkipTTGV)==true)
   {
      if(TotalTrades<1)GlobalVariableDel(SkipTTGV);
      
      if(GlobalVariableGet(SkipTTGV)==100)
      {
         SkipNextTT = true;
      }
      
      if(GlobalVariableGet(SkipTTGV)==0)SkipNextTT = false;
   }

   if(GlobalVariableCheck(SkipTTGV)==false)SkipNextTT = false;
  
   //---
   
   return(SkipNextTT);
}

// FINDS THE CURRENT OPEN PRICE BY TYPE 
int subFindLatestOpenTimeTT() //USED ON - "Stephen EA v4"
{
   int
      cnt, 
      total = 0;
   double OP = 0;
   datetime OT = 0;
   
   datetime OpenTime = 0;
    
   for(cnt=0;cnt<OrdersTotal();cnt++) 
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()<=OP_SELL &&
            OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
            //(OrderMagicNumber()==DENSE_MagicNumber || OrderMagicNumber()==CALM_MagicNumber ||
            //OrderMagicNumber()==HedgeTradeMagicNumber ||OrderMagicNumber()==Mirror_MagicNumber)) //(OrderType()==OP_BUY || OrderType()==OP_SELL)
            {
               if(OrderOpenTime()>OT)
               {
                  OT = OrderOpenTime();
                  //OP = OrderOpenPrice();
                  int OpenBars = iBarShift(Symbol(),0,OrderOpenTime(),true);
                  OpenTime = iTime(Symbol(),0,OpenBars);
               }
            }
      }
   }
   return(OpenTime); 
}

// OPEN ORDERS (UPDATED v2)
int subOpenOrderCP(int type, double stoploss, double takeprofit,double Lotz, string TradeCom)
{
   int NumberOfTries = 10;
   int
         ticket      = 0,
         err         = 0,
         c           = 0;
         
   double         
         aStopLoss   = 0,
         aTakeProfit = 0,
         bStopLoss   = 0,
         bTakeProfit = 0;

   int    decimalPlaces=0;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<1)decimalPlaces=1;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<0.1)decimalPlaces=2;

   double Lotzs = NormalizeDouble(Lotz,decimalPlaces);   
   if(Lotzs<MarketInfo(Symbol(),MODE_MINLOT)) Lotzs=MarketInfo(Symbol(),MODE_MINLOT);
   if(Lotzs>MarketInfo(Symbol(),MODE_MAXLOT)) Lotzs=MarketInfo(Symbol(),MODE_MAXLOT);   
   
   //string TicketComment =  WindowExpertName()+":ContraryPosition";
   
   if(type==OP_BUY)
   {
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }

         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_BUY,Lotzs,NormalizeDouble(Ask,Digits),Slippage,aStopLoss,aTakeProfit,TradeCom,ContraryPositionMagicNumber,0,Green);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_BUY,Lotz,NormalizeDouble(Ask,Digits),Slippage,0,0,TradeCom,ContraryPositionMagicNumber,0,Green);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss!=0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit!=0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(aStopLoss>0 || aTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red)==false)
                     {
                        bool ModBuy = OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red);
                     }
                  }
               }
            }
         }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));         
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_SELL)
   {   
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }
         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_SELL,Lotzs,NormalizeDouble(Bid,Digits),Slippage,bStopLoss,bTakeProfit,TradeCom,ContraryPositionMagicNumber,0,Red);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_SELL,Lotz,NormalizeDouble(Bid,Digits),Slippage,0,0,TradeCom,ContraryPositionMagicNumber,0,Red);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss!=0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit!=0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(bStopLoss>0 || bTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red)==false)
                     {
                        bool ModSell = OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red);
                     }
                  }
               }   
            }
        }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }  
   return(ticket);
}

// OPEN ORDERS (UPDATED v2)
int subOpenOrderLT(int type, double stoploss, double takeprofit,double Lotz, string TradeCom)
{
   int NumberOfTries = 10;
   int
         ticket      = 0,
         err         = 0,
         c           = 0;
         
   double         
         aStopLoss   = 0,
         aTakeProfit = 0,
         bStopLoss   = 0,
         bTakeProfit = 0;

   int    decimalPlaces=0;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<1)decimalPlaces=1;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<0.1)decimalPlaces=2;

   double Lotzs = NormalizeDouble(Lotz,decimalPlaces);   
   if(Lotzs<MarketInfo(Symbol(),MODE_MINLOT)) Lotzs=MarketInfo(Symbol(),MODE_MINLOT);
   if(Lotzs>MarketInfo(Symbol(),MODE_MAXLOT)) Lotzs=MarketInfo(Symbol(),MODE_MAXLOT);   
   
   //string TicketComment =  WindowExpertName()+":ContraryPosition";
   
   int LTMagicNumber = LureTradeMagicNumber;
   
   if(type==OP_BUY)
   {
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }

         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_BUY,Lotzs,NormalizeDouble(Ask,Digits),Slippage,aStopLoss,aTakeProfit,TradeCom,LTMagicNumber,0,Green);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_BUY,Lotz,NormalizeDouble(Ask,Digits),Slippage,0,0,TradeCom,LTMagicNumber,0,Green);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss!=0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit!=0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(aStopLoss>0 || aTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red)==false)
                     {
                        bool ModBuy = OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red);
                     }
                  }
               }
            }
         }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));         
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_SELL)
   {   
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }
         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_SELL,Lotzs,NormalizeDouble(Bid,Digits),Slippage,bStopLoss,bTakeProfit,TradeCom,LTMagicNumber,0,Red);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_SELL,Lotz,NormalizeDouble(Bid,Digits),Slippage,0,0,TradeCom,LTMagicNumber,0,Red);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss!=0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit!=0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(bStopLoss>0 || bTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red)==false)
                     {
                        bool ModSell = OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red);
                     }
                  }
               }   
            }
        }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }  
   return(ticket);
}

//-------------------------------------------------------------------+
   
void CreateAOPLine(double LinePrice)
{
   string SPTName = (PREF+"AverageOpenPrice");
   
   if(ObjectFind(SPTName)==-1)
   {
      ObjectCreate(SPTName,OBJ_HLINE,0,iTime(Symbol(),0,0),LinePrice,iTime(Symbol(),0,0),LinePrice);
   }
   
   double LastLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
   
   if(ObjectFind(SPTName)!=-1 && LinePrice!=LastLinePrice)
   {
      //Print("AOPLastLinePrice :"+LastLinePrice+", AOPLinePrice :"+LinePrice);
      
      ObjectSet(SPTName, OBJPROP_COLOR, AverageOpenPriceLine_LineColor);
      ObjectSet(SPTName, OBJPROP_PRICE1, LinePrice);
      ObjectSet(SPTName, OBJPROP_WIDTH,AverageOpenPriceLine_LineWidth);
      ObjectSet(SPTName, OBJPROP_STYLE,AverageOpenPriceLine_LineStyle);
      ObjectSet(SPTName, OBJPROP_RAY, false);
      ObjectSet(SPTName, OBJPROP_BACK, false);
      //ObjectSetInteger(0,EntryName,OBJPROP_HIDDEN,true);
   }
}

void CreateSPTLine(double LinePrice)
{
   string SPTName = (PREF+"SoftPipTargetLine");
   
   if(ObjectFind(SPTName)==-1)
   {
      ObjectCreate(SPTName,OBJ_HLINE,0,iTime(Symbol(),0,0),LinePrice,iTime(Symbol(),0,0),LinePrice);
   }
   
   double LastLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
   
   if(ObjectFind(SPTName)!=-1 && LinePrice!=LastLinePrice)
   {
      //Print("LastLinePrice :"+LastLinePrice+", LinePrice :"+LinePrice);
      
      ObjectSet(SPTName, OBJPROP_COLOR, SoftPipTarget_LineColor);
      ObjectSet(SPTName, OBJPROP_PRICE1, LinePrice);
      ObjectSet(SPTName, OBJPROP_WIDTH,SoftPipTarget_LineWidth);
      ObjectSet(SPTName, OBJPROP_STYLE,SoftPipTarget_LineStyle);
      ObjectSet(SPTName, OBJPROP_RAY, false);
      ObjectSet(SPTName, OBJPROP_BACK, false);
      //ObjectSetInteger(0,EntryName,OBJPROP_HIDDEN,true);
   }
}

void CreateMirrorSPTLine(double LinePrice)
{
   string SPTName = (PREF+"MirrorPipTargetLine");
   
   if(ObjectFind(SPTName)==-1)
   {
      ObjectCreate(SPTName,OBJ_HLINE,0,iTime(Symbol(),0,0),LinePrice,iTime(Symbol(),0,0),LinePrice);
   }
   
   double LastLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
   
   if(ObjectFind(SPTName)!=-1 && LinePrice!=LastLinePrice)
   {
      //Print("MirrorLastLinePrice :"+LastLinePrice+", MirrorLinePrice :"+LinePrice);
      
      ObjectSet(SPTName, OBJPROP_COLOR, MirrorTradesTarget_LineColor);
      ObjectSet(SPTName, OBJPROP_PRICE1, LinePrice);
      ObjectSet(SPTName, OBJPROP_WIDTH,MirrorTradesTarget_LineWidth);
      ObjectSet(SPTName, OBJPROP_STYLE,MirrorTradesTarget_LineStyle);
      ObjectSet(SPTName, OBJPROP_RAY, false);
      ObjectSet(SPTName, OBJPROP_BACK, false);
      //ObjectSetInteger(0,EntryName,OBJPROP_HIDDEN,true);
   }
   
   //---
   
   string SPTName2 = (PREF+"MirrorPipTargetName");
   
   if(ObjectFind(SPTName2)==-1)
   {
      ObjectCreate(SPTName2,OBJ_TEXT,0,(TimeCurrent()+(Period()*60*25)),LinePrice);
      ObjectSet(SPTName2, OBJPROP_COLOR, MirrorTradesTarget_LineColor);
      ObjectSet(SPTName2, OBJPROP_WIDTH,MirrorTradesTarget_LineWidth);
      ObjectSet(SPTName2, OBJPROP_STYLE,MirrorTradesTarget_LineStyle);
      ObjectSet(SPTName2, OBJPROP_RAY, false);
      ObjectSet(SPTName2, OBJPROP_BACK, false);
      ObjectSetString(0,SPTName2,OBJPROP_TEXT,"MIRROR"); 
      ObjectSetString(0,SPTName2,OBJPROP_FONT,"Arial");  
      ObjectSetInteger(0,SPTName2,OBJPROP_FONTSIZE,8); 
   }
   
   double LastLinePrice2 = ObjectGetDouble(0,SPTName2,OBJPROP_PRICE);
   
   if(ObjectFind(SPTName2)!=-1 && LinePrice!=LastLinePrice2)
   {
      //Print("MirrorLastNamePrice :"+LastLinePrice2+", MirrorLinePrice :"+LinePrice);
      ObjectSet(SPTName2, OBJPROP_PRICE1, LinePrice);
      //ObjectSetInteger(0,EntryName,OBJPROP_HIDDEN,true);
   }
}

void CreateContrarySPTLine(double LinePrice)
{
   string SPTName = (PREF+"ContraryPipTargetLine");
   
   if(ObjectFind(SPTName)==-1)
   {
      ObjectCreate(SPTName,OBJ_HLINE,0,iTime(Symbol(),0,0),LinePrice,iTime(Symbol(),0,0),LinePrice);
   }
   
   double LastLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
   
   if(ObjectFind(SPTName)!=-1 && LinePrice!=LastLinePrice)
   {
      //Print("ContraryLastLinePrice :"+LastLinePrice+", ContraryLinePrice :"+LinePrice);
      
      ObjectSet(SPTName, OBJPROP_COLOR, ContraryTradesTarget_LineColor);
      ObjectSet(SPTName, OBJPROP_PRICE1, LinePrice);
      ObjectSet(SPTName, OBJPROP_WIDTH,ContraryTradesTarget_LineWidth);
      ObjectSet(SPTName, OBJPROP_STYLE,ContraryTradesTarget_LineStyle);
      ObjectSet(SPTName, OBJPROP_RAY, false);
      ObjectSet(SPTName, OBJPROP_BACK, false);
      //ObjectSetInteger(0,EntryName,OBJPROP_HIDDEN,true);
   }
   
   //---
   
   string SPTName2 = (PREF+"ContraryPipTargetName");
   
   if(ObjectFind(SPTName2)==-1)
   {
      ObjectCreate(SPTName2,OBJ_TEXT,0,(TimeCurrent()+(Period()*60*25)),LinePrice); 
      ObjectSet(SPTName2, OBJPROP_COLOR, ContraryTradesTarget_LineColor);
      //ObjectSet(SPTName2, OBJPROP_PRICE1, LinePrice);
      ObjectSet(SPTName2, OBJPROP_WIDTH,ContraryTradesTarget_LineWidth);
      ObjectSet(SPTName2, OBJPROP_STYLE,ContraryTradesTarget_LineStyle);
      ObjectSet(SPTName2, OBJPROP_RAY, false);
      ObjectSet(SPTName2, OBJPROP_BACK, false);
      ObjectSetString(0,SPTName2,OBJPROP_TEXT,"CONTRARY"); 
      ObjectSetString(0,SPTName2,OBJPROP_FONT,"Arial");  
      ObjectSetInteger(0,SPTName2,OBJPROP_FONTSIZE,8); 
   }
   
   double LastLinePrice2 = ObjectGetDouble(0,SPTName2,OBJPROP_PRICE);
   
   if(ObjectFind(SPTName2)!=-1 && LinePrice!=LastLinePrice2)
   {
      //Print("ContraryLastNamePrice :"+LastLinePrice+", ContraryLinePrice :"+LinePrice);
      ObjectSet(SPTName2, OBJPROP_PRICE1, LinePrice); 
      //ObjectSetInteger(0,EntryName,OBJPROP_HIDDEN,true);
   }
}

void CreateATPBLine(double LinePrice)
{
   string ATPBName = (PREF+"B.AveragePipTakeProfitLine");
   
   if(ObjectFind(ATPBName)==-1)
   {
      ObjectCreate(ATPBName,OBJ_HLINE,0,iTime(Symbol(),0,0),LinePrice,iTime(Symbol(),0,0),LinePrice);
   }
   
   double LastLinePrice = ObjectGetDouble(0,ATPBName,OBJPROP_PRICE);
   
   if(ObjectFind(ATPBName)!=-1 && LinePrice!=LastLinePrice)
   {
      Print("ATPBLastLinePrice :"+LastLinePrice+", ATPBLinePrice :"+LinePrice);
      
      ObjectSet(ATPBName, OBJPROP_COLOR, AveragePipTakeProfitLine_BuyTradeLineColor);
      ObjectSet(ATPBName, OBJPROP_PRICE1, LinePrice);
      ObjectSet(ATPBName, OBJPROP_WIDTH,AveragePipTakeProfitLine_LineWidth);
      ObjectSet(ATPBName, OBJPROP_STYLE,AveragePipTakeProfitLine_LineStyle);
      ObjectSet(ATPBName, OBJPROP_RAY, false);
      ObjectSet(ATPBName, OBJPROP_BACK, false);
      //ObjectSetInteger(0,EntryName,OBJPROP_HIDDEN,true);
   }
}

void CreateATPSLine(double LinePrice)
{
   string ATPSName = (PREF+"S.AveragePipTakeProfitLine");
   
   if(ObjectFind(ATPSName)==-1)
   {
      ObjectCreate(ATPSName,OBJ_HLINE,0,iTime(Symbol(),0,0),LinePrice,iTime(Symbol(),0,0),LinePrice);
   }
   
   double LastLinePrice = ObjectGetDouble(0,ATPSName,OBJPROP_PRICE);
   
   if(ObjectFind(ATPSName)!=-1 && LinePrice!=LastLinePrice)
   {
      //Print("ATPSLastLinePrice :"+LastLinePrice+", ATPSLinePrice :"+LinePrice);
      
      ObjectSet(ATPSName, OBJPROP_COLOR, AveragePipTakeProfitLine_BuyTradeLineColor);
      ObjectSet(ATPSName, OBJPROP_PRICE1, LinePrice);
      ObjectSet(ATPSName, OBJPROP_WIDTH,AveragePipTakeProfitLine_LineWidth);
      ObjectSet(ATPSName, OBJPROP_STYLE,AveragePipTakeProfitLine_LineStyle);
      ObjectSet(ATPSName, OBJPROP_RAY, false);
      ObjectSet(ATPSName, OBJPROP_BACK, false);
      //ObjectSetInteger(0,EntryName,OBJPROP_HIDDEN,true);
   }
}

void DELETE(string NAME)
{
   string SPTName = (PREF+"SoftPipTargetLine");
   if(ObjectFind(SPTName)!=-1)
   {
      ObjectDelete(SPTName);
   }
   
   string SPTName2 = (PREF+"AverageOpenPrice");
   if(ObjectFind(SPTName2)!=-1)
   {
      ObjectDelete(SPTName2);
   }
}
void DELETE3(string NAME)
{
   
   string SPTName3 = (PREF+"MirrorPipTargetLine");
   if(ObjectFind(SPTName3)!=-1)
   {
      ObjectDelete(SPTName3);
   }
   string SPTName3b = (PREF+"MirrorPipTargetName");
   if(ObjectFind(SPTName3b)!=-1)
   {
      ObjectDelete(SPTName3b);
   }
}
void DELETE4(string NAME)
{
   string SPTName4 = (PREF+"ContraryPipTargetLine");
   if(ObjectFind(SPTName4)!=-1)
   {
      ObjectDelete(SPTName4);
   }
   
   string SPTName4b = (PREF+"ContraryPipTargetName");
   if(ObjectFind(SPTName4b)!=-1)
   {
      ObjectDelete(SPTName4b);
   }
}

void DELETE5B()
{
   string SPTName5 = (PREF+"B.AveragePipTakeProfitLine");
   if(ObjectFind(SPTName5)!=-1)
   {
      ObjectDelete(SPTName5);
   }
}
void DELETE5S()
{
   string SPTName5 = (PREF+"S.AveragePipTakeProfitLine");
   if(ObjectFind(SPTName5)!=-1)
   {
      ObjectDelete(SPTName5);
   }
}

double subSoftPipTargetCalSell()
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   
   double STarget = 0;
   if(total>0)
   {
      STarget = (SoftPipTarget/XLots/tickvalue);
      STarget = (STarget*MyPoint);
   }
   Ave = (Ave-STarget);
   
   return(Ave);
}

double subSoftPipTargetCalBuy()
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   
   double STarget = 0;
   if(total>0)
   {
      STarget = (SoftPipTarget/XLots/tickvalue);
      STarget = (STarget*MyPoint);
   }
   Ave = (Ave+STarget);
   
   return(Ave);
}

double subMirrorTargetCalSell()
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   
   double STarget = 0;
   if(total>0)
   {
      STarget = (BrokerTakeProfit/XLots/tickvalue);
      STarget = (STarget*MyPoint);
   }
   Ave = (Ave-STarget);
   
   return(Ave);
}

double subMirrorTargetCalBuy()
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   
   double STarget = 0;
   if(total>0)
   {
      STarget = (BrokerTakeProfit/XLots/tickvalue);
      STarget = (STarget*MyPoint);
   }
   Ave = (Ave+STarget);
   
   return(Ave);
}

double subContraryTargetCalSell()
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==ContraryPositionMagicNumber)
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   
   double STarget = 0;
   if(total>0)
   {
      STarget = (ContraryPositionTP/XLots/tickvalue);
      STarget = (STarget*MyPoint);
   }
   Ave = (Ave-STarget);
   
   return(Ave);
}

double subContraryTargetCalBuy()
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==ContraryPositionMagicNumber)
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   
   double STarget = 0;
   if(total>0)
   {
      STarget = (ContraryPositionTP/XLots/tickvalue);
      STarget = (STarget*MyPoint);
   }
   Ave = (Ave+STarget);
   
   return(Ave);
}


double subAverageOpenPriceCal()
{
 
   int
      cnt, 
      total = 0;
   double XLots = 0;
   double PriceT = 0;
   
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             total++;
             PriceT += OrderOpenPrice() * OrderLots();
             XLots +=OrderLots();
         }    
      }
   }
   double Ave = 0;
   if(total>0 && XLots>0 && PriceT>0)Ave =  NormalizeDouble(PriceT / XLots, Digits);
   
   return(Ave);
}
   
int subLastTradeHitSLCloseMins()
{
    int orders = OrdersHistoryTotal();
    double PL = 0;
    bool SLHit = false;
    
    int CloseMinuteShift = 10000;

      for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
      {
           if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
           if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=MagicNumber) continue;
           //----
           
           if(OrderType()==OP_BUY)
           {
              if(OrderClosePrice()<=OrderStopLoss() && OrderStopLoss()>0)
              {
                 SLHit = true;
                 CloseMinuteShift = iBarShift(Symbol(),PERIOD_M1,OrderCloseTime(),true);
                 break;
              }
           }
           if(OrderType()==OP_SELL)
           {
              if(OrderClosePrice()>=OrderStopLoss() && OrderStopLoss()>0)
              {
                 SLHit = true;
                 CloseMinuteShift = iBarShift(Symbol(),PERIOD_M1,OrderCloseTime(),true);
                 break;
              }
           }
           if(StringFind(OrderComment(),"[sl]",0)!=-1)
           {
              SLHit = true;
              CloseMinuteShift = iBarShift(Symbol(),PERIOD_M1,OrderCloseTime(),true);
              break;
           }
           break;    
      }
   
    return(CloseMinuteShift);
}

int LureTradesOpen(int Type, double LL)
{
   /* 
   LURE TRADES
   SecondsToAddTrades=
   -AddTradesAfterSeconds
   -UseContraryPosition
   -EnableMirrorTrading
   */
   
   int Trades = LureTradesToOpen;
   
   int X = 1;
   int Y = 0;
   while(X<=Trades || Y>Trades*10)
   {
      int ticket = 0;
      if(Type == OP_BUY)
      {
         ticket = subOpenOrderLT(OP_BUY, 0, 0, LL, "LureTrade");
         if(ticket>0)
         {
            X=X+1;
            Print("LureTradeOpen: "+ticket);
         }
      }
      if(Type == OP_SELL)
      {
         ticket = subOpenOrderLT(OP_SELL, 0, 0, LL, "LureTrade");
         if(ticket>0)
         {
            X=X+1;
            Print("LureTradeOpen: "+ticket);
         }
      }
      Y++;
   }
   
   return(Y);
}

// CLOSE TRADE BY TICKET
void subCloseOrderBySeconds(int CloseSeconds) //USED ON - "MA Grid EA v6"
{
   int
         cnt, 
         total       = 0,
        ticket      = 0,
         err         = 0,
         c           = 0;

   RefreshRates();
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {
         if(OrderSymbol() == Symbol() && StringFind(OrderComment(),"LureTrade",0)!=-1 && (TimeCurrent()-OrderOpenTime())>CloseSeconds &&
            (OrderMagicNumber()==LureTradeMagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            Print("LT. Close Order# "+OrderTicket());
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_SELL     :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
            }
         }
      }
   }      
}

int subCloseSequence(int BestCount) //USED ON - "Keiths EA"                 
{ 
   int cnt = 0;
   int BCount = 0;
   
   while(subTotalOpenTradeSequence()>0)
   {
      //CLOSE PROFIT
      int winT = subHighestProfit();
      //int loseT = subLowestProfit();
      if(OrderSelect(winT,SELECT_BY_TICKET)==true)
      {
         bool TradeClose = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
         
         if(TradeClose==true)
         {
            BCount = (BCount+1);
            if(BCount >= BestCount)return(0);
         }
      }
      
      cnt++;
      if(cnt>500)break;
   }
   return(0);
}

int subTotalOpenTradeSequence() //USED ON - "Keiths EA"
{
   
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() &&
            (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))) 
            {
               total++;
               break;
            }
         }
   }
   return(total);
}

int subHighestProfit() ////USED ON - "Keiths EA"
{
   
   int
      cnt, 
      total = 0;
   int ticket = 0;
   double Profit = -1000;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() &&
            (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))) 
            {
               if(OrderProfit()>Profit)
               {      
                  Profit = OrderProfit();
                  ticket = OrderTicket();
               }
            }
      }
   }
   return(ticket);
}

int subSoftPipTarget() //USED ON - "Keiths EA"
{
   int total = 0;

   double PipProfitTotal = subPipProfitTotal();
   
   int BuyTrades = subTotalTypeOrders(OP_BUY);
   int SellTrades = subTotalTypeOrders(OP_SELL);

   if(ShowSoftPipTargetLine==true)
   {
      if(BuyTrades<1 && SellTrades<1)DELETE(PREF);
     
      if(BuyTrades>0 && SellTrades>0)
      {
         if(BuyTrades>SellTrades)
         {
            CreateSPTLine(subSoftPipTargetCalBuy()); 
            
            string SPTName = (PREF+"SoftPipTargetLine");
            double YellowLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
            
            if(Bid>=YellowLinePrice && YellowLinePrice!=0)
            {
               Print("B.UseSoftTarget Close - PipProfitTotal :"+PipProfitTotal+", GlobalVariableGet(PP) :"+GlobalVariableGet(PP));
               subCloseOrder();
               subCloseOrder();
               subCloseOrder();
               subCloseOrder();
               subCloseOrder();
            }
         }
         if(BuyTrades<SellTrades)
         {
            CreateSPTLine(subSoftPipTargetCalSell()); 
            
            SPTName = (PREF+"SoftPipTargetLine");
            YellowLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
            
            if(Ask<=YellowLinePrice && YellowLinePrice!=0)
            {
               Print("S.UseSoftTarget Close - PipProfitTotal :"+PipProfitTotal+", GlobalVariableGet(PP) :"+GlobalVariableGet(PP));
               subCloseOrder();
               subCloseOrder();
               subCloseOrder();
               subCloseOrder();
               subCloseOrder();
            }
         } 
      }  
      if(BuyTrades>0 && SellTrades==0)
      {
         CreateSPTLine(subSoftPipTargetCalBuy()); 
         
         SPTName = (PREF+"SoftPipTargetLine");
         YellowLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
         
         if(Bid>=YellowLinePrice && YellowLinePrice!=0)
         {
            Print("B1.UseSoftTarget Close - PipProfitTotal :"+PipProfitTotal+", GlobalVariableGet(PP) :"+GlobalVariableGet(PP));
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
         }
      }
      if(BuyTrades==0 && SellTrades>0)
      {
         CreateSPTLine(subSoftPipTargetCalSell()); 
         
         SPTName = (PREF+"SoftPipTargetLine");
         YellowLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
         
         if(Ask<=YellowLinePrice && YellowLinePrice!=0)
         {
            Print("S.UseSoftTarget Close - PipProfitTotal :"+PipProfitTotal+", GlobalVariableGet(PP) :"+GlobalVariableGet(PP));
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
            subCloseOrder();
         }
      }
   }
      
   return(total);
}

int RSITPSL()
{
   /*
   RSIPeriod               = 14, 
   LongExitLevel           = 67,
   ShortExitLevel          = 33,
   LongSLLevel             = 50,
   ShortSLLevel            = 50;
   */
   
   double RSI = iRSI(Symbol(),0,RSIPeriod,PRICE_CLOSE,1);
   double RSILast = iRSI(Symbol(),0,RSIPeriod,PRICE_CLOSE,2);
   
   int BuyCount = subTotalTypeOrders(OP_BUY);
   int SellCount = subTotalTypeOrders(OP_SELL);
   
   //RSI TP
   if(BuyCount>0 && RSI>=LongExitLevel && RSILast<LongExitLevel)
   {
      subCloseOrderType(OP_BUY);
      subCloseOrderType(OP_BUY);
      subCloseOrderType(OP_BUY); 
      Print("B.RSI-TP=RSI "+RSI);
   }
   if(SellCount>0 && RSI<=ShortExitLevel && RSILast>ShortExitLevel)
   {
      subCloseOrderType(OP_SELL);
      subCloseOrderType(OP_SELL);
      subCloseOrderType(OP_SELL);
      Print("S.RSI-TP=RSI "+RSI);
   }
   
   //RSI SL
   if(BuyCount>0 && RSI<=LongSLLevel && RSILast>LongSLLevel) 
   {
      subCloseOrderType(OP_BUY);
      subCloseOrderType(OP_BUY);
      subCloseOrderType(OP_BUY); 
      Print("B.RSI-SL=RSI "+RSI);
   }
   if(SellCount>0 && RSI>=ShortSLLevel && RSILast<ShortSLLevel) 
   {
      subCloseOrderType(OP_SELL);
      subCloseOrderType(OP_SELL);
      subCloseOrderType(OP_SELL);
      Print("S.RSI-SL=RSI "+RSI);
   }
   
   //---
   
   return(0);
}

int subMirrorPipTarget() //USED ON - "Keiths EA"
{
   int total = 0;

   double PipProfitTotal = subMirrorPipProfitTotal();
   
   int BuyTrades = subTotalTypeOrdersMirror(OP_BUY);
   int SellTrades = subTotalTypeOrdersMirror(OP_SELL);

   if(MirrorTradesTargetLine==true)
   {
      if(BuyTrades<1 && SellTrades<1)DELETE3(PREF);
      
      if(BuyTrades>0 || SellTrades>0)
      {
         if(BuyTrades>SellTrades)
         {
            CreateMirrorSPTLine(subMirrorTargetCalBuy()); 
            
            string SPTName = (PREF+"MirrorPipTargetLine");
            double YellowLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
            
            if(Bid>=YellowLinePrice && YellowLinePrice!=0)
            {
               Print("B.MirrorTarget Close - PipProfitTotal :"+PipProfitTotal+", GlobalVariableGet(PP) :"+GlobalVariableGet(PP));
               subCloseOrderMirrorTrades();
               subCloseOrderMirrorTrades();
               subCloseOrderMirrorTrades();
            }
         }
         if(BuyTrades<SellTrades)
         {
            CreateMirrorSPTLine(subMirrorTargetCalSell()); 
            
            SPTName = (PREF+"MirrorPipTargetLine");
            YellowLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
            
            if(Ask<=YellowLinePrice && YellowLinePrice!=0)
            {
               Print("S.MirrorTarget Close - PipProfitTotal :"+PipProfitTotal+", GlobalVariableGet(PP) :"+GlobalVariableGet(PP));
               subCloseOrderMirrorTrades();
               subCloseOrderMirrorTrades();
               subCloseOrderMirrorTrades();
            }
         }
      }
   }
      
   return(total);
}

int subContraryPipTarget() //USED ON - "Keiths EA"
{
   int total = 0;

   double PipProfitTotal = subContraryPipProfitTotal();
   
   int BuyTrades = subTotalTypeOrdersContrary(OP_BUY);
   int SellTrades = subTotalTypeOrdersContrary(OP_SELL);

   if(ContraryTradesTargetLine==true)
   {
      if(BuyTrades<1 && SellTrades<1)DELETE4(PREF);
      
      if(BuyTrades>0 || SellTrades>0)
      {
         if(BuyTrades>SellTrades)
         {
            CreateContrarySPTLine(subContraryTargetCalBuy()); 
            
            string SPTName = (PREF+"ContraryPipTargetLine");
            double YellowLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
            
            if(Bid>=YellowLinePrice && YellowLinePrice!=0)
            {
               Print("B.ContraryTarget Close - PipProfitTotal :"+PipProfitTotal+", GlobalVariableGet(PP) :"+GlobalVariableGet(PP));
               subCloseOrderContraryTrades();
               subCloseOrderContraryTrades();
               subCloseOrderContraryTrades();
            }
         }
         if(BuyTrades<SellTrades)
         {
            CreateContrarySPTLine(subContraryTargetCalSell()); 
            
            SPTName = (PREF+"ContraryPipTargetLine");
            YellowLinePrice = ObjectGetDouble(0,SPTName,OBJPROP_PRICE);
            
            if(Ask<=YellowLinePrice && YellowLinePrice!=0)
            {
               Print("S.ContraryTarget Close - PipProfitTotal :"+PipProfitTotal+", GlobalVariableGet(PP) :"+GlobalVariableGet(PP));
               subCloseOrderContraryTrades();
               subCloseOrderContraryTrades();
               subCloseOrderContraryTrades();
            }
         }
      }
   }
      
   return(total);
}
   
void CloseTradesAtEndTradeTime(int MinTradeCount)
{
   if(UseTradeTime == true)
   {
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_1,TradeTime_StartMinute_1,TradeTime_EndHour_1,TradeTime_EndMinute_1)=="no")
      {
         string StartTime_1 = TradeTime_StartHour_1+":"+TradeTime_StartMinute_1;
         string EndTime_1 = TradeTime_EndHour_1+":"+TradeTime_EndMinute_1;
         int TradeCountTime1 = subTotalTradeTT(StartTime_1, EndTime_1);
         if(TradeCountTime1<=MinTradeCount && TradeCountTime1>0)
         {
            CloseTradeUsingTT(StartTime_1, EndTime_1);
            CloseTradeUsingTT2(StartTime_1, EndTime_1);
            //Print("TradeCountTime1 :"+TradeCountTime1);
         }
      }  
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_2,TradeTime_StartMinute_2,TradeTime_EndHour_2,TradeTime_EndMinute_2)=="no")
      {
         string StartTime_2 = TradeTime_StartHour_2+":"+TradeTime_StartMinute_2;
         string EndTime_2 = TradeTime_EndHour_2+":"+TradeTime_EndMinute_2;
         int TradeCountTime2 = subTotalTradeTT(StartTime_2, EndTime_2);
         if(TradeCountTime2<=MinTradeCount && TradeCountTime2>0)
         {
            CloseTradeUsingTT(StartTime_2, EndTime_2);
            CloseTradeUsingTT2(StartTime_2, EndTime_2);
            //Print("TradeCountTime2 :"+TradeCountTime2);
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_3,TradeTime_StartMinute_3,TradeTime_EndHour_3,TradeTime_EndMinute_3)=="no")
      {
         string StartTime_3 = TradeTime_StartHour_3+":"+TradeTime_StartMinute_3;
         string EndTime_3 = TradeTime_EndHour_3+":"+TradeTime_EndMinute_3;
         int TradeCountTime3 = subTotalTradeTT(StartTime_3, EndTime_3);
         if(TradeCountTime3<=MinTradeCount && TradeCountTime3>0)
         {
            CloseTradeUsingTT(StartTime_3, EndTime_3);
            CloseTradeUsingTT2(StartTime_3, EndTime_3);
            //Print("TradeCountTime3 :"+TradeCountTime3);
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_4,TradeTime_StartMinute_4,TradeTime_EndHour_4,TradeTime_EndMinute_4)=="no")
      {
         string StartTime_4 = TradeTime_StartHour_4+":"+TradeTime_StartMinute_4;
         string EndTime_4 = TradeTime_EndHour_4+":"+TradeTime_EndMinute_4;
         int TradeCountTime4 = subTotalTradeTT(StartTime_4, EndTime_4);
         if(TradeCountTime4<=MinTradeCount && TradeCountTime4>0)
         {
            CloseTradeUsingTT(StartTime_4, EndTime_4);
            CloseTradeUsingTT2(StartTime_4, EndTime_4);
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_5,TradeTime_StartMinute_5,TradeTime_EndHour_5,TradeTime_EndMinute_5)=="no")
      {
         string StartTime_5 = TradeTime_StartHour_5+":"+TradeTime_StartMinute_5;
         string EndTime_5 = TradeTime_EndHour_5+":"+TradeTime_EndMinute_5;
         int TradeCountTime5 = subTotalTradeTT(StartTime_5, EndTime_5);
         if(TradeCountTime5<=MinTradeCount && TradeCountTime5>0)
         {
            CloseTradeUsingTT(StartTime_5, EndTime_5);
            CloseTradeUsingTT2(StartTime_5, EndTime_5);
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_6,TradeTime_StartMinute_6,TradeTime_EndHour_6,TradeTime_EndMinute_6)=="no")
      {
         string StartTime_6 = TradeTime_StartHour_6+":"+TradeTime_StartMinute_6;
         string EndTime_6 = TradeTime_EndHour_6+":"+TradeTime_EndMinute_6;
         int TradeCountTime6 = subTotalTradeTT(StartTime_6, EndTime_6);
         if(TradeCountTime6<=MinTradeCount && TradeCountTime6>0)
         {
            CloseTradeUsingTT(StartTime_6, EndTime_6);
            CloseTradeUsingTT2(StartTime_6, EndTime_6);
         }
      }
      if(subTradingTime(UseTradeTime,TradeTime_StartHour_7,TradeTime_StartMinute_7,TradeTime_EndHour_7,TradeTime_EndMinute_7)=="no")
      {
         string StartTime_7 = TradeTime_StartHour_7+":"+TradeTime_StartMinute_7;
         string EndTime_7 = TradeTime_EndHour_7+":"+TradeTime_EndMinute_7;
         int TradeCountTime7 = subTotalTradeTT(StartTime_7, EndTime_7);
         if(TradeCountTime7<=MinTradeCount && TradeCountTime7>0)
         {
            CloseTradeUsingTT(StartTime_7, EndTime_7);
            CloseTradeUsingTT2(StartTime_7, EndTime_7);
         }
      }
      
      //---
   }
}

int CloseTradeUsingTT(string ST, string ET)
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
             datetime Start = StrToTime(ST);
             datetime End = StrToTime(ET);
             
             int ticket = OrderTicket();
             
             if(Start<End)
             {
                if(OrderOpenTime()>=Start && OrderOpenTime()<=End)
                {
                  total++;
                  //subCloseOrderByTicket2(ticket);
                  ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                  Print("CloseTradeUsingTT-OrderTicket():"+ticket);
                }
             }
             if(Start>End)
             {
                if(OrderOpenTime()>=Start && OrderOpenTime()<= StrToTime("23:59"))
                {
                  total++;
                  //subCloseOrderByTicket2(ticket);
                  ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                  Print("CloseTradeUsingTT-OrderTicket():"+ticket);
                }
                if(OrderOpenTime()>= StrToTime("00:00") && OrderOpenTime()<= End)
                {
                  total++;
                  //subCloseOrderByTicket2(ticket);
                  ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                  Print("CloseTradeUsingTT-OrderTicket():"+ticket);
                }
             } 
         }    
      }
   }
   return(total);
}

int CloseTradeUsingTT2(string ST, string ET)
{
   int
      cnt, 
      total = 0;
   OLots = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
             datetime Start = StrToTime(ST);
             datetime End = StrToTime(ET);
             
             int ticket = OrderTicket();
             
             if(Start<End)
             {
                if(OrderOpenTime()>=Start && OrderOpenTime()<=End)
                {
                  total++;
                  //subCloseOrderByTicket2(ticket);
                  ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                  Print("CloseTradeUsingTT-OrderTicket():"+ticket);
                }
             }
             if(Start>End)
             {
                if(OrderOpenTime()>=Start && OrderOpenTime()<= StrToTime("23:59"))
                {
                  total++;
                  //subCloseOrderByTicket2(ticket);
                  ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                  Print("CloseTradeUsingTT-OrderTicket():"+ticket);
                }
                if(OrderOpenTime()>= StrToTime("00:00") && OrderOpenTime()<= End)
                {
                  total++;
                  //subCloseOrderByTicket2(ticket);
                  ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                  Print("CloseTradeUsingTT-OrderTicket():"+ticket);
                }
             } 
         }    
      }
   }
   return(total);
}

// CLOSE TRADE BY TICKET
void subCloseOrderByTicket2(int levelticket) //USED ON - "MA Grid EA v6"
{
   int
         cnt, 
         total       = 0,
        ticket      = 0,
         err         = 0,
         c           = 0;

   RefreshRates();
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {
         if(OrderSymbol() == Symbol() &&
            OrderTicket()==levelticket)
         {
            Print("Close Order# "+OrderTicket());
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_SELL     :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_BUYLIMIT :
               case OP_BUYSTOP  :
               case OP_SELLLIMIT:
               case OP_SELLSTOP :
                  bool Del = OrderDelete(OrderTicket());
            }
         }
      }
   }      
}

void subCloseOrderMirrorTrades()
{
     int
         cnt, 
         total       = 0,
        ticket      = 0,
         err         = 0,
         c           = 0;

   RefreshRates();
   total = OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber()==Mirror_MagicNumber)
         {
            Print("Close Order# "+OrderTicket());
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = 0;
                           
                           total = OrdersTotal();
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              
                              total = OrdersTotal();
                              cnt = 0;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_SELL     :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = 0;
                           total = OrdersTotal();
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = 0;
                              total = OrdersTotal();
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_BUYLIMIT :
               case OP_BUYSTOP  :
               case OP_SELLLIMIT:
               case OP_SELLSTOP :
               {
                  bool Del = OrderDelete(OrderTicket());
                  if(Del==true)
                  {
                     cnt = 0;
                     total = OrdersTotal();
                  }
               }
            }
          }
     } 
   } 
}

void subCloseOrderContraryTrades()
{
     int
         cnt, 
         total       = 0,
        ticket      = 0,
         err         = 0,
         c           = 0;

   RefreshRates();
   total = OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber()==ContraryPositionMagicNumber)
         {
            Print("Close Order# "+OrderTicket());
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = 0;
                           
                           total = OrdersTotal();
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              
                              total = OrdersTotal();
                              cnt = 0;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_SELL     :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = 0;
                           total = OrdersTotal();
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = 0;
                              total = OrdersTotal();
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_BUYLIMIT :
               case OP_BUYSTOP  :
               case OP_SELLLIMIT:
               case OP_SELLSTOP :
               {
                  bool Del = OrderDelete(OrderTicket());
                  if(Del==true)
                  {
                     cnt = 0;
                     total = OrdersTotal();
                  }
               }
            }
          }
     } 
   } 
}
//--------------------------------------------------------------------
/*
int subTotalTrade_HedgePairTrades()
{
   int
      cnt, 
      total = 0;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol() &&
            OrderMagicNumber()==MagicNumber 
            && StringFind(OrderComment(),"HedgePair",0)!=-1) 
            {
               total=total+1;
            }
      }
   }
   return(total);
}
*/
// COUNTS THE TOTAL TRADE
int subTotalTrade_MainTrades()
{
   int
      cnt, 
      total = 0;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol() &&
            (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID))
            && StringFind(OrderComment(),"ALGO V33",0)!=-1) 
            {
               total=total+1;

               CheckHedgePair(OrderTicket(),OrderLots()); 
            }
      }
   }
   return(total);
}

// COUNTS THE TOTAL TRADE PER DAY IN PROFIT
int subTotalTradeHedgePairToday() //USED ON - "BeeTrader EA v3"
{
   int total = 0;

   int orders = OrdersHistoryTotal();

   for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
      if(OrderSymbol()!=Symbol() || OrderType()!=OP_BUY || OrderMagicNumber()!=HedgePairMagicNumber) continue;
      if(OrderCloseTime()>EAStartTime)
      {
         if(iBarShift(Symbol(), PERIOD_D1, OrderOpenTime(),false) == 0)total++;
      }
      if(OrderCloseTime()<=EAStartTime)break;
   }
   return(total);
}

// COUNTS THE TOTAL TRADE
int CheckHedgePair(int ticket, double lotz)
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol() &&
            OrderMagicNumber()==HedgePairMagicNumber && 
            (StringFind(OrderComment(),"HedgePairB-"+ticket,0)!=-1 || StringFind(OrderComment(),"HedgePairS-"+ticket,0)!=-1)) 
            {
               total=total+1;
               return(total);     
            }
      }
   }
   
   int ticketHP = 0;
   
   //if(IsTesting()==true)lotz = (lotz+0.1);
   
   if(total==0)
   {
      ticketHP = subOpenOrderHedgePairs(OP_BUY, 0, 0, lotz, ticket);
      ticketHP = subOpenOrderHedgePairs(OP_SELL, 0, 0, lotz, ticket);
      if(ticketHP>0)return(total);
   }
   
   return(total);
}

// OPEN ORDERS (UPDATED v2)
int subOpenOrderHedgePairs(int type, double stoploss, double takeprofit,double Lotz,int TradeTicket)
{
   int NumberOfTries = 10;
   int
         ticket      = 0,
         err         = 0,
         c           = 0;
         
   double         
         aStopLoss   = 0,
         aTakeProfit = 0,
         bStopLoss   = 0,
         bTakeProfit = 0;

   int    decimalPlaces=0;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<1)decimalPlaces=1;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<0.1)decimalPlaces=2;

   double Lotzs = NormalizeDouble(Lotz,decimalPlaces);   
   if(Lotzs<MarketInfo(Symbol(),MODE_MINLOT)) Lotzs=MarketInfo(Symbol(),MODE_MINLOT);
   if(Lotzs>MarketInfo(Symbol(),MODE_MAXLOT)) Lotzs=MarketInfo(Symbol(),MODE_MAXLOT);   
   
   string BTicketComment = ("HedgePairB-"+TradeTicket);
   string STicketComment = ("HedgePairS-"+TradeTicket);
   
   if(type==OP_BUY)
   {
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }

         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_BUY,Lotzs,NormalizeDouble(Ask,Digits),Slippage,aStopLoss,aTakeProfit,BTicketComment,HedgePairMagicNumber,0,Green);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_BUY,Lotz,NormalizeDouble(Ask,Digits),Slippage,0,0,BTicketComment,HedgePairMagicNumber,0,Green);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss!=0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit!=0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(aStopLoss>0 || aTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red)==false)
                     {
                        bool ModBuy = OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red);
                     }
                  }
               }
            }
         }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));         
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_SELL)
   {   
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }
         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_SELL,Lotzs,NormalizeDouble(Bid,Digits),Slippage,bStopLoss,bTakeProfit,STicketComment,HedgePairMagicNumber,0,Red);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_SELL,Lotz,NormalizeDouble(Bid,Digits),Slippage,0,0,STicketComment,HedgePairMagicNumber,0,Red);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss!=0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit!=0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(bStopLoss>0 || bTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red)==false)
                     {
                        bool ModSell = OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red);
                     }
                  }
               }   
            }
        }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }  
   return(ticket);
}

//-------------------------------------------------------------------+
// COUNTS THE TOTAL TRADE
void subCloseHedgePairTrades(int seconds)
{
   int
      cnt, 
      total = 0;
   
   int secondsX = seconds;
   if(secondsX<60)secondsX = 60;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol()==Symbol() && (OrderType()==OP_SELL||OrderType()==OP_BUY) && 
            OrderMagicNumber()==HedgePairMagicNumber)
            { 
               if(TimeCurrent()-OrderOpenTime()>=secondsX)
               {
                  subCloseOrderByTicketHedgePair(OrderTicket());
               }
            }   
      }
   }
}

// CLOSE TRADE BY TICKET
void subCloseOrderByTicketHedgePair(int levelticket) //USED ON - "MA Grid EA v6"
{
   int
         cnt, 
         total       = 0,
        ticket      = 0,
         err         = 0,
         c           = 0;

   RefreshRates();
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {
         if(OrderSymbol() == Symbol() &&
            OrderMagicNumber()==HedgePairMagicNumber && OrderTicket()==levelticket)
         {
            Print("HedgePair.Close Order# "+OrderTicket());
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_SELL     :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_BUYLIMIT :
               case OP_BUYSTOP  :
               case OP_SELLLIMIT:
               case OP_SELLSTOP :
                  bool Del = OrderDelete(OrderTicket());
            }
         }
      }
   }      
}

// FINDS THE LAST CLOSE PRICE & TYPE
double subClosePrice(int Ticket)
{
    int orders = OrdersHistoryTotal();
    double OT = 0; 
    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderMagicNumber()!=MagicNumber || OrderTicket()!=Ticket) continue;
         //----
            if(OrderTicket()==Ticket)OT = OrderClosePrice();
            break;
    }

    return(OT);
}

// LAST CLOSED PROFIT/LOSS
double subLastTradePL_OpenInstantTrades() 
{
    int orders = OrdersHistoryTotal();
    double PL = 0;
    int ticket = 0;
    int type = -1;
    double lot1 = 0;
    double lot = 0;
    datetime TradeCloseTime = -1;
    int CloseTimeDiff = 0;
    
    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=MagicNumber) continue;
         //----
            PL = OrderProfit(); 
            ticket = OrderTicket();
            type = OrderType();
            lot1 = OrderLots();
            lot=(lot1*InstantTradesLotMultiplier);
            TradeCloseTime = OrderCloseTime();
            CloseTimeDiff = (TimeCurrent()-TradeCloseTime);
            
            //Print("ticket :"+ticket+", CloseTimeDiff :"+CloseTimeDiff+", PL :"+PL);
            if(PL>0 && PL>=OpenInstantTrades_MinimumClosedProfit && CloseTimeDiff<30)
            {
               subOpenInstantTrades(ticket,type,lot);
               //Print("ticket :"+ticket+", CloseTimeDiff :"+CloseTimeDiff+", PL :"+PL);
            }
    }

    return(PL);
}

void subOpenInstantTrades(int ticket,int type,double lot)
{
   string SPTName = (PREF+ticket);
   
   double Lotz = lot;//(lot+0.01);

   if(ticket!=0 && ObjectFind(SPTName)==-1)
   {
      //BUY
      if(type == OP_BUY)
      {
         ticket = subOpenOrderOIT(OP_BUY, 0, 0, Lotz, ticket);
         if(ticket>0)
         {
            Print("OpenInstantTrades-ticket:"+ticket);
            if(ObjectFind(SPTName)==-1)
            {
               ObjectCreate(SPTName,OBJ_HLINE,0,iTime(Symbol(),0,0),0,iTime(Symbol(),0,0),0);
            }
            subCloseOrderByTicketOIT(ticket);
         }
      }
      //SELL
      if(type == OP_SELL)
      {
         ticket = subOpenOrderOIT(OP_SELL, 0, 0, Lotz, ticket);
         if(ticket>0)
         {
            Print("OpenInstantTrades-ticket:"+ticket);
            if(ObjectFind(SPTName)==-1)
            {
               ObjectCreate(SPTName,OBJ_HLINE,0,iTime(Symbol(),0,0),0,iTime(Symbol(),0,0),0);
            }
            subCloseOrderByTicketOIT(ticket);
         }
      }
   }     
}

// OPEN ORDERS (UPDATED v2)
int subOpenOrderOIT(int type, double stoploss, double takeprofit,double Lotz, string TCom)
{
   int NumberOfTries = 10;
   int
         ticket      = 0,
         err         = 0,
         c           = 0;
         
   double         
         aStopLoss   = 0,
         aTakeProfit = 0,
         bStopLoss   = 0,
         bTakeProfit = 0;

   int    decimalPlaces=0;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<1)decimalPlaces=1;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<0.1)decimalPlaces=2;

   double Lotzs = NormalizeDouble(Lotz,decimalPlaces);   
   if(Lotzs<MarketInfo(Symbol(),MODE_MINLOT)) Lotzs=MarketInfo(Symbol(),MODE_MINLOT);
   if(Lotzs>MarketInfo(Symbol(),MODE_MAXLOT)) Lotzs=MarketInfo(Symbol(),MODE_MAXLOT);   
   
   string TradeCom = ("OpenInstantTrades:"+TCom);
   
   if(type==OP_BUY)
   {
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }

         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_BUY,Lotzs,NormalizeDouble(Ask,Digits),Slippage,aStopLoss,aTakeProfit,TradeCom,MagicNumberOIT,0,Green);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_BUY,Lotz,NormalizeDouble(Ask,Digits),Slippage,0,0,TradeCom,MagicNumberOIT,0,Green);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss!=0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit!=0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(aStopLoss>0 || aTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red)==false)
                     {
                        bool ModBuy = OrderModify(ticket,OrderOpenPrice(),aStopLoss,aTakeProfit,0,Red);
                     }
                  }
               }
            }
         }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));         
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }
   if(type==OP_SELL)
   {   
      for(c=0;c<NumberOfTries;c++)
      {
         RefreshRates();
         if(stoploss!=0)
         {
            aStopLoss   = NormalizeDouble(Ask-stoploss*MyPoint,Digits);
            bStopLoss   = NormalizeDouble(Bid+stoploss*MyPoint,Digits);
         }
   
         if(takeprofit!=0)
         {
            aTakeProfit = NormalizeDouble(Ask+takeprofit*MyPoint,Digits);
            bTakeProfit = NormalizeDouble(Bid-takeprofit*MyPoint,Digits);
         }
         if(BrokerIsECN==false)ticket=OrderSend(Symbol(),OP_SELL,Lotzs,NormalizeDouble(Bid,Digits),Slippage,bStopLoss,bTakeProfit,TradeCom,MagicNumberOIT,0,Red);
         if(BrokerIsECN==True)
         {
            ticket=OrderSend(Symbol(),OP_SELL,Lotz,NormalizeDouble(Bid,Digits),Slippage,0,0,TradeCom,MagicNumberOIT,0,Red);
            if(ticket>0)
            {
               if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
               {
                  if(stoploss!=0)
                  {
                     aStopLoss   = NormalizeDouble(OrderOpenPrice()-stoploss*MyPoint,Digits);
                     bStopLoss   = NormalizeDouble(OrderOpenPrice()+stoploss*MyPoint,Digits);
                  }
      
                  if(takeprofit!=0)
                  {
                     aTakeProfit = NormalizeDouble(OrderOpenPrice()+takeprofit*MyPoint,Digits);
                     bTakeProfit = NormalizeDouble(OrderOpenPrice()-takeprofit*MyPoint,Digits);
                  }
                  if(bStopLoss>0 || bTakeProfit>0)
                  {
                     if(OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red)==false)
                     {
                        bool ModSell = OrderModify(ticket,OrderOpenPrice(),bStopLoss,bTakeProfit,0,Red);
                     }
                  }
               }   
            }
        }
         err=GetLastError();
         if(err==0)
         { 
            if(ticket>0) break;
         }
         else
         {
            Print("ERROR "+err+": "+error(err));
            if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
            {
               Sleep(5000);
               continue;
            }
            else //normal error
            {
               if(ticket>0) break;
            }  
         }
      }   
   }  
   return(ticket);
}

//-------------------------------------------------------------------+

// CLOSE TRADE BY TICKET
void subCloseOrderByTicketOIT(int levelticket) //USED ON - "MA Grid EA v6"
{
   int
         cnt, 
         total       = 0,
        ticket      = 0,
         err         = 0,
         c           = 0;

   RefreshRates();
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {

         if(OrderSymbol() == Symbol() &&
            OrderMagicNumber()==MagicNumberOIT && OrderTicket()==levelticket)
         {
            Print("Close Order# "+OrderTicket());
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_SELL     :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
            }
         }
      }
   }      
}

double subTotalOpenLots(int Magic)
{
   int
      cnt, 
      total = 0;
   double AllLots = 0;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Magic)
         {
             total++;
             AllLots = (AllLots+OrderLots());
         }    
      }
   }
   return(AllLots);
}
double subTotalOpenLots2(int Magic)
{
   int
      cnt, 
      total = 0;
   double AllLots = 0;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Magic && OrderComment()==ManualTradeID)
         {
             total++;
             AllLots = (AllLots+OrderLots());
         }    
      }
   }
   return(AllLots);
}
double subTotalLotsClosed(int Magic)
{
    int orders = OrdersHistoryTotal();
    double PL = 0;
    double Lotz = 0;

    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=Magic || OrderCloseTime()<AllLotsTT) continue;
         //----
         //PL = PL+OrderProfit()+OrderCommission();
         Lotz = (Lotz+OrderLots());
    }
    return(Lotz);
}  
double subTotalLotsClosed2(int Magic)
{
    int orders = OrdersHistoryTotal();
    double PL = 0;
    double Lotz = 0;

    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL||OrderMagicNumber()!=Magic || OrderCloseTime()<AllLotsTT || OrderComment()!=ManualTradeID) continue;
         //----
         //PL = PL+OrderProfit()+OrderCommission();
         Lotz = (Lotz+OrderLots());
    }
    return(Lotz);
}  

double subAllLots()
{
   double Lotz1 = 0;
   double Lotz2 = 0;
   double Lotz3 = 0;
   double Lotz4 = 0;
   double Lotz5 = 0;
   double Lotz6 = 0;
   double Lotz7 = 0;
   double LotzX = 0;
   double LotzX2 = 0;
   double LotzX3 = 0;
   
   /*
   DENSE_MagicNumber         = 11111,
   CALM_MagicNumber          = 22222,
   Mirror_MagicNumber = 451496;
   HedgeTradeMagicNumber      = 34491;
   ContraryPositionMagicNumber = 111,
   HedgePairMagicNumber        = 888,
   MagicNumberOIT
   */
   
   double OpenLotz1 = subTotalOpenLots(DENSE_MagicNumber);
   double OpenLotz2 = subTotalOpenLots(CALM_MagicNumber);
   double OpenLotz3 = subTotalOpenLots(Mirror_MagicNumber);
   double OpenLotz4 = subTotalOpenLots(HedgeTradeMagicNumber);
   double OpenLotz5 = subTotalOpenLots(ContraryPositionMagicNumber);
   double OpenLotz6 = subTotalOpenLots(HedgePairMagicNumber);
   double OpenLotz7 = subTotalOpenLots(MagicNumberOIT);
   double OpenLotz8 = subTotalOpenLots2(0);
   
   double ClosedLotz1 = subTotalLotsClosed(DENSE_MagicNumber);
   double ClosedLotz2 = subTotalLotsClosed(CALM_MagicNumber);
   double ClosedLotz3 = subTotalLotsClosed(Mirror_MagicNumber);
   double ClosedLotz4 = subTotalLotsClosed(HedgeTradeMagicNumber);
   double ClosedLotz5 = subTotalLotsClosed(ContraryPositionMagicNumber);
   double ClosedLotz6 = subTotalLotsClosed(HedgePairMagicNumber);
   double ClosedLotz7 = subTotalLotsClosed(MagicNumberOIT);
   double ClosedLotz8 = subTotalLotsClosed2(0);
   
   LotzX = (OpenLotz1+OpenLotz2+OpenLotz3+OpenLotz4+OpenLotz5+OpenLotz6+OpenLotz7+OpenLotz8);
   LotzX2 = (ClosedLotz1+ClosedLotz2+ClosedLotz3+ClosedLotz4+ClosedLotz5+ClosedLotz6+ClosedLotz7+ClosedLotz8);
   LotzX3 = (LotzX+LotzX2);
   
   //Print("LotzX :"+LotzX+", LotzX2 :"+LotzX2+", LotzX3 :"+LotzX3);
   
   return(LotzX3);
}

//-----------------------  INVISIBLE TAKE PROFIT
void subVirtualTPMirror(int VirtualTakeProfit)
{
   int
      cnt, 
      total = 0;
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   double TotalProfit = 0;
   int    decimalPlaces=1;
   if(MarketInfo(Symbol(),MODE_MINLOT)<0.1)decimalPlaces=2;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==Mirror_MagicNumber)
         {
            double PipProfit = (OrderProfit()/OrderLots()/tickvalue);
            
            if(VirtualTakeProfit>0)
            {
               if(PipProfit>=VirtualTakeProfit)
               {
                  bool TradeClose = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Violet);
               }
            }
         }
      }
   }
}

//-----------------------  INVISIBLE TAKE PROFIT
void subVirtualTP(int VirtualTakeProfit)
{
   int
      cnt, 
      total = 0;
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   double TotalProfit = 0;
   int    decimalPlaces=1;
   if(MarketInfo(Symbol(),MODE_MINLOT)<0.1)decimalPlaces=2;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
            OrderSymbol()==Symbol() &&
            (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
            {
               double PipProfit = (OrderProfit()/OrderLots()/tickvalue);
               
               if(VirtualTakeProfit>0)
               {
                  if(PipProfit>=VirtualTakeProfit)
                  {
                     bool TradeClose = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Violet);
                     Print("Trade Closed By V.TakeProfit :"+TakeProfit);
                  }
               }
            }
      }
   }
}

void subVirtualSL(int VirtualSL)
{
   int
      cnt, 
      total = 0;
   double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   if(Digits==3||Digits==5)tickvalue = tickvalue*10;
   
   double TotalProfit = 0;
   int    decimalPlaces=1;
   if(MarketInfo(Symbol(),MODE_MINLOT)<0.1)decimalPlaces=2;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
            OrderSymbol()==Symbol() &&
            (OrderMagicNumber()==MagicNumber || (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
            {
               double PipProfit = (OrderProfit()/OrderLots()/tickvalue);
               
               if(VirtualSL>0)
               {
                  if(PipProfit<=VirtualSL*(-1))
                  {
                     bool TradeClose = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Violet);
                     Print("Trade Closed By V.Stop_Loss :"+Stop_Loss);
                  }
               }
            }
      }
   }
}

void GMTClose()
{
   /*
   DENSE_MagicNumber         = 11111,
   CALM_MagicNumber          = 22222,
   Mirror_MagicNumber = 451496;
   HedgeTradeMagicNumber      = 34491;
   ContraryPositionMagicNumber = 111,
   HedgePairMagicNumber        = 888,
   MagicNumberOIT
   */
   
   subPartialTP(DENSE_MagicNumber,CloseTradesGMTClosePercent);
   subPartialTP(CALM_MagicNumber,CloseTradesGMTClosePercent);
   subPartialTP(Mirror_MagicNumber,CloseTradesGMTClosePercent);
   subPartialTP(HedgeTradeMagicNumber,CloseTradesGMTClosePercent);
   subPartialTP(ContraryPositionMagicNumber,CloseTradesGMTClosePercent);
   subPartialTP(HedgePairMagicNumber,CloseTradesGMTClosePercent);
   subPartialTP(MagicNumberOIT,CloseTradesGMTClosePercent);
   subPartialTP(0,CloseTradesGMTClosePercent);
}

void subPartialTP(int Magic, double ClosePercent) //NEW VERSION
{
   int
      cnt, 
      total = 0;
   int    decimalPlaces=0;
   if(MarketInfo(Symbol(),MODE_MINLOT)<1)decimalPlaces=1;
   if(MarketInfo(Symbol(),MODE_MINLOT)<0.1)decimalPlaces=2;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&
            OrderMagicNumber()==Magic)
         {
            double tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
            if(Digits==5||Digits==3)tickvalue=tickvalue*10;
            double PipProfit = (OrderProfit()/OrderLots()/tickvalue);
            string Com = OrderComment();
            double LOTS = OrderLots();
            //TAKE PROFIT 1
            if(StringFind(Com,"from #",0)==-1)
            {
               double LL = NormalizeDouble(LOTS*(ClosePercent*0.01),decimalPlaces);
               Print("OrderTicket: "+OrderTicket()+", PL= "+LL);
               bool TradeClose = OrderClose(OrderTicket(),LL,OrderClosePrice(),6,Gold);
            }
   
         }
      }
   }
   //return(total);
}

double subDollarProfitTotalAllMagic()//COUNTS THE TOTAL PROFIT IN DOLLAR
{
   int
      cnt, 
      total = 0;
   double Profit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderType()==OP_SELL||OrderType()==OP_BUY)
         {
            if(OrderMagicNumber()==DENSE_MagicNumber||
               OrderMagicNumber()==CALM_MagicNumber||
               OrderMagicNumber()==Mirror_MagicNumber||
               OrderMagicNumber()==HedgeTradeMagicNumber||
               OrderMagicNumber()==ContraryPositionMagicNumber||
               OrderMagicNumber()==HedgePairMagicNumber||
               OrderMagicNumber()==MagicNumberOIT||
               OrderMagicNumber()==0)Profit = Profit+OrderProfit()+OrderCommission()+OrderSwap();
  
         }
      }
   }
   return(Profit);
}

void subCloseOrderAllMagic()
{
   int
         cnt, 
         total       = 0,
         ticket      = 0,
         err         = 0,
         c           = 0;

   int NumberOfTries = 10;
   total = OrdersTotal();
   for(cnt=total-1;cnt>=0;cnt--)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {
         if((OrderMagicNumber()==MagicNumber || 
            OrderMagicNumber()==DENSE_MagicNumber || 
            OrderMagicNumber()==CALM_MagicNumber || 
            OrderMagicNumber()==Mirror_MagicNumber || 
            OrderMagicNumber()==HedgeTradeMagicNumber || 
            OrderMagicNumber()==ContraryPositionMagicNumber || 
            OrderMagicNumber()==HedgePairMagicNumber || 
            OrderMagicNumber()==MagicNumberOIT || 
           (OrderMagicNumber()==0 && OrderComment()==ManualTradeID)))
         {
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0)
                        {
                            cnt = cnt-1;
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0)
                           {
                            cnt = cnt-1;
                            break;
                            }
                        }  
                     }
                  }   
                  continue;
                  
               case OP_SELL     :
                  for(c=0;c<NumberOfTries;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(OrderClosePrice(),Digits),Slippage,Violet);
                     PerDay = iTime(Symbol(),PERIOD_D1,0);
                     err=GetLastError();
                     if(err==0)
                     { 
                         if(ticket>0)
                        {
                            cnt = cnt-1;
                            break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                            if(ticket>0)
                           {
                               cnt = cnt-1;
                               break;
                           }
                        }  
                     }
                  }   
                  continue;
            }
         }
      }
   }      
   ObjectDelete("BUY ENTRY1");
   ObjectDelete("SELL ENTRY1");
}

double subLastLots()
{
    int orders = OrdersHistoryTotal();
    double PL = 0;
    for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
    {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol()||OrderMagicNumber()!=MagicNumber) continue;
         //----
            PL = OrderLots();
            break;
    }

    return(PL);
}

// COUNTS THE TOTAL TRADE PER DAY IN PROFIT
double subStopIncreaseProfit() //USED ON - "BeeTrader EA v3"
{
   int total = 0;
   int orders = OrdersHistoryTotal();
   double PL = 0;
   
   datetime StartTimeX = GlobalVariableGet(StopTradeSizeIncreaseInProfitTTGV);

   for(int i=orders-1;i>=MathFloor(orders*Backtest_percent);i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
      if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL) continue;
      if(OrderCloseTime()>=StartTimeX)
      {
          PL = (PL+OrderProfit());      
      }
      if(OrderCloseTime()<=StartTimeX)break;
   }
   return(PL);
}

//----- FUNCTION DEFINITION      
void subBreakEvenAfterPips(bool Use, int BreakEvenPoint,int PipsProfit)//BREAK EVEN FUNCTION
{
    if(Use==true)
    {
      int total = OrdersTotal();
      for(int cnt=0;cnt<total;cnt++)
      {
         if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
         {
             if(OrderType()<=OP_SELL &&
                  OrderSymbol()==Symbol() &&
                  OrderMagicNumber()==MagicNumber)
           {
              if(OrderType()==OP_BUY)
              {
                 if(((Bid-OrderOpenPrice()) > (MyPoint*BreakEvenPoint))&&(NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(OrderOpenPrice()+(PipsProfit*MyPoint),Digits)))
                        bool ModBuy = OrderModify(
                                      OrderTicket(),
                                      OrderOpenPrice(),
                                      NormalizeDouble(OrderOpenPrice()+(PipsProfit*MyPoint),Digits),
                                      OrderTakeProfit(),
                                      0,
                                      GreenYellow);
              }
              if(OrderType()==OP_SELL)
              {
               if(((OrderOpenPrice()-Ask) > (MyPoint*BreakEvenPoint))&&(NormalizeDouble(OrderStopLoss(),Digits)>NormalizeDouble(OrderOpenPrice()-(PipsProfit*MyPoint),Digits)||OrderStopLoss()==0))
                        bool ModSell= OrderModify(
                                      OrderTicket(),
                                      OrderOpenPrice(),
                                      NormalizeDouble(OrderOpenPrice()-(PipsProfit*MyPoint),Digits),
                                      OrderTakeProfit(),
                                      0,
                                      Red);
              }
           }
        }
     } 
   }  
}


// FINDS THE FIRST ORDER BY TYPE
int subFirstOrderTicket() // USED ON - "MA Grid EA v4"
{
   int
      cnt, 
      total = 0;
   double Price = EMPTY_VALUE;
   int time = TimeCurrent();
   int ticket = EMPTY_VALUE;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&
         OrderMagicNumber()==MagicNumber) 
         
         {
            if(OrderOpenTime()<time)
            {
               ticket = OrderTicket();
               time = OrderOpenTime();
            }
         }
      }
   }
   return(ticket);
}

// CLOSE TRADE BY TICKET
void subCloseOrderByTicket(int levelticket) //USED ON - "MA Grid EA v6"
{
   int
         cnt, 
         total       = 0,
        ticket      = 0,
         err         = 0,
         c           = 0;

   RefreshRates();
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
      {

         if(OrderSymbol() == Symbol() &&
            OrderMagicNumber()==MagicNumber && OrderTicket()==levelticket)
         {
            Print("Close Order# "+OrderTicket());
            switch(OrderType())
            {
               case OP_BUY      :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
                  
               case OP_SELL     :
                  for(c=0;c<9;c++)
                  {
                     RefreshRates();
                     ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),6,Violet);
                     err=GetLastError();
                     if(err==0)
                     { 
                        if(ticket>0) 
                        {
                           cnt = cnt-1;
                           break;
                        }
                     }
                     else
                     {
                        if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                        {
                           Sleep(5000);
                           continue;
                        }
                        else //normal error
                        {
                           if(ticket>0) 
                           {
                              cnt = cnt-1;
                              break;
                           }
                        }  
                     }
                  }   
                  break;
            }
         }
      }
   }      
}

// FINDS THE CURRENT OPEN PRICE BY TYPE 
datetime subFindOpenTime() //USED ON - "Stephen EA v4"
{
   int
      cnt, 
      total = 0;
   double OP = 0;
   datetime OT = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++) 
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber) //(OrderType()==OP_BUY || OrderType()==OP_SELL)
         {
            if(OrderOpenTime()>OT)
            {
               OT = OrderOpenTime();
               OP = OrderOpenPrice();
            }
         }
      }
   }
   return(OT); 
}

// FINDS THE CURRENT OPEN PRICE BY TYPE 
int subFindTradeType() //USED ON - "Stephen EA v4"
{
   int
      cnt, 
      total = 0;
   double OP = 0;
   datetime OT = 0;
   int type = -1;
   
   for(cnt=0;cnt<OrdersTotal();cnt++) 
   {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber) //(OrderType()==OP_BUY || OrderType()==OP_SELL)
         {
            if(OrderOpenTime()>OT)
            {
               OT = OrderOpenTime();
               type = OrderType();
            }
         }
      }
   }
   
   return(type); 
}

