//+------------------------------------------------------------------+
//|                                          Trending or Ranging MOD |
//|                                                     ToR_1.02.mq4 |
//|                                       Copyright © 2007 Tom Balfe |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2021 Gamakiv"
#property link      "https://t.me/gamakiv"
#property description "Показывает значение и направлениеADX на H1, H4, D1"
#property indicator_separate_window

int spread;
//---- user selectable stuff
extern int  SpreadThreshold=6;
extern bool Show_D1_ADX=true;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   //---- indicator short name
   IndicatorShortName("ToR 1.02 ("+Symbol()+")");

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   //---- need to delete objects should user remove indicator
   ObjectsDeleteAll(0,OBJ_LABEL);
     ObjectDelete("ToR102-1");ObjectDelete("ToR102-2");ObjectDelete("ToR102-3");
     ObjectDelete("ToR102-4");ObjectDelete("ToR102-5");ObjectDelete("ToR102-6");
     ObjectDelete("ToR102-7");ObjectDelete("ToR102-8");ObjectDelete("ToR102-9");
     ObjectDelete("ToR102-10");ObjectDelete("ToR102-11");ObjectDelete("ToR102-12");
     ObjectDelete("ToR102-4a");ObjectDelete("ToR102-6a");ObjectDelete("ToR102-8a");
     ObjectDelete("ToR102-10a");ObjectDelete("ToR102-12a");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   //---- let's define some stuff 
   // M5 data
   double adx_m5 = iADX(NULL,5,14,PRICE_CLOSE,0,0);
   double di_p_m5 = iADX(NULL,5,14,PRICE_CLOSE,1,0);
   double di_m_m5 = iADX(NULL,5,14,PRICE_CLOSE,2,0);
   // M15 data
   double adx_m15 = iADX(NULL,15,14,PRICE_CLOSE,0,0); 
   double di_p_m15 = iADX(NULL,15,14,PRICE_CLOSE,1,0);
   double di_m_m15 = iADX(NULL,15,14,PRICE_CLOSE,2,0);
   // H1 data
   double adx_h1 = iADX(NULL,60,14,PRICE_CLOSE,0,0);
   double di_p_h1 = iADX(NULL,60,14,PRICE_CLOSE,1,0);
   double di_m_h1 = iADX(NULL,60,14,PRICE_CLOSE,2,0);
   // H4 data
   double adx_h4 = iADX(NULL,240,14,PRICE_CLOSE,0,0);
   double di_p_h4 = iADX(NULL,240,14,PRICE_CLOSE,1,0);
   double di_m_h4 = iADX(NULL,240,14,PRICE_CLOSE,2,0);
   // D1 data
   double adx_d1 = iADX(NULL,1440,14,PRICE_CLOSE,0,0);
   double di_p_d1 = iADX(NULL,1440,14,PRICE_CLOSE,1,0);
   double di_m_d1 = iADX(NULL,1440,14,PRICE_CLOSE,2,0);
   
   //---- define colors and arrows 
   color adx_color_m5,adx_color_m15,adx_color_h1,adx_color_h4,adx_color_d1;
   
   string  adx_arrow_m5,adx_arrow_m15,adx_arrow_h1,adx_arrow_h4,adx_arrow_d1;
      
   //---- assign color
   // M5 colors
   if ((adx_m5 < 23) && (adx_m5 != 0)) { adx_color_m5 = LightSkyBlue; }
   if ((adx_m5 >=23) && (di_p_m5 > di_m_m5)) { adx_color_m5 = Lime; }
   if ((adx_m5 >=23) && (di_p_m5 < di_m_m5)) { adx_color_m5 = Red; }
      
   // M15 colors
   if ((adx_m15 < 23) && (adx_m15 != 0)) { adx_color_m15 = LightSkyBlue; }
   if ((adx_m15 >=23) && (di_p_m15 > di_m_m15)) { adx_color_m15 = Lime; }
   if ((adx_m15 >=23) && (di_p_m15 < di_m_m15)) { adx_color_m15 = Red; }
   
   // H1 colors
   if ((adx_h1 < 23) && (adx_h1 != 0)) { adx_color_h1 = LightSkyBlue; }
   if ((adx_h1 >=23) && (di_p_h1 > di_m_h1)) { adx_color_h1 = Lime; }
   if ((adx_h1 >=23) && (di_p_h1 < di_m_h1)) { adx_color_h1 = Red; }
   
   // H4 colors
   if ((adx_h4 < 23) && (adx_h4 != 0)) { adx_color_h4 = LightSkyBlue; }
   if ((adx_h4 >=23) && (di_p_h4 > di_m_h4)) { adx_color_h4 = Lime; }
   if ((adx_h4 >=23) && (di_p_h4 < di_m_h4)) { adx_color_h4 = Red; }
   
   // D1 colors 
   if ((adx_d1 < 23) && (adx_d1 != 0)) { adx_color_d1 = LightSkyBlue; }
   if ((adx_d1 >=23) && (di_p_d1 > di_m_d1)) { adx_color_d1 = Lime; }
   if ((adx_d1 >=23) && (di_p_d1 < di_m_d1)) { adx_color_d1 = Red; }
   
   //---- feed all the ADX values into strings      
   string adx_value_m5 = adx_m5;
   string adx_value_m15 = adx_m15;
   string adx_value_h1 = adx_h1;
   string adx_value_h4 = adx_h4;
   string adx_value_d1 = adx_d1;
   
   //---- assign arrows strong up: { adx_arrow_ = "й"; } strong down: { adx_arrow_ = "к"; }
   //                   up: { adx_arrow_ = "м"; } down: { adx_arrow_ = "о"; }
   //                   range: { adx_arrow_ = "h"; }
   //                   use wingdings for these, the h is squiggly line
   
   // M5 arrows
   if (adx_m5 < 23 && adx_m5 != 0) { adx_arrow_m5 = "h"; }
   if ((adx_m5 >= 23 && adx_m5 < 28) && (di_p_m5 > di_m_m5)) { adx_arrow_m5 = "м"; }
   if ((adx_m5 >= 23 && adx_m5 < 28) && (di_p_m5 < di_m_m5)) { adx_arrow_m5 = "о"; }
   if ((adx_m5 >=28) && (di_p_m5 > di_m_m5)) { adx_arrow_m5 = "й"; }
   if ((adx_m5 >=28) && (di_p_m5 < di_m_m5)) { adx_arrow_m5 = "к"; }
   
   // M15 arrows
   if (adx_m15 < 23 && adx_m15 != 0) { adx_arrow_m15 = "h"; }
   if ((adx_m15 >= 23 && adx_m15 < 28) && (di_p_m15 > di_m_m15)) { adx_arrow_m15 = "м"; }
   if ((adx_m15 >= 23 && adx_m15 < 28) && (di_p_m15 < di_m_m15)) { adx_arrow_m15 = "о"; }
   if ((adx_m15 >=28) && (di_p_m15 > di_m_m15)) { adx_arrow_m15 = "й"; }
   if ((adx_m15 >=28) && (di_p_m15 < di_m_m15)) { adx_arrow_m15 = "к"; }
   
   // H1 arrows
   if (adx_h1 < 23 && adx_h1 != 0) { adx_arrow_h1 = "h"; }
   if ((adx_h1 >= 23 && adx_h1 < 28) && (di_p_h1 > di_m_h1)) { adx_arrow_h1 = "м"; }
   if ((adx_h1 >= 23 && adx_h1 < 28) && (di_p_h1 < di_m_h1)) { adx_arrow_h1 = "о"; }
   if ((adx_h1 >=28) && (di_p_h1 > di_m_h1)) { adx_arrow_h1 = "й"; }
   if ((adx_h1 >=28) && (di_p_h1 < di_m_h1)) { adx_arrow_h1 = "к"; }
   
   // H4 arrows
   if (adx_h4 < 23 && adx_h4 != 0) { adx_arrow_h4 = "h"; }
   if ((adx_h4 >= 23 && adx_h4 < 28) && (di_p_h4 > di_m_h4)) { adx_arrow_h4 = "м"; }
   if ((adx_h4 >= 23 && adx_h4 < 28) && (di_p_h4 < di_m_h4)) { adx_arrow_h4 = "о"; }
   if ((adx_h4 >=28) && (di_p_h4 > di_m_h4)) { adx_arrow_h4 = "й"; }
   if ((adx_h4 >=28) && (di_p_h4 < di_m_h4)) { adx_arrow_h4 = "к"; }
   
   // D1 arrows
   if (adx_d1 < 23 && adx_d1 != 0) { adx_arrow_d1 = "h"; }
   if ((adx_d1 >= 23 && adx_d1 < 28) && (di_p_d1 > di_m_d1)) { adx_arrow_d1 = "м"; }
   if ((adx_d1 >= 23 && adx_d1 < 28) && (di_p_d1 < di_m_d1)) { adx_arrow_d1 = "о"; }
   if ((adx_d1 >=28) && (di_p_d1 > di_m_d1)) { adx_arrow_d1 = "й"; }
   if ((adx_d1 >=28) && (di_p_d1 < di_m_d1)) { adx_arrow_d1 = "к"; }
   
   //---- defines what spread is 
   spread=MarketInfo(Symbol(),MODE_SPREAD);
        
   //----====>>>> create text "1 Hr: "
   ObjectCreate("ToR102-7",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-7","H1:", 10, "Courier New", LightSteelBlue);
     ObjectSet("ToR102-7", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-7", OBJPROP_XDISTANCE, 110);
     ObjectSet("ToR102-7", OBJPROP_YDISTANCE, 2);
 
   //---- create 1 hour value
   ObjectCreate("ToR102-8",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-8", " ADX "+StringSubstr(adx_value_h1,0,5)+" ",9, "Courier New",adx_color_h1);
     ObjectSet("ToR102-8", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-8", OBJPROP_XDISTANCE, 130);
     ObjectSet("ToR102-8", OBJPROP_YDISTANCE, 2);
 
   //---- create 1 hour arrow, squiggle if ranging
   ObjectCreate("ToR102-8a",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-8a",adx_arrow_h1,9, "Wingdings",adx_color_h1);
     ObjectSet("ToR102-8a", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-8a", OBJPROP_XDISTANCE, 205);
     ObjectSet("ToR102-8a", OBJPROP_YDISTANCE, 3); 




   //----====>>>> create text "4 Hr: "
   ObjectCreate("ToR102-9",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-9","H4:", 10, "Courier New", LightSteelBlue);
     ObjectSet("ToR102-9", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-9", OBJPROP_XDISTANCE, 250);
     ObjectSet("ToR102-9", OBJPROP_YDISTANCE, 2);
   //---- create 4 hour value
   ObjectCreate("ToR102-10",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-10", " ADX "+StringSubstr(adx_value_h4,0,5)+" ",9, "Courier New",adx_color_h4);
     ObjectSet("ToR102-10", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-10", OBJPROP_XDISTANCE, 275);
     ObjectSet("ToR102-10", OBJPROP_YDISTANCE, 2);
   //---- create 1 hour arrow, squiggle if ranging
   ObjectCreate("ToR102-10a",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-10a",adx_arrow_h4,9, "Wingdings",adx_color_h4);
     ObjectSet("ToR102-10a", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-10a", OBJPROP_XDISTANCE, 350);
     ObjectSet("ToR102-10a", OBJPROP_YDISTANCE, 3); 
      
   if (Show_D1_ADX==true)
   {
   //----====>>>> create text "1 Day: "
   ObjectCreate("ToR102-11",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-11","D1:", 10, "Courier New", LightSteelBlue);
     ObjectSet("ToR102-11", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-11", OBJPROP_XDISTANCE, 390);
     ObjectSet("ToR102-11", OBJPROP_YDISTANCE, 2);
   //---- create 15 min value
   ObjectCreate("ToR102-12",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-12", " ADX "+StringSubstr(adx_value_d1,0,5)+" ",9, "Courier New",adx_color_d1);
     ObjectSet("ToR102-12", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-12", OBJPROP_XDISTANCE, 415);
     ObjectSet("ToR102-12", OBJPROP_YDISTANCE, 2);
   ObjectCreate("ToR102-12a",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-12a",adx_arrow_d1,9, "Wingdings",adx_color_d1);
     ObjectSet("ToR102-12a", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-12a", OBJPROP_XDISTANCE, 495);
     ObjectSet("ToR102-12a", OBJPROP_YDISTANCE, 4);
   }


//----
   return(0);
  }
//+------------------------------------------------------------------+