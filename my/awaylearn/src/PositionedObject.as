/**
 *	PositionedObject.as
 *    
 * 	This class defines the base class for all world objects.  World objects are walls, items, sticky notes, anything that's placeable in the level.
 *
 * @package ZEngineCore
 * @copyright Copyright (&copy;) 2010, Zynga Game Network, Inc.
 */
package Engine.Classes {
	import Engine.Constants;
	import Engine.Helpers.Box3D;
	import Engine.Helpers.Vector2;
	import Engine.Helpers.Vector3;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	
	public class PositionedObject extends EngineObject {
		/** The type of object this is */
		protected var m_objectType:int=Constants.WORLDOBJECT_UNKNOWN;
		
		/** Property flags for this object */
		protected var m_objectFlags:int=Constants.OBJECTFLAG_NONE;
		
		/** Position of the object in tile space */
		protected var m_position:Vector3=new Vector3;
		
		/** Object position in screen space. */
		protected var m_screenPosition:Point;
		
		/** Size of the object in tile space */
		protected var m_size:Vector3=new Vector3;
		
		/** DisplayObject for this world object */
		protected var m_displayObject:DisplayObject=null;
		
		/** Whether or not this world object's display object is dirty and requries a complete reload. */
		protected var m_displayObjectDirty:Boolean=false;
		
		/** Whether or not this world object's position is dirty and requires a refresh. */
		protected var m_transformDirty:Boolean=false;
		
		/** Whether or not the world object is visible */
		protected var m_visible:Boolean=true;
		
		/** The last position we attached to the level at */
		protected var m_attachPosition:Vector3=null;
		
		/** The last size we attached to the level at. */
		protected var m_attachSize:Vector3=null;
		
		/** Whether or not this object is highlighted */
		protected var m_highlighted:Boolean;
		
		/** Whether or not the object is culled */
		protected var m_culled:Boolean;

		/** Memory space for the end position instead of allocating it every time it is needed*/
		protected var m_endPosition:Vector3 = new Vector3;
				
		/** Constructor **/
		public function PositionedObject():void {
			super();
		}
		
		/** Whether or not the object can be picked */
		public function isPickable():Boolean{
			return true;
		}
		
		/** @inherit */
		override public function getSaveObject():Object {
			var obj:Object=super.getSaveObject();
			obj.position=m_position;
			return obj;
		}
		
		/** @inherit */
		override public function loadObject(data:Object):void {
			super.loadObject(data);
			//new Vector3(inX:Number=0.0, inY:Number=0.0, inZ:Number=0.0)
			m_position = new Vector3(data.position.x,data.position.y,data.position.z);
		}
		
		/** @return 	Returns the type of this object. */
		public function getObjectType():int {
			return m_objectType;
		}
		
		/** @return		Returns a reference to this */
		public function getReference():PositionedObject {
			return this; 
		}

		/**
		 * Checks to see if the object type matches the object type mask provided.
		 * 
		 * @param typeMask		A bitmask of WORLDOBJECT types.
		 * 
		 * @return 	true if this object is of a type contained within the mask, false otherwise.
		 */ 
		public function checkObjectType(typeMask:uint):Boolean {
			return ((m_objectType & typeMask) > 0);
		}
		
		/**
		 * Checks to see if the object has all of the flags specified.
		 * 
		 * @param flagMask		A bitmask of OBJECTFLAG flags.
		 * @param allFlags		Whether to check to see if ALL flags are present or not.  If this is false, this func will return true when any of the flags are present.
		 * 
		 * @return 	true if this object has the flags specified.
		 */ 
		public function checkObjectFlags(flagMask:uint, allFlags:Boolean=true):Boolean {
			if(allFlags) {
				return ((m_objectFlags & flagMask) == flagMask);
			} else {
				return ((m_objectFlags & flagMask) > 0);
			}
		}				
				
		/**
		 * @return Returns the position of the world object.
		 */
		public function getPosition():Vector3 {
			return m_position.clone();
		}  
		
		/**
		 * @return Returns the position of the world object without memory allocation.
		 */
		public function getPositionNoClone():Vector3 {
			return m_position;
		}  
		
		/**
		 * @return Returns the ending position of the world object. (position + size)
		 */
		public function getEndPosition():Vector3 {
			m_endPosition.x = m_position.x + m_size.x;
			m_endPosition.y = m_position.y + m_size.y;
			m_endPosition.z = m_position.z + m_size.z;
			return m_endPosition;
		}  
				
		/**
		 * @return Returns the screen position of the world object.
		 */
		public function getScreenPosition():Point {
			return m_screenPosition.clone();
		}  		
		
		/**
		 * @return Returns the size of the world object without memory allocation.
		 */
		public function getSizeNoClone():Vector3 {
			return m_size;
		}  			
		
		/**
		 * @return Returns the size of the world object.
		 */
		public function getSize():Vector3 {
			return m_size.clone();
		}  			
		
		/** @return Returns the bounding box for this world object. */
		public function getBoundingBox():Box3D {
			return new Box3D(m_position, m_size);
		}		
		
		/** @return	Whether or not this object should be culled */
		public function isWithinViewport():Boolean {
			var result:Boolean=false;
			if(m_displayObject) {
				result=true;
				
				var objRect:Rectangle=m_displayObject.getRect(GlobalEngine.viewport);
				if(0 >= objRect.right || 0 >= objRect.bottom || GlobalEngine.stage.stageWidth <= objRect.x || GlobalEngine.stage.stageHeight <= objRect.y) {
					result=false;
				}
			}
			
			return result;
		}
		
		/**
		 * Checks to see if the specified pixel exists within this world object's screen representation.
		 * 
		 * @param pixel		Pixel to check with.
		 * 
		 * @return		true if the pixel is inside, false otherwise.
		 */
		public function isPixelInside(pixel:Point):Boolean {
			var result:Boolean=false;
			
			if(m_displayObject) {
				if(m_displayObject.getRect(m_displayObject.parent).containsPoint(pixel)) {
					result=true;
				}
			}
			
			return result;
		}
	
		/**
		 * Sees if one object is completely within another item's bounds.
		 * 
		 * @param other			Object that we are checking to see if we contain.
		 * 
		 * @return Returns true if the other item is within the bounds of this item.
		 */ 
		public function isWithinBounds(other:PositionedObject):Boolean	{
			var pos:Vector3 = getPosition();
			var endPos:Vector3 = getEndPosition();
			var otherPos:Vector3 = other.getPosition();
			var otherEndPos:Vector3 = other.getEndPosition();
						
			return (pos.x <= otherPos.x && pos.y <= otherPos.y && endPos.x >= otherEndPos.x && endPos.y >= otherEndPos.y);
		}
		
		/** Updates culling state for the object */
		public function updateCulling():void {
			m_culled=(isWithinViewport()==false);
			setVisible(m_visible);
		} 
			
		/**
		 * Sets visibility of the world object.
		 * 
		 * @param visible	Whether or not the object should be visible.
		 */
		public function setVisible(visible:Boolean):void {
			m_visible=visible;
			
			if(m_displayObject) {
				m_displayObject.visible=visible && m_culled==false;
			}
		} 
		
		/** @return Returns whether or not the object is visible. */
		public function isVisible():Boolean {
			return m_visible && m_culled==false;
		}
	
		/**
		 * Sets the alpha of the world object.
		 * 
		 * @param alpha		New alpha for the world object
		 */
		public function set alpha(alpha:Number):void {
			if(m_displayObject) {
				m_displayObject.alpha=alpha;
			}
		} 
		
		/** @return	The alpha of the world object */
		public function get alpha():Number {
			var result:Number=1.0;
			
			if(m_displayObject) {
				result=m_displayObject.alpha;
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
		public function setPosition(newX:Number, newY:Number, newZ:Number=0.0):void {
			if(m_position.x != newX || m_position.y != newY || m_position.z != newZ) {
				var delta:Vector3 = new Vector3(newX-m_position.x, newY-m_position.y, newZ-m_position.z);
				m_position = new Vector3(newX, newY, newZ);

				// Set the transform dirty flag to true so we update depth
				m_transformDirty=true;		
			}
		}
		
		/**
		 * Translates this object by the delta specified.
		 * 
		 * @param delta		Delta to translate the object by.
		 */
		public function translate(delta:Vector3):void {
			setPosition(m_position.x+delta.x, m_position.y+delta.y, m_position.z+delta.z);
		}
				
		/**
		 * Sets the size of the world object.
		 * 
		 * @param newSizeX	New size X 
		 * @param newSizeY	New size Y 
		 * @param newSizeZ	New size Z 
		 */ 
		public function setSize(newSizeX:Number, newSizeY:Number, newSizeZ:Number=0.0):void {
			if(m_size.x != newSizeX || m_size.y != newSizeY || m_size.z != newSizeZ) {	
				m_size = new Vector3(newSizeX, newSizeY, newSizeZ);
				
				// Set the transform dirty flag to true so we update depth
				m_transformDirty=true;
			}
		}
		
		
		/** @return	Returns whether or not this object is attached to the level. */
		public function isAttached():Boolean {
			return (m_attachPosition!=null);
		}			
		
		/** @return Returns the last attachment position for this object. */
		public function getAttachPosition():Vector3 {
			return m_attachPosition.clone();
		}
		
		/** @return Returns the last attachment size for this object. */
		public function getAttachSize():Vector3 {
			return m_attachSize.clone();
		}			
		
		/**
		 * Checks to see if 2 positioned objects intersect
		 * 
		 * @param checkObj	Object to check for intersection.
		 * 
		 * @return	TRUE if there is an intersection, false otherwise.
		 */ 
		public function intersects(checkObj:PositionedObject):Boolean {
			var pos:Vector3=getPosition();
			var endPos:Vector3=getEndPosition();
			var otherPos:Vector3=checkObj.getPosition();
			var otherEndPos:Vector3=checkObj.getEndPosition();
			var result:Boolean=true;	
			
			if(endPos.x <= otherPos.x || pos.x >= otherEndPos.x ||
			   endPos.y <= otherPos.y || pos.y >= otherEndPos.y ||
			   (endPos.z!=pos.z && otherPos.z!=otherEndPos.z && (endPos.z < otherPos.z || pos.z > otherEndPos.z))) {
			   	result=false;
			} 
			
			return result;
		}	
		
		/** @return Whether or not the object is placeable at the current location. */
		public function isCurrentPositionValid():Boolean {
			return true;	
		}		
					
		/** @return	Returns a contextual cursor for this object */
		public function getCursor():Class {
			return null;
		}
		
		/**
		 * Sets whether or not this object is highlighted.  If it is highlighted, it has a glow filter applied to its display object. 
		 * 
		 * @param highlighted	Whether or not to highlight the object. 
		 * @param color			Optional color to use for the highlight effect, defaults to Constants.COLOR_HIGHLIGHT
		 */
		public function setHighlighted(highlighted:Boolean, color:uint=Constants.COLOR_HIGHLIGHT):void {
			if(m_displayObject) {
				m_highlighted=highlighted;
				if(highlighted) {
					m_displayObject.filters = [new GlowFilter(color,1,16,16,4)];
				} else {
					m_displayObject.filters = [];
				}
			}
		}		
		
		/** @return Whether or not the object is currently highlighted */
		public function isHighlighted():Boolean {
			return m_highlighted;
		}
		
		/** @return Returns whether or not the object can be interacted with. */
		public function isInteractable():Boolean {
			return (m_objectFlags & Constants.OBJECTFLAG_INTERACTIVE)>0;
		}
		
		/** @return Returns whether or not the object has a mouse over state. */
		public function hasMouseOver():Boolean {
			return false;
		}
		
		
		/**
		 * Picks an object from this object given a mouse click location.
		 * 
		 * @param mousePos			Position of the mouse click, relative to the world base.
		 * @param objectType		The type of objects to pick.  By default we pick ALL objects.
		 * @param requiredFlags		Flags the object must possess to be selected.  By default no flags are required.
		 */ 
		public function pickObject(mousePos:Point, objectType:uint=Constants.WORLDOBJECT_ALL, requiredFlags:uint=Constants.OBJECTFLAG_NONE):PositionedObject {
			var result:PositionedObject=null;
			
			if(isPickable() && checkObjectType(objectType) && checkObjectFlags(requiredFlags)) {
				if(isVisible() && isPixelInside(mousePos)) {
					result = this.getReference();
				}
			}
			
			return result;
		}
				
		/**************************
		 * 
		 * Display object interface
		 *  
		 **************************/ 
		
				
		/**
		 * Redraws the display object for this world object.
		 * 
		 * This is called to redraw the display object in the case where it is dirty.
		 */
		public function drawDisplayObject():void {
		}
				
		/**
		 * Creates the display objects for this world object.
		 * 
		 * @return Returns the display object for this world object, may be null!
		 */
		public function createDisplayObject():DisplayObject {
			return null;
		}
		
		
		/**
		 * Updates the display objects for this world object.
		 */
		public function updateDisplayObjectTransform():void {
		}
				
		/**
		 * Cleans up the old display object and removes it from its owning display container.
		 */ 
		public function deleteDisplayObject():void {
			if(m_displayObject != null) {
				if(m_displayObject.parent!=null) {
					m_displayObject.parent.removeChild(m_displayObject);
				}
				
				m_displayObject=null;
				m_displayObjectDirty=true;
			}	
		}
		
		/**
		 * @return Returns the display object for this world object.  May be null!
		 */ 
		public function getDisplayObject():DisplayObject {
			return m_displayObject;
		}
		
		/** @return Returns whether or not the display object for this world object is dirty and needs to be recreated. */
		public function isDisplayObjectDirty():Boolean {
			return m_displayObjectDirty || (m_displayObject==null);
		}
				
		/**
		 * Sets the display object dirty flag
		 * 
		 * @param dirty		Dirty or not.
		 */
		public function setDisplayObjectDirty(dirty:Boolean):void {
			m_displayObjectDirty=dirty;	
		}
		 
		/** @return Returns the actual display object size for this world object. */
		public function getActualDisplayObjectSize():Vector2 {
			var result:Vector2 = new Vector2();
			
			if(m_displayObject != null) {
				result.x=m_displayObject.width;
				result.y=m_displayObject.height;
			}
			
			return result;
		}					 
	}
}