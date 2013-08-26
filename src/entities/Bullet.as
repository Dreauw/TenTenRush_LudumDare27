package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import net.flashpunk.graphics.Image;
	import flash.filters.GlowFilter;
	import net.flashpunk.FP;
	import utils.Audio;
	import utils.SyParticle;
	
	public class Bullet extends Entity{
		private var durationTimer:Number = 0;
		public function Bullet() {
			var img:Image = new Image(Assets.BULLET);
			img.filters = [new GlowFilter(0xD9B835, 1, 3, 3, 2)];
			layer = 3;
			type = "bullet";
			Audio.registerSound("bullet", "0,,0.2392,0.2982,0.2524,0.6379,0.0198,-0.4367,,,,,,0.834,-0.1359,,,,1,,,0.2171,,0.5");
			super(0, 0, img, new Hitbox(3, 6));
		}
		
		public function initialize(x : Number, y : Number) : void {
			durationTimer = 1.5;
			this.x = x;
			this.y = y;
			Audio.playSound("bullet");
		}
		
		override public function update():void {
			super.update();
			durationTimer -= FP.elapsed;
			if (durationTimer <= 0) destroy();
			moveBy(100 * FP.elapsed, 500 * FP.elapsed, "solid");
		}
		
		public function destroy() : void {
			SyParticle.emit("bullet", x + width / 2, y + height / 2, 1);
			world.recycle(this);
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			destroy();
			return super.moveCollideX(e);
		}
		
	}

}