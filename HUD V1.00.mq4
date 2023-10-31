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
double current_drawdown;
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
   if(OrdersTotal()>0)
   {
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
      if(AccountEquity()<AccountBalance()) current_drawdown = ((AccountBalance()-AccountEquity())/AccountBalance())*100;
      if(current_drawdown>highest_unrealized_drawdown)   GlobalVariableSet("HUD", current_drawdown);
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
      if(AccountEquity()<AccountBalance()) current_drawdown = ((AccountBalance()-AccountEquity())/AccountBalance())*100;
      if(current_drawdown>highest_unrealized_drawdown)   GlobalVariableSet("HUD", current_drawdown);
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
   };
   ObjectDelete(0, "HUD");
   ObjectCreate(0, "HUD", OBJ_LABEL, 0, TimeCurrent(), Bid);
   ObjectSetString(0, "HUD", OBJPROP_TEXT, 0, StringConcatenate("HUD: ", highest_unrealized_drawdown, " %"));
   ObjectSetInteger(0, "HUD", OBJPROP_COLOR, clrYellow);
   ObjectSetInteger(0, "HUD", OBJPROP_CORNER, 0);
   ObjectSet("HUD", OBJPROP_FONTSIZE, 15);
   ObjectSet("HUD", OBJPROP_XDISTANCE, 10);
   ObjectSet("HUD", OBJPROP_YDISTANCE, 30);
   
  }
//+------------------------------------------------------------------+};