package {
public class Particle {
	public var x:Number;
	public var y:Number;
	public var vy:Number = 0;
	public var vx:Number = 0;
	public var color:uint;
	public function Particle(x:Number = 0, y:Number = 0){
		this.x = x;
		this.y = y;
	}
}
}
