package entities {
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import net.flashpunk.FP;
	import utils.SyParticle;
	import utils.Audio;
	
	public class Slime extends Slow{
		private var img:Image;
		private var color:uint = 0;
		public function Slime() {
			super(0, 0, null, new Hitbox(14, 9));
			layer = 5;
			type = "slow";
			Audio.registerSound("slime", "3,,0.3139,0.6724,0.3539,0.114,,-0.3531,,,,,,,,,,,1,,,,,0.5");
		}
		
		public function initialize(x:Number, y:Number) : void {
			color = FP.choose(0, 1, 3);
			graphic = new Image(Assets.SLIME, new Rectangle(14 * color, 0, 14, 9));
			this.x = x;
			this.y = y;
		}
		
		override public function update():void {
			super.update();
			moveBy(0, 5, "solid");
			if (collide("bullet", x, y)) destroy();
			if (x + width < FP.camera.x) world.recycle(this);
		}
		
		override public function destroy():void {
			Audio.playSound("slime");
			SyParticle.emit(["slime_red", "slime_green", "slime_blue", "slime_purple"][color], x + width / 2, y + height / 2, 10);
			world.recycle(this);
		}
		
	}

}