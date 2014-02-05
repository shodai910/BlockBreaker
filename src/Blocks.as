package {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;

public class Blocks {
	public var _count:int;

	public function count():int {
		return _count;
	}

	public var _width:Number;

	public function width():Number {
		return _width;
	}

	public var _height:Number;

	public function height():Number {
		return _height;
	}

	public var values:Vector.<Particle>;

	function Blocks() {
		// ブロックの横幅
		_width  = 465;
		// ブロックの縦幅
		_height = 200;
		
		// ランダム配置された玉の固まり
		var rdmCircle:RandomCircle = new RandomCircle();
		
		// RandamCircleをビットマップに変換
		var bmd:BitmapData = new BitmapData(_width, _height, false, 0x333333);
		
		// 玉の固まりを中央に移動
		var mtx:Matrix = new Matrix();
		mtx.translate(_width >> 1, 100);
		
		// 玉の固まりを描画
		bmd.draw(rdmCircle, mtx);
		
		var bmp:Bitmap = new Bitmap(bmd);
		
		// ブロックの総量
		_count = _width * _height;
		values = new Vector.<Particle>(_width * _height, false);

		// ブロックの横幅まで
		for (var i : int = 0; i < bmp.width; i++) {
			// ブロックの縦幅まで
			for (var j : int = 0; j < bmp.height; j++) {
				var p : Particle = new Particle(i, j);
				// パーティクルの色を設定
				p.color = bmd.getPixel(i,j);
				
				values[i + j * _width] = p;
			}
		}
	}

	public function getParticle(x : int, y : int) : Particle {
		var index:int = x + y * _width;
		if (values.length <= index || index < 0) {
			return null;
		}
		return values[x + y * _width];
	}

	// ボールがブロックにヒットした際呼び出す関数
	public function removeParticle(x : int, y : int) : Particle {
		var p : Particle = values[x + y * _width];
		if (p) {
			_count--;
			values[x + y * _width] = undefined;
		}
		return p;
	}
}
}
