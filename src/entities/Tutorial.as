package entities {
	import utils.gui.Window;
	import net.flashpunk.utils.Input;

	public class Tutorial extends Window{
		public var id : uint = 0;
		public function Tutorial() {
			super((320 - 250)/2, 10, 250, 0, "Press Z to jump");
			graphic.scrollX = graphic.scrollY = text.scrollX = text.scrollY = 0;
			layer = 10;
		}
		
		override public function update():void {
			super.update();
			if (id == 0 && Input.pressed("jump")) {
				id = 1;
				text.text = "Press X to dash/shoot";
			}
			if (id == 1 && Input.pressed("attack")) {
				id = 2;
				text.text = "Hourglass add few seconds to the bomb timer";
			}
		}
		
	}

}