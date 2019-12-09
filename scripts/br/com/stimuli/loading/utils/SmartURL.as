package br.com.stimuli.loading.utils
{
   public class SmartURL
   {
       
      
      public var rawString:String;
      
      public var protocol:String;
      
      public var port:int;
      
      public var host:String;
      
      public var path:String;
      
      public var queryString:String;
      
      public var queryObject:Object;
      
      public var queryLength:int = 0;
      
      public function SmartURL(param1:String)
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         super();
         this.rawString = param1;
         var _loc2_:RegExp = /((?P<protocol>[a-zA-Z]+: \/\/)   (?P<host>[^:\/]*) (:(?P<port>\d+))?)?  (?P<path>[^?]*)? ((?P<query>.*))? /x;
         var _loc3_:* = _loc2_.exec(param1);
         if(_loc3_)
         {
            this.protocol = !!Boolean(_loc3_.protocol)?_loc3_.protocol:"http://";
            this.protocol = this.protocol.substr(0,this.protocol.indexOf("://"));
            this.host = _loc3_.host || null;
            this.port = !!_loc3_.port?int(int(_loc3_.port)):80;
            this.path = _loc3_.path;
            this.queryString = _loc3_.query;
            if(this.queryString)
            {
               this.queryObject = {};
               this.queryString = this.queryString.substr(1);
               for each(_loc6_ in this.queryString.split("&"))
               {
                  _loc5_ = _loc6_.split("=")[0];
                  _loc4_ = _loc6_.split("=")[1];
                  this.queryObject[_loc5_] = _loc4_;
                  this.queryLength++;
               }
            }
         }
      }
      
      public function toString(... rest) : String
      {
         if(rest.length > 0 && rest[0] == true)
         {
            return "[URL] rawString :" + this.rawString + ", protocol: " + this.protocol + ", port: " + this.port + ", host: " + this.host + ", path: " + this.path + ". queryLength: " + this.queryLength;
         }
         return this.rawString;
      }
   }
}
