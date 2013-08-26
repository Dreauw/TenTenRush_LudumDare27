package entities {
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import utils.SyParticle;
	import net.flashpunk.FP;
	import utils.Audio;

	public class Box extends Slow{
		
		public function Box() {
			super(0, 0, new Image(Assets.BOX), new Hitbox(16, 16));
			layer = 5;
			Audio.registerSound("box", "3,,0.1098,0.484,0.1885,0.0873,,0.1876,,,,,,,,0.6684,0.2775,-0.2713,1,,,,,0.5");
		}
		
		
		public function initialize(x:Number, y:Number) : void {
			this.x = x;
			this.y = y
		}
		
		override public function update():void {
			super.update();
			if (x + width < FP.camera.x) world.recycle(this);
			if (collide("bullet", x, y)) destroy();
			moveBy(0, 5, ["solid", "slow"]);
		}
		
		override public function destroy():void {
			world.recycle(this);
			SyParticle.emit("box", x + width / 2, y + height / 2, 10);
			Audio.playSound("box");
		}
	}

}