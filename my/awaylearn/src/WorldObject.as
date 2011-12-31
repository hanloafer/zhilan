/**
 *	WorldObject.as
 *    
 * 	This class defines the base class for all world objects.  World objects are walls, items, sticky notes, anything that's placeable in the level.
 * 
 * 
 *
 * @package ZEngineIso
 * @copyright Copyright (&copy;) 2010, Zynga Game Network, Inc.
 */
package Engine.Classes {
	import Engine.Constants;
	import Engine.Helpers.Vector3;
	import Engine.Interfaces.IEngineObject;
	import Engine.Interfaces.IRenderObject;
	import Engine.IsoMath;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.getTimer;
	
	public class WorldObject extends PositionedObject implements IEngineObject, IRenderObject {
		
		/** Type of world object */
		protected var m_typeName:String;
		
		/** Outer container of this world object */
		protected var m_outer:World;
		
		/** Direction the object is rotated to face. */				
		protected var m_direction:int;
		
		/** Index of this object in the global depth array. */
		protected var m_depthIndex:int=0;
		
		/** Collision flags for this world object.  These specify what the object can collide with. */
		protected var m_collisionFlags:int=Constants.COLLISION_ALL;
		
		/** Parent of this world object.  Objects move with their parents and are always drawn before them. */
		protected var m_parent:WorldObject=null;
		
		/** World Objects which are children of this object */					
		protected var m_children:Array=new Array();
		
		/** Last update time */ 
		private var m_lastUpdateTime:Number=0; 

		/** Whether or not the render buffer for this object is dirty */
		public var renderBufferDirty:Boolean = true;
				
		/** The shard that this object is assigned to (range is 0 to m_maxNumShards)*/
		private var m_shard:int=0;
		
		/** The animation bucket index this object was inserted into */
		protected var m_animationBucket:int;
				
		/** Constructor **/
		public function WorldObject() {
			super();
		}		
		
		/** @inherit */
		public function get children():Array {
			return [];
		}
		
		/** @return Returns the type name for this object. */
		public function getTypeName():String {
			return m_typeName;
		}  
		
		/** @return	Returns all of the assets referenced by this object. */
		public function getReferencedAssets():Array {
			return [];
		}
		
		/** @inherit */
		override public function getSaveObject():Object {
			var obj:Object=super.getSaveObject();
			obj.direction=m_direction;
			return obj;
		}
		
		/** @inherit */
		override public function loadObject(data:Object):void {
			super.loadObject(data);
			m_direction = data.direction;
		}
		
		/** Allows this object to perform any cleanup of references. */
		public function cleanUp():void {
			m_outer=null;
			m_parent=null;
			m_children=[];
		}
		
		/** Updates the delta from the last time it was updated */ 
		public final function update():void{
			//update this object only if it's in the current shard
			if(m_outer){
				var delta:Number = m_outer.getShardDelta(m_shard)
				if(delta >= 0){
					onUpdate(delta);
				}
			}
				
			// if the object has children, update the children
			for(var objIdx:int=0; objIdx<m_children.length; objIdx++) {
				m_children[objIdx].update();
			}
		}
		
		/** @inherit */
		public function render( context:RenderContext ):void {
			// Override
		}
		
		/** Informs the world that it needs to refresh the all objects list */
		protected function setObjectsDirty():void{
			if(m_outer){
				this.m_outer.setObjectsDirty();
			}
		}
				
		/**
		 * Deletes the object and adds it to a deletion list if it has a valid ID.
		 * 
		 * @param shouldBeDeleted	Whether or not the object should be deleted.
		 */
		override public function markForDeletion(shouldBeDeleted:Boolean):void {
			super.markForDeletion(shouldBeDeleted);
			
			if(shouldBeDeleted) {
				m_outer.addToDeletionList(this);
			} else {
				m_outer.removeFromDeletionList(this);
			}
		}	
		
		/** Increments the transaction counter for this object. */
		public function incrementTransactionsForChildren():void {
			for(var childIdx:int=0;childIdx<m_children.length; childIdx++) {
				m_children[childIdx].incrementTransactions();
			}
		} 
		
		/** Decrements the transaction counter for this object. */
		public function decrementTransactionsForChildren():void {
			for(var childIdx:int=0;childIdx<m_children.length; childIdx++) {
				m_children[childIdx].decrementTransactions();
			}
		} 
						
		/**
		 * Checks to see if 2 objects are intersecting.
		 * 
		 * @param other			Other object to check intersection with.
		 * 
		 * @return		true if the objects are intersecting, false otherwise.
		 */ 
		public function isIntersecting(other:WorldObject):Boolean {
			var depthPos:Vector3 = getDepthPosition();
			var depthSize:Vector3 = getDepthSize();
			var otherPos:Vector3 = other.getDepthPosition();
			var otherSize:Vector3 = other.getDepthSize();
			
			var maxPos:Vector3 = depthPos.add(depthSize);
			var otherMaxPos:Vector3 = otherPos.add(otherSize);
			var result:Boolean = false;
			
			if(maxPos.x < otherPos.x || depthPos.x > otherMaxPos.x ||
			   maxPos.y < otherPos.y || depthPos.y > otherMaxPos.y ||
			   maxPos.z < otherPos.z || depthPos.z > otherMaxPos.z) {
			   	result=false;
			} else {
				if((depthSize.x==0 && otherSize.x > 0 && (otherPos.x >= depthPos.x || otherMaxPos.x <= depthPos.x)) || 
				   (depthSize.y==0 && otherSize.y > 0 && (otherPos.y >= depthPos.y || otherMaxPos.y <= depthPos.y)) || 
				   (otherSize.x==0 && depthSize.x > 0 && (depthPos.x >= otherPos.x || maxPos.x <= otherPos.x)) || 
				   (otherSize.y==0 && depthSize.y > 0 && (depthPos.y >= otherPos.y || maxPos.y <= otherPos.y))) {
					return false
				}
				
				result = true;
			}
			
			return result;   
		}
		
		/**
		 * Set the position of the world object
		 * 
		 * @param newX		New X position for the item instance.
		 * @param newY		New Y position for the item instance.
		 * @param newZ		New Z position for the item instance.
		 */ 
		override public function setPosition(newX:Number, newY:Number, newZ:Number=0.0):void {
			if(m_position.x != newX || m_position.y != newY || m_position.z != newZ) {
				var delta:Vector3 = new Vector3(newX-m_position.x, newY-m_position.y, newZ-m_position.z);
				m_position = new Vector3(newX, newY, newZ);
				
				if(m_outer != null) {
					m_screenPosition = IsoMath.tilePosToPixelPos(m_position.x, m_position.y, m_position.z, true);
				}
			
				// Set the transform dirty flag to true so we update depth
				m_transformDirty=true;
				
				// Move all our children as well
				for(var childIdx:int=0; childIdx<m_children.length; childIdx++) {
					var child:WorldObject = m_children[childIdx] as WorldObject;
					child.translate(delta);
				}				
			}
		}  
		
		/**
		 * Sets the direction for the item.
		 * 
		 * @param direction 	The new direction for the item
		 */ 
		public function setDirection(direction:int):void {
			m_direction=direction;
		}
		
		/**
		 * Sets the collision flags for this object.
		 * 
		 * @param newFlags	New collision flags.
		 */
		public function setCollisionFlags(flags:uint):void {
			m_collisionFlags=flags;
		}  
		
		/** 
		 * Retrieves collision flags for the object at the specified point
		 * 
		 * @param x		Local X position  (Between 0 and width-1)
		 * @param y		Local Y position  (Between 0 and height-1)
		 * 
		 * @return		A set of collision flags for the current position 
		 */ 
		public function getCollisionFlags(x:int, y:int):int {
			return m_collisionFlags;
		} 
		
		/**
		 * Sees if the object is collidable internally at the given point
		 * 
		 * @param x		Local X position  (Between 0 and width-1)
		 * @param y		Local Y position  (Between 0 and height-1)
		 * @param flags	Flags of the object we are colliding with
		 *
		 * @return	TRUE if the object is collidable at the position, false otherwise
		 */
		public function checkInternalCollision(x:int, y:int,flags:int):Boolean {
			return CollisionMap.compareCollisionFlags(getCollisionFlags(x, y), flags);
		}  
			
		/**
		 * Sets the outer that this object belongs to.
		 * 
		 * @param outer		Outer container that the object belongs to.
		 */ 
		public function setOuter(outer:World):void {
			m_outer=outer;
			if(outer != null){
				m_shard=m_outer.getRandomShard();
			}
		}
		
		/** @return Returns the outer container for this world object. */
		public function getOuter():PositionedObjectContainer {
			return m_outer;
		}
		
		/** @return	Returns the current direction for the item. */
		public function getDirection():int {
			return m_direction;
		}
		
		/** @return Returns the size of the world object used for depth testing. */
		public function getDepthSize():Vector3 {
			return m_size.clone();
		}  					
		
		/** @return	Returns the depth priority for this object.  0.0 is default priority.  &gt;0 is closer to the screen, &lt;0 is further from the screen. */
		public function getDepthPriority():Number {
			return 0.0;
		}
				
		/** @return Returns the position of the world object used for depth testing. */
		public function getDepthPosition():Vector3 {
			return m_position.clone();
		}		
		/** @return NEVER MODIFY THE RETURN OF THIS FUNCTION!!! Returns the position of the world object used for depth testing. */
		public function getDepthPositionNoClone():Vector3 {
			return m_position;
		}		
				
		/** @return Returns whether or not the world object is collidable. */
		public function isCollidable():Boolean {
			return m_collisionFlags != 0;
		}
		
		/** @return	Returns the name of the layer for this object to live on */
		protected function getLayerName():String {
			return null;
		}
		
		/** Attaches this object to the level.  Attaching to a level involves adding it to the level's display list and collision maps. */ 
		public function attach():void {
			GlobalEngine.assert(m_outer != null, "Outer for WorldObject is null!");
			
			if(m_attachPosition==null) {
				
				calculateDepthIndex();
				m_outer.insertObjectIntoDepthArray(this, getLayerName());
				setObjectsDirty();
				m_outer.insertObjectIntoCollisionMap(this);
				m_animationBucket = m_outer.insertItemIntoAnimationBucket(this);
				
				updateDisplayObjectTransform();
				updateCulling();
				
				m_attachPosition=m_position.clone();
				m_attachSize=m_size.clone();
								
				m_transformDirty=false;
			}
		}
		
		/** @inherit */
		public function detach():void {
			if(m_attachPosition != null && m_outer != null) {
				m_outer.removeObjectFromCollisionMap(this);
				m_outer.removeObjectFromDepthArray(this);
				m_outer.removeItemFromAnimationBucket(this, m_animationBucket);
				m_attachPosition=null;
				m_attachSize=null;
				m_displayObjectDirty=true;
				setObjectsDirty();
			}
		}
		
		/** @deprecated - This function is misnamed */
		public function detatch():void {
			this.detach();
		}  
		
		/**
		 * Conditionally redraws the display object for this world object.
		 * 
		 * @param forceRedraw	Whether or not to always redraw
		 */
		public function conditionallyRedraw(forceRedraw:Boolean=false):void {
			if(m_outer != null && m_outer.isRedrawLocked()==false && (m_displayObjectDirty || forceRedraw)) {
				drawDisplayObject();
				updateCulling();
				toggleAnimation();
				m_displayObjectDirty=false;
			}
		}		
		
		/**
		 * Reattaches this object to the level.  This involves updating its depth in the depth array
		 * and collision map entries.  Note that in order for a position or size change to take affect, this MUST be called.
		 * 
		 * @param force		Whether or not to force a reattach or not.
		 */
		public function conditionallyReattach(force:Boolean=false):void {
			if(isAttached()==false) {
				attach();
			} else if(force || m_transformDirty || m_displayObjectDirty || (m_attachPosition==null)) {
				// Remove from collision map first since we need our old transform info to do that
				m_outer.removeObjectFromCollisionMap(this);
				setObjectsDirty();
				// Update the display object for this world object.  
				// If the display object is also dirty, then we need to redraw it.
				if(m_displayObjectDirty) {
					drawDisplayObject();
				} else {
					updateDisplayObjectTransform();
				}
				
				// Update level attachments
				calculateDepthIndex();
				m_outer.updateObjectInDepthArray(this);
				m_outer.insertObjectIntoCollisionMap(this);
				updateCulling();
			
				// Store last attach position/size
				m_attachPosition=m_position.clone();
				m_attachSize=m_size.clone();
				
				// Reset the transform dirty flag to true so we update depth
				m_transformDirty=false;		
			}
			
			// Try to reattach all our children as well
			for(var childIdx:int=0; childIdx<m_children.length; childIdx++) {
				var child:WorldObject = m_children[childIdx] as WorldObject;
				child.conditionallyReattach();
			}				
		}
		
		/** @inherit */
		override public function updateCulling():void {
			super.updateCulling();
			
			for(var objIdx:int=0; objIdx<m_children.length; objIdx++) {
				var worldObj:PositionedObject = m_children[objIdx] as PositionedObject;
				
				if(worldObj != null) {
					worldObj.updateCulling();
				}
			}
		}
		
		/** Generates a sprite with an outline of this object's bounding region. */ 
		public function getBoundingBoxSprite(spr:Sprite=null):DisplayObject {
			if(spr == null) {
				spr = new Sprite();
			}
			
			var pixelPos:Point = IsoMath.tilePosToPixelPos(m_position.x, m_position.y, m_position.z);
			var deltaX:Point = IsoMath.tilePosToPixelPos(m_position.x+m_size.x, m_position.y, m_position.z);
			var deltaY:Point = IsoMath.tilePosToPixelPos(m_position.x, m_position.y+m_size.y, m_position.z);
			var endPos:Point = IsoMath.tilePosToPixelPos(m_position.x+m_size.x, m_position.y+m_size.y, m_position.z);
			
			spr.graphics.lineStyle(3,0xFF6600);
			spr.graphics.moveTo(pixelPos.x, pixelPos.y);
			spr.graphics.lineTo(pixelPos.x, pixelPos.y-m_size.z);
			spr.graphics.lineTo(deltaY.x, deltaY.y-m_size.z);
			spr.graphics.lineTo(deltaY.x, deltaY.y);
			spr.graphics.lineTo(pixelPos.x, pixelPos.y);
			
			//spr.graphics.lineTo(pixelPos.x, pixelPos.y-m_size.z);
			//spr.graphics.lineTo(pixelPos.x, pixelPos.y-m_size.z);
			
			
			
			
			
			return spr;
		}
		
		/**** Depth interface ****/
		
		
		/** @return	Returns the position of the tile furthest from the viewer. */
		public function getFurthestTilePosition():Vector3 {
			var depthPos:Vector3 = getDepthPosition();
			var depthSize:Vector3 = getDepthSize();
			
			var world:World=World.getInstance();
			var offsetPosition:Vector3 = new Vector3();
			switch(world.getRotation()) {
				case Constants.ROTATION_0:
					offsetPosition.x=depthSize.x;
					offsetPosition.y=depthSize.y;
				break;
				case Constants.ROTATION_90:
					offsetPosition.y=depthSize.y;
				break;
				case Constants.ROTATION_180:					
				break;														
				case Constants.ROTATION_270:
					offsetPosition.x=depthSize.x;
				break;							
			}	
			
			return depthPos.add(offsetPosition);		
		}
		
		/** Calculates the depth index for this object */
		protected function calculateDepthIndex():void {
			var realPos:Vector3 = getNearestTilePosition();
			var endPos:Vector3 = getFurthestTilePosition();
			var midX:Number=(realPos.x+endPos.x)/2.0;
			m_depthIndex=(midX+(realPos.y+endPos.y)/2.0)*1000+midX;
		}
		
		/** @return Returns the depth index for this object */
		public function get depthIndex():Number {
			return m_depthIndex;
		}
		
		/** @return	Returns the position of the tile nearest to the viewer. */
		public function getNearestTilePosition():Vector3 {
			return getOriginPoint(m_outer.getRotation());				
		}
		
		/** 
		 * Retrieves the origin point of the object given a rotation.
		 * 
		 * @param rotation	The point of he
		 * 
		 * @return	Returns the origin point of the object in un-rotated space.
		 */
		public function getOriginPoint(rotation:int):Vector3 {
			var depthPos:Vector3 = getDepthPosition();
			var depthSize:Vector3 = getDepthSize();
			
			var offsetPosition:Vector3 = new Vector3();
			switch(rotation) {
				case Constants.ROTATION_0:
				break;
				case Constants.ROTATION_90:
					offsetPosition.x=Math.max(0,depthSize.x);
				break;
				case Constants.ROTATION_180:
					offsetPosition.x=Math.max(0,depthSize.x);
					offsetPosition.y=Math.max(0,depthSize.y);					
				break;														
				case Constants.ROTATION_270:
					offsetPosition.y=Math.max(0,depthSize.y);
				break;							
			}	
			
			return depthPos.add(offsetPosition);	
		}
				
		/**
		 * Compares the depth of 2 world objects.
		 *
		 * @param 	other		Other object to compare depth against.
		 * 
		 * @return Returns a negative number if this object is closer to the camera than the other object, positive if it is further, 0 if it is the same. 
		 */
		public function compareDepth(other:WorldObject):int {
			var result:int=0;
			
			// Parent check, parent's are always drawn BEHIND their children
			if(other.getParent()==this) {
				return 1;
			} else if(getParent()==other) {
				return -1;
			}
			
			if(isIntersecting(other)) {
				var depthPriority:Number = getDepthPriority();
				var otherPriority:Number = other.getDepthPriority();
				
				if(depthPriority < otherPriority) {
					return 1;
				} else if(depthPriority > otherPriority) {
					return -1;
				}
			}
			
			var depthIndex:Number=this.depthIndex;
			var otherDepthIndex:Number=other.depthIndex;
			
			if(depthIndex<otherDepthIndex) {
				result=-1;
			} else if(otherDepthIndex<depthIndex) {
				result=1;
			} else {
				result=0;
			}
		
			return result;
		}
		
		
		/** Children interface */
		
		/** @return	Returns the array of children for this object. */
		public function getChildren():Array {
			return m_children.concat([]);	// this clones the array
		}
		
		/**
		 * Sets the parent for this object.
		 * 
		 * @param parent	New parent for the object, can be null.
		 */
		public function setParent(parent:WorldObject):void {
			if(m_parent != parent) {
				if(m_parent != null) {
					m_parent.removeChild(this);
				}
				
				m_parent = parent;
				
				if(parent != null) {
					parent.addChild(this);
				}
				
				m_transformDirty=true;
				
				// Callback for when the parent of this object has changed.
				onParentChanged();
			}
		}  
		
		/** @return 	Returns the parent for this world object. */
		public function getParent():WorldObject {
			return m_parent;
		}
		
		/**
		 * Adds a child to this world object.
		 * 
		 * @param child		Child to add
		 */ 
		public function addChild(child:WorldObject):void {
			if(m_children.indexOf(child)==-1) {
				m_children.push(child);	
				
				if(child.getParent() != this) {
					child.setParent(this);
				}
			}
		}
		
		/**
		 * Removes a child from this world object.
		 * 
		 * @param child		Child to remove
		 */ 
		public function removeChild(child:WorldObject):void {
			var childIdx:int = m_children.indexOf(child);
			
			if(childIdx != -1) {
				m_children.splice(childIdx,1);
				
				if(child.getParent() == this) {
					child.setParent(null);
				}
			}
		}
		
		/** Removes all children from this object. */
		public function removeAllChildren():void {
			var oldChildren:Array = getChildren();
			
			for(var childIdx:int=0; childIdx<oldChildren.length; childIdx++) {
				var child:WorldObject = oldChildren[childIdx] as WorldObject;
				child.setParent(null);
			}
			
			m_children = [];
		}
		
		/**
		 * Checks to see if a object is a child of this object or not.
		 * 
		 * @param worldObj		Object to check to see is a child
		 * 
		 * @return	true if the object is a child, false otherwise.
		 */ 
		public function isChild(worldObj:WorldObject):Boolean {
			return (m_children.indexOf(worldObj)!=-1);
		}		
		
		/** Callback for when the parent of this object has changed. */
		public function onParentChanged():void {
			// Do nothing by default.
		}
		
		/** turns animation on or off based on Global.playAnimations*/		
		public function toggleAnimation():void{
			
		}
		
		/** Centers on this object in the viewport */
		public function centerOn():void {
			World.getInstance().centerOnObject(this);
		}
		
		/** cleanup objecy, release memory etc. */
		public function cleanup():void {
		}
	}
}