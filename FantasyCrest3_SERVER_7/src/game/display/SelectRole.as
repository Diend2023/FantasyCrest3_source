package game.display
{
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.layout.FlowLayout;
   import game.data.Game;
   import game.data.OnlineRoleFightData;
   import game.data.SelectGroupConfig;
   import game.item.RoleSelectItem;
   import game.uilts.GameFont;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.filters.GlowFilter;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.data.RoleAttributeData;
   import zygame.display.KeyDisplayObject;
   import zygame.utils.MemoryUtils;
   
   public class SelectRole extends KeyDisplayObject
   {
      
      private static var FightData:ListCollection;
      
      private var _color:uint;
      
      private var _list:List;
      
      private var _group:SelectGroup;
      
      private var _attribute:AttributeView;
      
      private var _roleImage:Image;
      
      private var _nametext:TextField;
      
      private var _passivetext:TextField;
      
      private var _roleIntroduce:RoleIntroduce;
      
      public var config:SelectGroupConfig;
      
      private var _fightText:TextField;
      
      private var _acthor:TextField;
      
      private var _acthorBG:Quad;
      
      public var shareSelectRole:SelectRole;
      
      public var call:Function;
      
      public var onRoleSelect:Function;
      
      public var onSelectChange:Function;
      
      private var _rowCount:int = 8;
      
      public var lockButton:CommonButton;
      
      public var zsongButton:CommonButton;
      
      public var _coinText:TextField;
      
      public var _coinText2:TextField;
      
      public var onlineText:TextField;
      
      private var _randomArray:Array;
      
      public function SelectRole(color:uint, pconfig:SelectGroupConfig)
      {
         super();
         _color = color;
         config = pconfig;
         trace("SelectConfig:",pconfig.selectCount,"是否高端局",pconfig.highGame);
      }
      
      public function get list() : List
      {
         return _list;
      }
      
      override public function onInit() : void
      {
         super.onInit();
         onInitSelect();
      }
      
      public function onInitSelect() : void
      {
         var text:TextField = null;
         var img:Image = null;
         var q:Quad = new Quad(stage.stageWidth / 2,stage.stageHeight,_color);
         this.addChild(q);
         q.setVertexAlpha(2,0.5);
         q.setVertexAlpha(3,0.5);
         q.setVertexAlpha(0,0);
         q.setVertexAlpha(1,0);
         q.blendMode = "add";
         var wz:int = stage.stageWidth / 2;
         var textures:TextureAtlas = DataCore.getTextureAtlas("select_role");
         var heads:TextureAtlas = DataCore.getTextureAtlas("role_head");
         var frame:Texture = textures.getTexture("frame");
         var inum:int = wz / 50;
         var selectedImage:Image = new Image(textures.getTexture((_color != 16711680 ? 1 : 2) + "pselected"));
         this.addChild(selectedImage);
         selectedImage.scaleX *= 0.5;
         selectedImage.scaleY *= 0.5;
         var abg:Image = new Image(textures.getTexture("attrframe"));
         this.addChild(abg);
         abg.scale *= 0.5;
         abg.x = stage.stageWidth / 2 - abg.width;
         abg.y = 80;
         var zcount:int = 10;
         var count:int = zcount / inum;
         var loadingBg:Image = new Image(textures.getTexture("nameframe"));
         this.addChild(loadingBg);
         loadingBg.height = 100;
         loadingBg.alignPivot("center","bottom");
         loadingBg.x = stage.stageWidth / 2;
         loadingBg.y = stage.stageHeight;
         loadingBg.setTexCoords(1,0,0);
         loadingBg.setTexCoords(3,0,1);
         _list = new List();
         _list.layout = new FlowLayout();
         (_list.layout as FlowLayout).gap = 2;
         _list.itemRendererType = RoleSelectItem;
         parsingFightData();
         _list.width = frame.width * 9;
         _list.height = frame.height * 2;
         _list.scale = stage.stageWidth / 2 / (_list.width - frame.width + 50);
         _list.y = stage.stageHeight - _list.height - 2;
         _list.x = 2;
         this.addChild(_list);
         _list.selectedIndex = 0;
         _list.touchable = true;
         _list.addEventListener("change",onListChange);
         _attribute = new AttributeView();
         this.addChild(_attribute);
         _attribute.x = abg.x;
         _attribute.y = abg.y + 40;
         if(_list.selectedItem)
         {
            _attribute.data = _list.selectedItem.attr as RoleAttributeData;
         }
         var bd:Image = new Image(textures.getTexture("beidong"));
         this.addChild(bd);
         bd.scale = 0.5;
         bd.x = abg.x + 5;
         bd.y = abg.y + abg.height - bd.height - 5;
         var pname:Image = new Image(textures.getTexture("nameframe"));
         this.addChild(pname);
         pname.scale = 0.5;
         pname.x = 0;
         pname.width = bd.x;
         pname.y = abg.y + abg.height - 70;
         var pnametext:TextField = new TextField(pname.width,pname.height,"河城荷取",new TextFormat(GameFont.FONT_NAME,18,16777215));
         pnametext.x = pname.x;
         pnametext.y = pname.y;
         this.addChild(pnametext);
         this._nametext = pnametext;
         var bdtext:TextField = new TextField(bd.width,bd.height,"每次使用技能将恢复生命最大值1%",new TextFormat(GameFont.FONT_NAME,12,16777215,"left"));
         this.addChild(bdtext);
         bdtext.format.leading = 3;
         bdtext.x = bd.x + 2;
         bdtext.y = bd.y;
         _passivetext = bdtext;
         _passivetext.filter = new GlowFilter(0,1,1,1);
         var bg:Quad = new Quad(bd.x,32,0);
         bg.alpha = 0.5;
         this.addChild(bg);
         bg.x = 0;
         bg.y = abg.y + abg.height - bg.height;
         var texttips:TextField = new TextField(bg.width,bg.height,"ADSW选人 J确定 U人物详情",new TextFormat(GameFont.FONT_NAME,12,16777215));
         this.addChild(texttips);
         texttips.x = bg.x;
         texttips.y = bg.y;
         if(_color == 16711680)
         {
            texttips.text = "←→↑↓选人 1确定 4人物详情";
            texttips.scaleX *= -1;
            texttips.x += texttips.width;
            pnametext.scaleX = -1;
            pnametext.x += pnametext.width;
            bdtext.scaleX = -1;
            bdtext.x += bdtext.width;
         }
         _nametext.text = _list.selectedItem.name;
         _roleImage = new Image(null);
         this.addChildAt(_roleImage,1);
         _roleImage.y = 80;
         _roleImage.x = 0;
         var maskImage:Quad = new Quad(stage.stageWidth,abg.height);
         this.addChild(maskImage);
         _roleImage.mask = maskImage;
         maskImage.y = abg.y;
         this.createSelectGroup();
         var rolei:RoleIntroduce = new RoleIntroduce();
         this.addChild(rolei);
         rolei.create(abg.x,abg.height - 90);
         rolei.y = abg.y + rolei.height / 2;
         rolei.x = -rolei.width;
         rolei.alignPivot();
         if(_color == 16711680)
         {
            rolei.scaleX = -1;
         }
         rolei.data = "原名：绯村心太。日本漫画《浪客剑心》及其衍生作品中的男主角，过去曾经被称为“刽子手拔刀斋”，流派为“飞天御剑流”，师父为比古清十郎。";
         _roleIntroduce = rolei;
         var acthorBg:Quad = new Quad(stage.stageWidth / 2,32,0);
         acthorBg.alpha = 0.7;
         acthorBg.y = _nametext.y + 6;
         this.addChild(acthorBg);
         var acthor:TextField = new TextField(stage.stageWidth / 2 - 10,32,"作者：木姐",new TextFormat(GameFont.FONT_NAME,12,268431360,"left"));
         this.addChild(acthor);
         acthor.x = 5;
         acthor.y = acthorBg.y;
         acthorBg.width = bg.width;
         _acthor = acthor;
         _acthorBG = acthorBg;
         if(_color == 16711680)
         {
            acthor.scaleX = -1;
            acthor.x = bg.width - 5;
            selectedImage.scaleX *= -1;
            selectedImage.x = selectedImage.width;
         }
         pname.y -= pname.height;
         _nametext.y -= _nametext.height;
         if(config.showOnlineRoleData)
         {
            text = new TextField(stage.stageWidth / 2,100,"- 无战斗数据 -",new TextFormat(GameFont.FONT_NAME,12,16777215));
            this.addChild(text);
            text.y = stage.stageHeight - 100;
            text.x = 0;
            onlineText = text;
         }
         updateView();
         if(this.config.showFight)
         {
            img = new Image(textures.getTexture("fight_frame"));
            this.addChild(img);
            img.y = 100;
            _fightText = new TextField(img.width - 60,img.height,Game.forceData ? Game.forceData.getData(_list.selectedItem.target).toString() : "0",new TextFormat(GameFont.FONT_NAME,16,16777215));
            this.addChild(_fightText);
            _fightText.y = 100;
            _fightText.x = 60;
            if(_color == 16711680)
            {
               _fightText.x = 0;
               _fightText.scaleX = -1;
               _fightText.alignPivot("right","top");
               img.scaleX = -1;
               img.alignPivot("right","top");
            }
         }
         if(config.isShowAll)
         {
            showAll();
         }
      }
      
      public function showAll() : void
      {
         var lock:CommonButton;
         var zsong:CommonButton;
         var coinBg:Quad;
         var icon:Image;
         var icon2:Image;
         var coinText:TextField;
         var coinText2:TextField;
         _rowCount = 5;
         var textures:TextureAtlas = DataCore.getTextureAtlas("select_role");
         var frame:Texture = textures.getTexture("frame");
         _list.width = frame.width * 6;
         _list.height = frame.height * 2;
         _list.scale = stage.stageWidth / 2 / (_list.width - frame.width + 50);
         _list.x = stage.stageWidth / 2;
         _list.y = 80;
         _list.width = stage.stageWidth / 2;
         _list.height = stage.stageHeight - 180;
         lock = new CommonButton(config.showCoinRole ? "buy" : "lock","select_role");
         this.addChild(lock);
         lock.x = stage.stageWidth / 2 + stage.stageWidth / 4;
         lock.y = stage.stageHeight - 50;
         lockButton = lock;
         if(config.showCoinRole)
         {
            zsong = new CommonButton("zsong","select_role");
            this.addChild(zsong);
            zsong.x = lock.x;
            zsong.y = lock.y;
            lock.x += lock.width / 2;
            zsong.x -= zsong.width / 2;
            zsongButton = zsong;
         }
         lock.callBack = function():void
         {
            onDown(74);
         };
         if(config.showCoinRole)
         {
            coinBg = new Quad(260,32,0);
            coinBg.alpha = 0.7;
            coinBg.x = stage.stageWidth / 2 + stage.stageWidth / 4 - coinBg.width / 2;
            coinBg.y = lock.y - 65;
            this.addChild(coinBg);
            icon = new Image(DataCore.getTextureAtlas("start_main").getTexture("coin"));
            this.addChild(icon);
            icon.x = coinBg.x + 10;
            icon.y = coinBg.y + 6;
            icon2 = new Image(DataCore.getTextureAtlas("start_main").getTexture("crystal"));
            this.addChild(icon2);
            icon2.x = coinBg.x + 10 + 130;
            icon2.y = coinBg.y + 6;
            icon2.scale = 0.7;
            coinText = new TextField(130,32,"488",new TextFormat(GameFont.FONT_NAME,15,16777215));
            this.addChild(coinText);
            coinText.x = coinBg.x;
            coinText.y = coinBg.y;
            _coinText = coinText;
            coinText2 = new TextField(130,32,"488",new TextFormat(GameFont.FONT_NAME,15,16777215));
            this.addChild(coinText2);
            coinText2.x = coinBg.x + 130;
            coinText2.y = coinBg.y;
            _coinText2 = coinText2;
            onListChange(null);
         }
      }
      
      public function onListChange(e:Event) : void
      {
         this.updateView();
         if(_coinText)
         {
            _coinText2.text = currentSelectItem.crystal ? currentSelectItem.crystal : "无法使用";
            _coinText.text = currentSelectItem.coin ? currentSelectItem.coin : "无法使用";
         }
         if(onSelectChange != null)
         {
            onSelectChange();
         }
      }
      
      public function updateFight() : void
      {
         if(_fightText)
         {
            _fightText.text = Game.forceData ? Game.forceData.getData(_list.selectedItem.target).toString() : "0";
         }
         if(onlineText)
         {
            onlineText.text = Game.onlineData.dict[_list.selectedItem.target] ? (Game.onlineData.dict[_list.selectedItem.target] as OnlineRoleFightData).getString() : "- 无战斗数据 -";
         }
      }
      
      public function get group() : SelectGroup
      {
         return _group;
      }
      
      public function createSelectGroup() : void
      {
         var pClass:Class = config.highGame ? HighGameSelectGroup : SelectGroup;
         _group = new pClass(_color == 255 ? 0 : 1,config);
         this.addChild(_group);
         _group.x = 46;
      }
      
      public function parsingFightData() : void
      {
         var xmllist:XMLList = null;
         var rootName:String = null;
         var arr:Array = [];
         var figth:XML = DataCore.getXml("fight");
         var allcoin:int = 0;
         var unlock:XML = DataCore.getXml("unlock");
         var unlockData:String = unlock.toString();
         if(figth)
         {
            xmllist = figth.children();
            for(var i in xmllist)
            {
               rootName = (xmllist[i] as XML).localName();
               if(unlockData.indexOf("Role" + rootName) != -1 && rootName != "init" && String((xmllist[i] as XML).@visible) != "false" && (!config.showCoinRole || config.showCoinRole && (int((xmllist[i] as XML).@crystal) > 0 || int((xmllist[i] as XML).@coin) > 0)))
               {
                  if(!(false && (int((xmllist[i] as XML).@crystal) > 0 || int((xmllist[i] as XML).@coin) > 0) && String((xmllist[i] as XML).@in4399) != "true"))
                  {
                     arr.push({
                        "passive":xmllist[i].@passive,
                        "head":String(xmllist[i].@head).replace(".png",""),
                        "name":xmllist[i].@name,
                        "attr":getAttributeFormName(rootName),
                        "introduce":xmllist[i].@introduce,
                        "target":rootName,
                        "acthor":xmllist[i].@acthor,
                        "profession":xmllist[i].@profession,
                        "coin":int(xmllist[i].@coin),
                        "crystal":int(xmllist[i].@crystal),
                        "isNew":String(xmllist[i].@version) == String(DataCore.getXml("fight").@version),
                        "lock":true,
                        "xml":xmllist[i]
                     });
                     allcoin += int(xmllist[i].@coin);
                  }
               }
            }
         }
         _list.dataProvider = new ListCollection(arr);
      }
      
      public function getAttributeFormName(target:String) : RoleAttributeData
      {
         var attr:RoleAttributeData = new RoleAttributeData(target);
         DataCore.fightData.initAttribute(attr);
         return attr;
      }
      
      public function get isSelected() : Boolean
      {
         return _group.isSelected;
      }
      
      override public function onDown(key:int) : void
      {
         var randomItem:Object = null;
         var indexSelect:int = 0;
         if(this._group.isSelected)
         {
            return;
         }
         switch(key)
         {
            case 39:
            case 65:
               if(_list.selectedIndex > 0)
               {
                  _list.selectedIndex--;
               }
               break;
            case 37:
            case 68:
               if(_list.selectedIndex < _list.dataProvider.length - 1)
               {
                  _list.selectedIndex++;
               }
               break;
            case 38:
            case 87:
               if(_list.selectedIndex - _rowCount < 0)
               {
                  _list.selectedIndex = 0;
                  break;
               }
               _list.selectedIndex -= _rowCount;
               break;
            case 40:
            case 83:
               if(_list.selectedIndex + _rowCount > _list.dataProvider.length - 1)
               {
                  _list.selectedIndex = _list.dataProvider.length - 1;
                  break;
               }
               _list.selectedIndex += _rowCount;
               break;
            case 49:
            case 97:
            case 74:
               if(lockButton)
               {
                  lockButton.visible = false;
               }
               randomItem = null;
               indexSelect = -1;
               if(_list.selectedItem.name == "随机选择")
               {
                  while(!randomItem || randomItem.lock)
                  {
                     indexSelect = _list.dataProvider.length * Math.random();
                     randomItem = _list.dataProvider.getItemAt(indexSelect);
                     if(randomItem.name == "随机选择")
                     {
                        indexSelect = _list.dataProvider.length * Math.random();
                        randomItem = _list.dataProvider.getItemAt(indexSelect);
                        if(randomItem.name != "随机选择")
                        {
                           break;
                        }
                     }
                  }
               }
               if(indexSelect == -1)
               {
                  indexSelect = _list.selectedIndex;
               }
               if(!randomItem)
               {
                  randomItem = _list.selectedItem;
               }
               _list.selectedIndex = indexSelect;
               if(shareSelectRole && shareSelectRole.group.hasObject(randomItem))
               {
                  break;
               }
               if(!_group.pushSelect(randomItem))
               {
                  break;
               }
               selected(indexSelect);
               if(shareSelectRole)
               {
                  shareSelectRole.selected(indexSelect);
               }
               if(_group.isSelected)
               {
                  Starling.juggler.tween(_list,0.25,{"alpha":0});
               }
               if(call == null)
               {
                  break;
               }
               try
               {
                  call();
                  break;
               }
               catch(e:Error)
               {
                  call(randomItem);
                  break;
               }
               break;
            case 50:
            case 98:
            case 75:
               break;
            case 52:
            case 100:
            case 85:
               if(_roleIntroduce.x == _roleIntroduce.width / 2)
               {
                  Starling.juggler.tween(_roleIntroduce,0.25,{"x":-_roleIntroduce.width});
                  break;
               }
               Starling.juggler.tween(_roleIntroduce,0.25,{"x":_roleIntroduce.width / 2});
         }
         if(key != 85)
         {
            updateView();
         }
      }
      
      public function selected(index:int) : void
      {
         _list.dataProvider.getItemAt(index).selected = true;
         _list.dataProvider.updateItemAt(index);
      }
      
      public function selectedName(target:String) : void
      {
         var i:int = 0;
         for(i = 0; i < _list.dataProvider.length; )
         {
            if(_list.dataProvider.getItemAt(i).target == target)
            {
               _list.dataProvider.getItemAt(i).selected = true;
               _list.dataProvider.updateItemAt(i);
               break;
            }
            i++;
         }
      }
      
      public function updateView() : void
      {
         var texture:Texture;
         var tw:Tween;
         var str:String;
         if(!_list || !_list.selectedItem)
         {
            return;
         }
         _list.scrollToDisplayIndex(_list.selectedIndex);
         _attribute.data = _list.selectedItem.attr as RoleAttributeData;
         _nametext.text = _list.selectedItem.name;
         texture = Game.assets.getTexture(_list.selectedItem.head);
         if(_roleImage.texture != texture || !texture)
         {
            Starling.juggler.removeTweens(_roleImage);
            tw = new Tween(_roleImage,0.15);
            tw.animate("alpha",0);
            Starling.juggler.add(tw);
            tw.onComplete = function():void
            {
               Game.getRoleImage(_list.selectedItem.head,function(texture:Texture):void
               {
                  var show:Tween = new Tween(_roleImage,0.15);
                  show.animate("alpha",1);
                  _roleImage.width = texture.width;
                  _roleImage.height = texture.height;
                  _roleImage.texture = texture;
                  Starling.juggler.add(show);
               });
            };
         }
         if(_list.selectedItem.passive != undefined)
         {
            _passivetext.text = _list.selectedItem.passive;
         }
         else
         {
            _passivetext.text = "左眼还没设计他的被动吧...";
         }
         if(_list.selectedItem.introduce != undefined)
         {
            _roleIntroduce.data = _list.selectedItem.introduce;
         }
         else
         {
            _roleIntroduce.data = "左眼似乎还没有去取材。";
         }
         if(_acthor)
         {
            str = "";
            if(config.showActhor)
            {
               str = _list.selectedItem.acthor != undefined ? "作者：" + _list.selectedItem.acthor : "未知作者";
            }
            _acthor.text = str + "  ";
            _acthor.text += _list.selectedItem.profession != undefined ? "擅长：" + _list.selectedItem.profession : "擅长：无";
         }
         this.updateFight();
      }
      
      override public function onUp(key:int) : void
      {
      }
      
      public function get currentSelectItem() : Object
      {
         return _list.selectedItem;
      }
      
      override public function dispose() : void
      {
         if(_list)
         {
            _list.dataProvider.dispose(function(item:Object):void
            {
               MemoryUtils.clearObject(item);
            });
            _list.dataProvider = null;
            _list.dispose();
         }
         _list = null;
         this.config = null;
         this._acthor = null;
         this._acthorBG = null;
         this._attribute = null;
         this._coinText2 = null;
         this._coinText = null;
         this._fightText = null;
         this._group = null;
         this._nametext = null;
         this._passivetext = null;
         this._roleImage = null;
         this._roleIntroduce = null;
         super.dispose();
         trace("释放");
      }
   }
}

