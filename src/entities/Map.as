package entities {
	import net.flashpunk.graphics.Image;
	import utils.Assets;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	
	public class Map {
		private var levelRect:Array = new Array();
		private var levelNormalRect:Array = new Array();
		private var levelNinjaRect:Array = new Array();
		private var levelJetpackRect:Array = new Array();
		private var levelGravityRect:Array = new Array();
		private var img:Image;
		private var chunk:Array = new Array();
		public function Map() {
			img = new Image(Assets.PATTERN);
			var starty:int = -1;
			var endx:int = -1;
			for (var y:int = 0 ; y < img.height ; y++) {
				if (img.getPixel(1, y) == 0) {
					if (starty >= 0) {
						var col:uint = img.getPixel(endx+2, starty)
						if (col == 0xFF0000) levelNormalRect.push(new Rectangle(1, starty, endx, y - starty));
						if (col == 0x00FF00) levelNinjaRect.push(new Rectangle(1, starty, endx, y - starty));
						if (col == 0x0000FF) levelJetpackRect.push(new Rectangle(1, starty, endx, y - starty));
						if (col == 0xFF00FF) levelGravityRect.push(new Rectangle(1, starty, endx, y - starty));
						if (col == 0xFFFF00) levelRect.push(new Rectangle(1, starty, endx, y - starty));
					}
					starty = y + 1;
					for (var x:int = 1 ; x < img.width ; x++) {
						if (img.getPixel(x, y + 1) == 0) {
							endx = x - 1;
							break;
						}
					}
				}
			}
		}
		
		public function getNextChunk(chunk:MapChunk, x:Number, mode:uint, lastChunk:MapChunk = null) : void {
			var i : uint = 0;
			if (mode == 0) {
				i = FP.rand(levelNormalRect.length);
				//if (lastChunk) while (i == lastChunk.id) {i = FP.rand(levelNormalRect.length);}
				chunk.load(levelNormalRect[i], img, x);
			} else if (mode == 1) {
				i = FP.rand(levelNinjaRect.length);
				//if (lastChunk) while (i == lastChunk.id) {i = FP.rand(levelNinjaRect.length);}
				chunk.load(levelNinjaRect[i], img, x);
			} else if (mode == 2) {
				i = FP.rand(levelJetpackRect.length);
				//if (lastChunk) while (i == lastChunk.id) {i = FP.rand(levelJetpackRect.length);}
				chunk.load(levelJetpackRect[i], img, x);
			} else if (mode == 3) {
				i = FP.rand(levelGravityRect.length);
				//if (lastChunk) while (i == lastChunk.id) {i = FP.rand(levelGravityRect.length);}
				chunk.load(levelGravityRect[i], img, x);
			} else if (mode == 4) {
				i = FP.rand(levelRect.length);
				//if (lastChunk) while (i == lastChunk.id) {i = FP.rand(levelGravityRect.length);}
				chunk.load(levelRect[i], img, x);
			}
			chunk.id = i;
			
		}
	}

}