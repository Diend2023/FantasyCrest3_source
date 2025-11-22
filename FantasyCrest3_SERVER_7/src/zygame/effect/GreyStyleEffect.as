package zygame.effect
{
   import flash.display3D.Context3D;
   import starling.rendering.MeshEffect;
   import starling.rendering.Program;
   
   public class GreyStyleEffect extends MeshEffect
   {
      
      public function GreyStyleEffect()
      {
         super();
      }
      
      override protected function createProgram() : Program
      {
         var vertexShader:String = "m44 op, va0, vc0 \nmov v0, va1      \nmul v1, va2, vc4 \n";
         var fragmentShader:String = "tex ft0, v0, fs0 <2d, repeat> \nmov ft1, fc1 \nmul ft1.xyzw, ft1.xyzw, ft0.wwww \nadd ft1.x, ft0.x, ft0.y \nadd ft1.x, ft1.x, ft0.z \ndiv ft1.x, ft1.x, fc0.x \nmov ft1.yz, ft1.xx \nmov oc, ft1";
         return Program.fromSource(vertexShader,fragmentShader);
      }
      
      override protected function beforeDraw(context:Context3D) : void
      {
         super.beforeDraw(context);
         context.setProgramConstantsFromVector("fragment",0,Vector.<Number>([3,0,0,0]));
         context.setProgramConstantsFromVector("fragment",1,Vector.<Number>([0,0,0,1]));
      }
   }
}

