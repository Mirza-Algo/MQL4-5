//+------------------------------------------------------------------+
//|                                  Highest Unrealized Drawdown.mq4 |
//|                          Copyright 2023, Muhammad Mubashir Mirza |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza"
#property link      "mirza.mubashir786@hotmail.com"
#property version   "1.00"
#property strict
double highest_unrealized_drawdown = 0.0;
double highest_unrealized_drawdown_p = 0.0;
double current_drawdown;
double current_drawdown_p;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(GlobalVariableGet("HUD", highest_unrealized_drawdown)==false)
   {
      GlobalVariableSet("HUD", 0.0);
   }
   if(GlobalVariableGet("HUD_P", highest_unrealized_drawdown_p)==false)
   {
      GlobalVariableSet("HUD_P", 0.0);
   }
   if(OrdersTotal()>0)
   {
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
      if(CountLosses()!=-1) current_drawdown = CountLosses();
      current_drawdown = NormalizeDouble(current_drawdown, 2);
      if(current_drawdown>highest_unrealized_drawdown)   GlobalVariableSet("HUD", current_drawdown);
      
      highest_unrealized_drawdown_p = GlobalVariableGet("HUD_P");
      if(AccountEquity()<AccountBalance()) current_drawdown_p = ((AccountBalance()-AccountEquity())/AccountBalance())*100;
      current_drawdown_p = NormalizeDouble(current_drawdown_p, 2);
      if(current_drawdown_p>highest_unrealized_drawdown_p)  GlobalVariableSet("HUD_P", current_drawdown_p);
   };
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectDelete(0, "HUD");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(OrdersTotal()>0)
   {
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
      if(CountLosses()!=-1) current_drawdown = CountLosses();
      current_drawdown = NormalizeDouble(current_drawdown, 2);
      if(current_drawdown>highest_unrealized_drawdown)   GlobalVariableSet("HUD", current_drawdown);
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
      
      highest_unrealized_drawdown_p = GlobalVariableGet("HUD_P");
      if(AccountEquity()<AccountBalance())   current_drawdown_p = ((AccountBalance()-AccountEquity())/AccountBalance())*100;
      current_drawdown_p = NormalizeDouble(current_drawdown_p, 2);
      if(current_drawdown_p>highest_unrealized_drawdown_p)  GlobalVariableSet("HUD_P", current_drawdown_p);
      highest_unrealized_drawdown_p = GlobalVariableGet("HUD_P");
      
   };
   ObjectDelete(0, "HUD");
   ObjectCreate(0, "HUD", OBJ_LABEL, 0, TimeCurrent(), Bid);
   ObjectSetString(0, "HUD", OBJPROP_TEXT, 0, StringConcatenate("HUD($):  ", highest_unrealized_drawdown));
   ObjectSetInteger(0, "HUD", OBJPROP_COLOR, clrWhiteSmoke);
   ObjectSetInteger(0, "HUD", OBJPROP_CORNER, 0);
   ObjectSet("HUD", OBJPROP_FONTSIZE, 15);
   ObjectSet("HUD", OBJPROP_XDISTANCE, 10);
   ObjectSet("HUD", OBJPROP_YDISTANCE, 30);
   
   ObjectDelete(0, "HUD_P");
   ObjectCreate(0, "HUD_P", OBJ_LABEL, 0, TimeCurrent(), Bid);
   ObjectSetString(0, "HUD_P", OBJPROP_TEXT, 0, StringConcatenate("HUD(%): ", highest_unrealized_drawdown_p));
   ObjectSetInteger(0, "HUD_P", OBJPROP_COLOR, clrWhiteSmoke);
   ObjectSetInteger(0, "HUD_P", OBJPROP_CORNER, 0);
   ObjectSet("HUD_P", OBJPROP_FONTSIZE, 15);
   ObjectSet("HUD_P", OBJPROP_XDISTANCE, 10);
   ObjectSet("HUD_P", OBJPROP_YDISTANCE, 55);

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Counting Losses                                                  |
//+------------------------------------------------------------------+
double CountLosses()
{
   double return_value = 0.0;
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      bool selected = OrderSelect(i, SELECT_BY_POS);
      return_value = return_value + OrderProfit();
   };
   if(return_value>0)   return(-1);
   else return(MathAbs(return_value));
};