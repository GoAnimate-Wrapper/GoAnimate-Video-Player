package anifire.player.playback
{
   import anifire.util.UtilHashArray;
   import anifire.util.UtilPlain;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class PlayerConstant
   {
      
      public static const CHAR_XML_FILENAME:String = "desc.xml";
      
      public static const FILM_XML_FILENAME:String = "movie.xml";
      
      public static const MOVIE_ZIP_FONT_INFO:String = "custom_font.json";
      
      public static const GET_MOVIE_ACTION:String = "film1.zip";
      
      public static const PARAM_GET_MOVIE:String = "getMovie";
      
      public static const TON_CREDITS:String = "0Rez3tK32Dho";
      
      public static const MAX_NUM_TO_CACHE_BITMAP:int = 10;
      
      public static const BLEED_MARGIN:int = 1;
       
      
      public function PlayerConstant()
      {
         super();
      }
      
      public static function stopFamily(param1:DisplayObject) : void
      {
         var iObj:DisplayObject = param1;
         var treatment:Function = function(param1:DisplayObject):void
         {
            var _loc2_:MovieClip = null;
            if(param1 is MovieClip)
            {
               _loc2_ = MovieClip(param1);
               _loc2_.stop();
            }
         };
         UtilPlain.transverseFamily(iObj,treatment);
      }
      
      public static function playFamily(param1:DisplayObject) : void
      {
         var iObj:DisplayObject = param1;
         var treatment:Function = function(param1:DisplayObject):void
         {
            var _loc2_:MovieClip = null;
            if(param1 is MovieClip)
            {
               _loc2_ = MovieClip(param1);
               _loc2_.play();
            }
         };
         UtilPlain.transverseFamily(iObj,treatment,UtilPlain.PARTS_NOT_CONTROL_BY_PLAYER);
      }
      
      public static function goToAndStopFamilyAt1(param1:DisplayObject) : void
      {
         var iObj:DisplayObject = param1;
         var treatment:Function = function(param1:DisplayObject):void
         {
            var _loc2_:MovieClip = null;
            if(param1 is MovieClip)
            {
               _loc2_ = MovieClip(param1);
               _loc2_.gotoAndStop(1);
            }
         };
         UtilPlain.transverseFamily(iObj,treatment);
      }
      
      private static function nextFrameFamily(param1:DisplayObject) : void
      {
         var iObj:DisplayObject = param1;
         var treatment:Function = function(param1:DisplayObject):void
         {
            var _loc2_:MovieClip = null;
            if(param1 is MovieClip)
            {
               _loc2_ = MovieClip(param1);
               if(_loc2_.currentFrame >= _loc2_.totalFrames)
               {
                  _loc2_.gotoAndStop(1);
               }
               else
               {
                  _loc2_.nextFrame();
               }
            }
         };
         UtilPlain.transverseFamily(iObj,treatment);
      }
      
      public static function goToAndStopFamily(param1:DisplayObject, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         PlayerConstant.goToAndStopFamilyAt1(param1);
         _loc4_ = param2 - 1;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            PlayerConstant.nextFrameFamily(param1);
            _loc3_++;
         }
      }
      
      private static function goToAndPlayFamily(param1:DisplayObject, param2:Number) : void
      {
         PlayerConstant.goToAndStopFamily(param1,param2);
         PlayerConstant.playFamily(param1);
      }
      
      public static function getBehaviourXMLfromThemeXML(param1:String, param2:String, param3:UtilHashArray) : XML
      {
         var resultXML:XML = null;
         var charNode:XML = null;
         var behaviourFileName:String = param1;
         var behaviourNodeName:String = param2;
         var themeXMLs:UtilHashArray = param3;
         var themeID:String = behaviourFileName.split(".")[0];
         var charID:String = behaviourFileName.split(".")[2];
         var behaviourID:String = behaviourFileName.split(".")[3] + "." + behaviourFileName.split(".")[4];
         var themeXML:XML = themeXMLs.getValueByKey(themeID) as XML;
         if(themeXML == null)
         {
            return null;
         }
         try
         {
            charNode = XMLList(themeXML.char.(@id == charID))[0];
            if(behaviourNodeName == "action")
            {
               resultXML = XMLList(charNode..action.(@id == behaviourID))[0];
               if(resultXML == null)
               {
                  resultXML = XMLList(charNode..motion.(@id == behaviourID))[0];
               }
            }
            else if(behaviourNodeName == "motion")
            {
               resultXML = XMLList(_loc5_)[0];
            }
         }
         catch(e:Error)
         {
            return null;
         }
         if(resultXML == null)
         {
            return null;
         }
         return resultXML;
      }
   }
}
