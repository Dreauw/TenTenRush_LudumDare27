package entities {
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import utils.SyParticle;
	import net.flashpunk.FP;
	import utils.Audio;
	import worlds.WorldGame;

	public class Coin extends Entity{
		
		public function Coin() {
			var img : Image = new Image(Assets.COIN);
			img.filters = [new GlowFilter(0xC9A31F, 1, 3, 3, 2)];
			super(0, 0, img, new Hitbox(10, 12));
			layer = 4;
			type = "coin";
			Audio.registerSound("coin", "0,,0.0387,0.4516,0.2052,0.8934,,,,,,0.4574,0.6811,,,,,,1,,,,,0.5");
		}
		
		override public function update():void {
			if (collide("player", x, y)) {
				(world as WorldGame).score += 5;
				Audio.playSound("coin");
				SyParticle.emit("coin", x + width / 2, y + height / 2, 10);
				world.recycle(this);
			}
			if (x + width < FP.camera.x) world.recycle(this);
			super.update();
		}
		
		
	}

}