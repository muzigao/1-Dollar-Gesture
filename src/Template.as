// ActionScript file
package
{
	import mx.messaging.channels.StreamingAMFChannel;

	public class Template {
		
		public var name:String;
		public var points:Array;
		
		public function Template(name:String=null, points:Array=null) // constructor
		{
			this.name = name;
			if (points && points.length > 1) {
				this.points = Recognizer.Resample(points, Recognizer.NumPoints);
				this.points = Recognizer.RotateToZero(this.points);
				this.points = Recognizer.ScaleToSquare(this.points, Recognizer.SquareSize);
				this.points = Recognizer.TranslateToOrigin(this.points);
			}	
		}
	}
}