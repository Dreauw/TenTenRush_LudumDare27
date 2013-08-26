package worlds {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import utils.gui.Button;
	import utils.WorldBase;
	import utils.Audio;
	import utils.Assets;
	import net.flashpunk.graphics.Image;

	public class WorldTitle extends WorldBase{
		private var button1 : Button;
		private var button2 : Button;
		
		public function WorldTitle() {
			Audio.playMusic(Assets.TITLE_ZIC, true);
			addGraphic(new Image(Assets.TITLE), 0);
			button1 = new Button(0, 135, "Play", playButton, null, 0xFF4444, 1, 8, 60, 16);
			button1.x = (320 - button1.width) / 2;
			button2 = new Button(0, 160, "Highscore", scoreButton, null, 0x77FF77, 1, 8, 60, 16);
			button2.x = (320 - button2.width) / 2;
			add(button1);
			add(button2);
			var t : Entity = addGraphic(new Text("TenTen Rush", 0, 50, { size:16 + 8, color:0x4388A3} ));
			(t.graphic as Text).filters = [new GlowFilter(0x316478, 1, 2, 2, 20), new GlowFilter(0x4388A3, 1, 3, 3)]
			t.x = (320 - (t.graphic as Text).textWidth) / 2;
			
		}
		
		
		public function playButton(b : Button) : void {
			switchWorld(WorldGame);
		}
		
		public function scoreButton(b : Button) : void {
			showLeaderBoard();
		}
	}

}