package {
	import net.flashpunk.FP;
	import net.flashpunk.Engine;
	import net.flashpunk.utils.Key;
	import worlds.WorldGame;
	import mochi.as3.MochiServices;
	import mochi.as3.MochiScores;
	import worlds.WorldTitle;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	[SWF(backgroundColor="#202020", width="640", height="480")]
	[Frame(factoryClass = "Preloader")]
	public class Main extends Engine {
		public function Main() {
			super(640, 480, 60, false);
				//FP.console.enable();
				//FP.console.toggleKey = Key.F1;
			FP.screen.scale = 2;
			FP.screen.color = 0x88c7ea;
			FP.world = new WorldTitle();
		}
		
		override public function init():void {
			super.init();
			MochiServices.connect("xxxxx", this);
			MochiScores.setBoardID("xxxxx");
		}
	}
}