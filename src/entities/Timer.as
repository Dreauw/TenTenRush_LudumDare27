package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import worlds.WorldGame;
	
	public class Timer extends Entity{
		public var timer:Number = 10;
		private var text:Text;
		public function Timer() {
			text = new Text(timer.toString(), 0, 20, { size:8, outlineSize:1 } ); 
			super((FP.screen.width/2 - text.textWidth)/2, 20, text);
			//text.scrollX = text.scrollY = 0;
			layer = 6;
		}
		
		override public function update():void {
			timer -= FP.elapsed;
			if (timer <= 0) {
				text.size = 16;
				text.scrollX = text.scrollY = 0;
				text.color = 0xFFFFFF;
				text.text = "\n\n\t\t\tScore : "+((world as WorldGame).score+Math.round(FP.camera.x/10)).toString()+"\n\t\tPress Z to restart\nPress X to submit your score";
				x = (FP.screen.width / 2 - text.textWidth) / 2;
				y = 20;
			} else if ((FP.world as WorldGame).player) {
				text.color = (timer <= 3 ? 0xFF0000 : 0xFFFFFF);
				text.text = (Math.round(timer * 10) / 10).toString();
				x = (FP.world as WorldGame).player.x-8;
				y = (FP.world as WorldGame).player.y-10;
			}
			super.update();
		}
		
	}

}