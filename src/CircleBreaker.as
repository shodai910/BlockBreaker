package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	[SWF(backgroundColor=0x000000, width=465, height=465, frameRate=60 )]
	public class CircleBreaker extends Sprite {
		
		public function CircleBreaker() {
			var bb:BlockBreaker = new BlockBreaker();
			addChild(bb);
		}
	}
}