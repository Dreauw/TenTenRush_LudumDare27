package worlds {
	import entities.Hourglass;
	import entities.Map;
	import entities.MapChunk;
	import entities.Player;
	import entities.Timer;
	import entities.Tutorial;
	import flash.events.IMEEvent;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import utils.WorldBase;
	import net.flashpunk.FP;
	import utils.SyParticle;
	import utils.Assets;
	import utils.Audio;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import mochi.as3.MochiScores;
	

	public class WorldGame extends WorldBase{
		public var player : Player = new Player();
		private var map : Map = new Map();
		private var timer : Timer = new Timer();
		private var chunk : Array = new Array();
		private var currentChunk1 : MapChunk = new MapChunk();
		private var currentChunk2 : MapChunk = new MapChunk();
		private var background1 : Backdrop;
		private var background2 : Backdrop;
		public var shakeTimer : Number;
		private var chunkCount : uint = 10;
		public var score : uint = 0;
		private var imgFlash : Image;
		private var tuto:Tutorial = new Tutorial();
		public var difficult:Boolean = false;
		public function WorldGame() {
			add(timer);
			add(player);
			background1 = new Backdrop(Assets.BACKGROUND1, true, false);
			background1.scrollX = 0.4;
			addGraphic(background1, 0);
			background2 = new Backdrop(Assets.BACKGROUND2, true, false);
			background2.scrollX = 0.8;
			addGraphic(background2, 1);
			imgFlash = Image.createRect(320, 240, 0xFFFFFF, 0);
			imgFlash.scrollX = imgFlash.scrollY = 0
			addGraphic(imgFlash, 10);
			add(tuto);
			Audio.playMusic(Assets.MUSIC, true);
		}
		
		public function recycleChunk(chunk : MapChunk) : void {
			chunkCount -= 1;
			var mem : MapChunk = currentChunk1;
			currentChunk1 = currentChunk2;
			currentChunk2 = mem;
			if (chunkCount <= 0) {
				player.setMode(player.mode + 1);
				if (player.mode == 0) difficult = true;
				imgFlash.alpha = 1;
				chunkCount = 10;
			}
			map.getNextChunk(mem, currentChunk1.x + currentChunk1.realWidth, (chunkCount == 1 ? player.getMode(1) : player.mode), currentChunk2);
		}
		
		override public function update():void {
			if (!currentChunk1.loaded) {
				map.getNextChunk(currentChunk1, 0, 4);
				add(currentChunk1);
				map.getNextChunk(currentChunk2, currentChunk1.x + currentChunk1.realWidth, player.mode, currentChunk1);
				add(currentChunk2);
				chunkCount -= 2;
			}
			if (shakeTimer >= 0) {
				shakeTimer -= FP.elapsed;
				FP.camera.x += FP.choose(-1, -2, 2, 1);
				FP.camera.y += FP.choose(-1, -2, 2, 1);
			}
			if (timer.timer < 0 || player.y > FP.screen.height || player.y + player.height/2 < 0) {
				if (player) {
					player.die();
					player = null;
					timer.timer = 0;
				}
				if (Input.pressed("jump")) {
					switchWorld(WorldGame);
				}
				
				if (Input.pressed("attack")) {
					showLeaderBoard(score + Math.round(FP.camera.x / 10));
				}
			}
			
			if (imgFlash.alpha > 0) imgFlash.alpha -= 0.1;
			
			super.update();
		}
		
		public function addTime(time:uint = 1) : void {
			timer.timer += time;
			if (tuto && tuto.id == 2) {
				remove(tuto);
				tuto = null;
			}
			if (timer.timer > 10)  timer.timer = 10;
		}
		
	}

}