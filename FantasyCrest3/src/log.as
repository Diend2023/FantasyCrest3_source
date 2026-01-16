package
{
   public function log(... res) : void
   {
      var data:String = "";
      for(var i in res)
      {
         data += res[i] + " ";
      }
      trace("[GameCore]",data);
   }
}

