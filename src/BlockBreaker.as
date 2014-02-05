package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	[SWF(backgroundColor=0x000000, width=465, height=465, frameRate=30 )]
	public class BlockBreaker extends Sprite{
		// ステージの大きさ
		private static const HEIGHT:Number = 465;
		// ステージの横幅
		private static const WIDTH:Number = 465;
		private var _canvas:BitmapData;
		private var _blocks:Blocks;
		private var _fallBlocks:Vector.<Particle>;
		private var _balls:Vector.<Particle>;
		private var _bar:Bitmap;
		
		// Twitter用
		private var postUrl:String="http://twitter.com/home?status=";
		//private var wonderflUrl:String="http://bit.ly/9xsPLp %23StardustBreakout";
		

		
		
		public function BlockBreaker(){
			_canvas = new BitmapData(WIDTH,HEIGHT,false,0x000000);
			addChild(new Bitmap(_canvas));
			
			// 初期配置ブロック生成
			_blocks = new Blocks();
			
			// 球に当たって落ちてくるブロック
			_fallBlocks = new Vector.<Particle>();
			
			// バーを生成
			var b:BitmapData = new BitmapData(100, 10, false, 0x00FF00);
			addChild(_bar = new Bitmap(b));
			_bar.y = HEIGHT - b.width;
			
			// 初期配置のボールを生成
			var _ball:Particle = new Particle(WIDTH / 2, HEIGHT / 2);
			_ball.vx = Math.random() * 10;
			_ball.vy = -Math.random() * 9 - 1;
			_ball.color = 0xFFFFFF;
			_balls = new Vector.<Particle>();
			_balls.push(_ball);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(evt:Event):void {
			_canvas.lock();
			_canvas.colorTransform(_canvas.rect, new ColorTransform(0.9, 0.5, 0.9));
			
			// ブロックを描画
			for each(var block:Particle in _blocks.values) {
				if(block){
					_canvas.setPixel(block.x, block.y, block.color);
				}
			}
			var removeBalls:Vector.<Particle> = new Vector.<Particle>();
			
			// ボールの数だけ処理
			for each(var ball:Particle in _balls) {
				var bvx:Number = ball.vx;
				var bvy:Number = ball.vy;
				var bspeed:Number = Math.sqrt(bvx * bvx + bvy * bvy);
				var bradius:Number = Math.atan2(bvy, bvx);
				
				// ボールの移動処理
				for(var i:int = 0; i < bspeed; i++) {
					// ボールを移動させる
					ball.x += ball.vx / bspeed;
					ball.y += ball.vy / bspeed;
					
					// ボールの座標より、ブロックの位置にあるかどうかを調べる
					var hitParticle:Particle = _blocks.getParticle(ball.x, ball.y);
					
					// ボールがブロックの位置にある場合(ボールがブロックに当たっている場合)					
					if(hitParticle) {
						// ブロックから落ちるパーティクルを生成
						var removeP:Particle = _blocks.removeParticle(ball.x, ball.y);
						
						// 横への移動は弧を描くように
						removeP.vx = Math.cos(bradius + Math.PI * 2 / (30 * Math.random()) - 15) * 3;
						removeP.vy = 1;
						removeP.color = hitParticle.color;
						_fallBlocks.push(removeP);
						
						// ボールの進行方向を反転させる(上方向から下方向へ)
						ball.vy = -ball.vy;
					}
					// ボールが画面左端(進行方向左)か、
					// ボールが画面右端(進行方向右)のとき
					if((ball.x < 0 && ball.vx < 0) || (WIDTH < ball.x && 0 < ball.vx)){
						// 横方向への方向を反転
						ball.vx = -ball.vx;
					}
					// ボールが画面下端(進行方向下)のとき
					if(ball.y < 0 && ball.vy < 0){
						ball.vy = -ball.vy;
					}
					// ボールが画面(上端)のとき
					if(HEIGHT < ball.y){
						// ボールを消す
						removeBalls.push(ball);
					}
					// ボールがバーに当たったとき
					if(_bar.hitTestPoint(ball.x, ball.y)){
						// ボールの進行方向を上にする
						ball.vy = -Math.abs(ball.vy);
					}
					// ボールを描画する
					_canvas.setPixel(ball.x, ball.y, ball.color);
				}
			}

			removeBalls.forEach(function(b:Particle, ...args):void{
				var index:int = _balls.indexOf(b);
				if(index != -1){
					// ボールを削除する
					_balls.splice(index,1);
				}
			});
			
			var removeFallBs:Vector.<Particle> = new Vector.<Particle>();
			// 落ちていく全ブロックへ実行
			_fallBlocks.forEach(function(fallP:Particle, ...args):void{
				fallP.vy += 0.1;
				fallP.x += fallP.vx;
				fallP.y += fallP.vy;
				_canvas.setPixel(fallP.x, fallP.y, fallP.color);
				
				// 落ちていくブロックがバーに当たったとき
				if(_bar.hitTestPoint(fallP.x, fallP.y)){
					var newball:Particle = new Particle(fallP.x, fallP.y);
					newball.vx = Math.random() * 10;
					newball.vy = Math.random() * 9 +1;
					newball.color = fallP.color;
					_balls.push(newball);
					removeFallBs.push(fallP);
					
				// 落ちていくブロックが画面下端を過ぎたとき
				}else if(HEIGHT < fallP.y){
					removeFallBs.push(fallP);
				}
			});
			
			removeFallBs.forEach(function(b:Particle,...args):void{
				var index:int = _fallBlocks.indexOf(b);
				if(index != -1){
					_fallBlocks.splice(index, 1);
				}
			});
			
			// バーの中心を基準に移動
			_bar.x = stage.mouseX - _bar.width * 0.5;
			
			_canvas.unlock();
			
			//ブ ロックが0になったとき(ゲームクリア時)
			if(_blocks.count() == 0){
				removeEventListener(Event.ENTER_FRAME, update);
				var clearTF:TextField = new TextField();
				clearTF.text = "CLEAR!\nおめでと";
				clearTF.textColor = 0x00FF80;
				clearTF.autoSize = TextFieldAutoSize.LEFT;
				_canvas.draw(clearTF,new Matrix(5,0,0,5,WIDTH/2-clearTF.width * 5/2, HEIGHT/2 - clearTF.height * 5 /2));
			}
		}
	}
}
