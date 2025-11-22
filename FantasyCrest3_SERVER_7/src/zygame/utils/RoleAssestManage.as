package zygame.utils
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import starling.utils.AssetManager;
   import starling.utils.EncodeAssets;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.display.BaseRole;
   import zygame.display.DragonRole;
   import zygame.display.SpriteRole;
   
   public class RoleAssestManage
   {
      
      public static var IS_ATF_EFFECT:Boolean = false;
      
      private var _assets:AssetManager;
      
      private var _back:Function;
      
      private var _roleList:Array;
      
      private var _xmlRoleData:Dictionary;
      
      private var _assetsReference:Dictionary;
      
      public function RoleAssestManage(assets:AssetManager)
      {
         super();
         _assets = assets;
         _roleList = [];
         _assetsReference = new Dictionary();
         _xmlRoleData = new Dictionary();
      }
      
      public function set textureFormat(str:String) : void
      {
         _assets.textureFormat = str;
      }
      
      public function load(url:String) : void
      {
         if(EncodeAssets.loadPathConversion != null)
         {
            url = EncodeAssets.loadPathConversion(url);
         }
         for(var i in _roleList)
         {
            if(_roleList[i].path == url)
            {
               return;
            }
         }
         _roleList.push({
            "name":getTargetName(url),
            "path":url
         });
         log("角色加载：",url);
      }
      
      public function start(onPro:Function) : void
      {
         _back = onPro;
         next();
      }
      
      public function next() : void
      {
         var loadData:Object;
         var loadAsset:*;
         if(_roleList.length > 0)
         {
            loadAsset = function():void
            {
               var urlLoader:URLLoader = new URLLoader(new URLRequest(loadData.path));
               urlLoader.addEventListener("complete",function(e:Event):void
               {
                  addRoleData(loadData.name,e.target.data);
                  next();
               });
            };
            loadData = _roleList[0];
            _roleList.shift();
            if(Boolean(AssetManager.onLoadRawAssetOverride))
            {
               AssetManager.onLoadRawAssetOverride(loadData.path,function(byte:ByteArray):void
               {
                  if(byte)
                  {
                     addRoleData(loadData.name,byte.toString());
                     next();
                  }
                  else
                  {
                     loadAsset();
                  }
               },loadAsset);
            }
            else
            {
               loadAsset();
            }
         }
         else
         {
            loadOtherData();
         }
      }
      
      public function removeRole(target:String, need:Array = null, arr:Array = null) : void
      {
         var list:Array = null;
         var delName:String = null;
         if(need == null)
         {
            need = [];
         }
         if(arr == null)
         {
            arr = [];
         }
         if(_assetsReference[target])
         {
            list = _assetsReference[target].list;
            for(var i2 in list)
            {
               delName = RUtils.getPathName(list[i2]);
               if(arr.indexOf(list[i2]) == -1 && !cheakNeed(delName,need))
               {
                  _assets.removeTexture(delName);
                  _assets.removeXml(delName);
                  _assets.removeTextureAtlas(delName);
                  System.disposeXML(_xmlRoleData[delName]);
                  delete _xmlRoleData[delName];
                  trace("clear",delName);
               }
            }
            delete _assetsReference[target];
         }
      }
      
      public function loadOtherData() : void
      {
         var i:Object;
         var ob:Object;
         var arr:Array;
         var xml:XML;
         var content:XMLList;
         var ske:String;
         var i3:Object;
         var i2:Object;
         var other:XMLList;
         var lname:String;
         var spritePath:String;
         for(i in _xmlRoleData)
         {
            if(!_assetsReference[i])
            {
               ob = {};
               arr = [];
               ob.list = arr;
               xml = _xmlRoleData[i];
               content = xml.content.children();
               ske = "";
               for(i3 in content)
               {
                  if(String(content[i3].@path).indexOf("_ske") != -1)
                  {
                     ske = String(content[i3].@path);
                     ske = ske.substr(ske.lastIndexOf("/") + 1);
                     ske = ske.substr(0,ske.lastIndexOf("_"));
                  }
               }
               for(i2 in content)
               {
                  if(String(content[i2].@path).indexOf("_ske.json") != -1 || !DataCore.hasDragon(ske))
                  {
                     trace("加载",DataCore.webAssetsPath + GameCore.currentCore.loadHeader + String(content[i2].@path));
                     arr.push(content[i2].@path);
                     _assets.enqueue(DataCore.webAssetsPath + GameCore.currentCore.loadHeader + String(content[i2].@path));
                  }
               }
               if(xml.@type == "dragonbone" && !DataCore.hasDragon(ske))
               {
                  DataCore.pushDragon(ske);
               }
               other = xml.loads.children();
               for(i3 in other)
               {
                  lname = other[i3].localName();
                  trace("角色资源加载",_assets.textureFormat,other[i3].@path);
                  if(lname == "sprites")
                  {
                     spritePath = other[i3].@path;
                     if(IS_ATF_EFFECT && spritePath.indexOf("effect") != -1)
                     {
                        spritePath = spritePath.replace("effect","atf_effect");
                        spritePath = spritePath.replace(".png",".atf");
                     }
                     if(arr.indexOf(spritePath + ".xml") == -1)
                     {
                        arr.push(spritePath + ".xml");
                        _assets.enqueue(DataCore.webAssetsPath + GameCore.currentCore.loadHeader + spritePath + ".xml");
                        arr.push(spritePath + (IS_ATF_EFFECT ? ".atf" : ".png"));
                        _assets.enqueue(DataCore.webAssetsPath + GameCore.currentCore.loadHeader + spritePath + (IS_ATF_EFFECT ? ".atf" : ".png"));
                     }
                  }
                  else
                  {
                     arr.push(other[i3].@path);
                     _assets.enqueue(DataCore.webAssetsPath + GameCore.currentCore.loadHeader + String(other[i3].@path));
                  }
               }
               if(xml.@ai != undefined)
               {
                  _assets.enqueue(DataCore.webAssetsPath + GameCore.currentCore.loadHeader + "data/ai/" + String(xml.@ai));
               }
               _assetsReference[i] = ob;
            }
         }
         _assets.loadQueue(function(n:Number):void
         {
            if(!DataCore.onProgress(n))
            {
               _back(n);
            }
         });
      }
      
      public function addRoleData(target:String, data:String) : void
      {
         log("add",target,"to roleData");
         var xml:XML = new XML(data);
         if(Boolean(EncodeAssets.addXmlConversion))
         {
            _xmlRoleData[target] = EncodeAssets.addXmlConversion(xml);
         }
         else
         {
            _xmlRoleData[target] = xml;
         }
         var list:XMLList = _xmlRoleData[target].child("bind");
         for(var i in list)
         {
            load(DataCore.webAssetsPath + GameCore.currentCore.loadHeader + list[i].@path);
         }
      }
      
      public function getTargetName(url:String) : String
      {
         url = url.substr(url.lastIndexOf("/") + 1);
         return url.substr(0,url.lastIndexOf("."));
      }
      
      public function getXmlData(pname:String) : XML
      {
         return _xmlRoleData[pname];
      }
      
      public function getClass(target:String) : Class
      {
         var classSrc:String = null;
         var reClass:Class = null;
         if(!BaseRole.defalutSpriteRoleClass)
         {
            BaseRole.defalutSpriteRoleClass = SpriteRole;
         }
         if(!BaseRole.defalutDragonRoleClass)
         {
            BaseRole.defalutDragonRoleClass = DragonRole;
         }
         var roleXml:XML = this.getXmlData(target);
         if(roleXml)
         {
            if(roleXml.child("class").length() > 0)
            {
               classSrc = roleXml.child("class")[0].@src;
               reClass = GameCore.currentCore.getClass(classSrc);
               return reClass ? reClass : BaseRole.defalutSpriteRoleClass;
            }
            if(String(roleXml.@type) != "dragonbone")
            {
               return BaseRole.defalutSpriteRoleClass;
            }
            return BaseRole.defalutDragonRoleClass;
         }
         if(roleXml)
         {
            target = roleXml.@initName;
         }
         if(DataCore.assetsSwf.otherAssets.getObject(target + "_ske"))
         {
            return BaseRole.defalutDragonRoleClass;
         }
         return null;
      }
      
      public function clear(need:Array) : void
      {
         var arr:Array = [];
         for(var i in need)
         {
            if(_assetsReference[need[i]])
            {
               arr = arr.concat(_assetsReference[need[i]].list);
            }
         }
         for(var w in _assetsReference)
         {
            if(need.indexOf(w) == -1)
            {
               removeRole(String(w),need,arr);
            }
         }
      }
      
      public function cheakNeed(fileName:String, need:Array) : Boolean
      {
         var ob:Object = null;
         var list:Array = null;
         var delName:String = null;
         for(var i in need)
         {
            ob = _assetsReference[need[i]];
            if(ob)
            {
               list = ob.list;
               for(var i2 in list)
               {
                  delName = RUtils.getPathName(list[i2]);
                  if(delName == fileName)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public function clearAllRoleData() : void
      {
         clear([]);
         if(_roleList)
         {
            _roleList.splice(0,_roleList.length);
         }
         _xmlRoleData = new Dictionary();
         _assetsReference = new Dictionary();
      }
   }
}

