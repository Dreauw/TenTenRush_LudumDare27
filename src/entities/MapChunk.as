package entities {
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import utils.Assets;
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import worlds.WorldGame;

	public class MapChunk extends Entity{
		public var realWidth : uint = 0;
		public var loaded:Boolean = false;
		public var id:uint = 0;
		public function MapChunk() {
			type = "solid";
			layer = 1;
		}
		
		public function load(rect:Rectangle, img:Image, x:Number) : void {
			this.x = x;
			realWidth = (rect.width) * 16;
			//var image:BitmapData = new BitmapData(realWidth, (rect.height) * 16, false, 0);
			var tileset:Tilemap = new Tilemap(Assets.TILESET, realWidth, (rect.height) * 16, 16, 16);
			var grid:Grid = new Grid(realWidth, (rect.height)*16, 16, 16, 0, 0);
			//FP.sprite.graphics.clear();
			//FP.sprite.graphics.beginFill(0xFFFFFF);
			for (var xx:int = rect.x; xx < rect.x+rect.width ; xx++) {
				for (var yy:int = rect.y ; yy < rect.y + rect.height ; yy++) {
					var posx:Number = xx - rect.x;
					var posy:Number = yy - rect.y;
					var col:uint = img.getPixel(xx, yy)
					if (col == 0x7F7F7F) {
						var l:Boolean = img.getPixel(xx - 1, yy) == 0x7F7F7F;
						if (xx-1 == 0) l = true;
						var r:Boolean = img.getPixel(xx + 1, yy) == 0x7F7F7F;
						if (xx+1 == rect.x+rect.width) r = true;
						var u:Boolean = img.getPixel(xx, yy - 1) == 0x7F7F7F;
						if (yy - 1 <= rect.y) u = true;
						var d:Boolean = img.getPixel(xx, yy +1 ) == 0x7F7F7F;
						if (yy+1 == rect.y+rect.height) d = true;
						tileset.setTile(posx, posy, getTileId(l, r, u, d, 4));
						//FP.sprite.graphics.drawRect(posx * 16, posy * 16, 16, 16);
						grid.setTile(posx, posy, true);
					} else if (col == 0x0000FF) {
						var hourglass : Hourglass = FP.world.create(Hourglass) as Hourglass;
						hourglass.x = posx * 16 + x;
						hourglass.y = posy * 16 - 5;
						FP.world.add(hourglass);
					} else if (col == 0x00FF00) {
						var slime : Slime = FP.world.create(Slime) as Slime;
						slime.initialize(posx * 16 + x, posy * 16 - 5);
						FP.world.add(slime);
					} else if (col == 0xFF00FF) {
						var box : Box = FP.world.create(Box) as Box;
						box.initialize(posx * 16 + x, posy * 16 - 5);
						FP.world.add(box);
					} else if (col == 0xFFFF00) {
						var coin : Coin = FP.world.create(Coin) as Coin;
						coin.x = posx * 16 + x;
						coin.y = posy * 16 - 5;
						FP.world.add(coin);
					} if (col == 0xEFE4B0) {
						tileset.setTile(posx, posy, 27);
						grid.setTile(posx, posy, true);
					} 
				}
			}
			//image.draw(FP.sprite);
			graphic = tileset;//new Image(image);
			mask = grid;
			loaded = true;
		}
		
		public function getTileId(left:Boolean, right:Boolean, up:Boolean, down:Boolean, idBase:int = 0) : int {
			if (!left && right && !up && down) {
				return idBase + 0;
			} else if (left && right && !up && down) {
				return idBase + 1;
			} else if (!right && left && !up && down) {
				return idBase + 2;
			} else if (!left && right && up && down) {
				return idBase + 12;
			} else if (left && right && up && down) {
				return idBase + 13;
			} else if (!right && left && up && down) {
				return idBase + 14;
			} else if (right && !left && up && !down) {
				return idBase + 24;
			} else if (right && left && up && !down) {
				return idBase + 25;
			} else if (!right && left && up && !down) {
				return idBase + 26;
			} else if (!right && !left && !up && !down) {
				return idBase - 1;
			} else if (right && !left && !up && !down) {
				return idBase + 24 - 4;
			} else if (right && left && !up && !down) {
				return idBase + 24 - 3;
			} else if (!right && left && !up && !down) {
				return idBase + 24 - 2;
			}
			return idBase + 13;
		}
		
		override public function update():void {
			super.update();
			if (x + realWidth < FP.camera.x ) (FP.world as WorldGame).recycleChunk(this);
		}
		
	}

}