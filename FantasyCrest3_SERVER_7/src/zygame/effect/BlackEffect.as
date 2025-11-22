package zygame.effect
{
   import flash.display3D.Context3D;
   import starling.rendering.MeshEffect;
   import starling.rendering.Program;
   import starling.rendering.VertexDataFormat;
   
   public class BlackEffect extends MeshEffect
   {
      
      private var ver:Vector.<Number>;
      
      public function BlackEffect()
      {
         super();
         ver = Vector.<Number>([0.25,1,0.5,0]);
      }
      
      override protected function createProgram() : Program
      {
         var vertexShader:String = "m44 op, va0, vc0 \nmov v0, va1      \nmul v1, va2, vc4 \n";
         var fragmentShader:String = tex("ft0","v0",0,texture) + "sge ft1.x, ft0.x, fc0.x\n" + "sge ft1.y, ft0.y, fc0.x\n" + "sge ft1.z, ft0.z, fc0.x\n" + "add ft1.w, ft1.x, ft1.y\n" + "add ft1.w, ft1.w, ft1.z\n" + "sge ft1.w, ft1.w, fc0.y\n" + "mul ft0, ft0, ft1.w\n" + "mul ft0.w, ft0.w, fc0.z\n" + "mov oc, ft0";
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

