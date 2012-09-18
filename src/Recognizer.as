// ActionScript file
package 	
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.charts.AreaChart;
	import mx.messaging.channels.StreamingAMFChannel;
	
	import spark.primitives.Rect;

   // Rectangle class

	public class Recognizer {
		
		public static var NumPoints:int = 64;
		public static var SquareSize:Number = 250.0;
		public static var HalfDiagonal:Number = 0.5 * Math.sqrt(250.0 * 250.0 + 250.0 * 250.0);
		public static var AngleRange:Number = 45.0;
		public static var AnglePrecision:Number = 2.0;
		public static var Phi:Number = 0.5 * (-1.0 + Math.sqrt(5.0)); // Golden Ratio
		
		public var templates:Array;
		//
		// DollarRecognizer class
		//
		public function Recognizer() // constructor
		{  
			this.templates=new Array();
	
			this.templates[0] = new Template("answer", new Array(
				new Point(-150,0),new Point(-144,27),new Point(-136,46),new Point(-128,59),new Point(-120,72),new Point(-111,77),
				new Point(-102,78),new Point(-94,79),new Point(-85,77),new Point(-76,71),new Point(-68,65),new Point(-59,62),
				new Point(-51,54),new Point(-42,41),new Point(-35,23),new Point(-27,9),new Point(-20,-13),new Point(-13,-38),
				new Point(-7,-64),new Point(-2,-97),new Point(-7,-124),new Point(-11,-136),new Point(-18,-128),new Point(-25,-122),
				new Point(-31,-103),new Point(-38,-77),new Point(-42,-45),new Point(-46,-11),new Point(-46,24),new Point(-42,58),
				new Point(-36,84),new Point(-28,102),new Point(-20,109),new Point(-11,113),new Point(-2,114),new Point(6,109),
				new Point(15,100),new Point(23,87),new Point(31,79),new Point(39,65),new Point(48,52),new Point(56,42),
				new Point(64,23),new Point(72,9),new Point(78,-15),new Point(85,-33),new Point(88,-56),new Point(80,-63),
				new Point(71,-73),new Point(63,-85),new Point(55,-93),new Point(46,-97),new Point(44,-96),new Point(52,-94),
				new Point(60,-93),new Point(69,-89),new Point(77,-77),new Point(85,-73),new Point(93,-61),new Point(100,-61),
				new Point(97,-27),new Point(95,10),new Point(92,46),new Point(87,79)));
			
			this.templates[1] = new Template("decline", new Array(
				new Point(-147,0),new Point(-142,-29),new Point(-134,-49),new Point(-126,-69),new Point(-118,-89),new Point(-109,-103),
				new Point(-99,-110),new Point(-89,-114),new Point(-79,-116),new Point(-70,-107),new Point(-60,-102),new Point(-51,92),
				new Point(-41,-82),new Point(-32,-65),new Point(-24,-47),new Point(-16,-28),new Point(-11,2),new Point(-10,36),
				new Point(-16,65),new Point(-22,91),new Point(-30,111),new Point(-39,128),new Point(-48,134),new Point(-57,123),
				new Point(-64,103),new Point(-67,72),new Point(-67,37),new Point(-61,10),new Point(-52,-9),new Point(-45,-31),
				new Point(-36,-48),new Point(-27,-64),new Point(-18,-76),new Point(-9,-90),new Point(0,-98),new Point(10,-104),
				new Point(20,-104),new Point(30,-95),new Point(39,-84),new Point(47,-65),new Point(54,-40),new Point(61,-15),
				new Point(67,11),new Point(73,41),new Point(77,71),new Point(81,103),new Point(80,119),new Point(73,110),
				new Point(64,95),new Point(55,83),new Point(47,74),new Point(53,70),new Point(62,84),new Point(72,94),
				new Point(81,106),new Point(90,119),new Point(98,121),new Point(96,90),new Point(96,56),new Point(96,21),
				new Point(96,-13),new Point(96,-48),new Point(99,-82),new Point(103,-112)));
			
			this.templates[2] = new Template("microPhone", new Array(
				new Point(-154,0),new Point(-147,0),new Point(-138,-5),new Point(-128,-11),new Point(-118,-16),new Point(-108,-21),
				new Point(-98,-27),new Point(-89,-33),new Point(-79,-39),new Point(-70,-45),new Point(-61,-51),new Point(-51,56),
				new Point(-42,-63),new Point(-33,-70),new Point(-24,-76),new Point(-16,-83),new Point(-7,-88),new Point(1,-94),
				new Point(8,-98),new Point(3,-88),new Point(-2,-77),new Point(-5,-66),new Point(-9,-55),new Point(-13,-44),
				new Point(-17,-33),new Point(-21,-22),new Point(-24,-11),new Point(-27,1),new Point(-30,12),new Point(-35,23),
				new Point(-38,33),new Point(-37,39),new Point(-27,35),new Point(-17,30),new Point(-8,24),new Point(2,18),
				new Point(12,14),new Point(23,9),new Point(31,2),new Point(41,-3),new Point(51,-9),new Point(61,-14),
				new Point(71,-19),new Point(78,-25),new Point(87,-30),new Point(96,-35),new Point(96,-27),new Point(91,-17),
				new Point(88,-6),new Point(85,6),new Point(80,17),new Point(77,28),new Point(72,39),new Point(68,50),
				new Point(65,61),new Point(61,72),new Point(56,82),new Point(50,93),new Point(46,103),new Point(42,114),
				new Point(38,124),new Point(35,133),new Point(31,142),new Point(26,152)));
			
			this.templates[3] = new Template("speakerPhone", new Array(
				new Point(-128,0),new Point(-127,13),new Point(-129,23),new Point(-128,35),new Point(-125,48),new Point(-120,59),
				new Point(-116,71),new Point(-112,82),new Point(-108,94),new Point(-101,102),new Point(-95,111),new Point(-88,118),
				new Point(-82,124),new Point(-74,128),new Point(-66,129),new Point(-58,128),new Point(-49,126),new Point(-40,125),
				new Point(-33,116),new Point(-29,109),new Point(-22,101),new Point(-17,91),new Point(-14,79),new Point(-12,67),
				new Point(-11,56),new Point(-9,45),new Point(-10,33),new Point(-10,21),new Point(-11,10),new Point(-12,-2),
				new Point(-13,-14),new Point(-12,-26),new Point(-14,-38),new Point(-13,-50),new Point(-11,-59),new Point(-11,-69),
				new Point(-10,-78),new Point(-5,-85),new Point(-1,-94),new Point(6,-102),new Point(10,-109),new Point(19,-115),
				new Point(28,-120),new Point(36,-120),new Point(45,-121),new Point(53,-121),new Point(59,-116),new Point(67,-115),
				new Point(73,-109),new Point(80,-105),new Point(87,-98),new Point(93,-92),new Point(99,-86),new Point(103,-75),
				new Point(107,-63),new Point(111,-52),new Point(116,-40),new Point(120,3),new Point(121,-17),new Point(120,-7),
				new Point(120,3),new Point(119,15),new Point(118,26),new Point(115,39)));
			
			this.templates[4] = new Template("number", new Array(
				new Point(-126,0),new Point(-119,-3),new Point(-112,-10),new Point(-105,-17),new Point(-97,-24),new Point(-90,-31),
				new Point(-83,-38),new Point(-75,-44),new Point(-68,-51),new Point(-61,-59),new Point(-54,-66),new Point(-46,-73),
				new Point(-39,-79),new Point(-31,-85),new Point(-23,-91),new Point(-16,-98),new Point(-9,-105),new Point(-1,-112),
				new Point(7,-117),new Point(13,-125),new Point(16,-125),new Point(15,-117),new Point(14,-105),new Point(12,-94),
				new Point(9,-83),new Point(9,-72),new Point(8,-61),new Point(7,-49),new Point(5,-38),new Point(3,-27),
				new Point(0,-16),new Point(0,-4),new Point(-1,7),new Point(-3,18),new Point(-4,30),new Point(-5,41),
				new Point(-6,52),new Point(-5,63),new Point(-7,74),new Point(-9,84),new Point(-10,94),new Point(-10,103),
				new Point(-13,111),new Point(-12,119),new Point(-13,125),new Point(-6,117),new Point(2,111),new Point(8,103),
				new Point(16,98),new Point(23,90),new Point(31,84),new Point(37,76),new Point(45,70),new Point(52,62),
				new Point(60,57),new Point(68,51),new Point(75,45),new Point(82,38),new Point(90,32),new Point(97,24),
				new Point(104,19),new Point(111,15),new Point(117,7),new Point(124,-1)));
			
			this.templates[5] = new Template("camera", new Array(
				new Point(-118,0),new Point(-114,14),new Point(-106,29),new Point(-99,33),new Point(-90,59),new Point(-82,73),
				new Point(-72,86),new Point(-63,101),new Point(-55,115),new Point(-46,127),new Point(-33,121),new Point(-19,111),
				new Point(-6,102),new Point(7,92),new Point(20,82),new Point(32,72),new Point(45,62),new Point(57,52),
				new Point(71,43),new Point(83,32),new Point(96,23),new Point(109,16),new Point(123,10),new Point(132,0),
				new Point(123,-13),new Point(114,-27),new Point(104,-41),new Point(96,-55),new Point(86,-68),new Point(77,-83),
				new Point(67,-96),new Point(59,-110),new Point(49,-123),new Point(35,-116),new Point(22,-107),new Point(8,-98),
				new Point(-4,-88),new Point(-17,-78),new Point(-31,69),new Point(-43,-59),new Point(-56,-49),new Point(-69,-39),
				new Point(-82,-29),new Point(-95,-20),new Point(-102,-9),new Point(-93,4),new Point(-79,12),new Point(-64,20),
				new Point(-50,26),new Point(-34,30),new Point(-19,32),new Point(-3,29),new Point(12,24),new Point(24,13),
				new Point(35,1),new Point(40,-15),new Point(40,-31),new Point(32,-45),new Point(17,-52),new Point(2,-51),
				new Point(-12,-44),new Point(-20,-29),new Point(-23,-12),new Point(-15,2)));
			
			this.templates[6] = new Template("notepad", new Array(
				new Point(-144,0),new Point(-132,1),new Point(-120,3),new Point(-108,4),new Point(-96,5),new Point(-85,7),
				new Point(-73,7),new Point(-61,7),new Point(-49,8),new Point(-37,10),new Point(-25,11),new Point(-13,12),
				new Point(-1,14),new Point(11,15),new Point(23,16),new Point(35,15),new Point(47,17),new Point(58,20),
				new Point(69,21),new Point(81,20),new Point(93,20),new Point(104,21),new Point(106,16),new Point(97,10),
				new Point(90,3),new Point(81,-4),new Point(74,-12),new Point(67,-20),new Point(61,-29),new Point(54,-38),
				new Point(49,-47),new Point(44,-57),new Point(37,-65),new Point(31,-74),new Point(26,-83),new Point(18,-92),
				new Point(11,-99),new Point(2,-105),new Point(-7,108),new Point(-5,-100),new Point(-4,-90),new Point(-5,80),
				new Point(-5,-70),new Point(-6,-59),new Point(-7,-49),new Point(-9,-39),new Point(-10,-28),new Point(-10,-18),
				new Point(-11,-8),new Point(-12,2),new Point(-14,13),new Point(-15,23),new Point(-17,33),new Point(-17,44),
				new Point(-17,54),new Point(-21,63),new Point(-23,74),new Point(26,83),new Point(-29,93),new Point(-30,103),
				new Point(-32,113),new Point(-30,123),new Point(-30,132),new Point(-30,142)));
			

		}
		//
		// The $1 Gesture Recognizer API begins here!
		//
		
		//public function Recognizer(){
			//this.Templates = new Array();
		//}
		
		public function recognize(points:Array):Result
		{
			points = Resample(points, NumPoints);
			points = RotateToZero(points);
			points = ScaleToSquare(points, SquareSize);
			points = TranslateToOrigin(points);
			
			var b:Number = +Infinity;
			var t:uint;
		
			for (var i:int = 0; i < this.templates.length; i++)
			{
				var d:Number = DistanceAtBestAngle(points, this.templates[i], -AngleRange, +AngleRange, AnglePrecision);
				if (d < b)
				{
					b = d;
					t = i;
				}
			}
			var score:Number = 1.0 - (b / HalfDiagonal);
			var result_template:Template=this.templates[t];
			//var testres=new Result(this.templates[t].Name, score);
			return new Result(this.templates[t], score);
			//return result_template.name;
		}
		
		public function templatePoint(points:Array, name:String):Array
		{
			var nPoints:Array;
			nPoints=Resample(points, NumPoints);
			nPoints=RotateToZero(nPoints);
			nPoints=ScaleToSquare(nPoints, SquareSize);
			nPoints=TranslateToOrigin(nPoints);
			return nPoints;
		}
		//
		// add/delete new templates
		//
		public function addTemplate(name:String, points:Array):Number
		{
			this.templates[this.templates.length] = new Template(name, points); // append new template
			var num:Number = 0;
			for (var i:int = 0; i < this.templates.length; i++)
			{
				if (this.templates[i].Name == name)
					num++;
			}
			return num;
		}
		
		
		// Helper functions
		
		public static function Resample(points:Array, n:uint):Array
		{
			var I:Number = PathLength(points) / (n - 1); // interval length
			var D:Number = 0.0;
			var newpoints:Array = new Array(points[0]);
			for (var i:int = 1; i < points.length; i++)
			{
				var d:Number = Distance(points[i - 1], points[i]);
				if ((D + d) >= I)
				{
					var qx:Number = points[i - 1].x + ((I - D) / d) * (points[i].x - points[i - 1].x);
					var qy:Number = points[i - 1].y + ((I - D) / d) * (points[i].y - points[i - 1].y);
					var q:Point = new Point(qx, qy);
					newpoints[newpoints.length] = q; // append new point 'q'
					points.splice(i, 0, q); // insert 'q' at position i in points s.t. 'q' will be the next i
					D = 0.0;
				}
				else D += d;
			}
			// somtimes we fall a rounding-error short of adding the last point, so add it if so
			if (newpoints.length == n - 1)
			{
				newpoints[newpoints.length] = points[points.length - 1];
			}
			return newpoints;
		}
		public static function RotateToZero(points:Array):Array
		{
			var c:Point = Centroid(points);
			var theta:Number = Math.atan2(c.y - points[0].y, c.x - points[0].x);
			return RotateBy(points, -theta);
		}
		
		public static function ScaleToSquare(points:Array, size:Number):Array
		{
			var B:Rectangle = BoundingBox(points);
			var newpoints:Array = new Array();
			for (var i:int = 0; i < points.length; i++)
			{
				var qx:Number = points[i].x * (size / B.width);
				var qy:Number = points[i].y * (size / B.height);
				newpoints[newpoints.length] = new Point(qx, qy);
			}
			return newpoints;
		}			
		public static function TranslateToOrigin(points:Array):Array
		{
			var c:Point = Centroid(points);
			var newpoints:Array = new Array();
			for (var i:int = 0; i < points.length; i++)
			{
				var qx:Number = points[i].x - c.x;
				var qy:Number = points[i].y - c.y;
				newpoints[newpoints.length] = new Point(qx, qy);
			}
			return newpoints;
		}
		
		public static function DistanceAtBestAngle(points:Array, T:Template, a:Number, b:Number, threshold:Number):Number
		{
			var x1:Number = Phi * a + (1.0 - Phi) * b;
			var f1:Number = DistanceAtAngle(points, T, x1);
			var x2:Number = (1.0 - Phi) * a + Phi * b;
			var f2:Number = DistanceAtAngle(points, T, x2);
			while (Math.abs(b - a) > threshold)
			{
				if (f1 < f2)
				{
					b = x2;
					x2 = x1;
					f2 = f1;
					x1 = Phi * a + (1.0 - Phi) * b;
					f1 = DistanceAtAngle(points, T, x1);
				}
				else
				{
					a = x1;
					x1 = x2;
					f1 = f2;
					x2 = (1.0 - Phi) * a + Phi * b;
					f2 = DistanceAtAngle(points, T, x2);
				}
			}
			return Math.min(f1, f2);
		}
		
		public static function PathLength(points:Array):Number
		{
			var d:Number = 0.0;
			for (var i:int = 1; i < points.length; i++)
				d += Distance(points[i - 1], points[i]);
			return d;
		}
		
		public static function Distance(p1:Point, p2:Point):Number
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		public static function Centroid(points:Array):Point
		{
			var x:Number = 0.0, y:Number = 0.0;
			for (var i:int = 0; i < points.length; i++)
			{
				x += points[i].x;
				y += points[i].y;
			}
			x /= points.length;
			y /= points.length;
			return new Point(x, y);
		}
		public static function RotateBy(points:Array, theta:Number):Array
		{
			var c:Point = Centroid(points);
			var cos:Number = Math.cos(theta);
			var sin:Number = Math.sin(theta);
			
			var newpoints:Array = new Array();
			for (var i:int = 0; i < points.length; i++)
			{
				var qx:Number = (points[i].x - c.x) * cos - (points[i].y - c.y) * sin + c.x
				var qy:Number = (points[i].x - c.x) * sin + (points[i].y - c.y) * cos + c.y;
				newpoints[newpoints.length] = new Point(qx, qy);
			}
			return newpoints;
		}
		public static function BoundingBox(points:Array):Rectangle
		{
			var minX:Number = +Infinity, maxX:Number = -Infinity, minY:Number = +Infinity, maxY:Number = -Infinity;
			for (var i:int = 0; i < points.length; i++)
			{
				if (points[i].x < minX)
					minX = points[i].x;
				if (points[i].x > maxX)
					maxX = points[i].x;
				if (points[i].y < minY)
					minY = points[i].y;
				if (points[i].y > maxY)
					maxY = points[i].y;
			}
			return new Rectangle(minX, minY, maxX - minX, maxY - minY);
		}
		
		public static function DistanceAtAngle(points:Array, T:Template, theta:Number):Number
		{
			var newpoints:Array = RotateBy(points, theta);
			return PathDistance(newpoints, T.points);
		}
		
		public static function PathDistance(pts1:Array, pts2:Array):Number
		{
			var d:Number = 0.0;
			for (var i:int = 0; i < pts1.length; i++) // assumes pts1.length == pts2.length
				d += Distance(pts1[i], pts2[i]);
			return d / pts1.length;
		}
		public function Deg2Rad(d:Number):Number
		{
			return (d * Math.PI / 180.0);
		}
		public function Rad2Deg(r:Number):Number
		{
			return (r * 180.0 / Math.PI);
		}
	}

}