package anifire.player.playback
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.player.assetTransitions.models.AssetTransition;
   import anifire.player.assetTransitions.models.AssetTransitionCollection;
   import anifire.player.assetTransitions.views.AssetAppearTransitionView;
   import anifire.player.assetTransitions.views.AssetBlurTransitionView;
   import anifire.player.assetTransitions.views.AssetFlashEffSpriteTransitionView;
   import anifire.player.assetTransitions.views.AssetFlashEffTransitionView;
   import anifire.player.assetTransitions.views.AssetFlexTransitionView;
   import anifire.player.assetTransitions.views.AssetHandDrawnTransitionView;
   import anifire.player.assetTransitions.views.AssetHandSlideTransitionView;
   import anifire.player.assetTransitions.views.AssetPopSpriteTransitionView;
   import anifire.player.assetTransitions.views.AssetSlideTransitionView;
   import anifire.player.assetTransitions.views.AssetTransitionView;
   import anifire.player.assetTransitions.views.AssetZoomTransitionView;
   import anifire.player.assetTransitions.views.WidgetTransitionView;
   import anifire.player.interfaces.IPlayerAssetView;
   
   public class AssetViewFactory
   {
       
      
      public function AssetViewFactory()
      {
         super();
      }
      
      public static function createAssetView(param1:AssetTransitionCollection) : IPlayerAssetView
      {
         var _loc3_:AssetTransition = null;
         var _loc2_:IPlayerAssetView = new AssetView();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = param1.getTransitionAt(_loc4_);
            switch(_loc3_.type)
            {
               case AssetTransitionConstants.TYPE_APPEAR:
                  _loc2_ = new AssetAppearTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_HAND_DRAWN:
                  _loc2_ = new AssetHandDrawnTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_HANDSLIDE:
                  _loc2_ = new AssetHandSlideTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_SLIDE:
                  _loc2_ = new AssetSlideTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_BLUR:
                  _loc2_ = new AssetBlurTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_ZOOM:
                  _loc2_ = new AssetZoomTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_WIDGET_ANIMATION:
                  _loc2_ = new WidgetTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_SPRITE_POP_DOTS:
               case AssetTransitionConstants.TYPE_SPRITE_POP_RINGS:
               case AssetTransitionConstants.TYPE_SPRITE_POP_SINGLE_RING:
               case AssetTransitionConstants.TYPE_SPRITE_POP_STAR:
                  _loc2_ = new AssetPopSpriteTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_TEXT_3DCAMDEPTH:
               case AssetTransitionConstants.TYPE_TEXT_3DCAMFOCUS:
               case AssetTransitionConstants.TYPE_TEXT_3DCAMMATRIX:
               case AssetTransitionConstants.TYPE_TEXT_3DCAMXYZ:
               case AssetTransitionConstants.TYPE_TEXT_3DCAMXYZPIVOT:
               case AssetTransitionConstants.TYPE_TEXT_3DMOTION:
               case AssetTransitionConstants.TYPE_TEXT_ALPHA:
               case AssetTransitionConstants.TYPE_TEXT_BLUR + "_16":
               case AssetTransitionConstants.TYPE_TEXT_BLUR + "_26":
               case AssetTransitionConstants.TYPE_TEXT_BLUR + "_1":
               case AssetTransitionConstants.TYPE_TEXT_BLUR + "_20":
               case AssetTransitionConstants.TYPE_TEXT_BLURRYLIGHT:
               case AssetTransitionConstants.TYPE_TEXT_BUBBLES:
               case AssetTransitionConstants.TYPE_TEXT_BUBBLESCALE:
               case AssetTransitionConstants.TYPE_TEXT_CENTERSCALEDISSOLVE:
               case AssetTransitionConstants.TYPE_TEXT_CHAOTIC:
               case AssetTransitionConstants.TYPE_TEXT_CHASINGWORDS:
               case AssetTransitionConstants.TYPE_TEXT_CREATION:
               case AssetTransitionConstants.TYPE_TEXT_DYNAMICCURVE:
               case AssetTransitionConstants.TYPE_TEXT_ELASTICSCALE:
               case AssetTransitionConstants.TYPE_TEXT_EMERGE:
               case AssetTransitionConstants.TYPE_TEXT_FALLANDGLOW:
               case AssetTransitionConstants.TYPE_TEXT_FLIP:
               case AssetTransitionConstants.TYPE_TEXT_GLOW:
               case AssetTransitionConstants.TYPE_TEXT_GLOWNBURN:
               case AssetTransitionConstants.TYPE_TEXT_GLOWINGGROUP:
               case AssetTransitionConstants.TYPE_TEXT_HORIZONTALDISOLVE:
               case AssetTransitionConstants.TYPE_TEXT_HORIZONTALGROW:
               case AssetTransitionConstants.TYPE_TEXT_INDUSTRIAL:
               case AssetTransitionConstants.TYPE_TEXT_INDUSTRIAL2:
               case AssetTransitionConstants.TYPE_TEXT_JIGGY:
               case AssetTransitionConstants.TYPE_TEXT_LIGHTBEAM:
               case AssetTransitionConstants.TYPE_TEXT_LINEBENT:
               case AssetTransitionConstants.TYPE_TEXT_LINEBURNANDFLOW:
               case AssetTransitionConstants.TYPE_TEXT_MAGNETICWIND + "_9":
               case AssetTransitionConstants.TYPE_TEXT_MAGNETICWIND + "_14":
               case AssetTransitionConstants.TYPE_TEXT_NEONTUBES:
               case AssetTransitionConstants.TYPE_TEXT_SCRAMBLE:
               case AssetTransitionConstants.TYPE_TEXT_SCROLLSLIDE:
               case AssetTransitionConstants.TYPE_TEXT_SCROLLSLIDE + "_19_3":
               case AssetTransitionConstants.TYPE_TEXT_SCROLLSLIDE + "_19_4":
               case AssetTransitionConstants.TYPE_TEXT_SCROLLSLIDE + "_18":
               case AssetTransitionConstants.TYPE_TEXT_SCROLLSLIDEBLUR:
               case AssetTransitionConstants.TYPE_TEXT_SCROLLSLIDEGLOW:
               case AssetTransitionConstants.TYPE_TEXT_SLICE + "_1_v":
               case AssetTransitionConstants.TYPE_TEXT_SLICE + "_2_h":
               case AssetTransitionConstants.TYPE_TEXT_SLICE + "_1_h":
               case AssetTransitionConstants.TYPE_TEXT_SLIDEBOUNCE:
               case AssetTransitionConstants.TYPE_TEXT_SLOWSLIDE:
               case AssetTransitionConstants.TYPE_TEXT_SMARTSLIDE:
               case AssetTransitionConstants.TYPE_TEXT_SPINNINGGENIE:
               case AssetTransitionConstants.TYPE_TEXT_SPIRAL:
               case AssetTransitionConstants.TYPE_TEXT_SPIRALNO2:
               case AssetTransitionConstants.TYPE_TEXT_STATIONPANELS:
               case AssetTransitionConstants.TYPE_TEXT_TWILIGHT + "_d":
               case AssetTransitionConstants.TYPE_TEXT_TWILIGHT + "_n":
               case AssetTransitionConstants.TYPE_TEXT_VERTICALDISOLVE:
               case AssetTransitionConstants.TYPE_TEXT_VERTICALSTRIPES:
               case AssetTransitionConstants.TYPE_TEXT_WAVESMASK:
               case AssetTransitionConstants.TYPE_TEXT_WAVINGLINES:
               case AssetTransitionConstants.TYPE_TEXT_WIGILIGI:
               case AssetTransitionConstants.TYPE_TEXT_XYRESOLVE:
               case AssetTransitionConstants.TYPE_TEXT_XYSCALE + "_18":
               case AssetTransitionConstants.TYPE_TEXT_XYSCALE + "_24":
               case AssetTransitionConstants.TYPE_TEXT_XYSCALEBLUR:
                  _loc2_ = new AssetFlashEffTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_SPRITE_BADTRAN:
               case AssetTransitionConstants.TYPE_SPRITE_BRIGHTSQ + "_11":
               case AssetTransitionConstants.TYPE_SPRITE_BRIGHTSQ + "_13":
               case AssetTransitionConstants.TYPE_SPRITE_DESERTILL:
               case AssetTransitionConstants.TYPE_SPRITE_INTERSTRIPES + "_1":
               case AssetTransitionConstants.TYPE_SPRITE_INTERSTRIPES + "_4":
               case AssetTransitionConstants.TYPE_SPRITE_LIGHTSTRIPES:
               case AssetTransitionConstants.TYPE_SPRITE_MYSTERY:
               case AssetTransitionConstants.TYPE_SPRITE_SCALE:
               case AssetTransitionConstants.TYPE_SPRITE_SPARKLE + "_1":
               case AssetTransitionConstants.TYPE_SPRITE_SPARKLE + "_4":
               case AssetTransitionConstants.TYPE_SPRITE_SQEXPLODE:
               case AssetTransitionConstants.TYPE_SPRITE_UNPACK + "_2":
               case AssetTransitionConstants.TYPE_SPRITE_UNPACK + "_1":
               case AssetTransitionConstants.TYPE_SPRITE_UNPACK + "_8":
               case AssetTransitionConstants.TYPE_SPRITE_ZOOMBLUR:
               case AssetTransitionConstants.TYPE_SPRITE_DISC:
                  _loc2_ = new AssetFlashEffSpriteTransitionView(_loc2_);
                  break;
               case AssetTransitionConstants.TYPE_MOTION_PATH:
                  _loc2_ = new AssetTransitionView(_loc2_);
                  break;
               default:
                  _loc2_ = new AssetFlexTransitionView(_loc2_);
            }
            if(_loc2_ is AssetTransitionView)
            {
               AssetTransitionView(_loc2_).transition = _loc3_;
            }
            _loc4_++;
         }
         return _loc2_;
      }
   }
}
