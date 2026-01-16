package zygame.effect
{
   import flash.display3D.Context3D;
   import starling.rendering.MeshEffect;
   import starling.rendering.Program;
   import starling.rendering.VertexDataFormat;
   
   public class Color2Effect extends MeshEffect
   {
      
      private var ver:Vector.<Number>;
      
      private var ver2:Vector.<Number>;
      
      public function Color2Effect()
      {
         super();
         ver = Vector.<Number>([0,0,0,0]);
         ver2 = Vector.<Number>([0,0,0,3]);
      }
      
      public function set color(rgb:uint) : void
      {
         var r:* = rgb >> 16;
         var g:* = rgb >> 8 & 0xFF;
         var b:* = rgb & 0xFF;
         ver[0] = r / 255;
         ver[1] = g / 255;
         ver[2] = b / 255;
      }
      
      public function set intensity(i:Number) : void
      {
         ver2[0] = i;
      }
      
      override protected function createProgram() : Program
      {
         var vertexShader:String = "m44 op, va0, vc0 \nmov v0, va1      \nmul v1, va2, vc4 \n";
         var fragmentShader:String = tex("ft0","v0",0,texture) + "add ft1.x, ft0.x, ft0.y \n" + "add ft1.x, ft1.x, ft0.z \n" + "sne ft1.y, ft1.x, fc0.w \n" + "div ft1.z, ft1.x, fc1.w \n" + "mul ft2.xyz, fc0.xyz, ft1.yyy \n" + "mul ft2.xyz, ft2.xyz, ft1.zzz \n" + "add ft0.xyz, ft0.xyz, ft2.xyz \n" + "mov ft0.w, fc0.w \n" + "mov ft2.w, fc0.w \n" + "mul ft2.xyzw, fc1.xxxx, ft2.xyzw \n" + "mul ft2, ft2, v1  \n" + "mov oc, ft2 \n                   ";
         return Program.fromSource(vertexShader,fragmentShader);
      }
      
      override public function get vertexFormat() : VertexDataFormat
      {
         return VERTEX_FORMAT;
      }
      
      override protected function beforeDraw(context:Context3D) : void
      {
         super.beforeDraw(context);
         context.setProgramConstantsFromVector("fragment",0,ver);
         context.setProgramConstantsFromVector("fragment",1,ver2);
      }
      
      override protected function afterDraw(context:Context3D) : void
      {
         super.afterDraw(context);
      }
   }
}

