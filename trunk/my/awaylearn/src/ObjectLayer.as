/**
 *	ObjectLayer.as
 *    
 * 	Defines an object layer for the isometric viewport in which objects can be sorted against each other.
 *
 * @package ZEngineIso
 * @copyright Copyright (&copy;) 2010, Zynga Game Network, Inc.
 */
package Engine.Classes {
	import Engine.Constants;
	import Engine.Helpers.Vector2;
	import Engine.Helpers.Vector3;
	import Engine.Interfaces.IEngineObject;
	import Engine.Interfaces.IRenderObject;
	import Engine.IsoMath;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class ObjectLayer extends PositionedObject implements IEngineObject, IRenderObject {
		/** Objects within this layer */
		protected var m_children:Array=[];

		/** Priority of the layer, higher priority means the layer will be on-top */
		public var priority:Number;
		
		/** Name of the layer */
		public var name:String;
		
		/** Constructor */
		public function ObjectLayer(layerName:String,layerPriority:Number=0.0) {
			this.name=layerName;
			this.priority=layerPriority;
			this.m_displayObject=new Sprite;
		}
		
		/** @return	Returns all of the depth sorted objects in this container */
		public function get children():Array {
			return m_children;
		}
		
		/** @inherit */
		public function cleanUp():void {
			var oldDepthSortedObjects:Array = m_children.concat([]);
			for(var objIdx:int=0; objIdx<oldDepthSortedObjects.length; objIdx++) {
				var obj:WorldObject = oldDepthSortedObjects[objIdx] as WorldObject;
				if(obj != null) {
					obj.detach();
					obj.cleanUp();
				}
			}
			m_displayObject=new Sprite;
		}
		
		/** @inherit */
		public function update():void {
			for(var objIdx:int=0; objIdx<m_children.length; objIdx++) {
				m_children[objIdx].update();
			}
		}
		
		/** @inherit */
		public function attach():void {
			var isoViewport:IsoViewport=GlobalEngine.viewport as IsoViewport;
			isoViewport.addObjectLayer(this);
		}
		
		/** @inherit */
		public function detach():void {
			var isoViewport:IsoViewport=GlobalEngine.viewport as IsoViewport;
			isoViewport.removeObjectLayer(this);
		}
		
		/** @inherit */
		public function render( context:RenderContext ):void {
			var l:int = m_children.length;
			for( var i:int=0; i<l; ++i) {
				m_children[i].render( context );
			}
		}
		
		/**
		 * Inserts an object into the depth sorted array.
		 * 
		 * @param worldObj		Object to insert.
		 */ 
		public function insertObjectIntoDepthArray(worldObj:PositionedObject, layer:String=null):void {

			// run Binary search to find proper location
			var insertIdx:int = binarySearch(worldObj );
			
			//insert into arrays
			m_children.splice(insertIdx, 0, worldObj);
			var displayObj:DisplayObject=worldObj.getDisplayObject();
			var spr:Sprite=this.getDisplayObject() as Sprite;
			if ( displayObj == null ){
				spr.addChildAt(worldObj.createDisplayObject(),insertIdx);
			}	else if ( displayObj.parent == null ){
				spr.addChildAt(displayObj,insertIdx);
			} else {
				displayObj.parent.setChildIndex(displayObj,insertIdx);
			}
		}


		
		/**
		 * Updates an object in the depth sorted array.
		 * 
		 * @param worldObj		Object to update.
		 */ 
		public function updateObjectInDepthArray(worldObj:PositionedObject):void {
			var displayObj:DisplayObject=worldObj.getDisplayObject();
			if ( displayObj && displayObj.parent && worldObj.isAttached()){
				//remove from depth array
				var depthIdx:int = m_children.indexOf(worldObj);
				if(depthIdx >= 0 && depthIdx < m_children.length) {		
					m_children.splice(depthIdx, 1);
				}
				
				// insert back into array:
				var insertIdx:int = binarySearch(worldObj );
				//insert into array and update display object
				m_children.splice(insertIdx, 0, worldObj);
				displayObj.parent.setChildIndex(displayObj,insertIdx);
			} else if (worldObj.isAttached()){
				insertObjectIntoDepthArray(worldObj);
			}
		}
		
		/** binary search function to find where in an array a new object should be inserted. */
		protected function binarySearch(worldObj:PositionedObject):int{
			var start:int = 0;
			var end:int = m_children.length;
			var mid:int = (start+end)>>1;
			var compare:int=0;
			//run Binary search to find proper location (Assumes already ordered array!)
			while ( start < end){
				var tempObj:PositionedObject = m_children[mid] as PositionedObject;
				compare = sortObjects(worldObj, tempObj);
				if ( compare == -1 ){
					//object is < mid
					end = mid;
					mid = (start+end)>>1;
				} else if ( compare == 1 ){
					//object is > mid
					start = mid+1;
					mid = (start+end)>>1;
				} else if ( compare == 0 ){
					// exact tie, just insert here
					break;
				}
			}	
			return mid;
		}
		
		/** @return Returns whether the object is in the same place in the depth array and the scene graph*/
		public function checkObjectDepthLocation(displayObj:DisplayObject, index:int):Boolean{
			return displayObj==displayObj.parent.getChildAt(index);
		}
		
		/** Sorts objects 
		 * @return int -1 if obj1 &lt; obj2, 1 if obj1 &gt; obj2, 0 if equal
		 */
		protected function sortObjects(obj1:Object,obj2:Object):int {
			var result:int=0;
			var priorityResult:int=0;
			var worldObj1:WorldObject=obj1 as WorldObject;
			var worldObj2:WorldObject=obj2 as WorldObject;
			var worldPos1:Vector3=worldObj1.getDepthPositionNoClone();
			var worldPos2:Vector3=worldObj2.getDepthPositionNoClone();
			var worldEndPos1:Vector3=worldObj1.getEndPosition();
			var worldEndPos2:Vector3=worldObj2.getEndPosition();
			
			// the function is written for speed, not readability.  readable version:
			/*
			var noPriority:Boolean = worldObj2.getDepthPriority()==worldObj1.getDepthPriority();
			var a:WorldObject=obj1 as WorldObject;
			var b:WorldObject=obj2 as WorldObject;
			if (a.depth &gt; b.depth){ //a's depth is greater than b
			 	if(checkCornerCases(a,b) && noPriority){
					return -1; //a is in front
				} else {
					return 1; //b is in front
				}
			} else if (b.depth &gt; a.depth){
			 	if(checkCornerCases(b,a) && noPriority){
					return 1; //b is in front
				} else {
					return -1; //a is in front
				}
			} else if (noPriority) {
			 	if(checkCornerCases(a,b)){
					return -1; //a is in front
				} else if (checkCornerCases(b,a) ){
					return 1; //b is in front
				}
			}
			// checkCornerCases checks if any part of arg2 is directly behind a part of arg1. 
			//		It is needed to handle non-square objects
			//
			// TODO the depth priority system has never been properly implemented - 
			//		all it does currently is prevent the corner cases from overriding the actual depth
			//
			// note that this algorithm still returns an 'incorrect' result when 
			//		confronted with the painter's dilema i.e.  a &gt; c, but a &lt; b &lt; c
			*/
			
			if(worldObj2.depthIndex > worldObj1.depthIndex) { 							//by depth index, obj1 is in front of obj2
				if(worldObj2.getDepthPriority()==worldObj1.getDepthPriority() && ( 		//case to handle non-square overlaps
					//check if obj2 has a section that is explicitly behind obj1 (x dimension)
					(worldPos1.x >= worldEndPos2.x && worldPos1.y < worldEndPos2.y && worldEndPos1.y > worldPos2.y) 
					|| 
					//check if obj2 has a section that is explicitly behind obj1 (y dimension)
					(worldPos1.y >= worldEndPos2.y && worldPos1.x < worldEndPos2.x && worldEndPos1.x > worldPos2.x)
					)) {
					result=-1; //obj2 is in front
				} else {
					result=1; //obj1 is in front
				}
			} else if(worldObj2.depthIndex < worldObj1.depthIndex) { 					//by depth index, obj2 is in front of obj1
				if(worldObj2.getDepthPriority()==worldObj1.getDepthPriority() && ( 		//case to handle non-square overlaps
					//check if obj1 has a section that is explicitly behind obj2 (x dimension)
					(worldPos2.x >= worldEndPos1.x && worldPos2.y < worldEndPos1.y && worldEndPos2.y > worldPos1.y) 
					||
					//check if obj1 has a section that is explicitly behind obj2 (y dimension)
					(worldPos2.y >= worldEndPos1.y && worldPos2.x < worldEndPos1.x && worldEndPos2.x > worldPos1.x)
					)) {
					result=1;//obj1 is in front
				} else {
					result=-1;//obj2 is in front
				}
			} else if (worldObj2.getDepthPriority()==worldObj1.getDepthPriority()){ // depth is equal, need to check corner cases
				if( ( 		//case to handle non-square overlaps
					//check if obj2 has a section that is explicitly behind obj1 (x dimension)
					(worldPos1.x >= worldEndPos2.x && worldPos1.y < worldEndPos2.y && worldEndPos1.y > worldPos2.y) 
					|| 
					//check if obj2 has a section that is explicitly behind obj1 (y dimension)
					(worldPos1.y >= worldEndPos2.y && worldPos1.x < worldEndPos2.x && worldEndPos1.x > worldPos2.x)
					)) {
					result=-1;//obj2 is in front
				} else if(( 		//case to handle non-square overlaps
					//check if obj1 has a section that is explicitly behind obj2 (x dimension)
					(worldPos2.x >= worldEndPos1.x && worldPos2.y < worldEndPos1.y && worldEndPos2.y > worldPos1.y) 
					||
					//check if obj1 has a section that is explicitly behind obj2 (y dimension)
					(worldPos2.y >= worldEndPos1.y && worldPos2.x < worldEndPos1.x && worldEndPos2.x > worldPos1.x)
					)) {
					result=1;//obj1 is in front
				}
			}
			return result;
		}
		
		/**
		 * Removes an object from the depth sorted array.
		 * 
		 * @param worldObj		Object to remove.
		 */ 
		public function removeObjectFromDepthArray(worldObj:PositionedObject):void {
			var depthIdx:int = m_children.indexOf(worldObj);
			
			if(depthIdx >= 0 && depthIdx < m_children.length) {		
				m_children.splice(depthIdx, 1);
				
				// Remove from the canvas
				var displayObj:DisplayObject=worldObj.getDisplayObject();
				if(displayObj && displayObj.parent) {
					displayObj.parent.removeChild(displayObj);
				}
			}			
		}			
		
		/** @inherit */ 
		override public function pickObject(mousePos:Point, objectType:uint=Constants.WORLDOBJECT_ALL, requiredFlags:uint=Constants.OBJECTFLAG_NONE):PositionedObject {
			var objIdx:int;
			var result:PositionedObject = null;
			
			// Go from closest to furthest when picking objects.
			for(objIdx=m_children.length-1; objIdx>=0; objIdx--) {
				var curObject:PositionedObject = m_children[objIdx] as PositionedObject;
				
				// Check object type first.
				result = curObject.pickObject(mousePos, objectType, requiredFlags) as PositionedObject;
				
				if(result != null) {
					break;
				}
			}
			
			return result;	
		}		
	}
}