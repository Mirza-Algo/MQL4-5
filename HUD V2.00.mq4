//+------------------------------------------------------------------+
//|                                  Highest Unrealized Drawdown.mq4 |
//|                          Copyright 2023, Muhammad Mubashir Mirza |
//|                                    mirza.mubashir786@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Muhammad Mubashir Mirza"
#property link      "mirza.mubashir786@hotmail.com"
#property version   "2.00"
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
  // Alert("Run this EA with a single EA running in the Account!");
   if(GlobalVariableGet("HUD", highest_unrealized_drawdown)==false)
   {
      GlobalVariableSet("HUD", 0.0);
   }
   if(GlobalVariableGet("HUD_P", highest_unrealized_drawdown_p)==false)
   {
      GlobalVariableSet("HUD_P", 0.0);
   }
//---Call Main Function---
Main();
//---Create Dashboard---
CreateDash();
//----------------------
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectDelete(0, "HUD");
   ObjectsDeleteAll();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//------Call Main Function---
Main();
//------Update Dashboard-----
UpdateDash();
  }
//+------------------------------------------------------------------+
//| Create Dashboard                                                 |
//+------------------------------------------------------------------+

void CreateDash()
{
//-----------Box-----------------------------------------------
   ObjectCreate(0, "box", OBJ_RECTANGLE_LABEL, 0, TimeCurrent(), Bid);
   ObjectSetInteger(0, "box", OBJPROP_XSIZE, 180);
   ObjectSetInteger(0, "box", OBJPROP_YSIZE, 100);
   ObjectSetInteger(0, "box", OBJPROP_XDISTANCE, 7);
   ObjectSetInteger(0, "box", OBJPROP_YDISTANCE, 20);     
   ObjectSetInteger(0, "box", OBJPROP_BGCOLOR, clrBlack);
   ObjectSetInteger(0, "box", OBJPROP_BACK, false);
   ObjectSetInteger(0, "box", OBJPROP_BORDER_COLOR, clrYellow);
   ObjectSetInteger(0, "box", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "box", OBJPROP_SELECTED, false);
   ObjectSetInteger(0, "box", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, "box", OBJPROP_BORDER_TYPE, BORDER_SUNKEN);
   ObjectSetInteger(0, "box", OBJPROP_BORDER_COLOR, clrGreen);
   //---Label---
   ObjectDelete(0, "Label");
   ObjectCreate(0, "Label", OBJ_LABEL, 0, TimeCurrent(), Bid);
   ObjectSetInteger(0, "Label", OBJPROP_COLOR, clrYellow);
   ObjectSetString(0, "Label", OBJPROP_TEXT, 0, "       <HUD EA>");
   ObjectSetInteger(0, "Label", OBJPROP_CORNER, 0);
   ObjectSet("Label", OBJPROP_FONTSIZE, 15);
   ObjectSet("Label", OBJPROP_COLOR, clrGold);
   ObjectSet("Label", OBJPROP_XDISTANCE, 7.5);
   ObjectSet("Label", OBJPROP_YDISTANCE, 30);
   //---------------HUD---------------------------------------
   ObjectDelete(0, "HUD");
   ObjectCreate(0, "HUD", OBJ_LABEL, 0, TimeCurrent(), Bid);
   ObjectSetString(0, "HUD", OBJPROP_TEXT, 0, StringConcatenate("HUD(D): ", highest_unrealized_drawdown));
   ObjectSetInteger(0, "HUD", OBJPROP_COLOR, clrGold);
   ObjectSetInteger(0, "HUD", OBJPROP_CORNER, 0);
   ObjectSet("HUD", OBJPROP_FONTSIZE, 15);
   ObjectSet("HUD", OBJPROP_XDISTANCE, 10);
   ObjectSet("HUD", OBJPROP_YDISTANCE, 55);
   //------------HUD Percentage---------------------------------------
   ObjectDelete(0, "HUD_P");
   ObjectCreate(0, "HUD_P", OBJ_LABEL, 0, TimeCurrent(), Bid);
   ObjectSetString(0, "HUD_P", OBJPROP_TEXT, 0, StringConcatenate("HUD(P): ", highest_unrealized_drawdown_p));
   ObjectSetInteger(0, "HUD_P", OBJPROP_COLOR, clrGold);
   ObjectSetInteger(0, "HUD_P", OBJPROP_CORNER, 0);
   ObjectSet("HUD_P", OBJPROP_FONTSIZE, 15);
   ObjectSet("HUD_P", OBJPROP_XDISTANCE, 10);
   ObjectSet("HUD_P", OBJPROP_YDISTANCE, 80);
};
//+------------------------------------------------------------------+
//| Update Dashboard                                                 |
//+------------------------------------------------------------------+
void UpdateDash()
{
   highest_unrealized_drawdown =   NormalizeDouble(highest_unrealized_drawdown, 2);
   highest_unrealized_drawdown_p = NormalizeDouble(highest_unrealized_drawdown_p, 2);
   ObjectSetString(0, "HUD", OBJPROP_TEXT, 0, StringConcatenate("HUD($):  ", highest_unrealized_drawdown));
   ObjectSetString(0, "HUD_P", OBJPROP_TEXT, 0, StringConcatenate("HUD(%): ", highest_unrealized_drawdown_p));
};
//+------------------------------------------------------------------+
//| Main Function                                                    |
//+------------------------------------------------------------------+
void Main()
{
if(OrdersTotal()>0)
   {
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
      if(AccountEquity()<AccountBalance()) current_drawdown = AccountBalance()-AccountEquity();
      current_drawdown = NormalizeDouble(current_drawdown, 2);
      if(current_drawdown>highest_unrealized_drawdown)   GlobalVariableSet("HUD", current_drawdown);
      highest_unrealized_drawdown = GlobalVariableGet("HUD");
      
      highest_unrealized_drawdown_p = GlobalVariableGet("HUD_P");
      if(AccountEquity()<AccountBalance())   current_drawdown_p = ((AccountBalance()-AccountEquity())/AccountBalance())*100;
      current_drawdown_p = NormalizeDouble(current_drawdown_p, 2);
      if(current_drawdown_p>highest_unrealized_drawdown_p)  GlobalVariableSet("HUD_P", current_drawdown_p);
      highest_unrealized_drawdown_p = GlobalVariableGet("HUD_P");
      
   };
};