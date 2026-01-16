package zygame.effect
{
   import flash.display3D.Context3D;
   import starling.rendering.MeshEffect;
   import starling.rendering.Program;
   import starling.rendering.VertexDataFormat;
   
   public class WhiteEffect extends MeshEffect
   {
      
      private var ver:Vector.<Number>;
      
      public function WhiteEffect()
      {
         super();
         ver = Vector.<Number>([3,1,0,0]);
      }
      
      override protected function createProgram() : Program
      {
         var vertexShader:String = "m44 op, va0, vc0 \nmov v0, va1      \nmul v1, va2, vc4 \n";
         var fragmentShader:String = tex("ft0","v0",0,texture) + "add ft1.x, ft0.x, ft0.y \n" + "add ft1.x, ft1.x, ft0.z \n" + "div ft1.x, ft1.x, fc0.x \n" + "sub ft1.x, fc0.y, ft1.x \n" + "mul ft2, ft0, ft1.xxxx \n" + "mov oc, ft2";
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
      }
      
      override protected function afterDraw(context:Context3D) : void
      {
         super.afterDraw(context);
      }
   }
}

