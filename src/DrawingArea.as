// ActionScript file
package
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.graphics.codec.PNGEncoder;
	
	[Bindable]
	public class DrawingArea extends UIComponent
	{
		protected var isDrawing:Boolean = false;
		protected var x1:int;
		protected var y1:int;
		protected var x2:int;
		protected var y2:int;
		protected var _points:Array;
		
		//public var drawColor:uint = 0xC5D8DA;
		public var drawColor:uint = 0x000000;
		
		public function DrawingArea()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void {
				erase();
			});
			
			addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
				x1 = mouseX;
				y1 = mouseY;
				
				//////
				_points= new Array();
				var p:Point = new Point (x1, y1);
				_points.push(p);
				//////
				//_points.length=1;
				//_points[0]=new Point(mouseX, mouseY);
				//_points.push(p);
				//////	
				
				isDrawing = true;
				graphics.clear();
				
				graphics.beginFill(0xffffff, 0.00001);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			});				
			
			
			
			addEventListener(MouseEvent.MOUSE_MOVE, function(event:MouseEvent):void {
				if (!event.buttonDown)
				{
					isDrawing = false;
				}
				
				x2 = mouseX;
				y2 = mouseY;
				
				if (isDrawing)
				{
					////
					var p:Point = new Point(x2, y2);
					_points.push(p);
					////
					//graphics.lineStyle(2, drawColor,0);
					graphics.lineStyle(2, drawColor,1);
					graphics.moveTo(x1, y1);
					graphics.lineTo(x2, y2);
					
					////
					//
					//_points[_points.length]=new Point(x2,y2);//append
					//
					////
					
					x1 = x2;
					y1 = y2;
					
				}
			});
			
			addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void {
				isDrawing = false;
				
			});
		}
		public function getPoints():Array {
			return _points;
		}
		
		public function erase():void
		{
			graphics.clear();
			
			graphics.beginFill(0xffffff, 0.00001);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		public function save():void
		{
			var bd:BitmapData = new BitmapData(width, height);
			bd.draw(this);
			
			var ba:ByteArray = (new PNGEncoder()).encode(bd);
			(new FileReference()).save(ba, "doodle.png");
		}
		
	}
}