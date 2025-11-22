package zygame.effect
{
   import flash.display3D.Context3D;
   import starling.rendering.FilterEffect;
   import starling.rendering.Program;
   
   public class GoldenBodyEffect extends FilterEffect
   {
      
      private var vec:Vector.<Number>;
      
      private var off:Vector.<Number>;
      
      public function GoldenBodyEffect()
      {
         super();
         vec = Vector.<Number>([1,1,0,0]);
         off = Vector.<Number>([0.0125,-0.0125,0,0]);
      }
      
      override protected function createProgram() : Program
      {
         var vertexShader:String = "m44 op, va0, vc0 \nmov v0, va1 \n\nadd v1, va1, vc4.xxzz\nadd v2, va1, vc4.xyzz\nadd v3, va1, vc4.yxzz\nadd v4, va1, vc4.yyzz\n";
         var fragmentShader:String = tex("ft0","v1",0,texture) + "mul ft1 fc0, ft0 \n" + "mov ft0, ft1 \n" + tex("ft2","v2",0,texture) + "add ft0, ft0, ft2 \n" + tex("ft2","v3",0,texture) + "add ft0, ft0, ft2 \n" + tex("ft2","v4",0,texture) + "add ft0, ft0, ft2 \n" + "mul ft0, ft0, fc0 \n" + "mov oc, ft0";
         return Program.fromSource(vertexShader,fragmentShader);
      }
      
      override protected function beforeDraw(context:Context3D) : void
      {
         super.beforeDraw(context);
         context.setProgramConstantsFromVector("vertex",4,off);
         context.setProgramConstantsFromVector("fragment",0,vec);
      }
   }
}

