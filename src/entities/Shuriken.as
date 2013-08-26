package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import net.flashpunk.FP;
	import flash.filters.GlowFilter;
	import utils.Audio;
	import utils.SyParticle;

	public class Shuriken extends Entity{
		private var durationTimer:Number = 3;
		public function Shuriken() {
			var img:Image = new Image(Assets.SHURIKEN);
			super(0, 0, img, new Hitbox(7, 7, -img.width / 2, -img.height / 2));
			img.originX = img.width / 2;
			img.originY = img.height / 2;
			layer = 3;
			type = "bullet";
			Audio.registerSound("bullet", "0,,0.2392,0.2982,0.2524,0.6379,0.0198,-0.4367,,,,,,0.834,-0.1359,,,,1,,,0.2171,,0.5");
		}
		
		public function initialize(x:Number, y:Number) : void {
			durationTimer = 1.5;
			this.x = x;
			this.y = y;
			Audio.playSound("bullet");
		}
		
		override public function update():void {
			super.update();
			durationTimer -= FP.elapsed;
			(graphic as Image).angle -= 10;
			if (durationTimer <= 0) destroy();
			moveBy(500 * FP.elapsed, 0, "solid");
		}
		
		public function destroy() : void {
			world.recycle(this);
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			destroy();
			return super.moveCollideX(e);
		}
		
	}

}