package entities {
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import worlds.WorldGame;
	import net.flashpunk.FP;
	import utils.SyParticle;
	import utils.Audio;

	public class Hourglass extends Entity{
		
		public function Hourglass() {
			var img:Image = new Image(Assets.HOURGLASS);
			img.filters = [new GlowFilter(0xFFFFFF)];
			super(0, 0, img, new Hitbox(9, 13));
			type = "hourglass";
			layer = 4;
			Audio.registerSound("hourglass", "0,,0.0256,0.4167,0.3577,0.4832,,,,,,0.5851,0.6718,,,,,,1,,,,,0.5");
		}
		
		override public function update():void {
			if (collide("player", x, y)) {
				var mode : uint = (world as WorldGame).player.mode ;
				(world as WorldGame).addTime((mode == 0 || mode == 1 || (world as WorldGame).difficult) ? 2 : 3);
				Audio.playSound("hourglass");
				SyParticle.emit("hourglass", x + width / 2, y + height / 2, 10);
				world.recycle(this);
			}
			if (x < FP.camera.x) world.recycle(this);
			super.update();
		}
		
	}

}