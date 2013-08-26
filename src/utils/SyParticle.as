package utils {
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.ParticleType;
	/**
	* ...
	* @author Dreauw
	*/
	
	public class SyParticle extends Entity {
		static public var instance : SyParticle;
		public function SyParticle() {
			super(0, 0, new Emitter(Assets.PARTICLES, 7, 7));
			layer = 10;
			registerParticle();
		}
		
		public function newType(name:String, frames:Array = null):ParticleType {
			return (graphic as Emitter).newType(name, frames);
		}

		private function registerParticle() : void {
			/*
			newType("foobar", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setGravity(5, 10);
			*/
			newType("slime_red", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);
			newType("slime_green", [1])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);	
			newType("slime_blue", [2])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);
			newType("slime_purple", [3])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);
			newType("box", [4])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);
			newType("hourglass", [5])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);
			newType("coin", [6])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);
			newType("mode", [7])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4);
			newType("speed", [8])
				.setAlpha(1, 0)
				.setMotion(0, 0, 0.7, 0, 0, 0);
			newType("bullet", [9])
				.setAlpha(1, 0)
				.setMotion(0, 0, 0.7, 0, 0, 0);
		}

		static public function emit(name:String, x:Number, y:Number, nbr:Number = 1) : void {
			if (!instance || instance.world != FP.world) {
				instance = new SyParticle();
				if (instance.world) instance.world.remove(instance);
				FP.world.add(instance);
			}
			for (var i : Number = 0; i < nbr ; i++) {(instance.graphic as Emitter).emit(name, x, y);}
		}

	}

}