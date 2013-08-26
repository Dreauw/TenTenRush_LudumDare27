package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.graphics.Spritemap
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.FlickerTween;
	import utils.Assets;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import utils.SyParticle;
	import worlds.WorldGame;
	import utils.Audio;

	public class Player extends Entity{
		private var sprite:Spritemap;
		private var speedY:Number = 0;
		private var speedX:Number = 0;
		private var jumpHigh:Number = 0;
		private const GRAVITY:Number = 20;
		private const GRAVITY_JETPACK:Number = 10;
		private const GRAVITY_MODE:Number = 20;
		private const ACCEL:Number = 200;
		private var timer:Number = 0;
		public var mode:uint = 0;
		private var onGround:Boolean = false;
		private var inverseGravity:Boolean = false;
		private var dashTimer:Number = 0;
		private var reloadTimer:Number = 0;
		private var emitter:Emitter;
		private var emitterAdded:Boolean = false;
		private var particleTimer:Number = 0;
		private var slowTimer:Number = 3;
		public function Player() {
			sprite = new Spritemap(Assets.PLAYER, 16, 23);
			sprite.add("stand", [0], 0, false);
			sprite.add("normal_run", [0, 1, 0, 2], 15);
			sprite.add("ninja_run", [3, 4, 3, 5], 15);
			sprite.add("jetpack_run", [6, 7, 6, 8], 15);
			sprite.add("gravity_run", [9, 10, 9, 11], 15);
			sprite.add("gravity_inverse_run", [12, 13, 12, 14], 15);
			sprite.play("normal_run");
			sprite.originX = sprite.width / 2;
			sprite.originY = sprite.height / 2;
			super(50, 130, sprite, new Hitbox(8, 21, -sprite.originX+5, -sprite.originY+1));
			Input.define("jump", Key.UP, Key.Z);
			Input.define("attack", Key.SPACE, Key.X, Key.SHIFT);
			layer = 5;
			type = "player";
			emitter = new Emitter(sprite, 16, 23);
			emitter.newType("dash", [0])
				.setAlpha(1, 0)
				.setMotion(0, 0, 0.4, 0, 0, 0);
			Audio.registerSound("dash", "0,,0.2631,0.0307,0.3655,0.5609,0.2436,-0.2166,,,,,,0.1032,0.0642,,0.0086,-0.0392,1,,,0.0466,,0.5", true);
			Audio.registerSound("mode", "1,,0.0481,,0.4346,0.454,,0.322,,,,,,,,0.5981,,,1,,,,,0.5", true);
			Audio.registerSound("hit", "0,,0.0735,,0.2298,0.5041,,-0.4887,,,,,,0.3555,,,,,1,,,0.1656,,0.5");
			Audio.registerSound("explosion", "3,,0.2778,0.6226,0.3653,0.0386,,0.1198,,,,0.2814,0.7032,,,,,,1,,,,,0.5");
		}
		
		public function centerCamera() : void {
			FP.camera.x = x - FP.screen.width / (2 * FP.screen.scale) + 100;
			//FP.camera.y = y - FP.screen.height / (2 * FP.screen.scale);
			if (FP.camera.x < 0) FP.camera.x = 0;
			if ((world as WorldGame).shakeTimer <= 0) {
				FP.camera.y = 0;
				if (y + FP.screen.height / (2 * FP.screen.scale) > 240) FP.camera.y = 240 - FP.screen.height / 2;
			}
			//if (x + FP.screen.width / (2 * FP.screen.scale) > mapWidth) FP.camera.x = mapWidth - FP.screen.width / 2;
			//if (y + FP.screen.height / (2 * FP.screen.scale) > 480) FP.camera.y = 480 - FP.screen.height / 2;
		}
		
		public function setMode(id : uint) : void {
			if (id > 3) id = 0;
			mode = id;
			if (mode == 0) sprite.play("normal_run");
			if (mode == 1) sprite.play("ninja_run");
			if (mode == 2) sprite.play("jetpack_run");
			if (mode == 3 && !inverseGravity) sprite.play("gravity_run");
			if (mode == 3 && inverseGravity) sprite.play("gravity_inverse_run");
			Audio.playSound("mode");
			SyParticle.emit("mode", x, y, 20);
		}
		
		public function getMode(id : uint) : uint {
			id += mode;
			if (id > 3) id = 0;
			return id;
		}
		
		public function resetAlpha() : void {
			sprite.alpha = 1;
		}
		
		override public function update():void {
			super.update();
			reloadTimer -= FP.elapsed;
			if (Input.pressed("jump")) {
				if (mode == 3 && onGround) {
					inverseGravity = !inverseGravity;
					if (inverseGravity) sprite.play("gravity_inverse_run");
					if (!inverseGravity) sprite.play("gravity_run");
					onGround = false;
				}
			}
			
			if (dashTimer <= 0) {
				if (mode == 2) {
					speedY += GRAVITY_JETPACK * FP.elapsed;
				} else if (mode == 3) {
					speedY += (inverseGravity ? -GRAVITY_MODE * FP.elapsed : GRAVITY_MODE * FP.elapsed);
				} else {
					speedY += GRAVITY * FP.elapsed;
				}
			}
				if (dashTimer > 0) {
					dashTimer -= FP.elapsed;
					speedX += ACCEL * 100 * FP.elapsed;
					emitter.emit("dash", x-originX, y-originY);
				} else {
					if (slowTimer > 0) {
						slowTimer -= FP.elapsed;
						speedX += 150 * FP.elapsed;
					} else {
						speedX += ACCEL * FP.elapsed;
					}
					
				}
			if (speedX > 200 && dashTimer <= 0) {
				particleTimer -= FP.elapsed
				if (particleTimer <= 0) {
					SyParticle.emit("speed", x-5, y + FP.choose( -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8), 1);
					particleTimer = 0.05;
				}
				speedX = 200;
			}
			if (speedY > 200) speedY = 200;
			if (speedY < -3 && mode == 2) speedY = -3;
			if (speedY > 3 && mode == 2) speedY = 3;
			if (Input.check("jump")) {
				if (mode == 0 && jumpHigh < 10) {
					speedY -= 1;
					jumpHigh += 1;
					onGround = false;
				}
				if (mode == 1 && jumpHigh < 10) {
					speedY -= 1;
					jumpHigh += 1;
					onGround = false;
				}
				if (mode == 2) {
					speedY -= 0.5;
					onGround = false;
				}
			}
			if (Input.check("attack")) {
				if (mode == 1 && reloadTimer <= 0) {
					reloadTimer = 0.1;
					var shuriken:Shuriken = FP.world.create(Shuriken) as Shuriken;
					shuriken.initialize(x+10, y+FP.choose(4, 2, -4, -2, 0)+5);
				}
				
				if (mode == 2 && reloadTimer <= 0) {
					reloadTimer = 0.1;
					var bullet:Bullet = FP.world.create(Bullet) as Bullet;
					bullet.initialize(x+FP.choose(4, 2, -4, -2, 0)-5, y+5);
				}
				
				if ((mode == 0 || mode == 3) && dashTimer <= 0 && reloadTimer <= 0) {
					if (!emitterAdded) {
						 
						FP.world.addGraphic(emitter, 4)
						emitterAdded = true;
					}
					Audio.playSound("dash");
					reloadTimer = 0.5;
					dashTimer = 0.1;
					speedY = 0;
					(world as WorldGame).shakeTimer = dashTimer;
				}
			}
			moveBy(speedX * FP.elapsed, (dashTimer <= 0 ? speedY * 40 * FP.elapsed : 0), "solid");
			var slow : Slow = collide("slow", x, y) as Slow;
			if (slow) {
				if (dashTimer <= 0) {
					speedX = 0;
					var tw : FlickerTween = new FlickerTween(resetAlpha);
					tw.tween(0.5, 0.1);
					tw.image = sprite;
					addTween(tw, true);
					Audio.playSound("hit");
				}
				slow.destroy();
			}
			
			if (!onGround && mode == 1 && dashTimer <= 0) {
				sprite.angle -= 600*FP.elapsed;
			} else {
				sprite.angle = 0;
			}
			timer += FP.elapsed;
			centerCamera();
		}
		
		public function die() : void {
			SyParticle.emit("slime_red", x, y, 30);
			Audio.playSound("explosion");
			FP.world.remove(this);
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			if (speedY >= 0) jumpHigh = 0;
			onGround = true;
			speedY = 0;
			return super.moveCollideY(e);
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			speedX = 0;
			return super.moveCollideX(e);
		}
		
	}

}