package anifire.component
{
	import anifire.util.UtilPlain;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.IFlexModuleFactory;
	import mx.core.UIComponentDescriptor;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	
	public class timeFrameSynchronizer extends Canvas
	{
		 
		
		private var _2070217628statusLbl:Label;
		
		private var _315645917streamImg:Image;
		
		private var _documentDescriptor_:UIComponentDescriptor;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		private var isSynOn:Boolean;
		
		private var _embed_mxml_timeFrameSynchronizer_24_swf_597725466:Class;
		
		public function timeFrameSynchronizer()
		{
			this._documentDescriptor_ = new UIComponentDescriptor({
				"type":Canvas,
				"events":{"creationComplete":"___timeFrameSynchronizer_Canvas1_creationComplete"},
				"stylesFactory":function():void
				{
					this.backgroundColor = 16777215;
				},
				"propertiesFactory":function():Object
				{
					return {
						"width":222,
						"height":22,
						"childDescriptors":[new UIComponentDescriptor({
							"type":Image,
							"id":"streamImg",
							"propertiesFactory":function():Object
							{
								return {
									"x":0,
									"y":0,
									"source":_embed_mxml_timeFrameSynchronizer_24_swf_597725466,
									"width":0,
									"height":0
								};
							}
						}),new UIComponentDescriptor({
							"type":Button,
							"events":{"click":"___timeFrameSynchronizer_Button1_click"},
							"propertiesFactory":function():Object
							{
								return {
									"x":0,
									"y":0,
									"label":"toggle timeFrame Syn"
								};
							}
						}),new UIComponentDescriptor({
							"type":Label,
							"id":"statusLbl",
							"propertiesFactory":function():Object
							{
								return {
									"x":160,
									"y":2,
									"text":"Label",
									"width":56
								};
							}
						})]
					};
				}
			});
			this._embed_mxml_timeFrameSynchronizer_24_swf_597725466 = timeFrameSynchronizer__embed_mxml_timeFrameSynchronizer_24_swf_597725466;
			super();
			mx_internal::_document = this;
			this.width = 222;
			this.height = 22;
			this.addEventListener("creationComplete",this.___timeFrameSynchronizer_Canvas1_creationComplete);
		}
		
		override public function set moduleFactory(param1:IFlexModuleFactory) : void
		{
			var factory:IFlexModuleFactory = param1;
			super.moduleFactory = factory;
			if(this.__moduleFactoryInitialized)
			{
				return;
			}
			this.__moduleFactoryInitialized = true;
			if(!this.styleDeclaration)
			{
				this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
			}
			this.styleDeclaration.defaultFactory = function():void
			{
				this.backgroundColor = 16777215;
			};
		}
		
		override public function initialize() : void
		{
			mx_internal::setDocumentDescriptor(this._documentDescriptor_);
			super.initialize();
		}
		
		private function onCreationComplete(param1:Event) : void
		{
			UtilPlain.stopFamily(this.streamImg);
			this.isSynOn = false;
			this.statusLbl.text = "OFF";
		}
		
		public function startSyn() : void
		{
			if(this.isSynOn == false)
			{
				UtilPlain.playFamily(this.streamImg);
				this.statusLbl.text = "ON";
			}
			else
			{
				UtilPlain.stopFamily(this.streamImg);
				UtilPlain.playFamily(this.streamImg);
			}
			this.isSynOn = true;
		}
		
		public function stopSyn() : void
		{
			if(this.isSynOn != false)
			{
				UtilPlain.stopFamily(this.streamImg);
				this.statusLbl.text = "OFF";
			}
			this.isSynOn = false;
		}
		
		private function toggleSyn(param1:Event) : void
		{
			if(this.isSynOn)
			{
				this.stopSyn();
			}
			else
			{
				this.startSyn();
			}
		}
		
		public function ___timeFrameSynchronizer_Canvas1_creationComplete(param1:FlexEvent) : void
		{
			this.onCreationComplete(param1);
		}
		
		public function ___timeFrameSynchronizer_Button1_click(param1:MouseEvent) : void
		{
			this.toggleSyn(param1);
		}
		
		[Bindable(event="propertyChange")]
		public function get statusLbl() : Label
		{
			return this._2070217628statusLbl;
		}
		
		public function set statusLbl(param1:Label) : void
		{
			var _loc2_:Object = this._2070217628statusLbl;
			if(_loc2_ !== param1)
			{
				this._2070217628statusLbl = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statusLbl",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get streamImg() : Image
		{
			return this._315645917streamImg;
		}
		
		public function set streamImg(param1:Image) : void
		{
			var _loc2_:Object = this._315645917streamImg;
			if(_loc2_ !== param1)
			{
				this._315645917streamImg = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"streamImg",_loc2_,param1));
				}
			}
		}
	}
}
