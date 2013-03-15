package psw2d
 {
     /**
      *    1 -    2
      *     | /    |
      *     0 - 3
      * @author Physwf
      * 
      */    
     public class Quad
     {
         private var _x:Number;
         private var _y:Number;
         private var _width:Number;
         private var _height:Number;
         private var _color:uint;
         
         public function Quad(w:Number,h:Number,color:uint=0)
         {
             _x = 0;
             _y = 0;
             _width = w;
             _height = h;
             _color = color;
         }
         
         public function set x(value:Number):void
         {
             _x = value;
         }
 
         public function get x():Number
         {
             return _x;
         }
 
         public function get y():Number
         {
             return _y;
         }
 
         public function set y(value:Number):void
         {
             _y = value;
         }
 
         public function get width():Number
         {
             return _width;
         }
 
         public function set width(value:Number):void
         {
             _width = value;
         }
 
         public function get height():Number
         {
             return _height;
         }
 
         public function set height(value:Number):void
         {
             _height = value;
         }
 
         public function get color():uint
         {
             return _color;
         }
 
         public function set color(value:uint):void
         {
             _color = value;
         }
         
         
     }
 }