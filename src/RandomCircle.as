package {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class RandomCircle extends Sprite{
		
		// ステージの半分
		private var halfWidth:int;
		private var halfHeight:int;
		
		// 円の大きさ
		private const SIZE:int = 100; ;
		
		public function RandomCircle() {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var n:uint = 10000;
			var sprite:Sprite;
			var g:Graphics;
			
			// 玉の固まりの描画
			for(var i:int = 0; i < n; i++) {
				sprite = new Sprite();
				addChild(sprite);
				g = sprite.graphics;
				g.beginFill(0xFFFFFF * Math.random());
				g.drawCircle(0, 0, 1);
				g.endFill();
				// 玉の位置決定
				checkPosition(sprite);
			}
		}
		
		// 位置を決定と再配置
		private function checkPosition(sprite:Sprite):void {
			var d:Number;
			sprite.x = halfWidth  + 200 - 400 * Math.random();
			sprite.y = halfHeight + 200 - 400 * Math.random();
			d = Math.sqrt(Math.pow(halfWidth - sprite.x, 2) + Math.pow(halfHeight - sprite.y, 2));
			
			 // 範囲の外の場合再配置
			if(SIZE < d) {
				checkPosition(sprite);
			}
		}
	}
}